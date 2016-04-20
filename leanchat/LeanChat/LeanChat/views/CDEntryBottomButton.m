//
//  CDEntryBottomButton.m
//  LeanChat
//
//  Created by lzw on 15/5/21.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDEntryBottomButton.h"
#import "CDCommon.h"

@implementation CDEntryBottomButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIImage *image = [[UIImage imageNamed:@"bottom_bar_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    UIImage *selectedImage = [[UIImage imageNamed:@"bottom_bar_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [self setTitleColor:RGBCOLOR(93, 92, 92) forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
