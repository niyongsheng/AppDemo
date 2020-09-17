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
        _urlStr = urlStr;
        _progressViewColor = NWKProgressColor;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
        [self.webView loadRequest:request];
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
    
    [self configTheme];
    [self setAutoTitle:YES];
    [self.view addSubview:self.webView];
}

#pragma mark - webview
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences.javaScriptEnabled = YES; // 打开js交互
        configuration.allowsInlineMediaPlayback = YES; // 允许H5嵌入视频
        _webConfiguration = configuration;
        _jsHandler = [[NYSJSHandler alloc] initWithViewController:self configuration:configuration];
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES; // 打开网页间的 滑动返回
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        // 监听进度条
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
       
        // 进度条
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.tintColor = _progressViewColor;
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 3.0);
        [_webView addSubview:_progressView];
    }
    return _webView;
}

- (void)backButtonClicked {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [super backBtnClicked];
    }
}

#pragma mark - 进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    [self updateProgress:_webView.estimatedProgress];
}

#pragma mark - 更新进度条
- (void)updateProgress:(double)progress {
    self.progressView.alpha = 1;
    if(progress > _lastProgress){
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    }else{
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
    
    if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
        dayThemeJS(webView);
    } else {
        nightThemeJS(webView);
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
    
    NSURL * url = webView.URL;
    // 打开wkwebview禁用了电话和跳转appstore 通过这个方法打开
    UIApplication *app = [UIApplication sharedApplication];
    if ([url.scheme isEqualToString:@"tel"]) {
        if ([app canOpenURL:url]) {
            [app openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    } if ([url.absoluteString containsString:@"itunes.apple.com"]) {
        if ([app canOpenURL:url]) {
            [app openURL:url options:@{} completionHandler:nil];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
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
- (void)loadHostPathURL:(NSString *)url {
    // 获取html文件的路径
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:url ofType:@"html"];
    // 获取html内容
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // 加载html
    [self.webView loadHTMLString:html baseURL:[[NSBundle bundleForClass:self.class] bundleURL]];
}

static void dayThemeJS(id  _Nonnull item) {
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.body.style.backgroundColor=%@", @"\"#FFFFFF\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust=%@", @"\'100%\'"] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor=%@", @"'#666666'"] completionHandler:nil];
    
    [(WKWebView *)item evaluateJavaScript:@"document.getElementsByClassName('bg-gray-light')[1].classList.add('bg-gray-light')" completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:@"document.getElementsByClassName('js-repo-nav')[0].classList.add('bg-gray-light')" completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:@"document.getElementsByClassName('Box-header')[1].classList.add('bg-white')" completionHandler:nil];
    
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByClassName('Box-header')[0].style.backgroundColor=%@", @"\"#FFFFFF\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByClassName('Box-header')[1].style.backgroundColor=%@", @"\"#FFFFFF\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByClassName('Box-footer')[0].style.backgroundColor=%@", @"\"#FFFFFF\""] completionHandler:nil];
    
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByClassName('btn')[3].style.backgroundColor=%@", @"\"#F9FAFC\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByClassName('btn')[4].style.backgroundColor=%@", @"\"#F9FAFC\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByClassName('btn')[6].style.backgroundColor=%@", @"\"#F9FAFC\""] completionHandler:nil];
    
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementById('readme').style.backgroundColor=%@", @"\"#FFFFFF\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('pre')[0].style.backgroundColor=%@", @"\"#F4F7F9\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('pre')[1].style.backgroundColor=%@", @"\"#F4F7F9\""] completionHandler:nil];
}

static void nightThemeJS(id  _Nonnull item) {
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.body.style.backgroundColor=%@", @"\"#000000\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust=%@", @"\'100%\'"] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor=%@", @"'#2D65FE'"] completionHandler:nil];
    
    [(WKWebView *)item evaluateJavaScript:@"document.getElementsByClassName('bg-gray-light')[1].classList.remove('bg-gray-light')" completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:@"document.getElementsByClassName('js-repo-nav')[0].classList.remove('bg-gray-light')" completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:@"document.getElementsByClassName('Box-header')[1].classList.remove('bg-white')" completionHandler:nil];
    
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByClassName('Box-header')[0].style.backgroundColor=%@", @"\"#000000\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByClassName('Box-header')[1].style.backgroundColor=%@", @"\"#000000\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByClassName('Box-footer')[0].style.backgroundColor=%@", @"\"#000000\""] completionHandler:nil];
    
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByClassName('btn')[3].style.backgroundColor=%@", @"\"#131313\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByClassName('btn')[4].style.backgroundColor=%@", @"\"#131313\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByClassName('btn')[6].style.backgroundColor=%@", @"\"#131313\""] completionHandler:nil];
    
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementById('readme').style.backgroundColor=%@", @"\"#000000\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('pre')[0].style.backgroundColor=%@", @"\"#131313\""] completionHandler:nil];
    [(WKWebView *)item evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('pre')[1].style.backgroundColor=%@", @"\"#131313\""] completionHandler:nil];
}

/// 设置主题
- (void)configTheme {
    self.view.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    
    self.webView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    
    self.webView.lee_theme
    .LeeAddCustomConfig(DAY, ^(id  _Nonnull item) {
        dayThemeJS(item);
    })
    .LeeAddCustomConfig(NIGHT, ^(id  _Nonnull item) {
        nightThemeJS(item);
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
