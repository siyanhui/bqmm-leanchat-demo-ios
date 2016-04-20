//
//  CDProfileController.m
//  LeanChat
//
//  Created by Qihe Bian on 7/28/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import <LeanChatLib/CDChatManager.h>
#import <LeanCloudSocial/AVOSCloudSNS.h>
#import <LeanCloudFeedback/LeanCloudFeedback.h>
#import <OpenShare/OpenShareHeader.h>
#import <PopMenu/PopMenu.h>

#import "CDProfileVC.h"
#import "CDUserManager.h"
#import "CDAppDelegate.h"
#import "CDSettingVC.h"
#import "CDWebViewVC.h"
#import "MCPhotographyHelper.h"
#import "CDBaseNavC.h"
#import "CDProfileNameVC.h"
#import "LZPushManager.h"

@interface CDProfileVC ()<UIActionSheetDelegate, CDProfileNameVCDelegate>

@property (nonatomic, strong) MCPhotographyHelper *photographyHelper;

@end

@implementation CDProfileVC

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"我";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableViewStyle = UITableViewStyleGrouped;
    [self loadDataSource];
    
    [OpenShare connectQQWithAppId:QQAppId];
    [OpenShare connectWeixinWithAppId:WeChatAppId];
    [OpenShare connectWeiboWithAppKey:WeiboAppId];
}

- (MCPhotographyHelper *)photographyHelper {
    if (_photographyHelper == nil) {
        _photographyHelper = [[MCPhotographyHelper alloc] init];
    }
    return _photographyHelper;
}

- (void)loadDataSource {
    [self showProgress];
    [[CDUserManager manager] getBigAvatarImageOfUser:[AVUser currentUser] block:^(UIImage *image) {
        [[LCUserFeedbackAgent sharedInstance] countUnreadFeedbackThreadsWithBlock:^(NSInteger number, NSError *error) {
            [self hideProgress];
            self.dataSource = [NSMutableArray array];
            [self.dataSource addObject:@[@{ kMutipleSectionImageKey:image, kMutipleSectionTitleKey:[AVUser currentUser].username, kMutipleSectionSelectorKey:NSStringFromSelector(@selector(showEditActionSheet:)) }]];
            [self.dataSource addObject:@[@{ kMutipleSectionTitleKey:@"消息通知", kMutipleSectionSelectorKey:NSStringFromSelector(@selector(goPushSetting)) }, @{ kMutipleSectionTitleKey:@"意见反馈", kMutipleSectionBadgeKey:@(number), kMutipleSectionSelectorKey:NSStringFromSelector(@selector(goFeedback)) }, @{ kMutipleSectionTitleKey:@"用户协议", kMutipleSectionSelectorKey:NSStringFromSelector(@selector(goTerms)) }, @{kMutipleSectionTitleKey:@"分享应用", kMutipleSectionSelectorKey:SELECTOR_TO_STRING(shareApp:)}]];
            [self.dataSource addObject:@[@{ kMutipleSectionTitleKey:@"退出登录", kMutipleSectionLogoutKey:@YES, kMutipleSectionSelectorKey:NSStringFromSelector(@selector(logout)) }]];
            [self.tableView reloadData];
        }];
    }];
}

#pragma mark - Actions

- (void)showEditActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更新资料" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"更改头像", @"更改用户名", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    if (buttonIndex == 0) {
        [self pickImage];
    } else {
        CDProfileNameVC *profileNameVC = [[CDProfileNameVC alloc] init];
        profileNameVC.placeholderName = [AVUser currentUser].username;
        profileNameVC.profileNameVCDelegate = self;
        [self.navigationController pushViewController:profileNameVC animated:YES];
    }
}

- (void)didDismissProfileNameVCWithNewName:(NSString *)name {
    [self showProgress];
    [[CDUserManager manager] updateUsername:name block:^(BOOL succeeded, NSError *error) {
        [self hideProgress];
        if ([self filterError:error]) {
            [self loadDataSource];
        }
    }];
}

-(void)pickImage {
    [self.photographyHelper showOnPickerViewControllerOnViewController:self completion:^(UIImage *image) {
        if (image) {
            UIImage *rounded = [CDUtils roundImage:image toSize:CGSizeMake(100, 100) radius:10];
            [self showProgress];
            [[CDUserManager manager] updateAvatarWithImage : rounded callback : ^(BOOL succeeded, NSError *error) {
                [self hideProgress];
                if ([self filterError:error]) {
                    [self loadDataSource];
                }
            }];
        }
    }];
}

/** 调用这个，下次 SNS 登录的时候会重新去第三方应用请求，而不会用本地缓存 */
- (void)deleteAuthDataCache {
    id authData = [[AVUser currentUser] objectForKey:@"authData"];
    if (authData != nil && authData != [NSNull null]) {
        if ([authData objectForKey:AVOSCloudSNSPlatformQQ]) {
            [AVOSCloudSNS logout:AVOSCloudSNSQQ];
        } else if ([authData objectForKey:AVOSCloudSNSPlatformWeiXin]) {
            [AVOSCloudSNS logout:AVOSCloudSNSWeiXin];
        } else if ([authData objectForKey:AVOSCloudSNSPlatformWeiBo]) {
            [AVOSCloudSNS logout:AVOSCloudSNSSinaWeibo];
        }
    }
}

