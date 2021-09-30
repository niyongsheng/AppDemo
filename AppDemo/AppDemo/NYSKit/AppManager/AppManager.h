//
//  AppManager.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppManager : NSObject

SINGLETON_FOR_HEADER(AppManager);

/// FPS监测
- (void)showFPS;

/// Mem监测
- (void)showMemory;

/// APP名称
- (NSString *)getAppName;

/// APP版本
- (NSString *)getAppVersion;

/// APP构建版本
- (NSString *)getAppBuildVersion;

/// APP ID
- (NSString *)getAppBundleId;

/// APP App Store URL
- (NSString *)getAppUrlInItunes;

@end

NS_ASSUME_NONNULL_END
