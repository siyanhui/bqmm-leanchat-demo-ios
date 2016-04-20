//
//  CDWebViewVC.m
//  LeanChat
//
//  Created by lzw on 15/4/28.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDWebViewVC.h"

@interface CDWebViewVC ()

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSURL *url;

@end

@implementation CDWebViewVC

- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title {
    self = [super init];
    if (self) {
        _url = url;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
