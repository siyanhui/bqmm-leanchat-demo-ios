//
//  UITableViewCell+LCCKCellIdentifier.m
//  LCCKChatBarExample
//
//  v0.8.5 Created by ElonChan ( https://github.com/leancloud/ChatKit-OC ) on 15/11/23.
//  Copyright © 2015年 https://LeanCloud.cn . All rights reserved.
//

#import "LCCKCellIdentifierFactory.h"
#import "LCCKMessage.h"
#import "NSObject+LCCKExtension.h"
#import <AVOSCloudIM/AVIMConversation.h>
#import "AVIMTypedMessage+LCCKExtension.h"
#import "LCCKConstants.h"
#import "LCCKBQMMMessageCell.h"
@implementation LCCKCellIdentifierFactory

+ (NSString *)cellIdentifierForMessageConfiguration:(id)message conversationType:(LCCKConversationType)conversationType {
    NSString *groupKey;
    switch (conversationType) {
        case LCCKConversationTypeGroup:
            groupKey = LCCKCellIdentifierGroup;
            break;
        case LCCKConversationTypeSingle:
            groupKey = LCCKCellIdentifierSingle;
            break;
        default:
            groupKey = @"";
            break;
    }
    
    if ([message lcck_isCustomMessage]) {
        return [self cellIdentifierForCustomMessageConfiguration:(AVIMTypedMessage *)message groupKey:groupKey];
    }
    return [self cellIdentifierForDefaultMessageConfiguration:(LCCKMessage *)message groupKey:groupKey];
}

+ (NSString *)cellIdentifierForDefaultMessageConfiguration:(LCCKMessage *)message groupKey:(NSString *)groupKey {
    LCCKMessageOwnerType messageOwner = message.ownerType;
    AVIMMessageMediaType messageType = message.mediaType;
    if ([message lcck_isCustomLCCKMessage]) {
        messageType = kAVIMMessageMediaTypeText;
    }
    NSNumber *key = [NSNumber numberWithInteger:messageType];
    Class aClass = [LCCKChatMessageCellMediaTypeDict objectForKey:key];
    NSString *typeKey = NSStringFromClass(aClass);
    NSString *ownerKey;
    switch (messageOwner) {
        case LCCKMessageOwnerTypeSystem:
            ownerKey = LCCKCellIdentifierOwnerSystem;
            break;
        case LCCKMessageOwnerTypeOther:
            ownerKey = LCCKCellIdentifierOwnerOther;
            break;
        case LCCKMessageOwnerTypeSelf:
            ownerKey = LCCKCellIdentifierOwnerSelf;
            break;
        default:
            NSAssert(NO, @"Message Owner Unknow");
            break;
    }
    NSAssert(typeKey.length > 0, @"🔴类名与方法名：%@（在第%@行），描述：%@,%@", @(__PRETTY_FUNCTION__), @(__LINE__), @(message.mediaType), NSStringFromClass([message class]));
    
    //BQMM集成
    if ([[message class] isSubclassOfClass:[AVIMTypedMessage class]]){
        AVIMTypedMessage *tempMessage = message;
        if([tempMessage.attributes[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_FACE_TYPE]) {
            typeKey = NSStringFromClass([LCCKBQMMMessageCell class]);
        }else if([tempMessage.attributes[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_WEB_TYPE]) {
            typeKey = NSStringFromClass([LCCKBQMMMessageCell class]);
        }
    }
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_%@_%@", typeKey, ownerKey, groupKey];
    return cellIdentifier;
}

+ (NSString *)cellIdentifierForCustomMessageConfiguration:(AVIMTypedMessage *)message groupKey:(NSString *)groupKey {
    AVIMMessageIOType messageOwner = message.ioType;
    AVIMMessageMediaType messageType = message.mediaType;
    if (![message lcck_isSupportThisCustomMessage]) {
        messageType = kAVIMMessageMediaTypeText;
    }
    NSNumber *key = [NSNumber numberWithInteger:messageType];
    NSString *typeKey = NSStringFromClass([LCCKChatMessageCellMediaTypeDict objectForKey:key]);
    NSAssert(typeKey.length > 0, @"🔴类名与方法名：%@（在第%@行），描述：%@,%@", @(__PRETTY_FUNCTION__), @(__LINE__), @(message.mediaType), NSStringFromClass([message class]));
    NSString *ownerKey;
    switch (messageOwner) {
        case AVIMMessageIOTypeOut:
            ownerKey = LCCKCellIdentifierOwnerSelf;
            break;
        case AVIMMessageIOTypeIn:
            ownerKey = LCCKCellIdentifierOwnerOther;
            break;
        default:
            NSAssert(NO, @"Message Owner Unknow");
            break;
    }
    //BQMM集成
    if ([[message class] isSubclassOfClass:[AVIMTypedMessage class]]){
        AVIMTypedMessage *tempMessage = message;
        if([tempMessage.attributes[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_FACE_TYPE]) {
            typeKey = NSStringFromClass([LCCKBQMMMessageCell class]);
        }else if([tempMessage.attributes[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_WEB_TYPE]) {
            typeKey = NSStringFromClass([LCCKBQMMMessageCell class]);
        }
    }
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_%@_%@", typeKey, ownerKey, groupKey];
    return cellIdentifier;
}

+ (NSString *)cacheKeyForMessage:(id)message {
    if (![message lcck_isCustomMessage]) {
        LCCKMessage *message_ = (LCCKMessage *)message;
        return message_.messageId ?: message_.systemText;
    }
    AVIMTypedMessage *message_ = (AVIMTypedMessage *)message;
    return message_.messageId;
}

@end
