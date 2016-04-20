//
//  CDGroupDetailController.m
//  LeanChat
//
//  Created by lzw on 14/11/6.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import "CDBaseNavC.h"
#import "CDConvDetailVC.h"
#import "CDAddMemberVC.h"
#import "CDUserInfoVC.h"
#import "CDConvNameVC.h"
#import "CDConvReportAbuseVC.h"
#import <LZMembersCell/LZMembersCell.h>

#import "CDCacheManager.h"
#import "CDUserManager.h"
#import "LZAlertViewHelper.h"
#import <LeanChatLib/CDChatManager.h>

static NSString *kCDConvDetailVCTitleKey = @"title";
static NSString *kCDConvDetailVCDisclosureKey = @"disclosure";
static NSString *kCDConvDetailVCDetailKey = @"detail";
static NSString *kCDConvDetailVCSelectorKey = @"selector";
static NSString *kCDConvDetailVCSwitchKey = @"switch";

static NSString *const reuseIdentifier = @"Cell";

@interface CDConvDetailVC () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, LZMembersCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) LZMembersCell *membersCell;

@property (nonatomic, assign) BOOL own;

@property (nonatomic, strong) NSArray *displayMembers;

@property (nonatomic, strong) UITableViewCell *switchCell;

@property (nonatomic, strong) UISwitch *muteSwitch;

@property (nonatomic, strong) LZAlertViewHelper *alertViewHelper;

@property (nonatomic, strong, readwrite) AVIMConversation *conv;

@end

@implementation CDConvDetailVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kCDNotificationConversationUpdated object:nil];
    [self setupDatasource];
    [self setupBarButton];
    [self refresh];
}

- (void)setupDatasource {
    NSDictionary *dict1 = @{
                            kCDConvDetailVCTitleKey : @"举报",
                            kCDConvDetailVCDisclosureKey : @YES,
                            kCDConvDetailVCSelectorKey : NSStringFromSelector(@selector(goReportAbuse))
                            };
    NSDictionary *dict2 = @{
                            kCDConvDetailVCTitleKey : @"消息免打扰",
                            kCDConvDetailVCSwitchKey : @YES
                            };
    if (self.conv.type == CDConversationTypeGroup) {
        self.dataSource = [@[
                             @{
                                 kCDConvDetailVCTitleKey : @"群聊名称",
                                 kCDConvDetailVCDisclosureKey : @YES,
                                 kCDConvDetailVCDetailKey : self.conv.displayName,
                                 kCDConvDetailVCSelectorKey : NSStringFromSelector(@selector(goChangeName))
                                 },
                             dict2,
                             dict1,
                             @{
                                 kCDConvDetailVCTitleKey : @"删除并退出",
                                 kCDConvDetailVCSelectorKey:NSStringFromSelector(@selector(quitConv))
                                 }
                             ] mutableCopy];
    } else {
        self.dataSource = [@[ dict2, dict1 ] mutableCopy];
    }
}

#pragma mark - Propertys

- (UISwitch *)muteSwitch {
    if (_muteSwitch == nil) {
        _muteSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_muteSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_muteSwitch setOn:self.conv.muted];
    }
    return _muteSwitch;
}

/* fetch from memory cache ,it is possible be nil ,if nil, please fetch from server with `refreshCurrentConversation:`*/
- (AVIMConversation *)conv {
    return [[CDCacheManager manager] currentConversationFromMemory];
}

- (LZAlertViewHelper *)alertViewHelper {
    if (_alertViewHelper == nil) {
        _alertViewHelper = [[LZAlertViewHelper alloc] init];
    }
    return _alertViewHelper;
}

#pragma mark

- (LZMember *)memberFromUser:(AVUser *)user {
    LZMember *member = [[LZMember alloc] init];
    member.memberId = user.objectId;
    member.memberName = user.username;
    return member;
}

- (void)refresh {
    [[CDCacheManager manager] fetchCurrentConversationIfNeeded:^(AVIMConversation *conversation, NSError *error) {
        if (!error) {
            self.conv  = conversation;
            [self unsafeRefresh];
        } else {
            [self alertError:error];
        }
    }];
}

/*
 * the members of conversation is possiable 0 ,so we call it unsafe
 */
- (void)unsafeRefresh {
    NSAssert(self.conv, @"the conv is nil in the method of `refresh`");
    NSSet *userIds = [NSSet setWithArray:self.conv.members];
    self.own = [self.conv.creator isEqualToString:[AVUser currentUser].objectId];
    self.title = [NSString stringWithFormat:@"详情(%ld人)", (long)self.conv.members.count];
    [self showProgress];
    [[CDCacheManager manager] cacheUsersWithIds:userIds callback: ^(BOOL succeeded, NSError *error) {
        [self hideProgress];
        if ([self filterError:error]) {
            NSMutableArray *displayMembers = [NSMutableArray array];
            for (NSString *userId in userIds) {
                [displayMembers addObject:[self memberFromUser:[[CDCacheManager manager] lookupUser:userId]]];
            }
            self.displayMembers = displayMembers;
            [self.tableView reloadData];
        }
    }];
}

