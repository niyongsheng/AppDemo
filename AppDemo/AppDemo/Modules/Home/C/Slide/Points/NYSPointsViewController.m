//
//  NYSPointsViewController.m
//  NYS
//
//  Created by niyongsheng on 2021/8/12.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSPointsViewController.h"
#import "NYSRepeatScrollView.h"

@interface NYSPointsViewController ()
@property (nonatomic, strong) NYSRepeatScrollView *repeatAnimationView;
@end

@implementation NYSPointsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.repeatAnimationView resumeAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.repeatAnimationView pauseAnimation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"积分"];
    
    [self.view addSubview:self.repeatAnimationView];
    [self.repeatAnimationView startAnimaiton];
    
    // 磨砂玻璃遮罩
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    if ([[LEETheme currentThemeTag] isEqualToString:NIGHT]) {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualView.frame = self.view.frame;
    [self.view addSubview:visualView];
}


/// 滚动背景图
- (NYSRepeatScrollView *)repeatAnimationView {
    if (!_repeatAnimationView) {
        _repeatAnimationView = [[NYSRepeatScrollView alloc] initWithFrame:self.view.bounds];
    }
    return _repeatAnimationView;
}

@end
