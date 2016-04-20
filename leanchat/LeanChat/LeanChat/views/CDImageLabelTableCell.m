//
//  CDImageLabelTableCell.m
//  LeanChat
//
//  Created by lzw on 14/11/5.
//  Copyright (c) 2014年 LeanCloud. All rights reserved.
//

#import "CDImageLabelTableCell.h"

@implementation CDImageLabelTableCell

+ (NSString *)identifier {
    return NSStringFromClass([CDImageLabelTableCell class]);
}

+ (void)registerCellToTalbeView:(UITableView *)tableView {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([CDImageLabelTableCell class]) bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[CDImageLabelTableCell identifier]];
}

+ (CDImageLabelTableCell *)createOrDequeueCellByTableView:(UITableView *)tableView {
    CDImageLabelTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[CDImageLabelTableCell identifier]];
    if (cell == nil) {
        cell = [[CDImageLabelTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CDImageLabelTableCell identifier]];
        if (cell == nil) {
            [CDImageLabelTableCell registerCellToTalbeView:tableView];
            return [self createOrDequeueCellByTableView:tableView];
        }
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
