//
//  NYSIconTextLayer.m
//  AppDemo
//
//  Created by niyongsheng on 2021/6/29.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSIconTextLayer.h"

@interface NYSIconTextLayer ()
@property (nonatomic, strong) CALayer *iconLayer;
@property (nonatomic, strong) CATextLayer *textLayer;
@end

@implementation NYSIconTextLayer

- (instancetype)init {
    if (self = [super init]) {
        
        self.maxWidth = 100;
        _imageSize = CGSizeMake(14, 14);
        self.font = [UIFont systemFontOfSize:12];
        
        [self addSublayer:self.textLayer];
        
        [self addSublayer:self.iconLayer];
    }
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    
    CGFloat h = self.bounds.size.height;
    self.borderWidth = 0.5f;
    self.cornerRadius = h/2;
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    self.borderColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    
    CGFloat margin = h * 0.2;
    _iconLayer.frame = CGRectMake(margin, margin, h-2*margin, h-2*margin);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGFloat y = (self.bounds.size.height - size.height) / 2 - 1;
    CGFloat x = CGRectGetMaxX(self.iconLayer.frame) + 5;
    size.width = MIN(size.width, self.maxWidth - x - 10);
    CGRect rect = CGRectMake(x, y, size.width, size.height);
    self.textLayer.frame = rect;
    [CATransaction commit];
    
    CGRect oldFrame = self.frame;
    oldFrame.size.width = CGRectGetMaxX(rect) + 10;
    self.frame = oldFrame;
}

- (void)setText:(NSString *)text {
    _text = text;
    NSAssert(_text, @"字符串不能为nil");
    if (!_text) {
        _text = @"";
    }
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName:self.font
                                 };
    NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    self.textLayer.string = attributedStr;
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    self.iconLayer.contents = (__bridge id _Nullable)(icon.CGImage);
}

- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    CGRect rect = self.iconLayer.frame;
    rect.size = imageSize;
    self.iconLayer.frame = rect;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    self.textLayer.font = fontRef;
    self.textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
}

- (CATextLayer *)textLayer {
    if (!_textLayer) {
        _textLayer = [CATextLayer layer];
        _textLayer.truncationMode = kCATruncationEnd;
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        _textLayer.alignmentMode = kCAAlignmentLeft;
    }
    return _textLayer;
}

- (CALayer *)iconLayer {
    if (!_iconLayer) {
        _iconLayer = [CALayer layer];
        _iconLayer.contentsScale = [UIScreen mainScreen].scale;
        _iconLayer.frame = CGRectMake(4, 4, 14, 14);
    }
    return _iconLayer;
}

@end
