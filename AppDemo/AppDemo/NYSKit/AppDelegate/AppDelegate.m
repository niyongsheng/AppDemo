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
    
//    [Chameleon setGlobalThemeUsingPrimaryColor:FlatMint withSecondaryColor:FlatBlue andContentStyle:UIContentStyleContrast];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
