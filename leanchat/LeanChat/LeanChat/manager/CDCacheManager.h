//
//  CDCacheService.h
//  LeanChat
//
//  Created by lzw on 14/12/3.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDCommon.h"
#import <LeanChatLib/AVIMConversation+Custom.h>

typedef void (^AVIMConversationResultBlock)(AVIMConversation *conversation, NSError *error);

@interface CDCacheManager : NSObject

+ (instancetype)manager;

- (AVUser *)lookupUser:(NSString *)userId;
- (void)registerUsers:(NSArray *)users;
- (void)cacheUsersWithIds:(NSSet *)userIds callback:(AVBooleanResultBlock)callback;
- (void)setCurrentConversation:(AVIMConversation *)conv;

/*!
 @brief  get current conversation, when converson is nil,it may be nil
 @details fetch from memory cache ,it is possible be nil ,if nil, please fetch from server with `refreshCurConv:`
 */
- (AVIMConversation *)currentConversationFromMemory;
- (void)refreshCurrentConversation:(AVBooleanResultBlock)callback;
/*!
 @brief  do like `currentConversationFromMemory`, but it can make sure the conversation is not nil 
 @attention use `refreshCurConv` to make sure the conversation is not nil
 @param callback with Conversation Result and error
 */
- (void)fetchCurrentConversationIfNeeded:(AVIMConversationResultBlock)callback;

@end
