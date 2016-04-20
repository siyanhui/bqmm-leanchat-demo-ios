//
//  CDUser.h
//  LeanChatLib
//
//  Created by lzw on 15/4/3.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LeanChatLib/CDChatManager.h>

/**
 *  简单的实现 CDUserModel 协议的类。可以直接在你的 User 类里实现该协议。
 */
@interface CDUser : NSObject<CDUserModelDelegate>

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *avatarUrl;

@end
