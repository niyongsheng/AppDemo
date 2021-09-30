//
//  NYSFeedbackViewController.m
//  NYS
//
//  Created by niyongsheng on 2021/8/12.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSFeedbackViewController.h"

@interface NYSFeedbackViewController ()

@end

@implementation NYSFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建WKWebView对象，设置大小为屏幕大小
    self.webView.frame = CGRectMake(0, NTopHeight, NScreenWidth, NScreenHeight - NTopHeight - NBottomHeight);
    self.progressView.frame = CGRectMake(0, 0, NScreenWidth, 0);

    // 用户ID
    NSString *open_id = @"tucao_123";
    // 昵称
    NSString *nickname = @"tucao";
    // 头像url地址
    NSString *avatar = @"https://txc.qq.com/static/desktop/img/products/def-product-logo.png";

    // 获得 webview url，请注意url单词是product而不是products，products是旧版本的参数，用错地址将不能成功提交
    NSString *appUrl = [@"https://support.qq.com/product/" stringByAppendingString:TXCAppID];

    // 设置请求体
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appUrl]];

    // 请求方式为POST请求
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *body = [NSString stringWithFormat:@"nickname=%@&avatar=%@&openid=%@", nickname, avatar, open_id];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];

    // WebView对象加载请求并且现实内容
    [self.webView loadRequest:request];
}

- (void)dayThemeJS:(WKWebView *)webview {
    [super dayThemeJS:webview];
    // 兔小巢
    [webview evaluateJavaScript:@"document.getElementsByClassName('power_by')[0].style.visibility=\"hidden\"" completionHandler:nil];
    
    // header
    [webview evaluateJavaScript:@"document.getElementsByClassName('page-general__top-area')[0].style.backgroundColor=\"#ffffff\"" completionHandler:nil];
    // 用户说
    [webview evaluateJavaScript:@"document.getElementsByClassName('post-list')[0].style.backgroundColor=\"#ffffff\"" completionHandler:nil];
    [webview evaluateJavaScript:@"document.getElementsByClassName('post-list__title')[0].style.backgroundColor=\"#ffffff\"" completionHandler:nil];
    [webview evaluateJavaScript:@"document.getElementsByClassName('post_list_label')[0].style.backgroundColor=\"#ffffff\"" completionHandler:nil];
    [webview evaluateJavaScript:@"document.getElementsByClassName('post_item_mobile post_list_item')[0].style.backgroundColor=\"#ffffff\"" completionHandler:nil];
    // tabbar
    [webview evaluateJavaScript:@"document.getElementsByClassName('wrap')[0].style.backgroundColor=\"#ffffff\"" completionHandler:nil];
}

- (void)nightThemeJS:(WKWebView *)webview {
    [super nightThemeJS:webview];
    // 兔小巢
    [webview evaluateJavaScript:@"document.getElementsByClassName('power_by')[0].style.visibility=\"hidden\"" completionHandler:nil];
    
    // header
    [webview evaluateJavaScript:@"document.getElementsByClassName('page-general__top-area')[0].style.backgroundColor=\"#000000\"" completionHandler:nil];
    // 用户说
    [webview evaluateJavaScript:@"document.getElementsByClassName('post-list')[0].style.backgroundColor=\"#000000\"" completionHandler:nil];
    [webview evaluateJavaScript:@"document.getElementsByClassName('post-list__title')[0].style.backgroundColor=\"#000000\"" completionHandler:nil];
    [webview evaluateJavaScript:@"document.getElementsByClassName('post_list_label')[0].style.backgroundColor=\"#000000\"" completionHandler:nil];
    [webview evaluateJavaScript:@"document.getElementsByClassName('post_item_mobile post_list_item')[0].style.backgroundColor=\"#000000\"" completionHandler:nil];
    // tabbar
    [webview evaluateJavaScript:@"document.getElementsByClassName('wrap')[0].style.backgroundColor=\"#292929\"" completionHandler:nil];
}

@end
