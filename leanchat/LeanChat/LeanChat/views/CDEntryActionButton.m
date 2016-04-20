//
//  CDEntryActionButton.m
//  LeanChat
//
//  Created by lzw on 15/5/21.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDEntryActionButton.h"

@implementation CDEntryActionButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup {
    [self setBackgroundImage:[UIImage imageNamed:@"blue_expand_normal"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"blue_expand_highlight"] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageNamed:@"blue_expand_highlight"] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
