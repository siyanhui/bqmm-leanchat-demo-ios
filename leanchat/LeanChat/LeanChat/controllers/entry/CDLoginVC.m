//
//  CDLoginController.m
//  LeanChat
//
//  Created by Qihe Bian on 7/24/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <LeanCloudSocial/AVOSCloudSNS.h>
#import <LZAlertViewHelper/LZAlertViewHelper.h>

#import "CDLoginVC.h"
#import "CDRegisterVC.h"
#import "CDAppDelegate.h"
#import "CDEntryBottomButton.h"
#import "CDEntryActionButton.h"
#import "CDBaseNavC.h"
#import "CDSNSView.h"
#import "CDUserManager.h"
#import "CDPhoneRegisterVC.h"

@interface CDLoginVC () <CDSNSViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) LZAlertViewHelper *alertViewHelper;

@property (nonatomic, strong) CDEntryActionButton *loginButton;
@property (nonatomic, strong) CDEntryBottomButton *registerButton;
@property (nonatomic, strong) CDEntryBottomButton *forgotPasswordButton;
@property (nonatomic, strong) CDSNSView *snsView;

@end

@implementation CDLoginVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:QQAppId andAppSecret:QQAppKey andRedirectURI:nil];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:WeiboAppId andAppSecret:WeiboAppKey andRedirectURI:@"http://wanpaiapp.com/oauth/callback/sina"];
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSWeiXin withAppKey:WeChatAppId andAppSecret:WeChatSecretKey andRedirectURI:nil];
    
    self.usernameField.placeholder = @"用户名或手机号";
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.forgotPasswordButton];
    [self.view addSubview:self.snsView];
    
//    [self performSelector:@selector(toRegister:) withObject:nil afterDelay:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.usernameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_USERNAME];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Propertys

- (CDResizableButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [[CDEntryActionButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.usernameField.frame), CGRectGetMaxY(self.passwordField.frame) + kEntryVCVerticalSpacing, CGRectGetWidth(self.usernameField.frame), CGRectGetHeight(self.usernameField.frame))];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)registerButton {
    if (_registerButton == nil) {
        _registerButton = [[CDEntryBottomButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - kEntryVCTextFieldHeight, CGRectGetWidth(self.view.frame) / 2, kEntryVCTextFieldHeight)];
        [_registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(toRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIButton *)forgotPasswordButton {
    if (_forgotPasswordButton == nil) {
        _forgotPasswordButton = [[CDEntryBottomButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) - kEntryVCTextFieldHeight, CGRectGetWidth(self.view.frame) / 2, kEntryVCTextFieldHeight)];
        [_forgotPasswordButton setTitle:@"找回密码" forState:UIControlStateNormal];
        [_forgotPasswordButton addTarget:self action:@selector(toFindPassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotPasswordButton;
}

- (CDSNSView *)snsView {
    if (_snsView == nil) {
        NSMutableArray *displayTypes = [NSMutableArray arrayWithObjects:@(CDSNSTypeQQ), @(CDSNSTypeWeibo), nil];
        if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSWeiXin]) {
            [displayTypes addObject:@(CDSNSTypeWeiXin)];
        }
        CGSize size = [CDSNSView sizeForDisplayTypes:displayTypes];
        _snsView = [[CDSNSView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - size.width / 2, CGRectGetMinY(self.registerButton.frame) - kEntryVCVerticalSpacing - size.height , size.width, size.height)];
        _snsView.displayTypes = displayTypes;
        _snsView.delegate = self;
        [_snsView reloadData];
    }
    return _snsView;
}

- (LZAlertViewHelper *)alertViewHelper {
    if (_alertViewHelper == nil) {
        _alertViewHelper = [[LZAlertViewHelper alloc] init];
    }
    return _alertViewHelper;
}

#pragma mark - Actions
- (void)login:(id)sender {
    if (self.usernameField.text.length < USERNAME_MIN_LENGTH || self.passwordField.text.length < PASSWORD_MIN_LENGTH) {
        [self toast:@"用户名或密码至少三位"];
        return;
    }
    [[CDUserManager manager] loginWithInput:self.usernameField.text password:self.passwordField.text block:^(AVUser *user, NSError *error) {
        if (error) {
            [self showHUDText:error.localizedDescription];
        }
        else {
            [[NSUserDefaults standardUserDefaults] setObject:self.usernameField.text forKey:KEY_USERNAME];
            CDAppDelegate *delegate = (CDAppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate toMain];
        }
    }];
}

- (void)toRegister:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"注册方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手机号注册",@"用户名注册", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    CDBaseVC *nextVC;
    if (buttonIndex == 0) {
        nextVC = [[CDPhoneRegisterVC alloc] init];
    } else {
        nextVC = [[CDRegisterVC alloc] init];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    CDBaseNavC *nav = [[CDBaseNavC alloc] initWithRootViewController:nextVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)toFindPassword:(id)sender {
    [self showHUDText:@"鞭打工程师中..."];
}


#pragma mark - sns login button clicked

- (BOOL)filterError:(NSError *)error {
    if (error.code == AVOSCloudSNSErrorUserCancel) {
        [self showHUDText:@"取消了登录"];
        return NO;
    }
    return [super filterError:error];
}

- (void)snsView:(CDSNSView *)snsView buttonClickedForType:(CDSNSType)type {
    NSString *platform;
    AVOSCloudSNSType snsType;
    switch (type) {
        case CDSNSTypeQQ: {
            snsType = AVOSCloudSNSQQ;
            platform = AVOSCloudSNSPlatformQQ;
            break;
        }
        case CDSNSTypeWeiXin: {
            snsType = AVOSCloudSNSWeiXin;
            platform = AVOSCloudSNSPlatformWeiXin;
            break;
        }
        case CDSNSTypeWeibo: {
            snsType = AVOSCloudSNSSinaWeibo;
            platform = AVOSCloudSNSPlatformWeiBo;
            break;
        }
    }
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        if ([self filterError:error]) {
            [[CDUserManager manager] loginByAuthData:object platform:platform block:^(BOOL succeeded, NSError *error) {
                if ([self filterError:error]) {
                    CDAppDelegate *delegate = (CDAppDelegate *)[UIApplication sharedApplication].delegate;
                    [delegate toMain];
                }
            }];
        }
    } toPlatform:snsType];
}

@end
