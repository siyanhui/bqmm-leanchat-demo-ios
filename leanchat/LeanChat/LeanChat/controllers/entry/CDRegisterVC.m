//
//  CDRegisterController.m
//  LeanChat
//
//  Created by Qihe Bian on 7/24/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "CDRegisterVC.h"
#import "CDAppDelegate.h"
#import "CDEntryActionButton.h"
#import "CDUserManager.h"

@interface CDRegisterVC () 

@property (nonatomic, strong) CDEntryActionButton *registerButton;

@end

@implementation CDRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    self.navigationItem.leftBarButtonItem = self.cancelBarButtonItem;
    [self.view addSubview:self.registerButton];
    
//    [self phoneButtonClicked:nil];
}

- (UIButton *)registerButton {
    if (_registerButton == nil) {
        _registerButton = [[CDEntryActionButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.usernameField.frame), CGRectGetMaxY(self.passwordField.frame) + kEntryVCVerticalSpacing, CGRectGetWidth(self.usernameField.frame), CGRectGetHeight(self.usernameField.frame))];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

#pragma mark - Actions

- (void)registerButtonClicked:(id)sender {
    if (self.usernameField.text.length < USERNAME_MIN_LENGTH || self.passwordField.text.length < PASSWORD_MIN_LENGTH) {
        [self toast:@"用户名或密码至少三位"];
        return;
    }
    [[CDUserManager manager] registerWithUsername:self.usernameField.text phone:nil password:self.passwordField.text block:^(BOOL succeeded, NSError *error) {
        if ([self filterError:error]) {
            [self dismissViewControllerAnimated:NO completion: ^{
                CDAppDelegate *delegate = (CDAppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate toMain];
            }];
        }
    }];
}

@end
