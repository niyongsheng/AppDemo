//
//  UserManager.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "UserManager.h"

@interface UserManager ()
/// 用户缓存对象
@property (nonatomic, strong) YYCache *userCache;

@end

@implementation UserManager

SINGLETON_FOR_CLASS(UserManager);

#pragma mark -- Lazy Load --
- (YYCache *)userCache {
    if (!_userCache) {
        _userCache = [[YYCache alloc] initWithName:NUserCacheName];
    }
    return _userCache;
}

- (BOOL)isLogined {
    if (!_isLogined) {
        _isLogined = [self.userCache objectForKey:NUserInfoModelCache] ? YES : NO;
    }
    return _isLogined;
}

- (NYSUserInfo *)userInfo {
    if (!_userInfo) {
        NSDictionary *userDict = (NSDictionary *)[self.userCache objectForKey:NUserInfoModelCache];
        _userInfo = [[NYSUserInfo alloc] initWithDictionary:userDict];
    }
    return _userInfo;
}

- (NYSUpdateUserInfo *)updateUserInfo {
    if (!_updateUserInfo) {
        NSDictionary *userDict = (NSDictionary *)[self.userCache objectForKey:NUpdateUserInfoModelCache];
        _updateUserInfo = [[NYSUpdateUserInfo alloc] initWithDictionary:userDict];
    }
    return _updateUserInfo;
}