- (void)setupBarButton {
    UIBarButtonItem *addMember = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMember)];
    self.navigationItem.rightBarButtonItem = addMember;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationConversationUpdated object:nil];
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LZMembersCell *cell = [LZMembersCell dequeueOrCreateCellByTableView:tableView];
        cell.members = self.displayMembers;
        cell.membersCellDelegate = self;
        return cell;
    } else {
        UITableViewCell *cell;
        static NSString *identifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        NSDictionary *data = self.dataSource[indexPath.row];
        NSString *title = [data objectForKey:kCDConvDetailVCTitleKey];
        cell.textLabel.text = title;
        NSString *detail = [data objectForKey:kCDConvDetailVCDetailKey];
        if (detail) {
            cell.detailTextLabel.text = self.conv.displayName;
        } else {
            cell.detailTextLabel.text = nil;
        }
        BOOL disclosure = [[data objectForKey:kCDConvDetailVCDisclosureKey] boolValue];
        if (disclosure) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        BOOL isSwitch = [[data objectForKey:kCDConvDetailVCSwitchKey] boolValue];
        if (isSwitch) {
            cell.accessoryView = self.muteSwitch;
        } else {
            cell.accessoryView = nil;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [LZMembersCell heightForMemberCount:self.displayMembers.count];
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    NSString *selectorName = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:kCDConvDetailVCSelectorKey];
    if (selectorName) {
        [self performSelector:NSSelectorFromString(selectorName) withObject:nil afterDelay:0];
    }
}

#pragma mark - member cell delegate

- (void)didSelectMember:(LZMember *)member {
    AVUser *user = [[CDCacheManager manager] lookupUser:member.memberId];
    if ([[AVUser currentUser].objectId isEqualToString:user.objectId] == YES) {
        return;
    }
    CDUserInfoVC *userInfoVC = [[CDUserInfoVC alloc] initWithUser:user];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

- (void)didLongPressMember:(LZMember *)user {
    AVUser *member = [[CDCacheManager manager] lookupUser:user.memberId];
    NSAssert(member, @"member in `didLongPressMember` is nil");
    if ([member.objectId isEqualToString:self.conv.creator] == NO) {
        [self.alertViewHelper showConfirmAlertViewWithMessage:@"确定要踢走该成员吗？" block:^(BOOL confirm, NSString *text) {
            if (confirm) {
                [self.conv removeMembersWithClientIds:@[ member.objectId ] callback : ^(BOOL succeeded, NSError *error) {
                    if ([self filterError:error]) {
                        [[CDCacheManager manager] refreshCurrentConversation: ^(BOOL succeeded, NSError *error) {
                            [self alertError:error];
                        }];
                    }
                }];
            }
        }];
    }
}

- (void)displayAvatarOfMember:(LZMember *)member atImageView:(UIImageView *)imageView {
    AVUser *user = [[CDCacheManager manager] lookupUser:member.memberId];
    [[CDUserManager manager] displayAvatarOfUser:user avatarView:imageView];
}

#pragma mark - Action

- (void)goReportAbuse {
    CDConvReportAbuseVC *reportAbuseVC = [[CDConvReportAbuseVC alloc] initWithConversationId:self.conv.conversationId];
    [self.navigationController pushViewController:reportAbuseVC animated:YES];
}

- (void)switchValueChanged:(UISwitch *)theSwitch {
    AVBooleanResultBlock block = ^(BOOL succeeded, NSError *error) {
        [self alertError:error];
    };
    if ([theSwitch isOn]) {
        [self.conv muteWithCallback:block];
    }
    else {
        [self.conv unmuteWithCallback:block];
    }
}

- (void)goChangeName {
    CDConvNameVC *vc = [[CDConvNameVC alloc] init];
    vc.detailVC = self;
    vc.conv = self.conv;
    CDBaseNavC *nav = [[CDBaseNavC alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)addMember {
    CDAddMemberVC *controller = [[CDAddMemberVC alloc] init];
    controller.groupDetailVC = self;
    CDBaseNavC *nav = [[CDBaseNavC alloc] initWithRootViewController:controller];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)quitConv {
    [self.conv quitWithCallback: ^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [[CDChatManager manager] deleteConversation:self.conv];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

@end
