//
//  AVIMConversation+CustomAttributes.m
//  LeanChatLib
//
//  Created by lzw on 15/4/8.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "AVIMConversation+Custom.h"
#import "CDChatManager.h"
#import "UIImage+Icon.h"
#import <objc/runtime.h>

@implementation AVIMConversation (Custom)

- (AVIMTypedMessage *)lastMessage {
    return objc_getAssociatedObject(self, @selector(lastMessage));
}

- (void)setLastMessage:(AVIMTypedMessage *)lastMessage {
    objc_setAssociatedObject(self, @selector(lastMessage), lastMessage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)unreadCount {
    return [objc_getAssociatedObject(self, @selector(unreadCount)) intValue];
}

- (void)setUnreadCount:(NSInteger)unreadCount {
    objc_setAssociatedObject(self, @selector(unreadCount), @(unreadCount), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)mentioned {
    return [objc_getAssociatedObject(self, @selector(mentioned)) boolValue];
}

- (void)setMentioned:(BOOL)mentioned {
    objc_setAssociatedObject(self, @selector(mentioned), @(mentioned), OBJC_ASSOCIATION_ASSIGN);
}

- (CDConversationType)type {
    return [[self.attributes objectForKey:CONVERSATION_TYPE] intValue];
}

+ (NSString *)nameOfUserIds:(NSArray *)userIds {
    NSMutableArray *names = [NSMutableArray array];
    for (int i = 0; i < userIds.count; i++) {
        id<CDUserModelDelegate> user = [[CDChatManager manager].userDelegate getUserById:[userIds objectAtIndex:i]];
        [names addObject:user.username];
    }
    return [names componentsJoinedByString:@","];
}

- (NSString *)displayName {
    if ([self type] == CDConversationTypeSingle) {
        NSString *otherId = [self otherId];
        id<CDUserModelDelegate> other = [[CDChatManager manager].userDelegate getUserById:otherId];
        return other.username;
    } else {
        return self.name;
    }
}

- (NSString *)otherId {
    NSArray *members = self.members;
    if (members.count == 0) {
        [NSException raise:@"invalid conversation" format:@"invalid conversation"];
    }
    if (members.count == 1) {
        return members[0];
    }
    NSString *otherId;
    if ([members[0] isEqualToString:[CDChatManager manager].clientId]) {
        otherId = members[1];
    } else {
        otherId = members[0];
    }
    return otherId;
}

- (NSString *)title {
    if (self.type == CDConversationTypeSingle) {
        return self.displayName;
    } else {
        return [NSString stringWithFormat:@"%@(%ld)", self.displayName, (long)self.members.count];
    }
}

- (UIImage *)icon {
    NSString *name = self.name;
    if (name.length == 0) {
        name = @"Conversation";
    }
    return [UIImage imageWithHashString:self.conversationId displayString:[[name substringWithRange:NSMakeRange(0, 1)] capitalizedString]];
}

@end
