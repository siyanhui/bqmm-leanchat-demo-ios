//
//  AddRequest.m
//  LeanChat
//
//  Created by lzw on 14-10-23.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import "CDAddRequest.h"

@implementation CDAddRequest

@dynamic fromUser;
@dynamic toUser;
@dynamic status;
@dynamic isRead;

+ (NSString *)parseClassName {
    return @"AddRequest";
}

@end
