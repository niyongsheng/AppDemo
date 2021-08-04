//
//  NYSTools.m
//  DaoCaoDui_IOS
//
//  Created by 倪永胜 on 2019/6/3.
//  Copyright © 2019 NiYongsheng. All rights reserved.
//

#import "NYSTools.h"

@implementation NYSTools
/**
 滚动动画
 
 @param duration 滚动显示
 @param layer 作用图层
 */
+ (void)animateTextChange:(CFTimeInterval)duration withLayer:(CALayer *)layer {
    CATransition *trans = [[CATransition alloc] init];
    trans.type = kCATransitionMoveIn;
    trans.subtype = kCATransitionFromTop;
    trans.duration = duration;
    trans.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [layer addAnimation:trans forKey:kCATransitionPush];
}

/**
 弹性缩放动画
 
 @param button 作用按钮
 */
+ (void)zoomToShow:(UIButton *)button {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .5f;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 2.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.5)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.5)]];
    
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
    
    UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    if (@available(iOS 13.0, *)) {
        [feedBackGenertor impactOccurredWithIntensity:0.75];
    } else {
        [feedBackGenertor impactOccurred];
    }
}

/**
 左右晃动动画
 
 @param button 作用按钮
 */
+ (void)swayToShow:(UIButton *)button {
    //创建动画
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI),@(0 /180.0 * M_PI)];//度数转弧度
    keyAnimaion.removedOnCompletion = YES;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.37;
    keyAnimaion.repeatCount = 0;
    [button.layer addAnimation:keyAnimaion forKey:nil];
}

/**
 按钮左右抖动动画（错误提醒）
 
 @param button 作用按钮
 */
+ (void)shakToShow:(UIButton *)button {
    CGFloat t = 4.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    button.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        button.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                button.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
    
    UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
    if (@available(iOS 13.0, *)) {
        [feedBackGenertor impactOccurredWithIntensity:0.75];
    } else {
        [feedBackGenertor impactOccurred];
    }
}

/**
 左右抖动动画（错误提醒）
 
 @param layer 左右图层
 */
+ (void)shakeAnimationWithLayer:(CALayer *)layer {
    CGPoint position = [layer position];
    CGPoint y = CGPointMake(position.x - 3.0f, position.y);
    CGPoint x = CGPointMake(position.x + 3.0f, position.y);
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.08f];
    [animation setRepeatCount:3];
    [layer addAnimation:animation forKey:nil];
}

/// 删除动画抖动效果
/// @param layer 作用图层
+ (void)deleteAnimationWithLayer:(CALayer *)layer {

    CABasicAnimation*animation=[CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.1f;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    animation.fromValue= [NSValue valueWithCATransform3D:CATransform3DRotate(layer.transform,-0.08,0.0,0.0,0.08)];
    animation.toValue= [NSValue valueWithCATransform3D:CATransform3DRotate(layer.transform,0.08,0.0,0.0,0.08)];
    [layer addAnimation:animation forKey:@"wiggle"];
}

/**
 判断是否为有效手机号码
 
 @param phone 手机号
 @return 是否有效
 */
+ (BOOL)isValidPhone:(NSString *)phone {
    if (phone.length != 11) {
        return NO;
    } else {
//        NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[57])|(17[013678]))\\d{8}$";
//        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//        return [phoneTest evaluateWithObject:phone];
        return YES;
    }
}

/// 将某个时间转化成 时间戳
/// @param formatTime 时间z字符串
/// @param format 格式（@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime];
    
    // 时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
}

/// 将某个时间戳转化成 时间
/// @param timestamp 时间戳
/// @param format 格式（@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
+ (NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

/**
 时间戳转换成XX分钟之前
 @param timestamp 时间戳
 */
+ (NSString *)timeBeforeInfoWithTimestamp:(NSInteger)timestamp {
    // 获取此时时间戳长度
    NSTimeInterval nowTimeinterval = [[NSDate date] timeIntervalSince1970];
    int timeInt = nowTimeinterval - timestamp; // 时间差
    
    int year = timeInt / (3600 * 24 * 30 *12);
    int month = timeInt / (3600 * 24 * 30);
    int day = timeInt / (3600 * 24);
    int hour = timeInt / 3600;
    int minute = timeInt / 60;
    int second = timeInt;
    if (year > 0) {
        return [NSString stringWithFormat:@"%d年以前", year];
    }else if(month > 0){
        return [NSString stringWithFormat:@"%d个月以前", month];
    }else if(day > 0){
        return [NSString stringWithFormat:@"%d天以前", day];
    }else if(hour > 0){
        return [NSString stringWithFormat:@"%d小时以前", hour];
    }else if(minute > 0){
        return [NSString stringWithFormat:@"%d分钟以前", minute];
    }else if(second > 0){
        return [NSString stringWithFormat:@"%d秒钟以前", second];
    }
    return [NSString stringWithFormat:@"刚刚"];
}

/// 计算年纪
/// @param birthdayStr >=4位生日字符串（1991-01-01）
+ (NSInteger)getAgeWithBirthdayString:(NSString *)birthdayStr {
    if (!birthdayStr) return 0;

    NSInteger birthdayYear = [[birthdayStr substringToIndex:4] integerValue];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy"];
    NSInteger currentYear = [[format stringFromDate:[NSDate date]] integerValue];
    
    return currentYear - birthdayYear;
}


/// 添加圆角阴影效果
/// @param theView 目标view
/// @param theColor 阴影颜色
+ (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 10.0;

    theView.layer.cornerRadius = 10.0;
    
    theView.clipsToBounds=NO;
}


////图片圆角效果
/// @param img 目标图片
/// @param cornerRadius 圆角尺度
+ (UIImage *)rh_bezierPathClip:(UIImage *)img
                  cornerRadius:(CGFloat)cornerRadius {
    int w = img.size.width * img.scale;
    int h = img.size.height * img.scale;
    CGRect rect = (CGRect){CGPointZero, CGSizeMake(w, h)};

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius] addClip];
    [img drawInRect:rect];
    UIImage *cornerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cornerImage;
}


/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
+ (void)addRoundedCorners:(UIView *)theview
                  corners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    theview.layer.mask = shape;
}


///  判断NSString值是否为空或null并转换为空字符串
/// @param string str
+ (NSString *)nullToString:(id)string {
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return @"";
    } else {
        return (NSString *)string;
    }
}

/// YES null    NO !null
/// @param string   str
+ (BOOL)stringIsNull:(id)string {
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return YES;
    } else {
        return NO;
    }
}

/// 获取当前时间戳（单位：秒）
+ (NSString *)getNowTimeTimestamp {

    NSDate *datenow = [NSDate date];

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];

    return timeSp;
}

/// 拼音转换
/// @param str content
+ (NSString *)transformToPinyin:(NSString *)str {
    NSMutableString *mutableString = [NSMutableString stringWithString:str];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

/// Toast
/// @param str 内容
+ (void)showToast:(NSString *)str {
    [SVProgressHUD setHapticsEnabled:YES];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:NAppThemeColor];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:(SVProgressHUDAnimationTypeFlat)];
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, NScreenHeight * 0.4)];
    [SVProgressHUD showImage:[UIImage imageNamed:@"_xxx_"] status:str];
    [SVProgressHUD dismissWithDelay:1.5 completion:^{
        [SVProgressHUD resetOffsetFromCenter];
    }];
}

@end
