//
//  CDSelectUserVC.m
//  LeanChat
//
//  Created by lzw on 15/6/30.
//  Copyright (c) 2015年 LeanCloud（Bug汇报：QQ1356701892）.  All rights reserved.
//

#import "CDSelectMemberVC.h"
#import "CDUserManager.h"
#import "CDCacheManager.h"
#import "CDChatManager.h"
#import "CDImageLabelTableCell.h"

@interface CDSelectMemberVC ()

@end

@implementation CDSelectMemberVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.viewControllerStyle = CDViewControllerStylePresenting;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择要提醒的人";
    [CDImageLabelTableCell registerCellToTalbeView:self.tableView];
    [self loadDataSource];
}

- (void)loadDataSource {
    NSMutableSet *userIds = [NSMutableSet setWithArray:self.conversation.members];
    [userIds removeObject:[CDChatManager manager].clientId];
    [self showProgress];
    [[CDCacheManager manager] cacheUsersWithIds:userIds callback:^(BOOL succeeded, NSError *error) {
        [self hideProgress];
        if ([self filterError:error]) {
            self.dataSource  = [[userIds allObjects] mutableCopy];
            [self.tableView reloadData];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDImageLabelTableCell *cell = [CDImageLabelTableCell createOrDequeueCellByTableView:tableView];
    NSString *userId = [self.dataSource objectAtIndex:indexPath.row];
    AVUser *user = [[CDCacheManager manager] lookupUser:userId];
    [[CDUserManager manager] displayAvatarOfUser:user avatarView:cell.myImageView];
    cell.myLabel.text = user.username;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *userId = [self.dataSource objectAtIndex:indexPath.row];
    AVUser *user = [[CDCacheManager manager] lookupUser:userId];
    if([self.selectMemberVCDelegate respondsToSelector:@selector(didSelectMember:)]) {
        [self.selectMemberVCDelegate didSelectMember:user];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
