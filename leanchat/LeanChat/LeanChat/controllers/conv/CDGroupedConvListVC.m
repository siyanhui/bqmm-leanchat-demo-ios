//
//  CDGroupTableViewController.m
//
//
//  Created by lzw on 14/11/6.
//
//

#import "CDGroupedConvListVC.h"
#import "CDIMService.h"
#import "CDUtils.h"
#import "CDImageLabelTableCell.h"
#import <LeanChatLib/CDChatManager.h>

@implementation CDGroupedConvListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"群组";
    [CDImageLabelTableCell registerCellToTalbeView:self.tableView];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:kCDNotificationConversationUpdated object:nil];
    [self loadConversationsWhenInit];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCDNotificationConversationUpdated object:nil];
}

- (void)loadConversationsWhenInit {
    [self showProgress];
    [[CDChatManager manager] findGroupedConversationsWithBlock:^(NSArray *objects, NSError *error) {
        [self hideProgress];
        if ([self filterError:error]) {
            self.dataSource = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [[CDChatManager manager] findGroupedConversationsWithNetworkFirst:YES block:^(NSArray *objects, NSError *error) {
        [CDUtils stopRefreshControl:refreshControl];
        if ([self filterError:error]) {
            self.dataSource = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDImageLabelTableCell *cell = [CDImageLabelTableCell createOrDequeueCellByTableView:tableView];
    AVIMConversation *conv = [self.dataSource objectAtIndex:indexPath.row];
    cell.myLabel.text = conv.title;
    [cell.myImageView setImage:conv.icon];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AVIMConversation *conv = [self.dataSource objectAtIndex:indexPath.row];
    [[CDIMService service] pushToChatRoomByConversation:conv fromNavigation:self.navigationController completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AVIMConversation *conv = [self.dataSource objectAtIndex:indexPath.row];
        WEAKSELF
        [conv quitWithCallback : ^(BOOL succeeded, NSError *error) {
            if ([self filterError:error]) {
                [weakSelf refresh:nil];
            }
        }];
    }
}

@end
