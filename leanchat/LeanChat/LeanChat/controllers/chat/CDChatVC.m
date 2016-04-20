//
//  CDChatVC.m
//  LeanChat
//
//  Created by lzw on 15/4/10.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDChatVC.h"
#import "CDConvDetailVC.h"
#import "CDUserInfoVC.h"
#import "CDSelectMemberVC.h"
#import "CDBaseNavC.h"

#import "CDCacheManager.h"
#import "AVIMCustomMessage.h"

@interface CDChatVC () <CDSelectMemberVCDelegate>

@end

@implementation CDChatVC

- (instancetype)initWithConversation:(AVIMConversation *)conv {
    self = [super initWithConversation:conv];
    if (self) {
        [[CDCacheManager manager] setCurrentConversation:conv];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contact_face_group_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(goChatGroupDetail:)];
    self.navigationItem.rightBarButtonItem = item;
//    [self testSendCustomeMessage];
}

- (void)testSendCustomeMessage {
    AVIMCustomMessage *userInfoMessage = [AVIMCustomMessage messageWithAttributes:@{ @"nickname" : @"lzw" }];
    [self.conversation sendMessage:userInfoMessage callback: ^(BOOL succeeded, NSError *error) {
        DLog(@"%@", error);
    }];
}

- (void)goChatGroupDetail:(id)sender {
    [self.navigationController pushViewController:[[CDConvDetailVC alloc] init] animated:YES];
}

- (void)didSelectedAvatorOnMessage:(id<XHMessageModel>)message atIndexPath:(NSIndexPath *)indexPath {
    AVIMTypedMessage *msg = self.msgs[indexPath.row];
    if ([msg.clientId isEqualToString:[CDChatManager manager].clientId] == NO) {
        CDUserInfoVC *userInfoVC = [[CDUserInfoVC alloc] initWithUser:[[CDCacheManager manager] lookupUser:msg.clientId]];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
}

- (void)didInputAtSignOnMessageTextView:(XHMessageTextView *)messageInputTextView {
    if (self.conversation.type == CDConversationTypeGroup) {
        [self performSelector:@selector(goSelectMemberVC) withObject:nil afterDelay:0];
        // weird , call below function not input @
//        [self goSelectMemberVC];
    }
}

- (void)goSelectMemberVC {
    CDSelectMemberVC *selectMemberVC = [[CDSelectMemberVC alloc] init];
    selectMemberVC.selectMemberVCDelegate = self;
    selectMemberVC.conversation = self.conversation;
    CDBaseNavC *nav = [[CDBaseNavC alloc] initWithRootViewController:selectMemberVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - CDSelectMemberVCDelegate

- (void)didSelectMember:(AVUser *)member {
    self.messageInputView.inputTextView.text = [NSString stringWithFormat:@"%@%@ ", self.messageInputView.inputTextView.text, member.username];
    [self performSelector:@selector(messageInputViewBecomeFristResponder) withObject:nil afterDelay:0];
}

- (void)messageInputViewBecomeFristResponder {
    [self.messageInputView.inputTextView becomeFirstResponder];
}

@end
