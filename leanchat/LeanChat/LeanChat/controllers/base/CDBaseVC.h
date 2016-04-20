//
//  CDBaseController.h
//  LeanChat
//
//  Created by Qihe Bian on 7/24/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDUtils.h"
#import "CDCommon.h"

typedef enum : NSInteger {
    CDViewControllerStylePlain = 0,
    CDViewControllerStylePresenting
}CDViewControllerStyle;

@interface CDBaseVC : UIViewController

@property (nonatomic, assign) CDViewControllerStyle viewControllerStyle;

- (void)showNetworkIndicator;

- (void)hideNetworkIndicator;

- (void)showProgress;

- (void)hideProgress;

- (void)alert:(NSString *)msg;

- (BOOL)alertError:(NSError *)error;

- (BOOL)filterError:(NSError *)error;

- (void)runInMainQueue:(void (^)())queue;

- (void)runInGlobalQueue:(void (^)())queue;

- (void)runAfterSecs:(float)secs block:(void (^)())block;

- (void)showHUDText:(NSString *)text;

- (void)toast:(NSString *)text;

- (void)toast:(NSString *)text duration:(NSTimeInterval)duration;

@end
