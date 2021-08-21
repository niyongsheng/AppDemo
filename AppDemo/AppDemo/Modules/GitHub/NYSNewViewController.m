//
//  NYSNewViewController.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSNewViewController.h"

@interface NYSNewViewController ()
@property (nonatomic, strong) UIBarButtonItem *rightItem2;
@end

@implementation NYSNewViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NYSTKConfig defaultConfig] clearDefaultValue];
    [NYSTKConfig defaultConfig].offsetFromCenter = UIOffsetMake(0, NYSTK_RealValue(280));
    [NYSTKAlert showToastWithMessage:@"Stay hungry，Stay foolish."];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"GitHub"];
    
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:nil];
    WS(weakSelf);
    [rightItem1 setActionBlock:^(id _Nonnull sender) {
        [weakSelf.webView reload];
    }];
    
    self.navigationItem.rightBarButtonItems = @[rightItem1];
    
    self.urlStr = GitHubURl;
    self.autoTitle = NO;
}

- (UIBarButtonItem *)rightItem2 {
    if (!_rightItem2) {
        UIButton *themeBtn = [UIButton new];
        themeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [themeBtn.titleLabel setTextColor:[UIColor colorWithHexString:@"#4183ED"]];
        themeBtn.lee_theme
        .LeeAddCustomConfig(DAY, ^(id  _Nonnull item) {
            [(UIButton *)item setTitle:@"Light" forState:UIControlStateNormal];
        })
        .LeeAddCustomConfig(NIGHT, ^(id  _Nonnull item) {
            [(UIButton *)item setTitle:@"Dark " forState:UIControlStateNormal];
        });
        themeBtn.lee_theme.LeeConfigButtonTitleColor(@"common_nav_font_color_1", UIControlStateNormal);
        [[themeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [[ThemeManager sharedThemeManager] changeTheme:NAppWindow];
        }];
        _rightItem2 = [[UIBarButtonItem alloc] initWithCustomView:themeBtn];
    }
    return _rightItem2;
}

@end
