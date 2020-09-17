//
//  NYSBaseNavigationController.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSBaseNavigationController.h"
#import "NYSBaseViewController.h"

@interface NYSBaseNavigationController () <UINavigationControllerDelegate>

@end

@implementation NYSBaseNavigationController

+ (void)initialize {
    UINavigationBar *navBar = [UINavigationBar appearance];
//    [navBar setBackgroundImage:[[UIImage imageWithColor:[UIColor whiteColor ]] imageByBlurRadius:40 tintColor:nil tintMode:0 saturation:1 maskImage:nil] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    // delete bottom line
    [navBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
    
    [self configTheme];
    self.delegate = self;
}


/// theme config
- (void)configTheme {

    if (CurrentSystemVersion < 13.0) {
        self.navigationBar.lee_theme
        .LeeConfigBarTintColor(@"common_bg_color_2")
        .LeeConfigTintColor(@"common_nav_font_color_1");
    }
    
    self.navigationBar.lee_theme
    .LeeAddCustomConfig(DAY, ^(UINavigationBar *bar) {
      
        bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
        if (@available(iOS 11.0, *)) {
            bar.largeTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],
            NSFontAttributeName : [UIFont fontWithName:@"04b_03b" size:50.0f]
            };
        }
    })
    .LeeAddCustomConfig(NIGHT, ^(UINavigationBar *bar) {
        
        bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor]};
        if (@available(iOS 11.0, *)) {
            bar.largeTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor lightGrayColor],
                                             NSFontAttributeName : [UIFont fontWithName:@"04b_03b" size:50.0f]
            };
        }
    });
}

/// when push auto hidden tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

/// navigation delegate hidden method
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[NYSBaseViewController class]]) {
        NYSBaseViewController *vc = (NYSBaseViewController *)viewController;
        if (vc.isHidenNaviBar) {
            vc.view.top = 0;
            [vc.navigationController setNavigationBarHidden:YES animated:animated];
        } else {
            vc.view.top = NTopHeight;
            [vc.navigationController setNavigationBarHidden:NO animated:animated];
        }
    }
}


@end
