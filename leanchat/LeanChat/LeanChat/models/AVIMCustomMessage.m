//
//  AVIMUserInfoMessage.m
//  LeanChat
//
//  Created by lzw on 15/4/14.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "AVIMCustomMessage.h"

@implementation AVIMCustomMessage

+ (void)load {
    [self registerSubclass];
}

- (instancetype)init {
    if ((self = [super init])) {
        self.mediaType = [[self class] classMediaType];
    }
    return self;
}

+ (AVIMMessageMediaType)classMediaType {
    return kAVIMMessageMediaTypeCustom;
}

+ (instancetype)messageWithAttributes:(NSDictionary *)attributes {
    AVIMCustomMessage *message = [[self alloc] init];
    message.attributes = attributes;
    return message;
}

@end