- (void)logout {
    [[CDChatManager manager] closeWithCallback: ^(BOOL succeeded, NSError *error) {
        DLog(@"%@", error);
        [self deleteAuthDataCache];
        [AVUser logOut];
        CDAppDelegate *delegate = (CDAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate toLogin];
    }];
}

- (void)goTerms {
    CDWebViewVC *webViewVC = [[CDWebViewVC alloc] initWithURL:[NSURL URLWithString:@"https://leancloud.cn/terms.html"] title:@"用户协议"];
    webViewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewVC animated:YES];
}

- (void)goPushSetting {
    CDSettingVC *controller = [[CDSettingVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)goFeedback {
    LCUserFeedbackViewController *feedbackViewController = [[LCUserFeedbackViewController alloc] init];
    feedbackViewController.navigationBarStyle = LCUserFeedbackNavigationBarStyleNone;
    feedbackViewController.contactHeaderHidden = YES;
    CDBaseNavC *navigationController = [[CDBaseNavC alloc] initWithRootViewController:feedbackViewController];
    [self presentViewController:navigationController animated:YES completion: ^{
    }];
    [self performSelector:@selector(loadDataSource) withObject:nil afterDelay:1];
}

#pragma mark - share App

- (void)shareApp:(id)sender {
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
    MenuItem *menuItem = [[MenuItem alloc] initWithTitle:@"QQ" iconName:@"sns_qq" glowColor:RGBCOLOR(104, 165, 225) index:0];
    [items addObject:menuItem];
    
    menuItem = [MenuItem initWithTitle:@"QQ空间" iconName:@"sns_qzone" glowColor:RGBCOLOR(246, 191, 45) index:1];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"微信" iconName:@"sns_wechat" glowColor:RGBCOLOR(139, 202, 0) index:2];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"微博" iconName:@"sns_weibo" glowColor:RGBCOLOR(247, 99, 100) index:3];
    [items addObject:menuItem];
    
    PopMenu *popMenu = [[PopMenu alloc] initWithFrame:self.view.bounds items:items];
    popMenu.menuAnimationType = kPopMenuAnimationTypeNetEase; // kPopMenuAnimationTypeSina
    popMenu.perRowItemCount = 3; // or 2
    // 请真机测试
    popMenu.didSelectedItemCompletion = ^(MenuItem *selectedItem) {
        [self shareAppAtIndex:selectedItem.index];
    };
    [popMenu showMenuAtView:self.view.window];
}

- (void)shareAppAtIndex:(NSInteger)index {
    NSString *title = @"分享一个用 LeanCloud 实时通信组件做的社交应用 LeanChat，还挺好用的";
    NSString *link = @"https://itunes.apple.com/gb/app/leanchat/id943324553";
    NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"AppIcon60x60"], 0.8);
    NSString *titleAndLink = [NSString stringWithFormat:@"%@ %@", title, link];
    shareFail failBlock = ^(OSMessage *message, NSError *error) {
        [self showHUDText:error.localizedDescription];
    };
    shareSuccess successBlock = ^(OSMessage *message) {
        [self showHUDText:@"分享成功"];
    };
    
    // 对话 Msg
    OSMessage *sessionMsg = [[OSMessage alloc] init];
    sessionMsg.image = imageData;
    //    sessionMsg.thumbnail = imageData;
    sessionMsg.title = @"分享应用";
    sessionMsg.desc = title;
    sessionMsg.link = link;
    
    // 时间线 Msg
    OSMessage *timelineMsg = [[OSMessage alloc] init];
    timelineMsg.image = imageData;
    timelineMsg.title = titleAndLink;
    switch (index) {
        case 0: {
            if ([OpenShare isQQInstalled] == NO) {
                [self showHUDText:@"QQ 未安装，无法分享"];
            } else {
                [OpenShare shareToQQFriends:sessionMsg Success:successBlock Fail:failBlock];
            }
            break;
        }
        case 1: {
            if ([OpenShare isQQInstalled] == NO) {
                [self showHUDText:@"QQ 未安装，无法分享"];
            } else {
                timelineMsg.image = nil;
                [OpenShare shareToQQZone:timelineMsg Success:successBlock Fail:failBlock];
            }
            break;
        }
        case 2: {
            if ([OpenShare isWeixinInstalled] == NO) {
                [self showHUDText:@"微信未安装，无法分享"];
            } else {
                [OpenShare shareToWeixinSession:sessionMsg Success:successBlock Fail:failBlock];
            }
            break;
        }
        case 3: {
            if ([OpenShare isWeiboInstalled] == NO) {
                [self showHUDText:@"微博未安装，无法分享"];
            } else {
                [OpenShare shareToWeibo:timelineMsg Success:successBlock Fail:failBlock];
            }
            break;
        }
    }
}

@end
