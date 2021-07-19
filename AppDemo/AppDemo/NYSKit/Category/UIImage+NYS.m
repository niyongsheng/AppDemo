//
//  UIImage+NYS.m
//  AppDemo
//
//  Created by 倪永胜 on 2020/9/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "UIImage+NYS.h"

@implementation UIImage (NYS)

- (UIImage*)imageChangeColor:(UIColor*)color {
    // 获取画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    // 画笔沾取颜色
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    // 绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    // 再绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    // 获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)nameImageWithNameString:(NSString *)string imageSize:(CGSize)size {
    return [self createNikeNameImageName:string imageSize:size];
}

// 按规则截取nikeName
+ (NSString *)dealWithNikeName:(NSString *)nikeName {
    // 筛除部分特殊符号
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"【】"];
    nikeName = [nikeName stringByTrimmingCharactersInSet:set];
    NSString *showName = @"";
    NSString *tempName = @"";
    
    NSRange range1 = [nikeName rangeOfString:@"-"];
    
    if (range1.length) {
        // 含有“-”
        tempName = [nikeName substringToIndex:range1.location];
    }
    else {
        // 不含“-”
        tempName = nikeName;
    }
    
    NSRange range2 = [tempName rangeOfString:@"("];
    
    if (range2.length) {
        // 含有“(”
        tempName = [tempName substringToIndex:range2.location];
    }
    else {
        // 不含“(”
        tempName = tempName;
    }
    
    if ([UIImage isStringContainLetterWith:tempName]) {
        // 含有字母取前两个
        showName = [tempName substringToIndex:2];
    }
    else {
        // 不含字母
        if (!tempName.length) {
            
        }
        else if (tempName.length == 1)
        {
            showName = [tempName substringToIndex:1];
        }
        else if (tempName.length == 2)
        {
            showName = [tempName substringToIndex:2];
        }
        else if (tempName.length == 3)
        {
            showName = [tempName substringFromIndex:1];
        }
        else if (tempName.length == 4)
        {
            showName = [tempName substringFromIndex:2];
        }
        else {
            showName = [tempName substringToIndex:2];
        }
    }
    return showName;
}
// 检查是否含有字母
+ (BOOL)isStringContainLetterWith:(NSString *)str {
    if (!str) {
        return NO;
    }
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //count是str中包含[A-Za-z]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {
        return YES;
    }
    return NO;
}
// 根据nikeName绘制图片
+ (UIImage *)createNikeNameImageName:(NSString *)name imageSize:(CGSize)size {
    NSArray *colorArr = @[@"17c295",@"b38979",@"f2725e",@"f7b55e",@"4da9eb",@"5f70a7",@"568aad"];
    UIImage *image = [UIImage imageColor:[UIImage colorWithHexString:colorArr[ABS(name.hash % colorArr.count)] alpha:1.0] size:size cornerRadius:size.width / 2];
    
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    
    [image drawAtPoint : CGPointMake ( 0 , 0 )];
    
    // 获得一个位图图形上下文
    
    CGContextRef context= UIGraphicsGetCurrentContext ();
    
    CGContextDrawPath (context, kCGPathStroke );
    
    // 画名字
    
    CGSize nameSize = [name sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
    
    [name drawAtPoint : CGPointMake ( (size.width  - nameSize.width) / 2 , (size.height  - nameSize.height) / 2 ) withAttributes : @{ NSFontAttributeName :[ UIFont systemFontOfSize:14], NSForegroundColorAttributeName :[ UIColor colorWithHexString:@"ffffff" ] } ];
    
    // 返回绘制的新图形
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    
    UIGraphicsEndImageContext ();
    
    return newImage;
    
}

+ (UIImage *)imageColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius {
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(1, 1);
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(rect);
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    [colorImage drawInRect:rect];
    
    colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}

+ (id)colorWithHexString:(NSString*)hexColor alpha:(CGFloat)alpha {
    
    unsigned int red,green,blue;
    NSRange range;
    
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    UIColor* retColor = [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:alpha];
    return retColor;
}

@end
