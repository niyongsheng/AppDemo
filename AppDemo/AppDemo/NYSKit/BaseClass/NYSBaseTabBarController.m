//
//  NYSBaseTabBarController.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/14.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSBaseTabBarController.h"

@interface NYSBaseTabBarController () <UITabBarControllerDelegate>

@end

@implementation NYSBaseTabBarController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self configTheme];
//    [self setDelegate:self];
    
    if (@available(iOS 13, *)) {
        UITabBarAppearance *appearance = [self.tabBar.standardAppearance copy];
        appearance.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
        // 重置阴影为透明
        [appearance configureWithTransparentBackground];
        self.tabBar.standardAppearance = appearance;
    } else {
        self.tabBar.shadowImage = [UIImage new];
    }
}

- (void)setVCArray:(NSArray<NSDictionary *> *)VCArray {
    _VCArray = VCArray;
    
    NSMutableArray *subControllers = [[NSMutableArray alloc] init];
    for (NSDictionary *viewController in VCArray) {
        NYSBaseNavigationController *navC = [[NYSBaseNavigationController alloc] initWithRootViewController:[[NSClassFromString(viewController[@"vc"]) alloc] init]];
        navC.tabBarItem.title = viewController[@"itemTitle"];
        navC.tabBarItem.image = [UIImage imageNamed:viewController[@"normalImg"]];
        navC.tabBarItem.selectedImage = [UIImage imageNamed:viewController[@"selectImg"]];
        
        [subControllers addObject:navC];
    }
    
    [self setViewControllers:subControllers animated:YES];
}

- (void)configTheme {
    
    if (CurrentSystemVersion < 13.0) {
        // push\pop导航栏右上角阴影
        self.view.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
        
        self.tabBar.lee_theme
        .LeeConfigBarTintColor(@"common_bg_color_2")
        .LeeConfigTintColor(@"app_theme_color");
    } else {
        self.tabBar.lee_theme
        .LeeConfigTintColor(@"app_theme_color");
    }
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

#pragma mark - auto rotate
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotate {
    
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [self.selectedViewController supportedInterfaceOrientations];
}

@end
