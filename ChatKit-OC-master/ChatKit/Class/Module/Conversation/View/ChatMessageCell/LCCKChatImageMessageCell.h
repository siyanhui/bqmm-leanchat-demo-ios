//
//  LCCKChatImageMessageCell.h
//  LCCKChatExample
//
//  v0.8.5 Created by ElonChan ( https://github.com/leancloud/ChatKit-OC ) on 15/11/16.
//  Copyright © 2015年 https://LeanCloud.cn . All rights reserved.
//

#import "LCCKChatMessageCell.h"
#import <BQMM/BQMM.h>
@interface LCCKChatImageMessageCell : LCCKChatMessageCell<LCCKChatMessageCellSubclassing>

/**
 *  用来显示image的UIImageView
 */
//BQMM集成
@property (nonatomic, strong, readonly) MMImageView *messageImageView;

- (void)setUploadProgress:(CGFloat)uploadProgress;

@end
