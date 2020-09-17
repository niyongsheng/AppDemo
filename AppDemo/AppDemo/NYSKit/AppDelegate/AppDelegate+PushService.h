//
//  AppDelegate+PushService.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
#import <JPush/JPUSHService.h>
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (PushService) <UNUserNotificationCenterDelegate, JPUSHRegisterDelegate, RCIMReceiveMessageDelegate>

/// 初始化推送服务
- (void)initPush:(NSDictionary *)launchOptions application:(UIApplication *)application;

@end

NS_ASSUME_NONNULL_END
