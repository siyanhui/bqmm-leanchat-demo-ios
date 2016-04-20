//
//  CDConvReportAbuseVC.m
//  LeanChat
//
//  Created by lzw on 15/4/29.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDConvReportAbuseVC.h"
#import "CDTextField.h"
#import "CDUserManager.h"
#import "CDUtils.h"

static CGFloat kCDConvReportAbuseVCHorizontalPadding = 10;
static CGFloat kCDConvReportAbuseVCVerticalPadding = 10;
static CGFloat kCDConvReportAbuseVCInputTextFieldHeight = 100;

@interface CDConvReportAbuseVC ()

@property (nonatomic, strong) CDTextField *inputTextField;

@property (nonatomic, strong) NSString *convid;

@end

@implementation CDConvReportAbuseVC


- (instancetype)initWithConversationId:(NSString *)convid;
{
    self = [super init];
    if (self) {
        _convid = convid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"举报";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submit:)];
    [self.view addSubview:self.inputTextField];
}

- (CDTextField *)inputTextField {
    if (_inputTextField == nil) {
        _inputTextField = [[CDTextField alloc] initWithFrame:CGRectMake(kCDConvReportAbuseVCHorizontalPadding, kCDConvReportAbuseVCVerticalPadding, CGRectGetWidth(self.view.frame) - 2 * kCDConvReportAbuseVCHorizontalPadding, kCDConvReportAbuseVCInputTextFieldHeight)];
        _inputTextField.borderStyle = UITextBorderStyleRoundedRect;
        _inputTextField.horizontalPadding = kCDTextFieldCommonHorizontalPadding;
        _inputTextField.verticalPadding = kCDTextFieldCommonVerticalPadding;
        _inputTextField.placeholder = @"请输入举报原因";
    }
    return _inputTextField;
}

- (void)submit:(id)sender {
    if (self.inputTextField.text.length > 0) {
        WEAKSELF
        DLog(@"%@", self.inputTextField.text);
        [self showProgress];
        [[CDUserManager manager] reportAbuseWithReason:self.inputTextField.text convid:self.convid block: ^(BOOL succeeded, NSError *error) {
            [weakSelf hideProgress];
            if ([self filterError:error]) {
                [self alert:@"感谢您的举报，我们将尽快处理。"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
