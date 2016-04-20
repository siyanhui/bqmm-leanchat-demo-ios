//
//  CDImageLabelTableCell.h
//  LeanChat
//
//  Created by lzw on 14/11/5.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDImageLabelTableCell : UITableViewCell

+ (NSString *)identifier;

+ (void)registerCellToTalbeView:(UITableView *)tableView;

+ (CDImageLabelTableCell *)createOrDequeueCellByTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@end
