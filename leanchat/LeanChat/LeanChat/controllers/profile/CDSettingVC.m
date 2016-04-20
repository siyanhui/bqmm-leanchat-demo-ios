//
//  CDPushSettingController.m
//  LeanChat
//
//  Created by lzw on 15/1/15.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDSettingVC.h"
#import <LeanChatLib/CDSoundManager.h>

static CGFloat kHorizontalSpacing = 40;
static CGFloat kFooterHeight = 30;

static NSString *kMainText = @"mainText";
static NSString *kDetailText = @"detailText";
static NSString *kTipText = @"tipText";
static NSString *kDetailSwitchOn = @"detailSwitchOn";
static NSString *kDetailSwitchChangeSelector = @"detailSwitchChangeSelector";

@interface CDSettingVC ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation CDSettingVC

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"消息通知"];
    NSString *detailText = [self isNotificationEnabled] ? @"已开启" : @"已关闭";
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    self.dataSource = @[
        @{kMainText:@"新消息通知",
          kDetailText:detailText,
          kTipText:[NSString stringWithFormat:@"如果你要关闭或开启%@的新消息通知，请在 iPhone 的\"设置\"-\"通知\"功能中，找到应用程序%@更改。", appName, appName]},
        @{kMainText:@"聊天音效",
          kDetailSwitchOn: @([CDSoundManager manager].needPlaySoundWhenChatting),
          kDetailSwitchChangeSelector:NSStringFromSelector(@selector(chattingSoundChanged:)),
          kTipText:@"开启时，将在聊天时播放发送消息和接受消息的提示音"},
        @{kMainText:@"通知声音",
          kDetailSwitchOn:@([CDSoundManager manager].needPlaySoundWhenNotChatting),
          kDetailSwitchChangeSelector:NSStringFromSelector(@selector(notChattingSoundChanged:)),
          kTipText:@"开启时，在其它页面接收到消息时将播放提示音"},
        @{kMainText:@"通知振动",
          kDetailSwitchOn:@([CDSoundManager manager].needVibrateWhenNotChatting),
          kDetailSwitchChangeSelector:NSStringFromSelector(@selector(vibrateChanged:)),
          kTipText:@"开启时，在其它页面接收到消息时将振动一下"}];
}

#pragma mark - actions or helpers

- (BOOL)isNotificationEnabled {
    UIApplication *application = [UIApplication sharedApplication];
    BOOL enabled;
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        // ios8
        enabled = [application isRegisteredForRemoteNotifications];
    }
    else {
        UIRemoteNotificationType types = [application enabledRemoteNotificationTypes];
        enabled = types & UIRemoteNotificationTypeAlert;
    }
    return enabled;
}

- (void)chattingSoundChanged:(UISwitch *)switchView {
    [CDSoundManager manager].needPlaySoundWhenChatting = switchView.on;
}

- (void)notChattingSoundChanged:(UISwitch *)switchView {
    [CDSoundManager manager].needPlaySoundWhenNotChatting = switchView.on;
}

- (void)vibrateChanged:(UISwitch *)switchView {
    [CDSoundManager manager].needVibrateWhenNotChatting = switchView.on;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kFooterHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *sectionData = self.dataSource[indexPath.section];
    NSString *text = sectionData[kMainText];
    NSString *detailText = sectionData[kDetailText];
    id switchValue = sectionData[kDetailSwitchOn];
    if (switchValue) {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        BOOL switchOn = [switchValue boolValue];
        [switchView setOn:switchOn];
        NSString *selectorName = sectionData[kDetailSwitchChangeSelector];
        [switchView addTarget:self action:NSSelectorFromString(selectorName) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switchView;
    }
    cell.textLabel.text = text;
    cell.detailTextLabel.text = detailText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSDictionary *sectionData = self.dataSource[section];
    NSString *tipText = sectionData[kTipText];
    if (tipText.length > 0) {
        UILabel *tipLabel = [self tipLabel];
        tipLabel.text = tipText;
        return tipLabel;
    }
    return nil;
}


- (UILabel *)tipLabel {
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHorizontalSpacing, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 2 * kHorizontalSpacing, kFooterHeight)];
    tipLabel.font = [UIFont systemFontOfSize:11];
    tipLabel.textColor = [UIColor grayColor];
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 0;
    return tipLabel;
}

@end
