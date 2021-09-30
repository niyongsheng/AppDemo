//
//  AppManager.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "AppManager.h"
#import "YYFPSLabel.h"
#import "NYSMemoryLabel.h"

@implementation AppManager

SINGLETON_FOR_CLASS(AppManager);

/// APP运行时帧率
- (void)showFPS {
    // 显示FPS
    YYFPSLabel *_fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = NScreenHeight - (isIphonex ? RealValue(90) : RealValue(55));
    _fpsLabel.right = NScreenWidth - 10;
    _fpsLabel.alpha = 0.8f;
    [NRootViewController.view addSubview:_fpsLabel];
}

/// APP运行时内存占用
- (void)showMemory {
    NYSMemoryLabel *_memLabel = [NYSMemoryLabel new];
    [_memLabel sizeToFit];
    _memLabel.bottom = NScreenHeight - (isIphonex ? RealValue(115) : RealValue(80));
    _memLabel.right = NScreenWidth - 10;
    _memLabel.alpha = 0.8f;
    [NRootViewController.view addSubview:_memLabel];
}

/// APP名称
- (NSString *)getAppName {
    // CFBundleName
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

/// APP版本
- (NSString *)getAppVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

/// APP构建版本
- (NSString *)getAppBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

/// APP ID
- (NSString *)getAppBundleId {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

/// APP App Store URL
- (NSString *)getAppUrlInItunes {
    return  [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?bundleId=%@", [self getAppBundleId]];
}

@end
