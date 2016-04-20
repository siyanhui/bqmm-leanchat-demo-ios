//
//  AddRequest.h
//  LeanChat
//
//  Created by lzw on 14-10-23.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import "CDCommon.h"

typedef enum : NSUInteger {
    CDAddRequestStatusWait = 0,
    CDAddRequestStatusDone
} CDAddRequestStatus;

#define kAddRequestFromUser @"fromUser"
#define kAddRequestToUser @"toUser"
#define kAddRequestStatus @"status"
#define kAddRequestIsRead @"isRead"

@interface CDAddRequest : AVObject<AVSubclassing>

@property (nonatomic) AVUser *fromUser;
@property (nonatomic) AVUser *toUser;
@property (nonatomic, assign) CDAddRequestStatus status;
@property (nonatomic, assign) BOOL isRead; /**< 是否已读*/

@end
