//
//  AppDelegate.m
//  BaseIOS
//
//  Created by niyongsheng on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化window
    [self initWindow];
    
    // 初始化导航栏样式
    [self initNavBarAppearence];
    
    // 初始化app服务
    [self initService];
    
    // 初始化网络
    [self initNetwork];
    
    // 网络监听
    [self initMonitorNetworkStatus];
    
    // 推送初始化
    [self initPush:launchOptions application:application];
    
    // 友盟初始化
    [self initUMeng];
    
    // 初始化用户系统
    [self initUserManager];
    
    // 初始化IM
    [[IMManager sharedIMManager] initRongCloudIM];
    
    // 启动广告
    [[ADManager sharedADManager] showAD];
    
#if defined(DEBUG)
    // 帧率
    [[AppManager sharedAppManager] showFPS];
    // 内存
    [[AppManager sharedAppManager] showMemory];
    // 主题切换
    [[ThemeManager sharedThemeManager] initBubble:self.window];
#endif
    
    // 全局配置主题色
//    [Chameleon setGlobalThemeUsingPrimaryColor:NAppThemeColor withSecondaryColor:nil andContentStyle:UIContentStyleContrast];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

    [[UIApplication sharedApplication].keyWindow addSubview:self.visualEffectView];
    
    WS(weakSelf)
    [UIView animateWithDuration:1.0 animations:^{
        [self.visualEffectView.contentView viewWithTag:1001].alpha = 1;
        if ([[LEETheme currentThemeTag] isEqualToString:NIGHT]) {
            weakSelf.visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        } else {
            weakSelf.visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        }
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if (_visualEffectView) {
        self.visualEffectView.effect = nil;
        UILabel *textL = [self.visualEffectView.contentView viewWithTag:1001];
        textL.alpha = 0;
        [self.visualEffectView removeFromSuperview];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark 后台模糊效果
- (UIVisualEffectView *)visualEffectView {
    
    if (!_visualEffectView) {
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
        _visualEffectView.frame = [UIScreen mainScreen].bounds;
        
        UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(0, NScreenHeight - 50, NScreenWidth, 50)];
        [textL setFont:[UIFont fontWithName:@"DOUYU Font" size:12.0f]];
        textL.textAlignment = NSTextAlignmentCenter;
        textL.textColor = UIColor.lightGrayColor;
        textL.alpha = 0;
        textL.tag = 1001;
        textL.text = [[[AppManager sharedAppManager] getAppName] stringByAppendingString:@"全力守护您的信息安全"];
        [_visualEffectView.contentView addSubview:textL];
    }
    
    return _visualEffectView;
}

@end
