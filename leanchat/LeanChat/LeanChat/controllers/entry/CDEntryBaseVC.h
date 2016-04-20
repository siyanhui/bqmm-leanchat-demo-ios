//
//  CDEntryBaseVC.h
//  LeanChat
//
//  Created by lzw on 15/8/10.
//  Copyright (c) 2015年 LeanCloud（Bug汇报：QQ1356701892）.  All rights reserved.
//

#import "CDBaseVC.h"

static CGFloat kEntryVCHorizontalSpacing = 30;
static CGFloat kEntryVCVerticalSpacing = 15;
static CGFloat kEntryVCTextFieldPadding = 10;
static CGFloat kEntryVCTextFieldHeight = 40;

@interface CDEntryBaseVC : CDBaseVC

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIBarButtonItem *cancelBarButtonItem;

- (void)closeKeyboard:(id)sender;

@end
