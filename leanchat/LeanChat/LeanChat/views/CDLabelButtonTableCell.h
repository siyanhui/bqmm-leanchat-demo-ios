//
//  CDNewFriendTableCell.h
//  LeanChat
//
//  Created by lzw on 14-10-23.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDLabelButtonTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end
