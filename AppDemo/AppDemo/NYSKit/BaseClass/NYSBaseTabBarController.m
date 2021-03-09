//
//  NYSBaseTabBarController.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/14.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSBaseTabBarController.h"

@interface NYSBaseTabBarController ()

@end

@implementation NYSBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self configTheme];
}

- (void)setVCArray:(NSArray<NSDictionary *> *)VCArray {
    _VCArray = VCArray;
    
    NSMutableArray *subControllers = [[NSMutableArray alloc] init];
    for (NSDictionary *viewController in VCArray) {
        NYSBaseNavigationController *navC = [[NYSBaseNavigationController alloc] initWithRootViewController:[[NSClassFromString(viewController[@"vc"]) alloc] init]];
//        navC.viewControllers.firstObject.title = viewController[@"itemTitle"];
        navC.tabBarItem.title = viewController[@"itemTitle"];
        navC.tabBarItem.image = [UIImage imageNamed:viewController[@"normalImg"]];
        navC.tabBarItem.selectedImage = [UIImage imageNamed:viewController[@"selectImg"]];
        
        [subControllers addObject:navC];
    }
    
    [self setViewControllers:subControllers animated:YES];
}

- (void)configTheme {
    // push\pop导航栏右上角阴影
    self.view.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    
    if (CurrentSystemVersion < 13.0) {
        self.tabBar.lee_theme
        .LeeAddBarTintColor(DAY, [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:0.85f])
        .LeeAddBarTintColor(NIGHT, [UIColor colorWithRed:0.07 green:0.07 blue:0.07 alpha:0.85]);
        //    .LeeConfigBarTintColor(@"common_bg_color_2");
    }
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
