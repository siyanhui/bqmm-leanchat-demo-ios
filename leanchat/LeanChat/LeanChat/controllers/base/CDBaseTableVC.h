//
//  CDBaseTableController.h
//  LeanChat
//
//  Created by Qihe Bian on 7/24/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "CDBaseVC.h"

@interface CDBaseTableVC : CDBaseVC <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)loadDataSource;

@end
