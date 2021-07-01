//
//  NYSScrollImageViewController.m
//  AppDemo
//
//  Created by niyongsheng on 2021/6/29.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSScrollImageViewController.h"
#import "NYSRepeatScrollView.h"

@interface NYSScrollImageViewController ()
@property (nonatomic, strong) NYSRepeatScrollView *repeatAnimationView;

@end

@implementation NYSScrollImageViewController

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
    
    [self.view addSubview:self.repeatAnimationView];
    [self.repeatAnimationView startAnimaiton];
}

#pragma mark - Getter
- (NYSRepeatScrollView *)repeatAnimationView {
    if (!_repeatAnimationView) {
        _repeatAnimationView = [[NYSRepeatScrollView alloc] initWithFrame:self.view.frame];
    }
    return _repeatAnimationView;
}

@end
