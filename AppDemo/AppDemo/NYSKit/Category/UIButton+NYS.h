//
//  UIButton+NYS.h
//  NewAnju_IOS
//
//  Created by 倪永胜 on 2020/5/26.
//  Copyright © 2020 NiYongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define defaultInterval 1  // 默认时间间隔

@interface UIButton (NYS)
/// 点击响应范围
/// @param edge 范围
- (void)enlargeTouchEdge:(UIEdgeInsets)edge;

/// 设置点击时间间隔
@property (nonatomic, assign) NSTimeInterval timeInterval;
/// 用于设置单个按钮不需要被hook
@property (nonatomic, assign) BOOL isIgnore;
@end

NS_ASSUME_NONNULL_END
