//
//  CDCacheService.m
//  LeanChat
//
//  Created by lzw on 14/12/3.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import "CDCacheManager.h"
#import "CDUtils.h"
#import "CDUserManager.h"
#import <LeanChatLib/CDChatManager.h>
#import <LeanChatLib/CDChatListVC.h>

static CDCacheManager *cacheManager;

@interface CDCacheManager ()<NSCacheDelegate>

@property (nonatomic, strong) NSMutableDictionary *userMemoryCache;
@property (nonatomic, copy) NSString *currentConversationId;
@property (nonatomic, strong) AVIMConversation *currentConversation;
@end

@implementation CDCacheManager

+ (instancetype)manager {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        cacheManager = [[CDCacheManager alloc] init];
    });
    return cacheManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userMemoryCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - cache delegate
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    //    DLog(@"will evict object");
}

#pragma mark - user cache

- (void)registerUsers:(NSArray *)users {
    for (AVUser *user in users) {
        [self.userMemoryCache setObject:user forKey:user.objectId];
    }
}

- (AVUser *)lookupUser:(NSString *)userId {
    return [self.userMemoryCache objectForKey:userId];
}

- (void)cacheUsersWithIds:(NSSet *)userIds callback:(AVBooleanResultBlock)callback {
    NSMutableSet *uncachedUserIds = [[NSMutableSet alloc] init];
    for (NSString *userId in userIds) {
        if ([[CDCacheManager manager] lookupUser:userId] == nil) {
            [uncachedUserIds addObject:userId];
        }
    }
    if ([uncachedUserIds count] > 0) {
        [[CDUserManager manager] findUsersByIds:[[NSMutableArray alloc] initWithArray:[uncachedUserIds allObjects]] callback: ^(NSArray *objects, NSError *error) {
            if (objects) {
                [[CDCacheManager manager] registerUsers:objects];
            }
            callback(YES, error);
        }];
    } else {
        callback(YES, nil);
    }
}

#pragma mark - current conversation

- (void)setCurrentConversation:(AVIMConversation *)conv {
    self.currentConversationId = conv.conversationId;
    _currentConversation = conv;
}

/* fetch from memory cache ,it is possible be nil ,if nil, please fetch from server with `refreshCurConv:`*/
- (AVIMConversation *)currentConversationFromMemory {
    //FIXME: lookupConvById may return NULL
    NSString *reason = [NSString stringWithFormat:@"class name :%@, line: %@, %@", @(__PRETTY_FUNCTION__), @(__LINE__), @"currentConversationId is NULL"];
    NSAssert(self.currentConversationId.length > 0, reason);
    NSString *currentConversationAssertReason = [NSString stringWithFormat:@"class name :%@, line: %@ , %@", @(__PRETTY_FUNCTION__), @(__LINE__), @"_currentConversation is NULL"];
    NSAssert(_currentConversation, currentConversationAssertReason);
    AVIMConversation *conversation = [[CDChatManager manager] lookupConversationById:self.currentConversationId];
    if (conversation) {
        return conversation;
    }
    return _currentConversation;
}

- (void)refreshCurrentConversation:(AVBooleanResultBlock)callback {
    if ([self currentConversationFromMemory] != nil) {
        [[CDChatManager manager] fecthConversationWithConversationId:[self currentConversationFromMemory].conversationId callback: ^(AVIMConversation *conversation, NSError *error) {
            if (error) {
                callback(NO, error);
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kCDNotificationConversationUpdated object:nil];
                callback(YES, nil);
            }
        }];
    } else {
        [self fetchCurrentConversation:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                callback(NO, error);
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:kCDNotificationConversationUpdated object:nil];
                callback(YES, nil);
            }
        }];
    }
}

- (void)fetchCurrentConversation:(AVBooleanResultBlock)callback {
    NSString *reason = [NSString stringWithFormat:@"class name :%@, line: %@ , %@", @(__PRETTY_FUNCTION__), @(__LINE__), @"please fetch when current conversation is nil"];
    NSAssert([self currentConversationFromMemory] == nil, reason);
    [[CDChatManager manager] fecthConversationWithConversationId:self.currentConversationId callback: ^(AVIMConversation *conversation, NSError *error) {
        if (error) {
            callback(NO, error);
        } else {
            [self setCurrentConversation:conversation];
            callback(YES, nil);
        }
    }];
}

- (void)fetchCurrentConversationIfNeeded:(AVIMConversationResultBlock)callback {
    if ([self currentConversationFromMemory] == nil) {
        [[CDChatManager manager] fecthConversationWithConversationId:self.currentConversationId callback: ^(AVIMConversation *conversation, NSError *error) {
            if (error) {
                callback(nil, error);
            }
            else {
                [self setCurrentConversation:conversation];
                callback(conversation, nil);
            }
        }];
    } else {
        callback([self currentConversationFromMemory], nil);
    }
}

@end
