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
#define NNormalSpace        12.0f
#define SegmentViewHeight   44.0f
#define CellHeight          55.0f

#pragma mark -- 颜色区 --
// APP主题
#define DAY                         @"day"
#define NIGHT                       @"night"
#define StandOutHeight              15.0
#define NAppThemeColor              [UIColor colorWithHexString:@"2D65FE"]


// 分栏指示器文字灰色
#define NFontGrayColorSegment       RGBColor(161, 160, 160);
// WebView 加载进度条颜色
#define NWKProgressColor            [UIColor colorWithHexString:@"2D65FE"]
// 系统占位符颜色
#define NFontPlaceHolderColorSystem [[UIColor darkGrayColor] colorWithAlphaComponent:0.4f]

#pragma mark -- 占位图 --
#define NPHI                        [UIImage imageNamed:@"loadingImage"]

#pragma mark -- 字体区 --
#define NFontSize12                 [UIFont systemFontOfSize:12.0f]
#define NFontSize17                 [UIFont systemFontOfSize:20.0f] // 文章字体

#endif /* ThemeMacros_h */
