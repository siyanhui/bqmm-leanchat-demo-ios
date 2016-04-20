//
//  CDSNSView.m
//  LeanChat
//
//  Created by lzw on 15/8/7.
//  Copyright (c) 2015年 LeanCloud（Bug汇报：QQ1356701892）.  All rights reserved.
//

#import "CDSNSView.h"
#import "CDResizableButton.h"

static CGFloat const kCDSNSButtonSize = 40;
static CGFloat const kCDSNSButtonMargin = 15;

@interface CDSNSView()

@property (nonatomic, strong) CDResizableButton *weixinButton;
@property (nonatomic, strong) CDResizableButton *qqButton;
@property (nonatomic, strong) CDResizableButton *weiboButton;

@end

@implementation CDSNSView

+ (CGSize)sizeForDisplayTypes:(NSArray *)types {
    return CGSizeMake(types.count * (kCDSNSButtonSize + kCDSNSButtonMargin) - kCDSNSButtonMargin, kCDSNSButtonSize);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (CDResizableButton *)qqButton {
    if (_qqButton == nil) {
        _qqButton = [[CDResizableButton alloc] initWithFrame:CGRectZero];
        [_qqButton setImage:[UIImage imageNamed:@"sns_qq"] forState:UIControlStateNormal];
        [_qqButton addTarget:self action:@selector(qqButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqButton;
}

- (CDResizableButton *)weixinButton {
    if (_weixinButton == nil) {
        _weixinButton = [[CDResizableButton alloc] initWithFrame:CGRectZero];
        [_weixinButton setImage:[UIImage imageNamed:@"sns_wechat"] forState:UIControlStateNormal];
        [_weixinButton addTarget:self action:@selector(weixinButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weixinButton;
}

- (CDResizableButton *)weiboButton {
    if (_weiboButton == nil) {
        _weiboButton = [[CDResizableButton alloc] initWithFrame:CGRectZero];
        [_weiboButton setImage:[UIImage imageNamed:@"sns_weibo"] forState:UIControlStateNormal];
        [_weiboButton addTarget:self action:@selector(weiboButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weiboButton;
}

- (UIView *)buttonForType:(CDSNSType)type {
    switch (type) {
        case CDSNSTypeQQ:
            return self.qqButton;
        case CDSNSTypeWeibo:
            return self.weiboButton;
        case CDSNSTypeWeiXin:
            return self.weixinButton;
    }
    return nil;
}

- (void)reloadData {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (id displayType in self.displayTypes) {
        CDSNSType viewType = [displayType intValue];
        NSInteger index = [self.displayTypes indexOfObject:displayType];
        CGRect frame = CGRectMake(index * (kCDSNSButtonSize + kCDSNSButtonMargin ), 0, kCDSNSButtonSize, kCDSNSButtonSize);
        UIView * button =[self buttonForType:viewType];
        button.frame = frame;
        [self addSubview:button];
    }
}

- (void)handleClickForType:(CDSNSType)type {
    if ([self.delegate respondsToSelector:@selector(snsView:buttonClickedForType:)]) {
        [self.delegate snsView:self buttonClickedForType:type];
    }
}

- (void)weixinButtonClicked:(id)sender {
    [self handleClickForType:CDSNSTypeWeiXin];
}

- (void)qqButtonClicked:(id)sender {
    [self handleClickForType:CDSNSTypeQQ];
}

- (void)weiboButtonClicked:(id)sender {
    [self handleClickForType:CDSNSTypeWeibo];
}

@end
