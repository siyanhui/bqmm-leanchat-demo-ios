//
//  CDGroupAddMemberController.m
//  LeanChat
//
//  Created by lzw on 14/11/7.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import "CDAddMemberVC.h"
#import "CDImageLabelTableCell.h"

#import "CDUserManager.h"
#import "CDCacheManager.h"
#import "CDUtils.h"
#import "CDIMService.h"
#import <LeanChatLib/CDChatManager.h>


@interface CDAddMemberVC ()

@property (nonatomic) NSMutableArray *selected;
@property (nonatomic) NSMutableArray *potentialIds;

@end

@implementation CDAddMemberVC

static NSString *reuseIdentifier = @"Cell";

- (instancetype)init {
    self = [super init];
    if (self) {
        _selected = [NSMutableArray array];
        _potentialIds = [NSMutableArray array];
        self.viewControllerStyle = CDViewControllerStylePresenting;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [CDImageLabelTableCell registerCellToTalbeView:self.tableView];
    
    self.title = @"邀请好友";
    [self initBarButton];
    [self refresh];
}

- (void)initBarButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(invite)];
}

- (void)refresh {
    WEAKSELF
    [[CDUserManager manager] findFriendsWithBlock:^(NSArray *friends, NSError *error) {
        if ([self filterError:error]) {
            [self.potentialIds removeAllObjects];
            for (AVUser *user in friends) {
                [[CDCacheManager manager] fetchCurrentConversationIfNeeded:^(AVIMConversation *conversation, NSError *error) {
                    if ([conversation.members containsObject:user.objectId] == NO) {
                        [self.potentialIds addObject:user.objectId];
                    }
                }];
            }
            for (int i = 0; i < self.potentialIds.count; i++) {
                [self.selected addObject:[NSNumber numberWithBool:NO]];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)invite {
    NSMutableArray *inviteIds = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.selected.count; i++) {
        if ([self.selected[i] boolValue]) {
            [inviteIds addObject:[self.potentialIds objectAtIndex:i]];
        }
    }
    if (inviteIds.count == 0) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [[CDCacheManager manager] fetchCurrentConversationIfNeeded:^(AVIMConversation *conversation, NSError *error) {
        if (!error) {
            [self unsafeInviteWithConversation:conversation inviteIds:inviteIds];
        } else {
            [self alertError:error];
        }
    }];
}

/*
 * the conversation is possiable nil ,so we call it unsafe
 */
- (void)unsafeInviteWithConversation:(AVIMConversation *)conv inviteIds:(NSMutableArray *)inviteIds {
    if (conv.type == CDConversationTypeSingle) {
        // 单聊对话加入，直接创建一个群聊对话
        NSMutableArray *members = [conv.members mutableCopy];
        [members addObjectsFromArray:inviteIds];
        [self showProgress];
        [[CDChatManager manager] createConversationWithMembers:members type:CDConversationTypeGroup unique:NO callback:^(AVIMConversation *conversation, NSError *error) {
            [self hideProgress];
            if ([self filterError:error]) {
                [self.presentingViewController dismissViewControllerAnimated:YES completion: ^{
                    [[CDIMService service] pushToChatRoomByConversation:conversation fromNavigation:_groupDetailVC.navigationController completion:nil];
                }];
            }
        }];
    } else {
        // 本来就是群聊对话，直接拉人
        [self showProgress];
        [conv addMembersWithClientIds:inviteIds callback: ^(BOOL succeeded, NSError *error) {
            [self hideProgress];
            if ([self filterError:error]) {
                [self showProgress];
                [[CDCacheManager manager] refreshCurrentConversation: ^(BOOL succeeded, NSError *error) {
                    [self hideProgress];
                    if ([self filterError:error]) {
                        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    }
                }];
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.potentialIds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDImageLabelTableCell *cell = [CDImageLabelTableCell createOrDequeueCellByTableView:tableView];
    NSString *userId = [self.potentialIds objectAtIndex:indexPath.row];
    AVUser *user = [[CDCacheManager manager] lookupUser:userId];
    [[CDUserManager manager] displayAvatarOfUser:user avatarView:cell.myImageView];
    cell.myLabel.text = user.username;
    if ([self.selected[indexPath.row] boolValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger pos = indexPath.row;
    self.selected[pos] = [NSNumber numberWithBool:![self.selected[pos] boolValue]];
    [self.tableView reloadData];
}

@end
