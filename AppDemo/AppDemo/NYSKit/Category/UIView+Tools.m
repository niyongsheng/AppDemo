//
//  UIView+Tools.m
//  oatos-token
//
//  Created by QYY on 2017/6/16.
//  Copyright © 2017年 李少游. All rights reserved.
//

#import "UIView+Tools.h"
#define kLinePix ( 1 / [UIScreen mainScreen].scale)

@implementation UIView (Tools)
#pragma mark - StoryBoard tool
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth * kLinePix;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    // 栅格化 - 提高性能
    // 设置栅格化后，图层会被渲染成图片，并且缓存，再次使用时，不会重新渲染
    //    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    //    self.layer.shouldRasterize = YES;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

+ (UIView*)loadingAnimation{
    UIWindow *keywodow = UIApplication.sharedApplication.keyWindow;
    CGFloat  width =  UIApplication.sharedApplication.keyWindow.frame.size.width;
    CGFloat height = UIApplication.sharedApplication.keyWindow.frame.size.height;
    UIView *animationBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    animationBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    UIImageView *animation = [[UIImageView alloc] init];
    animation.frame = CGRectMake(0, 0, 80, 80);
    animation.center = animationBg.center;
    [animationBg addSubview:animation];
    NSURL *gifImageUrl = [[NSBundle mainBundle] URLForResource:@"loading_gif_plane" withExtension:@"gif"];
    [animation setImageURL:gifImageUrl];
    animationBg.tag = 1000001;
    [keywodow addSubview:animationBg];
    return animationBg;
}

+ (void)removeLoadingAnimation{
    UIWindow *keywodow = UIApplication.sharedApplication.keyWindow;
    UIView *animationBg = [keywodow viewWithTag:1000001];
    [animationBg removeFromSuperview];
}

@end
