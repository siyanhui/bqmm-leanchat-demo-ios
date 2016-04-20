//
//  CDEntryVC.h
//  LeanChat
//
//  Created by lzw on 15/4/15.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDBaseVC.h"
#import "CDTextField.h"
#import "CDResizableButton.h"
#import <AVOSCloud/AVOSCloud.h>
#import "CDEntryBaseVC.h"
#import "CDCommon.h"

static CGFloat kEntryVCIconImageViewMarginTop = 100;
static CGFloat kEntryVCIconImageViewSize = 80;
static CGFloat kEntryVCUsernameFieldMarginTop = 30;

@interface CDEntryVC : CDEntryBaseVC

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) CDTextField *usernameField;
@property (nonatomic, strong) CDTextField *passwordField;

@end
