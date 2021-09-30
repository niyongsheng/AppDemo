//
//  NYSTabBarViewController.h
//  BaseIOS
//
//  Created by niyongsheng on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSBaseTabBarController.h"
#import "WMTabBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface NYSTabBarViewController : NYSBaseTabBarController
- (void)changeTabBarAtIndex:(NSInteger )index;

// 切换动画logo和火箭的方法
- (void)pushHomeTabBarAnimationType:(anmationDirection )anmationDirection;

@end

NS_ASSUME_NONNULL_END
