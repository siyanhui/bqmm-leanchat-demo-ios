//
//  LCCKVCardView.h
//  ChatKit-OC
//
//  v0.8.5 Created by ElonChan on 16/8/15.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^LCCKVCardDidClickedHandler)(NSString *clientId);
@interface LCCKVCardView : UIView

+ (id)vCardView;
- (void)configureWithAvatarURL:(NSURL *)avatarURL title:(NSString *)title clientId:(NSString *)clientId;
@property (nonatomic, copy) LCCKVCardDidClickedHandler vCardDidClickedHandler;
- (void)setVCardDidClickedHandler:(LCCKVCardDidClickedHandler)vCardDidClickedHandler;

@end
