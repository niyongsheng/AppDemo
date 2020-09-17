//
//  NYSTabBarViewController.m
//  BaseIOS
//
//  Created by niyongsheng on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSTabBarViewController.h"
#import "NYSBlugeTabBar.h"

@interface NYSTabBarViewController ()

@end

@implementation NYSTabBarViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (CurrentSystemVersion < 13.0) {
        CGRect tabFrame = self.tabBar.frame;
        tabFrame.size.height = self.tabBar.frame.size.height + StandOutHeight;
        tabFrame.origin.y = self.view.frame.size.height - (self.tabBar.frame.size.height + StandOutHeight);
        self.tabBar.frame = tabFrame;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (CurrentSystemVersion >= 13.0 && !isIphonex) {
        CGRect tabFrame = self.tabBar.frame;
        tabFrame.size.height = self.tabBar.frame.size.height + StandOutHeight;
        tabFrame.origin.y = self.view.frame.size.height - (self.tabBar.frame.size.height + StandOutHeight);
        self.tabBar.frame = tabFrame;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // KVC替换tabbar
    NYSBlugeTabBar *myTabBar = [[NYSBlugeTabBar alloc] initWithStandOutHeight:StandOutHeight radius:27.0f strokelineWidth:0.7f];
    myTabBar.tabBarItemY = RealValue(15.0);
    myTabBar.centerTabBarItemY = isIphonex ? RealValue(-10) : -1;
    myTabBar.alpha = 0.95;
    [self setValue:myTabBar forKey:@"tabBar"];
    
    self.VCArray = @[
        @{@"vc" : @"NYSHomeViewController",
          @"normalImg" : @"Home",
          @"selectImg" : @"Home_selected",
          @"itemTitle" : @"Home"},
        @{@"vc" : @"NYSNewViewController",
          @"normalImg" : @"github",
          @"selectImg" : @"githubHilight",
          @"itemTitle" : @"GitHub"},
        @{@"vc": @"NYSMeViewController",
          @"normalImg" : @"Me",
          @"selectImg" : @"Me_selected",
          @"itemTitle" : @"Me"}
    ];
}

@end
