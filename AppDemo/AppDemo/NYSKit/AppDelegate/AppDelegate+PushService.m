//
//  AppDelegate+PushService.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "AppDelegate+PushService.h"

@implementation AppDelegate (PushService)

- (void)initPush:(NSDictionary *)launchOptions application:(UIApplication *)application {
    // 1.极光推送注册
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound | JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // IDFA
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    // Init JPush
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPUSH_APPKEY
                          channel:JPUSH_CHANNEl
                 apsForProduction:IS_Prod
            advertisingIdentifier:advertisingId];
    
    // 获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
      if (resCode == 0) {
        NLog(@"registrationID获取成功：%@",registrationID);
      } else {
        NLog(@"registrationID获取失败，code：%d",resCode);
      }
    }];
    
    // 监听融云IM接收消息
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 极光-注册DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    // 融云-注册DeviceToken
    [[RCIMClient sharedRCIMClient] setDeviceTokenData:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // Fail Optional
    NLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - RongCloudRegisterDelegate
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    // 监听融云接收到的消息并处理
    [NNotificationCenter postNotificationName:@"NYSTabBar1Notification" object:nil];
}

#pragma mark - JPUSHRegisterDelegate
/// iOS 10 Support 前台监听通知APP自动响应
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler API_AVAILABLE(ios(10.0)) {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    if ([[userInfo objectForKey:@"module"] isEqual:@"xxx"]) {
        
    } else if ([[userInfo objectForKey:@"module"] isEqual:@"xxx"]) {
        
    } else if ([[userInfo objectForKey:@"module"] isEqual:@"xxx"]) {
        
    }
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

/// iOS 10 Support app处于后台或退出时点击通知拉起APP响应
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        // 处理通知
        [JPUSHService handleRemoteNotification:userInfo];
    }
    if ([[userInfo objectForKey:@"module"] isEqual:@"xxx"]) {
        
    } else if ([[userInfo objectForKey:@"module"] isEqual:@"xxx"]) {
        
    } else if ([[userInfo objectForKey:@"module"] isEqual:@"xxx"]) {
    
    }
    completionHandler();
}

/*
 * @brief handle UserNotifications.framework [openSettingsForNotification:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param notification 当前管理的通知对象
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification NS_AVAILABLE_IOS(12.0) {
    
}

/**
 * 监测通知授权状态返回的结果
 * @param status 授权通知状态，详见JPAuthorizationStatus
 * @param info 更多信息，预留参数
 */
- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    
}

#pragma mark - JPush 服务器端脚标(该方法会覆盖AppDelegate中的方法)
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [JPUSHService setBadge:application.applicationIconBadgeNumber];
}

@end
