//
//  LCCKBQMMMessageCell.m
//  ChatKit-OC
//
//  Created by isan on 28/12/2017.
//  Copyright © 2017 ElonChan. All rights reserved.
//
#import "LCCKBQMMMessageCell.h"
#import "UIImage+LCCKExtension.h"
#import <BQMM/BQMM.h>

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#else
#import "UIImageView+WebCache.h"
#endif

@interface LCCKBQMMMessageCell ()

/**
 *  用来显示image的UIImageView
 */
@property (nonatomic, strong) UIImageView *messageImageView;

/**
 *  用来显示上传进度的UIView
 */
@property (nonatomic, strong) UIView *messageProgressView;

/**
 *  显示上传进度百分比的UILabel
 */
@property (nonatomic, weak) UILabel *messageProgressLabel;

@end

@implementation LCCKBQMMMessageCell

#pragma mark - Override Methods

#pragma mark - Public Methods

- (void)setup {
    [self.messageContentView addSubview:self.messageImageView];
    self.messageContentView.clipsToBounds = true;
    [self.messageContentView addSubview:self.messageProgressView];
    UIEdgeInsets edgeMessageBubbleCustomize;
    if (self.messageOwner == LCCKMessageOwnerTypeSelf) {
        UIEdgeInsets rightEdgeMessageBubbleCustomize = [LCCKSettingService sharedInstance].rightHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = rightEdgeMessageBubbleCustomize;
    } else {
        UIEdgeInsets leftEdgeMessageBubbleCustomize = [LCCKSettingService sharedInstance].leftHollowEdgeMessageBubbleCustomize;
        edgeMessageBubbleCustomize = leftEdgeMessageBubbleCustomize;
    }
    [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentView).with.insets(edgeMessageBubbleCustomize);
        make.height.lessThanOrEqualTo(@200).priorityHigh();
    }];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapMessageImageViewGestureRecognizerHandler:)];
    [self.messageContentView addGestureRecognizer:recognizer];
    [super setup];
    [self addGeneralView];
}

- (void)singleTapMessageImageViewGestureRecognizerHandler:(UITapGestureRecognizer *)tapGestureRecognizer {
    //BQMM集成
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if(self.delegate&&[self.delegate respondsToSelector:@selector(didTapBQMMEemojiMessage:)]){
            [self.delegate didTapBQMMEemojiMessage:self.message];
        }
    }
}


