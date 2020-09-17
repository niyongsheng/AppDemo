//
//  NYSUserProtoclViewController.m
//  AppDemo
//
//  Created by 倪永胜 on 2018/10/25.
//  Copyright © 2018 NiYongsheng. All rights reserved.
//

#import "NYSUserProtoclViewController.h"

@interface NYSUserProtoclViewController ()

@end

@implementation NYSUserProtoclViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1、创建UIWebView:
    CGRect bouds = [[UIScreen mainScreen] applicationFrame];
    UIWebView* webView = [[UIWebView alloc] initWithFrame:bouds];
    [self.view addSubview:webView];
    
    // 2、设置UIWebView的相关属性:
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor whiteColor];
    
    // 3、加载PDF
    NSString *pdfString = [[NSBundle mainBundle] pathForResource:@"UserPrivacyAgreement" ofType:@"pdf"];
    NSURL *filePath = [NSURL fileURLWithPath:pdfString];
    NSURLRequest *request = [NSURLRequest requestWithURL:filePath];
    [webView loadRequest:request];
}

@end
