//
//  AppDelegate+AppService.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (AppService)

/** 初始化服务 */
- (void)initService;

/** 初始化网络 */
- (void)initNetwork;

/** 初始化 window */
- (void)initWindow;

/** 初始化友盟 */
- (void)initUMeng;

/** 初始化用户系统 */
- (void)initUserManager;

/** 监听网络状态 */
- (void)initMonitorNetworkStatus;

@end

NS_ASSUME_NONNULL_END
