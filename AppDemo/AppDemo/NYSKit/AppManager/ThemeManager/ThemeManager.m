//
//  ThemeManager.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/13.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "ThemeManager.h"
#import "LEEBubble.h"

@implementation ThemeManager

SINGLETON_FOR_CLASS(ThemeManager);

#pragma mark -- 设置主题 --
- (void)configTheme {
    
    NSString *dayJsonPath = [[NSBundle mainBundle] pathForResource:@"themejson_day" ofType:@"json"];
    NSString *nightJsonPath = [[NSBundle mainBundle] pathForResource:@"themejson_night" ofType:@"json"];
    
    NSString *dayJson = [NSString stringWithContentsOfFile:dayJsonPath encoding:NSUTF8StringEncoding error:nil];
    NSString *nightJson = [NSString stringWithContentsOfFile:nightJsonPath encoding:NSUTF8StringEncoding error:nil];
    
    [LEETheme addThemeConfigWithJson:dayJson Tag:DAY ResourcesPath:nil];
    [LEETheme addThemeConfigWithJson:nightJson Tag:NIGHT ResourcesPath:nil];
    [LEETheme defaultTheme:DAY];
}

/// 初始化气泡
- (void)initBubble:(UIWindow *)window {
    if (@available(iOS 13.0, *)) {
        // 关闭跟随系统暗黑模式切换
//        [UIApplication sharedApplication].keyWindow.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    LEEBubble *bubble = [[LEEBubble alloc] initWithFrame:CGRectMake(CGRectGetWidth(window.frame) - 58, CGRectGetHeight(window.frame) - 200, 48, 48)];
    bubble.edgeInsets = UIEdgeInsetsMake(64, 0 , 0 , 0);
    [window addSubview:bubble];
    
    bubble.lee_theme
    .LeeAddSelectorAndColor(DAY, @selector(setColor:), [UIColor grayColor])
    .LeeAddSelectorAndColor(NIGHT, @selector(setColor:), [UIColor colorWithWhite:0 alpha:0.4f])
    .LeeThemeChangingBlock(^(NSString *tag, LEEBubble * item) {
        
        if ([tag isEqualToString:DAY]) {
            item.image = [UIImage imageNamed:@"day"];
        } else if ([tag isEqualToString:NIGHT]) {
            item.image = [UIImage imageNamed:@"night"];
        } else {
            item.image = [UIImage imageNamed:@"day"];
        }
    });
    
    __weak typeof(self) weakSelf = self;

    bubble.clickBubbleBlock = ^(){
        
        if (weakSelf) {
            [weakSelf changeTheme:window];
        }
    };
}

- (void)changeTheme:(UIWindow *)window {
    // 覆盖截图（获取当前window的快照视图）
    UIView *tempView = [window snapshotViewAfterScreenUpdates:NO];
    [window addSubview:tempView];
    
    // 切换主题
    if ([[LEETheme currentThemeTag] isEqualToString:DAY]) {
        [LEETheme startTheme:NIGHT];
        if (@available(iOS 13.0, *)) {
            [NAppWindow setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
        }
    } else {
        [LEETheme startTheme:DAY];
        if (@available(iOS 13.0, *)) {
            [NAppWindow setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
        }
    }
    
    // 增加动画 移除覆盖
    [UIView animateWithDuration:1.0f animations:^{
        tempView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [tempView removeFromSuperview];
    }];
}

/// 设置主题
/// @param tag 主题标签
- (void)setThemeWithTag:(NSString *)tag {
    [LEETheme startTheme:tag];
    
    if ([tag isEqualToString:NIGHT]) {
        if (@available(iOS 13.0, *)) {
            [NAppWindow setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
        }
    } else {
        if (@available(iOS 13.0, *)) {
            [NAppWindow setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
        }
    }
}

@end
