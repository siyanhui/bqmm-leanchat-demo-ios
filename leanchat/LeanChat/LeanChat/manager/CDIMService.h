//
//  CDIMService.h
//  LeanChat
//
//  Created by lzw on 15/4/3.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LeanChatLib/CDChatManager.h>
#import "CDCommon.h"
#import "CDBaseVC.h"

typedef void (^CompletionBlock)(BOOL successed, NSError *error);

@interface CDIMService : NSObject<CDUserDelegate>

+ (instancetype)service;

/*!
 @brief  create conversation room, if success push to it
 */
- (void)createChatRoomByUserId:(NSString *)userId fromViewController:(CDBaseVC *)viewController completion:(CompletionBlock)completion;

/*!
 @brief  firstly, create conversation room, secondly, if success, push to it.
 */
- (void)pushToChatRoomByConversation:(AVIMConversation *)conversation fromNavigation:(UINavigationController *)navigation completion:(CompletionBlock)completion;

@end
