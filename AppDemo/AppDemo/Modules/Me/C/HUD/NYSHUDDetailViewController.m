//
//  NYSHUDDetailViewController.m
//  AppDemo
//
//  Created by niyongsheng on 2021/7/7.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSHUDDetailViewController.h"

@interface NYSHUDDetailViewController ()

@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic) JHUD *hudView;

@end

@implementation NYSHUDDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    
    // 建议基类中Lazy创建，进行二次封装，使用时直接调用，避免子类中频繁创建产生冗余代码的问题。
    self.hudView = [[JHUD alloc]initWithFrame:self.view.bounds];

    __weak typeof(self)  _self = self;
    [self.hudView setJHUDReloadButtonClickedBlock:^() {
        NSLog(@"refreshButton");
        if (random()%2 == 1) {
            [_self custom1];
        } else {
            [_self nonetwork];
        }
    }];
    
    SEL sel = NSSelectorFromString(self.title);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:sel withObject:nil];
#pragma clang diagnostic pop
}

- (void)rightButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    button.selected ? [self hide] : [self failure1];
}

- (UIButton *)rightButton {
    if (_rightButton) {
        return _rightButton;
    }
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(0, 0,45, 35);
    [self.rightButton setTitleColor:NAppThemeColor forState:UIControlStateNormal];
    [self.rightButton setTitle:@"Hide" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"Show" forState:UIControlStateSelected];
    self.rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    return self.rightButton;
}

- (void)whirl {
    self.hudView.messageLabel.text = @"Hello ,this is a circle animation";
    self.hudView.indicatorForegroundColor = [UIColor lightGrayColor];
    self.hudView.indicatorBackGroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.1];
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircle];
}

- (void)circle {
    self.hudView.messageLabel.text = @"Hello ,this is a circleJoin animation";
    self.hudView.indicatorForegroundColor = NAppThemeColor;
    self.hudView.indicatorBackGroundColor = RGBAColor(185, 186, 200, 0.3);
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCircleJoin];
}

- (void)custom1 {
    NSMutableArray *images = [NSMutableArray array];
    CGFloat wh = 100;
    for (int i = 1; i <= 7; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"an_%03d", i]];
        [images addObject:image];
        wh = image.size.width;
    }

    self.hudView.indicatorViewSize = CGSizeMake(wh, wh);
    self.hudView.customAnimationImages = images;
    self.hudView.messageLabel.text = @"Loading ...";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCustomAnimations];
}

- (void)nonetwork {
    NSMutableArray *images = [NSMutableArray array];
    CGFloat wh = RealValue(150);
    for (int i = 1; i <= 14; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"no_network%d", i]];
        [images addObject:image];
    }

    self.hudView.indicatorViewSize = CGSizeMake(wh, wh);
    self.hudView.customAnimationImages = images;
    self.hudView.messageLabel.text = @"Loading ...";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeCustomAnimations];
}

- (void)dot {
    self.hudView.messageLabel.text = @"Hello ,this is a dot animation";
    self.hudView.indicatorForegroundColor = NAppThemeColor;
    self.hudView.indicatorBackGroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3];
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeDot];
}

- (void)gif {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loading_gif_plane" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    self.hudView.gifImageData = data;
    self.hudView.indicatorViewSize = CGSizeMake(110, 110); // Maybe you can try to use (100,250);😂
    self.hudView.messageLabel.text = @"Hello ,this is a gif animation";
    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeGifImage];
}

- (void)failure1 {
    self.hudView.indicatorViewSize = CGSizeMake(150, 150);
    self.hudView.messageLabel.text = @"Can't get data, please make sure the interface is correct !";
    [self.hudView.refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    self.hudView.customImage = [UIImage imageNamed:@"webloaderrorview.png"];

    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];

}

- (void)failure2 {
    self.hudView.indicatorViewSize = CGSizeMake(110, 110);
    self.hudView.messageLabel.text = @"Failed to get data, please try again later";
    [self.hudView.refreshButton setTitle:@"Refresh ?" forState:UIControlStateNormal];
    self.hudView.customImage = [UIImage imageNamed:@"nullData"];

    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
}

- (void)failure3 {
    self.hudView.indicatorViewSize = CGSizeMake(150, 150);
    self.hudView.messageLabel.text = @"Failed to get data, please try again later";
    [self.hudView.refreshButton setTitle:@"Refresh ?" forState:UIControlStateNormal];
    self.hudView.customImage = [UIImage imageNamed:@"hud_null"];

    [self.hudView showAtView:self.view hudType:JHUDLoadingTypeFailure];
}

- (void)classMethod {
    self.rightButton.hidden = YES;

    [JHUD showAtView:self.view message:@"I'm a class method."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JHUD hideForView:self.view];
    });
    
}

// 横竖屏适配的话，在此更新hudView的frame。
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat padding = 0;
    self.hudView.frame = CGRectMake(padding,
                                    padding,
                                    self.view.frame.size.width - padding*2,
                                    self.view.frame.size.height - padding*2);
}

- (void)hide {
    [self.hudView hide];
}

@end
