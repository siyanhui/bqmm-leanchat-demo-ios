//
//  UIself+LCCKCellRegister.m
//  LCCKChatBarExample
//
//  v0.8.5 Created by ElonChan  ( https://github.com/leancloud/ChatKit-OC ) on 15/11/23.
//  Copyright © 2015年 https://LeanCloud.cn . All rights reserved.
//

#import "LCCKCellRegisterController.h"
#import "LCCKBQMMMessageCell.h"
#import "LCCKChatSystemMessageCell.h"
#import "LCCKConstants.h"

@implementation LCCKCellRegisterController
//
+ (void)registerChatMessageCellClassForTableView:(UITableView *)tableView {
    [LCCKChatMessageCellMediaTypeDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull mediaType, Class _Nonnull aClass, BOOL * _Nonnull stop) {
        if (mediaType.intValue != -7) {
            [self registerMessageCellClass:aClass ForTableView:tableView];
        }
    }];
    //BQMM集成
    [self registerSystemMessageCellClassForTableView:tableView];
    [self registerBQMMMessageCellClass:[LCCKBQMMMessageCell class] ForTableView:tableView];
    
}

+ (void)registerMessageCellClass:(Class)messageCellClass ForTableView:(UITableView *)tableView  {
    NSString *messageCellClassString = NSStringFromClass(messageCellClass);
    UINib *nib = [UINib nibWithNibName:messageCellClassString bundle:nil];
    if([[NSBundle mainBundle] pathForResource:messageCellClassString ofType:@"nib"] != nil) {
    [tableView registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerSelf, LCCKCellIdentifierGroup]];
    [tableView registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerSelf, LCCKCellIdentifierSingle]];
    [tableView registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerOther, LCCKCellIdentifierGroup]];
    [tableView registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerOther , LCCKCellIdentifierSingle]];
    } else {
        [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerSelf, LCCKCellIdentifierGroup]];
        [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerSelf, LCCKCellIdentifierSingle]];
        [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerOther, LCCKCellIdentifierGroup]];
        [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerOther , LCCKCellIdentifierSingle]];
    }
}

//BQMM集成
+ (void)registerBQMMMessageCellClass:(Class)messageCellClass ForTableView:(UITableView *)tableView  {
    NSString *messageCellClassString = NSStringFromClass(messageCellClass);
    [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerSelf, LCCKCellIdentifierGroup]];
    [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerSelf, LCCKCellIdentifierSingle]];
    [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerOther, LCCKCellIdentifierGroup]];
    [tableView registerClass:messageCellClass forCellReuseIdentifier:[NSString stringWithFormat:@"%@_%@_%@", messageCellClassString, LCCKCellIdentifierOwnerOther , LCCKCellIdentifierSingle]];
}



+ (void)registerSystemMessageCellClassForTableView:(UITableView *)tableView {
    [tableView registerClass:[LCCKChatSystemMessageCell class] forCellReuseIdentifier:@"LCCKChatSystemMessageCell_LCCKCellIdentifierOwnerSystem_LCCKCellIdentifierSingle"];
    [tableView registerClass:[LCCKChatSystemMessageCell class] forCellReuseIdentifier:@"LCCKChatSystemMessageCell_LCCKCellIdentifierOwnerSystem_LCCKCellIdentifierGroup"];
}

@end
