//
//  NYSBlugeTabBar.h
//  NYSTK
//
//  Created by 倪永胜 on 2018/10/26.
//  Copyright © 2018 NiYongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSBlugeTabBar : UITabBar
/**
 初始化一个中心凸起的TabBar
 @param standOutHeight 凸起高度
 @param radius 圆弧半径
 @param strokelineWidth 描边线宽
 @return customTabBar
 */
- (instancetype)initWithStandOutHeight:(CGFloat)standOutHeight radius:(CGFloat)radius strokelineWidth:(CGFloat)strokelineWidth;

/** tabBar高度偏移量 */
@property (assign, nonatomic) CGFloat tabBarItemY;
/** 中心tabBar高度偏移量 */
@property (assign, nonatomic) CGFloat centerTabBarItemY;

@end

NS_ASSUME_NONNULL_END