//BQMM集成
- (void)configureCellWithData:(LCCKMessage *)message {
    [super configureCellWithData:message];
    if ([[message class] isSubclassOfClass:[AVIMTypedMessage class]]){
        AVIMTypedMessage *tempMessage = message;
        NSDictionary *ext = tempMessage.attributes;
        if([ext[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_FACE_TYPE]) {
            NSDictionary *ext = tempMessage.attributes;
            NSArray *codes = nil;
            if (ext[TEXT_MESG_DATA]) {
                codes = @[ext[TEXT_MESG_DATA][0][0]];
            }
            __weak typeof(self) weakself = self;
            [[MMEmotionCentre defaultCentre] fetchEmojisByType:MMFetchTypeBig codes:codes completionHandler:^(NSArray *emojis) {
                if (emojis.count > 0) {
                    MMEmoji *emoji = emojis[0];
                    if ([codes[0] isEqualToString:emoji.emojiCode]) {
                        weakself.messageImageView.image = emoji.emojiImage;
                    }
                }
                else {
                    weakself.messageImageView.image = [UIImage imageNamed:@"mm_emoji_error"];
                }
            }];
        }else if([ext[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_WEB_TYPE]) {
            self.messageImageView.image = [UIImage imageNamed:@"mm_emoji_loading"];
            NSDictionary *msgData = ext[TEXT_MESG_DATA];
            NSString *webStickerUrl = msgData[WEBSTICKER_URL];
            NSURL *url = [[NSURL alloc] initWithString:webStickerUrl];
            if (url != nil) {
                __weak typeof(self) weakSelf = self;
                [self.messageImageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageAvoidAutoSetImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    if(error == nil && image) {
                        if (image.images.count > 1) {
                            weakSelf.messageImageView.animationImages = image.images;
                            weakSelf.messageImageView.image = image.images[0];
                            weakSelf.messageImageView.animationDuration = image.duration;
                            [weakSelf.messageImageView startAnimating];
                        }else{
                            weakSelf.messageImageView.image = image;
                        }
                    }else{
                        weakSelf.messageImageView.image = [UIImage imageNamed:@"mm_emoji_error"];
                    }
                }];
                
            }else{
                self.messageImageView.image = [UIImage imageNamed:@"mm_emoji_error"];
            }
        }
    }
}

- (UIImage *)imageInBundleForImageName:(NSString *)imageName {
    return ({
        UIImage *image = [UIImage lcck_imageNamed:imageName bundleName:@"Placeholder" bundleForClass:[self class]];
        image;});
}

#pragma mark - Setters

- (void)setUploadProgress:(CGFloat)uploadProgress {
    [self setMessageSendState:LCCKMessageSendStateSending];
    [self.messageProgressView setFrame:CGRectMake(self.messageImageView.frame.origin.x, self.messageImageView.frame.origin.y, self.messageImageView.bounds.size.width, self.messageImageView.bounds.size.height * (1 - uploadProgress))];
    [self.messageProgressLabel setText:[NSString stringWithFormat:@"%.0f%%",uploadProgress * 100]];
}

- (void)setMessageSendState:(LCCKMessageSendState)messageSendState {
    [super setMessageSendState:messageSendState];
    if (messageSendState == LCCKMessageSendStateSending) {
        if (!self.messageProgressView.superview) {
            [self.messageContentView addSubview:self.messageProgressView];
        }
        [self.messageProgressLabel setFrame:CGRectMake(self.messageImageView.frame.origin.y, self.messageImageView.image.size.height/2 - 8, self.messageImageView.image.size.width, 16)];
    } else {
        [self removeProgressView];
    }
}

- (void)removeProgressView {
    [self.messageProgressView removeFromSuperview];
    [[self.messageProgressView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.messageProgressView = nil;
    self.messageProgressLabel = nil;
}

#pragma mark - Getters

- (UIImageView *)messageImageView {
    if (!_messageImageView) {
        _messageImageView = [[UIImageView alloc] init];
        //FIXME:这一行可以不需要
        _messageImageView.contentMode = UIViewContentModeScaleAspectFit;
        _messageImageView.clipsToBounds = true;
    }
    return _messageImageView;
    
}

- (UIView *)messageProgressView {
    if (!_messageProgressView) {
        _messageProgressView = [[UIView alloc] init];
        _messageProgressView.backgroundColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.3f];
        _messageProgressView.translatesAutoresizingMaskIntoConstraints = NO;
        _messageProgressView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UILabel *progressLabel = [[UILabel alloc] init];
        progressLabel.font = [UIFont systemFontOfSize:14.0f];
        progressLabel.textColor = [UIColor whiteColor];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        [_messageProgressView addSubview:self.messageProgressLabel = progressLabel];
    }
    return _messageProgressView;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.messageImageView.image = nil;
    self.messageImageView.animationImages = nil;
}

#pragma mark -
#pragma mark - LCCKChatMessageCellSubclassing Method

+ (void)load {
    [self registerSubclass];
}

+ (AVIMMessageMediaType)classMediaType {
    return kAVIMMessageMediaTypeImage;
}

+ (CGFloat)heightForBQMMCellWithMessage: (AVIMTypedMessage *)message {
    if([message.attributes[TEXT_MESG_TYPE] isEqualToString:TEXT_MESG_WEB_TYPE]) {
        NSDictionary *msgData = message.attributes[TEXT_MESG_DATA];
        float height = [msgData[WEBSTICKER_HEIGHT] floatValue];
        float width = [msgData[WEBSTICKER_WIDTH] floatValue];
//        //宽最大200 高最大 150
//        if (width > 200) {
//            height = 200.0 / width * height;
//            width = 200;
//        }else if(height > 150) {
//            width = 150.0 / height * width;
//            height = 150;
//        }
//        if(height > 200) {
//            width = 200 / height * width;
//            height = 200;
//        }
        return height;
    }else {
        return 140.0f;
    }
}

@end
