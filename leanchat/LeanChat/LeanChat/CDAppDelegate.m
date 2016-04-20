//
//  CDAppDelegate.m
//  LeanChat
//
//  Created by Qihe Bian on 7/23/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "CDAppDelegate.h"
#import "CDCommon.h"
#import "CDLoginVC.h"
#import "CDAbuseReport.h"
#import "CDCacheManager.h"
#import "CYLTabBarControllerConfig.h"
#import "CDUtils.h"
#import "CDAddRequest.h"
#import "CDIMService.h"
#import "LZPushManager.h"
#import <iRate/iRate.h>
#import <iVersion/iVersion.h>
#import <LeanCloudSocial/AVOSCloudSNS.h>
#import <AVOSCloudCrashReporting/AVOSCloudCrashReporting.h>
#import <OpenShare/OpenShareHeader.h>
#import "MBProgressHUD.h"

#import <BQMM/BQMM.h>

@interface CDAppDelegate()

@property (nonatomic, strong) CDLoginVC *loginVC;

@end

@implementation CDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [CDAddRequest registerSubclass];
    [CDAbuseReport registerSubclass];
#if USE_US
    [AVOSCloud useAVCloudUS];
#endif
    
    // Enable Crash Reporting
    [AVOSCloudCrashReporting enable];
    //希望能提供更详细的日志信息，打开日志的方式是在 AVOSCloud 初始化语句之后加上下面这句：
    
    //Objective-C
#ifndef __OPTIMIZE__
    [AVOSCloud setAllLogsEnabled:YES];
#endif
    
    [AVOSCloud setApplicationId:AVOSAppID clientKey:AVOSAppKey];
    //    [AVOSCloud setApplicationId:CloudAppId clientKey:CloudAppKey];
    //    [AVOSCloud setApplicationId:PublicAppId clientKey:PublicAppKey];
    
    [AVOSCloud setLastModifyEnabled:YES];
    
    if (SYSTEM_VERSION >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:NAVIGATION_COLOR];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    else {
        [[UINavigationBar appearance] setTintColor:NAVIGATION_COLOR];
    }
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:17], NSFontAttributeName, nil]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if ([AVUser currentUser]) {
        // Applications are expected to have a root view controller at the end of application launch
        self.window.rootViewController = [[UIViewController alloc] init];
        [self toMain];
    }
    else {
        [self toLogin];
    }
    
    [[LZPushManager manager] registerForRemoteNotification];
    
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [self initAnalytics];
    
#ifdef DEBUG
    [AVPush setProductionMode:NO];  // 如果要测试申请好友是否有推送，请设置为 YES
//    [AVOSCloud setAllLogsEnabled:YES];
#endif
    
    [[MMEmotionCentre defaultCentre] setAppId:@"15e0710942ec49a29d2224a6af4460ee"
                                       secret:@"b11e0936a9d04be19300b1d6eec0ccd5"];
    
    return YES;
}

- (void)initAnalytics {
    [AVAnalytics setAnalyticsEnabled:YES];
#ifdef DEBUG
    [AVAnalytics setChannel:@"Debug"];
#else
    [AVAnalytics setChannel:@"App Store"];
#endif
    // 应用每次启动都会去获取在线参数，这里同步获取即可。可能是上一次启动获取得到的在线参数。不过没关系。
    NSDictionary *configParams = [AVAnalytics getConfigParams];
    DLog(@"configParams: %@", configParams);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[LZPushManager manager] syncBadge];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[MMEmotionCentre defaultCentre] clearSession];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //[[LZPushManager manager] cleanBadge];
    [application cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[LZPushManager manager] syncBadge];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [AVOSCloudIM handleRemoteNotificationsWithDeviceToken:deviceToken];
    [[LZPushManager manager] saveInstallationWithDeviceToken:deviceToken userId:[AVUser currentUser].objectId];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState == UIApplicationStateActive) {
        // 应用在前台时收到推送，只能来自于普通的推送，而非离线消息推送
    }
    else {
//  当使用 https://github.com/leancloud/leanchat-cloudcode 云代码更改推送内容的时候
//        {
//            aps =     {
//                alert = "lzwios : sdfsdf";
//                badge = 4;
//                sound = default;
//            };
//            convid = 55bae86300b0efdcbe3e742e;
//        }
        [[CDChatManager manager] didReceiveRemoteNotification:userInfo];
        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    DLog(@"receiveRemoteNotification");
}

- (void)toLogin {
    self.loginVC = [[CDLoginVC alloc] init];
    self.window.rootViewController = self.loginVC;
}

- (void)toMain{
    [iRate sharedInstance].applicationBundleID = @"com.avoscloud.leanchat";
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].previewMode = NO;
    [iVersion sharedInstance].applicationBundleID = @"com.avoscloud.leanchat";
    [iVersion sharedInstance].previewMode = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[CDCacheManager manager] registerUsers:@[[AVUser currentUser]]];
    [CDChatManager manager].userDelegate = [CDIMService service];

#ifdef DEBUG
#warning 使用开发证书来推送，方便调试，具体可看这个变量的定义处
    [CDChatManager manager].useDevPushCerticate = YES;
#endif
    
    //提示正在登陆
    [self toast:@"正在登陆" duration:MAXFLOAT];
    [[CDChatManager manager] openWithClientId:[AVUser currentUser].objectId callback: ^(BOOL succeeded, NSError *error) {
        [self hideProgress];
        if (succeeded) {
            CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
            self.window.rootViewController = tabBarControllerConfig.tabBarController;
        } else {
            [self toLogin];
            DLog(@"%@", error);
        }

    }];
}

- (void)toast:(NSString *)text duration:(NSTimeInterval)duration {
    [AVAnalytics event:@"toast" attributes:@{@"text": text}];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    //    hud.labelText=text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.detailsLabelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud hide:YES afterDelay:duration];
}

-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.window animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.window animated:YES];
}

#pragma mark -

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [AVOSCloudSNS handleOpenURL:url];
    [OpenShare handleOpenURL:url];
    return YES;
}

@end
