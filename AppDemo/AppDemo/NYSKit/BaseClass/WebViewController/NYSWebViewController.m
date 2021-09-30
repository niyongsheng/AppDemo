//
//  NYSWebViewController.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSWebViewController.h"
#import "NYSJSHandler.h"

@interface NYSWebViewController () <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic,strong) NYSJSHandler * jsHandler;
@property (nonatomic,assign) double lastProgress; // 上次进度条位置

@end

@implementation NYSWebViewController

- (instancetype)initWithUrlStr:(NSString *)urlStr {
    self = [super init];
    if (self) {
        [self setUrlStr:urlStr];
    }
    return self;
}

- (void)setUrlStr:(NSString *)urlStr {
    if (_urlStr != urlStr) {
        _urlStr = urlStr;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
        [self.webView loadRequest:request];
    }
}

- (void)setAutoTitle:(BOOL)autoTitle {
    _autoTitle = autoTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAutoTitle:YES];
    [self.view addSubview:self.webView];
    
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:nil];
    WS(weakSelf);
    [rightItem1 setActionBlock:^(id _Nonnull sender) {
        [weakSelf.webView reload];
    }];
    self.navigationItem.rightBarButtonItems = @[rightItem1];
}

#pragma mark - webview
- (WKWebView *)webView {
    if (_webView == nil) {
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences.javaScriptEnabled = YES; // 打开js交互
        configuration.allowsInlineMediaPlayback = YES; // 允许H5嵌入视频
        _webConfiguration = configuration;
        _jsHandler = [[NYSJSHandler alloc] initWithViewController:self configuration:configuration];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, NScreenHeight) configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES; // 打开网页间的 滑动返回
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;

        [_webView addSubview:self.progressView];
        // 监听进度条
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, NTopHeight, NScreenWidth, 0);
        _progressView.transform = CGAffineTransformMakeScale(1.0, 0.5);
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = [NAppThemeColor colorWithAlphaComponent:0.75];
    }
    return _progressView;
}

#pragma mark - 进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    [self updateProgress:_webView.estimatedProgress];
}

#pragma mark - 更新进度条
- (void)updateProgress:(double)progress {
    self.progressView.alpha = 1;
    if (progress > _lastProgress) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    } else {
        [self.progressView setProgress:self.webView.estimatedProgress];
    }
    _lastProgress = progress;
    
    if (progress >= 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.alpha = 0;
            [self.progressView setProgress:0];
            self.lastProgress = 0;
        });
    }
}

#pragma mark - navigation delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.autoTitle) {
        self.title = webView.title;
    }
    [self updateProgress:webView.estimatedProgress];
    
    WS(weakSelf)
    if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
        [weakSelf dayThemeJS:webView];
    } else {
        [weakSelf nightThemeJS:webView];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    // 一个页面没有被完全加载之前收到下一个请求，此时迅速会出现此error,error=-999，先忽略处理
    if (error.code != -999) {
        [self loadHostPathURL:@"WebLoadErrorView"];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if(webView != self.webView) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    NSString *urlString = navigationAction.request.URL.absoluteString;
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 打开wkwebview禁用了电话和跳转appstore 通过这个方法打开
    UIApplication *app = [UIApplication sharedApplication];
    if ([url.scheme isEqualToString:@"tel"]) {
        if ([app canOpenURL:url]) {
            [app openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    if ([url.absoluteString containsString:@"itunes.apple.com"]) {
        if ([app canOpenURL:url]) {
            [app openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    
    if ([urlString hasPrefix:@"weixin://"]) {
        Boolean canOpenUrl = [[UIApplication sharedApplication] canOpenURL:url];
        if(canOpenUrl) {
            NSLog(@"已安装微信");
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            // 允许跳转
            decisionHandler(WKNavigationActionPolicyAllow);
        }else {
            NSLog(@"尚未安装微信");
            // 不允许跳转
            decisionHandler(WKNavigationActionPolicyCancel);
        }
    } else {
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

#pragma mark - UIDelegate
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    if (navigationAction.request.URL) {
        
        NSURL *url = navigationAction.request.URL;
        NSString *urlPath = url.absoluteString;
        if ([urlPath rangeOfString:@"https://"].location != NSNotFound || [urlPath rangeOfString:@"http://"].location != NSNotFound) {
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]]];
        }
    }
    
    return nil;
}

- (void)backBtnClicked {
    [self.webView stopLoading];
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [super backBtnClicked];
    }
}

/** 加载本地error html 文件 */
- (void)loadHostPathURL:(NSString *)html {
    // 获取html文件的路径
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:html ofType:@"html"];
    // 获取html内容
    NSString *htmlStr = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // 加载html
    [self.webView loadHTMLString:htmlStr baseURL:[[NSBundle bundleForClass:self.class] bundleURL]];
}

- (void)dayThemeJS:(WKWebView *)webview {
    [webview evaluateJavaScript:@"document.body.style.backgroundColor=\"#FFFFFF\"" completionHandler:nil];
}

- (void)nightThemeJS:(WKWebView *)webview {
    [webview evaluateJavaScript:@"document.body.style.backgroundColor=\"#000000\"" completionHandler:nil];
}

/// 设置主题
- (void)configTheme {
    [super configTheme];
    
    self.webView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    WS(weakSelf)
    self.webView.lee_theme
    .LeeAddCustomConfig(DAY, ^(id  _Nonnull item) {
        [weakSelf dayThemeJS:item];
    })
    .LeeAddCustomConfig(NIGHT, ^(id  _Nonnull item) {
        [weakSelf nightThemeJS:item];
    });
}

/// 屏幕旋转后重新布局
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    CGFloat duration = [coordinator transitionDuration];
    WS(weakSelf);
    [UIView animateWithDuration:duration animations:^{
        [weakSelf.webView setFrame:(CGRect){{0, 0}, size}];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_jsHandler cancelHandler];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    _webView = nil;
}

@end
