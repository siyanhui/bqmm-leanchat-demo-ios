//
//  CDConvNameVC.m
//  LeanChat
//
//  Created by lzw on 15/2/5.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDConvNameVC.h"

@interface CDConvNameVC ()

@property (strong, nonatomic) IBOutlet UITableViewCell *tableCell;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation CDConvNameVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"群聊名称";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveName:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backPressed)];
    self.nameTextField.text = self.conv.displayName;
    self.tableView.scrollEnabled = NO;
    //FIXME:修改 tableView 的高度
}

- (void)backPressed {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveName:(id)sender {
    if (self.nameTextField.text.length > 0) {
        [self showProgress];
        AVIMConversationUpdateBuilder *updateBuilder = [self.conv newUpdateBuilder];
        [updateBuilder setName:self.nameTextField.text];
        [self.conv update:[updateBuilder dictionary] callback: ^(BOOL succeeded, NSError *error) {
            [self hideProgress];
            if ([self filterError:error]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kCDNotificationConversationUpdated object:nil];
                [self backPressed];
            }
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableCell;
}

@end
