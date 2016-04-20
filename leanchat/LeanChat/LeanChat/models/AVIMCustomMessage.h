//
//  AVIMUserInfoMessage.h
//  LeanChat
//
//  Created by lzw on 15/4/14.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import <LeanChatLib/LeanChatLib.h>

/**
 *  自定义消息的类型，需要 > 0
 */
static NSInteger const kAVIMMessageMediaTypeCustom = 3;

/**
 *  自定义 AVIMTypedMessage，自定义的字段都放到 attributes 中来，不要有和 attributes 平级的字段。
 */

@interface AVIMCustomMessage : AVIMTypedMessage <AVIMTypedMessageSubclassing>

+ (instancetype)messageWithAttributes:(NSDictionary *)attributes;

@end
