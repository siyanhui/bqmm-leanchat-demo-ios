//
//  XHPhotographyHelper.h
//  MessageDisplayExample
//
//  Created by HUAJIE-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DidFinishTakeMediaCompledBlock)(UIImage *image, NSDictionary *editingInfo);
typedef void (^DidFinishTakeImageBlock)(UIImage *image);

@interface MCPhotographyHelper : NSObject

- (void)showOnPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing compled:(DidFinishTakeMediaCompledBlock)compled;

- (void)showOnPickerViewControllerOnViewController:(UIViewController *)viewController completion:(DidFinishTakeImageBlock)completion;

@end
