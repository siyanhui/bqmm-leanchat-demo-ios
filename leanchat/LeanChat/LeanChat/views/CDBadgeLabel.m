//
//  CDBadgeLabel.m
//  LeanChat
//
//  Created by lzw on 15/1/12.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDBadgeLabel.h"

@implementation CDBadgeLabel


- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setup {
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor redColor];
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
}

- (void)setNormalStyle {
    self.layer.cornerRadius = 1;
    self.text = @"";
}

- (void)awakeFromNib {
    [self setup];
    // Initialization code
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
