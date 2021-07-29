//
//  NYSIconTextView.h
//  AppDemo
//
//  Created by niyongsheng on 2021/6/29.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSIconTextLayer : CALayer
///  Default 14 * 14
@property (nonatomic) CGSize imageSize;
@property (nonatomic, assign) CGFloat maxWidth;
/// Default [UIFont systemFontOfSize:12]
@property (nonatomic, strong, nullable) UIImage *icon;
/// Before ‘text’ setter please
@property (nonatomic, strong, nullable) UIColor *textColor;
@property (nonatomic, copy, nullable) NSString *text;
@property (nonatomic, strong, nonnull) UIFont *font;
@end

NS_ASSUME_NONNULL_END
