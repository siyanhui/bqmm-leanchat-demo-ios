//
//  CDTextField.h
//  LeanChat
//
//  Created by Qihe Bian on 7/24/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat kCDTextFieldCommonVerticalPadding = 10;
static CGFloat kCDTextFieldCommonHorizontalPadding = 10;

@interface CDTextField : UITextField

@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat horizontalPadding;

+ (instancetype)textFieldWithPadding:(CGFloat)padding;

@end
