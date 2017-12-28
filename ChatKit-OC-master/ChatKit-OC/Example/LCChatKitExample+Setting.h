//
//  LCChatKitExample.m
//  LeanCloudChatKit-iOS
//
//  v0.8.5 Created by ElonChan on 16/2/24.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import "LCChatKitExample.h"
#import <Foundation/Foundation.h>

@interface LCChatKitExample (Setting) //<MWPhotoBrowserDelegate>

/**
 *  初始化需要的设置
 */
- (void)lcck_setting;
+ (void)lcck_pushToViewController:(UIViewController *)viewController;
+ (void)lcck_tryPresentViewControllerViewController:(UIViewController *)viewController;
+ (void)lcck_clearLocalClientInfo;
+ (void)lcck_exampleChangeGroupAvatarURLsForConversationId:(NSString *)conversationId
                                         shouldInsert:(BOOL)shouldInsert;
@end
