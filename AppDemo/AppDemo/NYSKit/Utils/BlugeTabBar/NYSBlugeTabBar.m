//
//  NYSBlugeTabBar.m
//  NYSTK
//
//  Created by 倪永胜 on 2018/10/26.
//  Copyright © 2018 NiYongsheng. All rights reserved.
//

#import "NYSBlugeTabBar.h"

@interface NYSBlugeTabBar ()

/** 凸起高度 */
@property (assign, nonatomic) CGFloat standOutHeight;
/** 圆弧半径 */
@property (assign, nonatomic) CGFloat radius;
/** 描边线宽 */
@property (assign, nonatomic) CGFloat strokelineWidth;
/** 描边颜色 */
@property (strong, nonatomic) UIColor *strokelineColor;
/** tabBar背景色 */
@property (strong, nonatomic) UIColor *tabBarBackgroundColor;

@end

@implementation NYSBlugeTabBar

- (instancetype)initWithStandOutHeight:(CGFloat)standOutHeight radius:(CGFloat)radius strokelineWidth:(CGFloat)strokelineWidth {
    if (self = [super init]) {
        self.standOutHeight = standOutHeight;
        self.radius = radius;
        self.strokelineWidth = strokelineWidth;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 1.描述路径
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    CGFloat with = rect.size.width;
    CGFloat height = rect.size.height;
    CGSize size = CGSizeMake(with, height + self.standOutHeight);
    
    // 突出高度
    CGFloat standOutHeight = self.standOutHeight;
    CGFloat radius = self.radius; // 圆半径
    // standOutHeight突出高度
    CGFloat allFloat = (pow(radius, 2)-pow((radius-standOutHeight), 2));
    CGFloat ww = sqrtf(allFloat); // 计算参数的平方根
    
    [path moveToPoint:CGPointMake(size.width/2 - ww, standOutHeight)];
    CGFloat angleH = 0.5*((radius-standOutHeight)/radius);
    CGFloat startAngle = (1+angleH)*((float)M_PI); // 开始弧度
    CGFloat endAngle = (2-angleH)*((float)M_PI); // 结束弧度
    // 开始画弧：CGPointMake：弧的圆心  radius：弧半径 startAngle：开始弧度 endAngle：介绍弧度 clockwise：YES为顺时针，No为逆时针
    [path addArcWithCenter:CGPointMake((size.width)/2, radius) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    // 开始画弧以外的部分
    [path addLineToPoint:CGPointMake(size.width/2 + ww, standOutHeight)];
    [path addLineToPoint:CGPointMake(size.width, standOutHeight)];
    [path addLineToPoint:CGPointMake(size.width, size.height)];
    [path addLineToPoint:CGPointMake(0, size.height)];
    [path addLineToPoint:CGPointMake(0, standOutHeight)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lee_theme.LeeConfigFillColor(@"common_bg_color_2");
    layer.lee_theme.LeeConfigStrokeColor(@"common_tabar_line_color_1");
    layer.lineWidth = self.strokelineWidth;
    [self.layer insertSublayer:layer atIndex:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.frame.size.width / self.subviews.count;
    CGFloat btnH = 0;
    NSInteger index = 0;
    // 遍历子控件
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (index == self.subviews.count / 2) {
                CGFloat temp = isIphonex ? 0 : self.centerTabBarItemY;
                btnY = self.centerTabBarItemY;
                btnH = self.frame.size.height - temp;
            } else {
                btnY = self.tabBarItemY;
                btnH = self.frame.size.height - self.tabBarItemY;
            }
            btnX = index * btnW;
            subView.frame = CGRectMake(btnX, btnY, btnW, btnH);
            index++;
        }
    }
}

@end
