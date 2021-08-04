//
//  NYSTabBarViewController.m
//  BaseIOS
//
//  Created by niyongsheng on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSTabBarViewController.h"
#import "NYSBlugeTabBar.h"

@interface NYSTabBarViewController () <UITabBarDelegate>
@property (nonatomic, strong) NYSBlugeTabBar *blugeTabBar;
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
    [self setValue:self.blugeTabBar forKey:@"tabBar"];
    
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

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSMutableArray *tabBarBtnArray = [NSMutableArray array];
    int index = [NSNumber numberWithUnsignedInteger:[tabBar.items indexOfObject:item]].intValue;
    // get UITabBarButton
    for (int i = 0 ;i < tabBar.subviews.count; i++ ) {
        UIView * tabBarButton = tabBar.subviews[i];
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarBtnArray addObject:tabBarButton];
        }
    }
    // add scale animation
    UIView *TabBarButton = tabBarBtnArray[index];
    for (UIView *imageV in TabBarButton.subviews) {
        if ([imageV isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.duration  = 0.35f;
            animation.fromValue = [NSNumber numberWithFloat:0.5f];
            animation.byValue = [NSNumber numberWithFloat:1.5f];
            animation.toValue   = [NSNumber numberWithFloat:1.f];
            [imageV.layer addAnimation:animation forKey:nil];
        }
    }
}

- (NYSBlugeTabBar *)blugeTabBar {
    if (!_blugeTabBar) {
        _blugeTabBar = [[NYSBlugeTabBar alloc] initWithStandOutHeight:StandOutHeight radius:27.0f strokelineWidth:0.45f];
        _blugeTabBar.delegate = self;
        _blugeTabBar.tabBarItemY = RealValue(15.0);
        _blugeTabBar.centerTabBarItemY = isIphonex ? RealValue(-10) : -1;
        _blugeTabBar.alpha = 0.95;
    }
    
    return _blugeTabBar;
}

@end
