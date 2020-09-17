//
//  ThemeManager.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/13.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThemeManager : NSObject

SINGLETON_FOR_HEADER(ThemeManager);

/// 主题配置
- (void)configTheme;

/// 初始化主题切换气泡
- (void)initBubble:(UIWindow *)window;

/// 切换主题
- (void)changeTheme:(UIWindow *)window;

/// 设置主题
/// @param tag 主题标签
- (void)setThemeWithTag:(NSString *)tag;

@end

NS_ASSUME_NONNULL_END
