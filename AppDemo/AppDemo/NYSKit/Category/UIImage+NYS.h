//
//  UIImage+NYS.h
//  AppDemo
//
//  Created by 倪永胜 on 2020/9/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (NYS)
/// 修改图片颜色
/// @param color 颜色
- (UIImage *)imageChangeColor:(UIColor*)color;

/// 修改图片尺寸
/// @param string 图片名
/// @param size 尺寸
+ (UIImage *)nameImageWithNameString:(NSString *)string imageSize:(CGSize)size;

/// 获取用户名头像
/// @param name 昵称
/// @param size 尺寸
+ (UIImage *)createNikeNameImageName:(NSString *)name imageSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
