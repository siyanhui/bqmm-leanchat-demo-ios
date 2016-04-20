//
//  CDProfileNameVC.h
//
//  Created by lzw on 15/4/6.
//  Copyright (c) 2015年 lzw. All rights reserved.
//

#import <FXForms/FXForms.h>

@protocol CDProfileNameVCDelegate <NSObject>

- (void)didDismissProfileNameVCWithNewName:(NSString *)name;

@end

@interface CDProfileNameVC : FXFormViewController

@property (nonatomic, strong) NSString *placeholderName;

@property (nonatomic, strong) id<CDProfileNameVCDelegate> profileNameVCDelegate;

@end
