//
//  AppDelegate+AppService.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogManager.h>

#import "NYSBaseWindow.h"
#import "NYSLoginViewController.h"
#import "NYSNewfeatureViewController.h"

@implementation AppDelegate (AppService)

#pragma mark —- 初始化服务 --
- (void)initService {
    // 注册登录状态监听
    [NNotificationCenter addObserver:self
                            selector:@selector(loginStateChange:)
                                name:NNotificationLoginStateChange
                              object:nil];
    
    // 网络状态监听
    [NNotificationCenter addObserver:self
                            selector:@selector(netWorkStateChange:)
                                name:NNotificationNetWorkStateChange
                              object:nil];
}


#pragma mark —- 初始化window --
- (void)initWindow {
    [[ThemeManager sharedThemeManager] configTheme];
    
    self.tabBarVC = [NYSTabBarViewController new];
    self.window = [[NYSBaseWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[UIButton appearance] setExclusiveTouch:YES];
    [[UIButton appearance] setShowsTouchWhenHighlighted:YES];
    
    // 骨架屏初始化
    [[TABAnimated sharedAnimated] initWithOnlySkeleton];
#if defined(DEBUG)
    [TABAnimated sharedAnimated].openLog = YES;
    [TABAnimated sharedAnimated].openAnimationTag = YES;
#endif
}

#pragma mark -- 初始化三方导航栏样式 --
- (void)initNavBarAppearence {
    
}

#pragma mark -- 初始化网络 --
- (void)initNetwork {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = APP_BaseURL;
    config.cdnUrl = APP_CDNURL;
    config.debugLogEnabled = YES;
    config.sessionConfiguration.timeoutIntervalForRequest = 15;
    config.sessionConfiguration.HTTPAdditionalHeaders = @{@"Version" : CurrentAppVersion, @"Platform" : @"IOS"};
}

#pragma mark -- 初始化用户 --
- (void)initUserManager {
    
    static NSString *key = @"CFBundleShortVersionString";
    NSString *lastVersion = [NUserDefaults stringForKey:key];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    NLog(@"lastVersion:%@     currentVersion:%@", lastVersion, currentVersion);
    if ([currentVersion isEqualToString:lastVersion]) {
        // 判断是否登陆过
        if (NIsLogin) {
            NSInteger nowStamp = [[NYSTools getNowTimeTimestamp] integerValue];
            NSInteger expiredStamp = [NUserDefaults integerForKey:NTokenExpiredTimeStamp];
            if (expiredStamp - nowStamp > 0) {
                NRootViewController = self.tabBarVC;
            } else {
                [SVProgressHUD showInfoWithStatus:@"token过期\n请重新登录"];
                [SVProgressHUD dismissWithDelay:1.0f];
                NPostNotification(NNotificationLoginStateChange, @NO)
            }
        } else {
            // 没有登录过，展示登录页面
            NPostNotification(NNotificationLoginStateChange, @NO)
            NLog(@"没有登录过，显示登录页面");
        }
    } else { // 新版本
        // 存储新版本
        [NUserDefaults setObject:currentVersion forKey:key];
        [NUserDefaults synchronize];
        // 跳转新特性控制器
        NRootViewController = [[NYSNewfeatureViewController alloc] init];
    }
    
}

#pragma mark -- 初始化 IQKM --
- (void)initIQKeyboardManager {
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

#pragma mark -- 登录状态处理 --
- (void)loginStateChange:(NSNotification *)notification {
    BOOL loginSuccess = [notification.object boolValue];
    if (loginSuccess) { // 登陆成功加载主窗口控制器
        // 为避免自动登录成功刷新tabbar
        if (!self.tabBarVC || ![self.window.rootViewController isKindOfClass:[NYSTabBarViewController class]]) {
            
            CATransition *anima = [CATransition animation];
            anima.type = @"cube";
            anima.subtype = kCATransitionFromRight;
            anima.duration = 0.3f;
            
            NRootViewController = [NYSTabBarViewController new];
            [NAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
        }
    } else { // 登陆失败加载登陆页面控制器
        self.tabBarVC = nil;
        
        CATransition *anima = [CATransition animation];
        anima.type = @"cube";
        anima.subtype = kCATransitionFromLeft;
        anima.duration = 0.3f;

        NRootViewController = [NYSLoginViewController new];
        [NAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
    }
}

#pragma mark -- 友盟 初始化 --
- (void)initUMeng {
    
    // 友盟统计+分享
    [UMConfigure initWithAppkey:UMengKey channel:@"App Store"];
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    [UMConfigure setAnalyticsEnabled:YES];
    
    [self configUSharePlatforms];
}

#pragma mark -- 配置第三方登录 --
- (void)configUSharePlatforms {
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAPPID  appSecret:QQAPPKEY redirectURL:nil];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXAPPID appSecret:APPSECRET redirectURL:nil];
    // 移除微信收藏
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
}

#pragma mark -- OpenURL 第三方登录/支付回调 --
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark -- 网络状态变化 --
- (void)netWorkStateChange:(NSNotification *)notification {
    BOOL isNetWork = [notification.object boolValue];
    
    if (isNetWork) { // 有网络
        if (!NIsLogin) { // 有用户数据 并且 未登录成功 重新来一次自动登录
            [NUserManager autoLoginToServer:^(BOOL success, NSString *des) {
                if (success) {
                    NLog(@"网络改变后，自动登录成功");
//                    [MBProgressHUD showSuccessMessage:@"网络改变后，自动登录成功"];
                    NPostNotification(NNotificationAutoLoginSuccess, nil);
                } else {
//                    [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
                }
            }];
        }
    } else { // 登陆失败加载登陆页面控制器
//        [MBProgressHUD showTopTipMessage:@"网络状态不佳" isWindow:YES];
    }
}

#pragma mark -- 网络状态监听 --
- (void)initMonitorNetworkStatus {
    
    // 网络状态改变一次, networkStatusWithBlock就会响应一次
//    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatusType networkStatus) {
//        
//        switch (networkStatus) {
//                // 未知网络
//            case PPNetworkStatusUnknown:
//                NLog(@"网络环境：未知网络");
//                // 无网络
//            case PPNetworkStatusNotReachable:
//                NLog(@"网络环境：无网络");
//                NPostNotification(NNotificationNetWorkStateChange, @NO);
//                break;
//                // 手机网络
//            case PPNetworkStatusReachableViaWWAN:
//                NLog(@"网络环境：手机自带网络");
//                // 无线网络
//            case PPNetworkStatusReachableViaWiFi:
//                NLog(@"网络环境：WiFi");
//                NPostNotification(NNotificationNetWorkStateChange, @YES);
//                break;
//        }
//    }];
}

@end
