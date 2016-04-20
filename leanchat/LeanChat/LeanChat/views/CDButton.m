//
//  CDButton.m
//  LeanChat
//
//  Created by lzw on 14/11/6.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import "CDButton.h"

@implementation CDButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setBackgroundImage:[UIImage imageNamed:@"blue_expand_normal"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"blue_expand_highlighted"] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return self;
}

@end
