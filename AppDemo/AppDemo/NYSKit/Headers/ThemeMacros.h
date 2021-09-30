//
//  ThemeMacros.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#ifndef ThemeMacros_h
#define ThemeMacros_h

#pragma mark -- 间距区 --
// 默认间距
#define NNormalSpace        RealValue(10.0f)
#define NCellHeight         RealValue(44.0f)
#define NRadius             RealValue(7.0f)

#pragma mark -- 颜色区 --
// APP主题
#define DAY                         @"day"
#define NIGHT                       @"night"
//#define NAppRoundStyle              1
//#define NAppTintImage               1
#define NAppThemeColor              [LEETheme getValueWithTag:[LEETheme currentThemeTag] Identifier:@"app_theme_color"]


// 分栏指示器文字灰色
#define NFontGrayColorSegment       NAppThemeColor
// WebView 加载进度条颜色
#define NWKProgressColor            NAppThemeColor
// 系统占位符颜色
#define NFontPlaceHolderColorSystem [[UIColor darkGrayColor] colorWithAlphaComponent:0.4f]

#pragma mark -- 占位图 --
#define NPImage                     [UIImage imageNamed:@"plaholder_image"]
#define NPImageFillet               [UIImage imageNamed:@"plaholder_image_fillet"]

#pragma mark -- 字体区 --
#define NFontSize12                 [UIFont systemFontOfSize:12.0f]
#define NFontSize17                 [UIFont systemFontOfSize:20.0f] // 文章字体

#pragma mark -- 数据区 --
#define DefaultPageSize             10

#endif /* ThemeMacros_h */
