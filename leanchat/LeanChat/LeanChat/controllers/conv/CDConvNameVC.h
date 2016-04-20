//
//  CDConvNameVC.h
//  LeanChat
//
//  Created by lzw on 15/2/5.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDBaseTableVC.h"
#import "CDConvDetailVC.h"
#import <LeanChatLib/CDChatManager.h>

@interface CDConvNameVC : CDBaseTableVC

@property (nonatomic, strong) CDConvDetailVC *detailVC;
@property (nonatomic,strong) AVIMConversation *conv;

@end
