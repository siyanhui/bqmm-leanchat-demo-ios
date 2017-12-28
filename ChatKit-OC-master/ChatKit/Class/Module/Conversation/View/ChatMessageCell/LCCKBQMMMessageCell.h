//
//  LCCKBQMMMessageCell.h
//  ChatKit-OC
//
//  Created by isan on 28/12/2017.
//  Copyright © 2017 ElonChan. All rights reserved.
//

#import "LCCKChatMessageCell.h"
#import "AVIMTypedMessage.h"

@interface LCCKBQMMMessageCell : LCCKChatMessageCell<LCCKChatMessageCellSubclassing>

/**
 *  用来显示image的UIImageView
 */
@property (nonatomic, strong, readonly) UIImageView *messageImageView;

- (void)setUploadProgress:(CGFloat)uploadProgress;

//BQMM集成
+ (CGFloat)heightForBQMMCellWithMessage: (AVIMTypedMessage *)message;
@end
