//
//  CommonMacros.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#ifndef CommonMacros_h
#define CommonMacros_h

#pragma mark -- 用户相关 --
// 登录状态改变通知
#define NNotificationLoginStateChange           @"KLoginStateChange"
// 自动登录成功
#define NNotificationAutoLoginSuccess           @"KNotificationAutoLoginSuccess"
// 被踢下线
#define NNotificationOnKick                     @"KNotificationOnKick"
// 用户信息缓存 名称
#define NUserCacheName                          @"KUserCacheName"
// 用户model缓存
#define NUserModelCache                         @"KUserModelCache"
// 用户注册信息缓存 名称
#define NregisterCacheName                      @"KregisterCacheName"
// 用户注册model缓存
#define NregisterModelCache                     @"KregisterModelCache"
// 用户更新信息缓存 名称
#define NUpdateCacheName                        @"KUpdateCacheName"
// 用户更新model缓存
#define NUpdateModelCache                       @"KUpdateModelCache"
// token过期时间戳
#define NTokenExpiredTimeStamp                  @"KTokenExpiredTimeStamp"

#pragma mark -- 网络相关 --
#define DevelopSever 1
#define TestSever    0
#define ProductSever 0

#if DevelopSever
/** 接口前缀-开发服务器*/
static NSString *const APP_BaseURL = @"https://newanju.qmook.com";
static NSString *const APP_CDNURL  = @"http://lpr.qmook.com";
#elif TestSever
/** 接口前缀-测试服务器*/
static NSString *const APP_BaseURL = @"http://192.168.31.182";
static NSString *const APP_CDNURL  = @"http://192.168.31.182";
#elif ProductSever
/** 接口前缀-生产服务器*/
static NSString *const APP_BaseURL = @"https://newanju.qmook.com";
static NSString *const APP_CDNURL  = @"http://127.1.1";
#endif

// 网络状态变化
#define NNotificationNetWorkStateChange         @"KNotificationNetWorkStateChange"


#pragma mark -- 第三方平台相关 --
// App Store ID
#define APPID           @"1438587777"
// App Store详情页
#define AppStoreURL     [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@", APPID]
// App APIs
#define AppAPIsURL      [NSString stringWithFormat:@"%@/api/swagger-ui.html", APP_BaseURL]
// GitHub
#define GitHubURl       [NSString stringWithFormat:@"https://github.com/%@", @"niyongsheng/AppDemo"]

// 微信登录
#define WXAPPID         @""
#define APPSECRET       @""

// QQ登录
#define QQAPPID         @""
#define QQAPPKEY        @""

// 极光推送
#define JPUSH_APPKEY    @""
#define JPUSH_CHANNEl   @"App Store"
#define IS_Prod         YES

// 友盟+
#define UMengKey        @""

// 融云IM
#define RCAPPKEY_DEV    @"n19jmcy5n8fz9" // 开发环境
#define RCAPPKEY_PRO    @"" // 生产环境

#endif /* CommonMacros_h */
