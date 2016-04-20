//
//  CDSelectUserVC.h
//  LeanChat
//
//  Created by lzw on 15/6/30.
//  Copyright (c) 2015年 LeanCloud（Bug汇报：QQ1356701892）.  All rights reserved.
//

#import "CDBaseTableVC.h"
#import <LeanChatLib/AVIMConversation+Custom.h>

@protocol CDSelectMemberVCDelegate <NSObject>

- (void)didSelectMember:(AVUser *)member;

@end

@interface CDSelectMemberVC : CDBaseTableVC

@property (nonatomic, strong) AVIMConversation *conversation;

@property id<CDSelectMemberVCDelegate> selectMemberVCDelegate;

@end
