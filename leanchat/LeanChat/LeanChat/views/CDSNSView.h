//
//  CDSNSView.h
//  LeanChat
//
//  Created by lzw on 15/8/7.
//  Copyright (c) 2015年 LeanCloud（Bug汇报：QQ1356701892）.  All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    CDSNSTypeQQ = 1,
    CDSNSTypeWeiXin = 2,
    CDSNSTypeWeibo = 4
}CDSNSType;

@class CDSNSView;

@protocol CDSNSViewDelegate <NSObject>

- (void)snsView:(CDSNSView *)snsView buttonClickedForType:(CDSNSType )type;

@end

@interface CDSNSView : UIView

@property (nonatomic, strong) NSArray *displayTypes;

@property (nonatomic, strong) id<CDSNSViewDelegate> delegate;

+ (CGSize)sizeForDisplayTypes:(NSArray *)types;

- (void)reloadData;

@end
