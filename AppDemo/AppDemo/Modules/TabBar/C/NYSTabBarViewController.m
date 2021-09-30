//
//  NYSTabBarViewController.m
//  BaseIOS
//
//  Created by niyongsheng on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSTabBarViewController.h"
#import "NYSBlugeTabBar.h"

#import "NYSHomeViewController.h"
#import "NYSAddViewController.h"
#import "NYSConversationListViewController.h"


@interface NYSTabBarViewController () <WMTabBarDelegate>

@property (nonatomic, strong) NSMutableArray *controllersArray;
@property (nonatomic, strong) WMTabBar *wmTabBar;
@end

@implementation NYSTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.controllersArray = [NSMutableArray new];
    [self createControllers];
    
    // push\pop导航栏右上角阴影
    self.view.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    if (CurrentSystemVersion < 13.0) {
        self.tabBar.lee_theme
        .LeeConfigBarTintColor(@"common_bg_color_2")
        .LeeConfigTintColor(@"app_theme_color");
    } else {
        self.tabBar.lee_theme
        .LeeConfigTintColor(@"app_theme_color");
    }
}

- (void)createControllers {
    
    NSArray *childVCArray = @[NYSHomeViewController.new, NYSAddViewController.new, NYSConversationListViewController.new];
    NSArray *titleArray   = @[@"首页", @"话题", @"朋友"];
    NSArray *imageArray   = @[@"Home_Normal", @"Add_Normal", @"Open_Normal"];
    NSArray *selectedImageArray = @[@"Home_Selected", @"Add_Selected", @"Open_Selected"];
    //添加子模块
    [self creatTabBarWithChildVCArray: childVCArray
                           titleArray: titleArray
                           imageArray: imageArray
                   selectedImageArray: selectedImageArray];
}

// 添加子模块
- (void)creatTabBarWithChildVCArray:(NSArray *)childVCArray
                         titleArray:(NSArray *)titleArray
                         imageArray:(NSArray *)imageArray
                 selectedImageArray:(NSArray *)selectedImageArray {
    
    for (int i = 0; i < childVCArray.count; i++) {
        NYSBaseNavigationController *navigationController = [[NYSBaseNavigationController alloc] initWithRootViewController:childVCArray[i]];
        [childVCArray[i] setValue:titleArray[i] forKey:@"title"];
        [self.controllersArray addObject:navigationController];
    }
    
    self.wmTabBar = [WMTabBar tabBarWithTitleArray:titleArray
                                      imageArray:imageArray
                              selectedImageArray:selectedImageArray];
    self.wmTabBar.tabBarDelegate = self;
    [self setValue:self.wmTabBar forKeyPath:@"tabBar"];
    self.viewControllers = self.controllersArray;
}

#pragma mark ----------- tabbarDelegate -------------

- (void)selectedWMTabBarItemAtIndex:(NSInteger)index {
    self.selectedIndex = index;
}


#pragma mark ----------- publick Mothed -------------

- (void)changeTabBarAtIndex:(NSInteger)index {
    self.selectedIndex = index;
    [self.wmTabBar selectedTabbarAtIndex:@(index)];
}

// 暴露外部的切换动画logo和火箭的方法
- (void)pushHomeTabBarAnimationType:(anmationDirection)anmationDirection {
    [self.wmTabBar pushHomeTabBarAnimationType:anmationDirection];
}

@end
