//
//  UIView+Tools.h
//  oatos-token
//
//  Created by QYY on 2017/6/16.
//  Copyright © 2017年 李少游. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tools)

/**
 StoryBoard tool
 */
/// 边线颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
/// 边线宽度
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
/// 圆角半径
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

+ (UIView*)loadingAnimation;

+ (void)removeLoadingAnimation;


@end