#pragma mark -- 传参登录 --
- (void)login:(UserLoginType)loginType params:(NSDictionary *)params completion:(loginBlock)completion {
    switch (loginType) {
        case NUserLoginTypePwd: {
            NYSRequest *request = [[NYSRequest alloc] initWithMethod:YTKRequestMethodPOST
                                                                 Url:@"/account/login_account"
                                                            Argument:params];
            [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                id object = request.responseJSONObject;
                if (object) {
                    [self LoginSuccess:object completion:completion];
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                completion(NO, request.error);
            }];
        }
            break;
            
        case NUserLoginTypeVerification: {
            
        }
            break;
            
        case NUserLoginTypeApple: {
            NYSRequest *request = [[NYSRequest alloc] initWithMethod:YTKRequestMethodPOST
                                                                 Url:@"/account/oauth"
                                                            Argument:params];
            [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                id object = request.responseJSONObject;
                if (object) {
                    [self LoginSuccess:object completion:completion];
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                completion(NO, request.error);
            }];
        }
            break;
            
        case NUserLoginTypeQQ: {
            
        }
            break;
            
        case NUserLoginTypeWeChat: {
            [[UMManager sharedUMManager] thirdSignInWithPlatform:NUserLoginTypeWeChat
                                           currentViewController:nil
                                                      completion:^(id result, NSError *error) {
                if (error) {
                    if (completion) {
                        completion(NO, error.localizedDescription);
                    }
                } else {
                    UMSocialUserInfoResponse *resp = result;
                    NLog(@"UMSocialManager originalResponse: %@", resp.originalResponse);
                    // sign in logic
                    
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- 自动登录 —-
- (void)autoLoginToServer:(loginBlock)completion{
    
}

#pragma mark —- 登录成功处理 —-
- (void)LoginSuccess:(id)responseObject completion:(loginBlock)completion {
    NSDictionary *data = responseObject;
    // 1.缓存登录用户信息
    [self saveUserInfo:data];
    
    // 2.获取缓存详细账户资料
    [self saveUpdateUserInfo:[data objectForKey:@"token"] completion:^(BOOL success, id description) {
        if (success) {
            // 登录IM
            [[IMManager sharedIMManager] IMLoginCompletion:^(BOOL success, id  _Nullable description) {
                
            }];
        }
    }];
    
    // 3.完成登录
    completion(YES, @"登录成功");
}

#pragma mark —- 储存用户信息 —-
- (void)saveUserInfo:(NSDictionary *)userDict {
    if (userDict) {
        WS(weakSelf);
        [self.userCache setObject:userDict forKey:NUserInfoModelCache withBlock:^{
            weakSelf.userInfo = [[NYSUserInfo alloc] initWithDictionary:userDict];
        }];
        
        // token过期时间戳
        NSInteger validTime = [[userDict objectForKey:@"expire_time"] integerValue];
        NSInteger expiredTime = validTime + [[NYSTools getNowTimeTimestamp] integerValue];
        [NUserDefaults setInteger:expiredTime forKey:NTokenExpiredTimeStamp];
        [NUserDefaults synchronize];
    }
}

#pragma mark —- 加载缓存的用户信息 —-
- (BOOL)loadUserInfo {
    NSDictionary *userDic = (NSDictionary *)[self.userCache objectForKey:NUserInfoModelCache];
    if (userDic) {
        self.userInfo = [[NYSUserInfo alloc] initWithDictionary:userDic];
        return YES;
    }
    return NO;
}

#pragma mark —- 被踢下线 —-
- (void)onKick {
    [self logout:^(BOOL success, id description) {
        if (success) {
            NPostNotification(NNotificationLoginStateChange, @NO)
        }
    }];
}

#pragma mark -- 退出登录 --
- (void)logout:(void (^)(BOOL, id))completion {
    // 退出IM
    [[IMManager sharedIMManager] IMLogout];
    
    // 清空极光别名tag
    NSInteger seq = 0;
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NLog(@"delAlias code:%ld content:%@ seq:%ld", (long)iResCode, iAlias, (long)seq);
    } seq:++seq];
    [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NLog(@"clearTags code:%ld content:%@ seq:%ld", (long)iResCode, iTags, (long)seq);
    } seq:++seq];
    
    // 清除APP角标
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    // 清空当前用户信息
    self.userInfo = nil;
    self.updateUserInfo = nil;
    self.isLogined = NO;
    
    // 移除缓存
    [self.userCache removeAllObjectsWithBlock:^{
        if (completion) {
            completion(YES, nil);
        }
    }];
}

#pragma mark —- 缓存更新用户信息 —-
- (void)saveUpdateUserInfo:(NSString *)token completion:(updateUserInfoCompletion)completion {
    WS(weakSelf);
    NYSRequest *request = [[NYSRequest alloc] initWithMethod:YTKRequestMethodGET
                                                         Url:@"/account/profile"
                                                    Argument:@{@"token" : token}];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        id data = request.responseJSONObject;
        if (data) {
            // 更新推送别名tag
            NSString *alias = data[@"alias"];
            [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                NLog(@"setAlias code:%ld content:%@ seq:%ld", (long)iResCode, iAlias, (long)seq);
            } seq:++self.seq];
            
            NSMutableSet *tagSet = [[NSMutableSet alloc] initWithArray:data[@"tags"]];
            [tagSet addObject:data[@"account"]];
            [JPUSHService setTags:tagSet completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                NLog(@"setTags code:%ld content:%@ seq:%ld", (long)iResCode, iTags, (long)seq);
            } seq:++self.seq];
            
            // 更新用户信息缓存
            [weakSelf.userCache setObject:data forKey:NUpdateUserInfoModelCache withBlock:^{
                weakSelf.updateUserInfo = [[NYSUpdateUserInfo alloc] initWithDictionary:data];
            }];
            completion(YES, @"UpdateUserInfo cache success!");
        } else {
            completion(NO, @"UpdateUserInfo data null!");
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completion(NO, request.error);
    }];
}

#pragma mark - 加载更新用户信息（获取当前用户信息的数据 /staff/account/info）
/// @return 是否成功
- (BOOL)loadUpdateUserInfo {
    NSDictionary *userDic = (NSDictionary *)[self.userCache objectForKey:NUpdateUserInfoModelCache];
    if (userDic) {
        self.updateUserInfo = [[NYSUpdateUserInfo alloc] initWithDictionary:userDic];
        return YES;
    }
    return NO;
}

@end
