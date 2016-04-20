//
//  CDEntryBaseVC.m
//  LeanChat
//
//  Created by lzw on 15/8/10.
//  Copyright (c) 2015年 LeanCloud（Bug汇报：QQ1356701892）.  All rights reserved.
//

#import "CDEntryBaseVC.h"

@interface CDEntryBaseVC ()

@end

@implementation CDEntryBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    self.view.backgroundColor = RGBCOLOR(247, 248, 248);
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView addMotionEffect:[self motionEffectWithX:60 y:40]];
}

- (UIBarButtonItem *)cancelBarButtonItem {
    if (_cancelBarButtonItem == nil) {
        UIImage *image = [UIImage imageNamed:@"cancel"];
        UIImage *selectedImage = [UIImage imageNamed:@"cancel_selected"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:selectedImage forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _cancelBarButtonItem;
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion: ^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }];
}

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        _backgroundImageView.image = [UIImage imageNamed:@"login_background"];
    }
    return _backgroundImageView;
}

#pragma mark - MotionEffect

- (UIMotionEffectGroup *)motionEffectWithX:(CGFloat)x y:(CGFloat)y {
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xAxis.minimumRelativeValue = @(-x);
    xAxis.maximumRelativeValue = @(x);
    
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yAxis.minimumRelativeValue = @(-y);
    yAxis.maximumRelativeValue = @(y);
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xAxis, yAxis];
    return group;
}

- (void)closeKeyboard:(id)sender {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
