//
//  NYSTitleButton.m
//  NewAnju_IOS
//
//  Created by 倪永胜 on 2020/4/5.
//  Copyright © 2020 NiYongsheng. All rights reserved.
//

#import "NYSTitleButton.h"

#define NWTitleButytonImageW 12

@implementation NYSTitleButton

+ (instancetype)titleButton {
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 高亮状态不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = NFontSize17;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.imageView.contentMode = UIViewContentModeRight;
        // 文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageY = 0;
    CGFloat imageH = contentRect.size.height;
    CGFloat imageW = NWTitleButytonImageW;
    CGFloat imageX = contentRect.size.width - imageW;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleH = contentRect.size.height;
    CGFloat titleW = contentRect.size.width - NWTitleButytonImageW;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
