//
//  NYSWebViewController.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSBaseViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSWebViewController : NYSBaseViewController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, weak) WKWebViewConfiguration *webConfiguration;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, assign) BOOL autoTitle;

- (instancetype)initWithUrlStr:(NSString *)urlStr;

- (void)loadHostPathURL:(NSString *)html;

/// 更新进度条
- (void)updateProgress:(double)progress;


/// JS主题适配
- (void)dayThemeJS:(WKWebView *)webview;
- (void)nightThemeJS:(WKWebView *)webview;

@end

NS_ASSUME_NONNULL_END
