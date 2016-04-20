//
//  CDTextField.m
//  LeanChat
//
//  Created by Qihe Bian on 7/24/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "CDTextField.h"

@implementation CDTextField

+ (instancetype)textFieldWithPadding:(CGFloat)padding {
    CDTextField *textField = [[CDTextField alloc] initWithFrame:CGRectZero];
    textField.horizontalPadding = padding;
    textField.verticalPadding = padding;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, _horizontalPadding, _verticalPadding);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, _horizontalPadding, _verticalPadding);
}

@end
