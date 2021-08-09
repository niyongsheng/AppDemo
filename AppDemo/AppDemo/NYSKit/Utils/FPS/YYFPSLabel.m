//
//  YYFPSLabel.m
//  YYKitExample
//
//  Created by ibireme on 15/9/3.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYFPSLabel.h"

#define kSize CGSizeMake(55, 20)

@implementation YYFPSLabel {
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
    
    NSTimeInterval _llll;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = kSize;
    }
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:4];
    }
    
    // 添加拖拽手势-改变控件的位置
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
    [self addGestureRecognizer:pan];
    
    _link = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}

- (void)dealloc {
    [_link invalidate];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS",(int)round(fps)]];
    [text setColor:color range:NSMakeRange(0, text.length - 3)];
    [text setColor:[UIColor whiteColor] range:NSMakeRange(text.length - 3, 3)];
    text.font = _font;
    [text setFont:_subFont range:NSMakeRange(text.length - 4, 1)];
    
    self.attributedText = text;
}

- (void)changePostion:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self];
    
    CGRect originalFrame = self.frame;
    
    originalFrame = [self changeXWithFrame:originalFrame point:point];
    originalFrame = [self changeYWithFrame:originalFrame point:point];
    
    self.frame = originalFrame;
    
    [pan setTranslation:CGPointZero inView:self];
    
    UIButton *button = (UIButton *)pan.view;
    if (pan.state == UIGestureRecognizerStateBegan) {
        button.enabled = NO;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
    } else {
        
        CGRect frame = self.frame;
        
        if (self.center.x <= NScreenWidth / 2.0){
            frame.origin.x = 10;
        }else
        {
            frame.origin.x = NScreenWidth - frame.size.width - 10;
        }
        
        if (frame.origin.y < 20) {
            frame.origin.y = 20;
        } else if (frame.origin.y + frame.size.height > NScreenHeight) {
            frame.origin.y = NScreenHeight - frame.size.height;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        }];
        
        button.enabled = YES;
        
    }
}

// 拖动改变控件的水平方向x值
- (CGRect)changeXWithFrame:(CGRect)originalFrame point:(CGPoint)point {
    BOOL q1 = originalFrame.origin.x >= 0;
    BOOL q2 = originalFrame.origin.x + originalFrame.size.width <= NScreenWidth;
    
    if (q1 && q2) {
        originalFrame.origin.x += point.x;
    }
    return originalFrame;
}

// 拖动改变控件的竖直方向y值
- (CGRect)changeYWithFrame:(CGRect)originalFrame point:(CGPoint)point {
    
    BOOL q1 = originalFrame.origin.y >= 20;
    BOOL q2 = originalFrame.origin.y + originalFrame.size.height <= NScreenHeight;
    if (q1 && q2) {
        originalFrame.origin.y += point.y;
    }
    return originalFrame;
}

@end
