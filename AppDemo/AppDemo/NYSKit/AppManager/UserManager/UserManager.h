//
//  UserManager.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NYSUserInfo.h"
#import "NYSUpdateUserInfo.h"

#define NUserCacheName              @"KUserCacheName"
#define NUserInfoModelCache         @"KUserInfoModelCache"
#define NUpdateUserInfoModelCache   @"KUpdateUserInfoModelCache"

typedef NS_ENUM(NSInteger, UserLoginType) {
    NUserLoginTypeUnKnow = 0,   // 未知
    NUserLoginTypeWeChat,       // 微信登录
    NUserLoginTypeQQ,           // QQ登录
    NUserLoginTypePwd,          // 账号密码登录
    NUserLoginTypeApple,        // Sign In With Apple
    NUserLoginTypeVerification  // 一键认证
};

typedef void (^updateUserInfoCompletion)(BOOL success, id description);
typedef void (^loginBlock)(BOOL success, id description);
typedef void (^rigesterBlock)(BOOL success, id description);

#define NUserManager [UserManager sharedUserManager]
#define NIsLogin [UserManager sharedUserManager].isLogined
#define NUserInfo [UserManager sharedUserManager].userInfo
#define NUpdateUserInfo [UserManager sharedUserManager].updateUserInfo

@interface UserManager : NSObject

/// 用户管理单例
SINGLETON_FOR_HEADER(UserManager);

/** 登录用户信息 */
@property (nonatomic, strong) NYSUserInfo *userInfo;
/** 更新用户信息 */
@property (nonatomic, strong) NYSUpdateUserInfo *updateUserInfo;
/** 是否已登录 */
@property (nonatomic, assign) BOOL isLogined;
/** 请求序列号 */
@property (nonatomic, assign) NSInteger seq;

#pragma mark -— 登录相关方法 --

/// 传参登录
/// @param loginType 登录方式
/// @param params 参数，手机或账号登录需要
/// @param completion  登录完成回调
- (void)login:(UserLoginType)loginType params:(NSDictionary *)params completion:(loginBlock)completion;

/// 自动登录
/// @param completion 回调
- (void)autoLoginToServer:(loginBlock)completion;

/// 退出登录
/// @param completion 回调
- (void)logout:(loginBlock)completion;

///// 加载缓存用户数据（登录成功后的数据）
//- (BOOL)loadUserInfo;
//
///// 缓存用户数据（登录成功后的数据）
///// @param userDict 当前登录用户信息
//- (void)saveUserInfo:(NSDictionary *)userDict;

/// 缓存更新用户信息（获取当前用户信息的数据 /staff/account/info）
/// @param token 登录令牌
/// @param completion 完成回调
- (void)saveUpdateUserInfo:(NSString *)token completion:(updateUserInfoCompletion)completion;

/// 加载更新用户信息（获取当前用户信息的数据 /staff/account/info）
/// @return 是否成功
- (BOOL)loadUpdateUserInfo;

@end
