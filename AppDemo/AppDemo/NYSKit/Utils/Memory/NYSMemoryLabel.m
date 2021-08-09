//
//  NYSMemoryLabel.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/13.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSMemoryLabel.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

#define kSize CGSizeMake(75, 20)

@implementation NYSMemoryLabel {
    CADisplayLink *_link;
    UIFont *_font;
    UIFont *_subFont;
    CGFloat _availableMemory;
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
        _subFont = [UIFont fontWithName:@"Menlo" size:12];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:12];
    }
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePostion:)];
    [self addGestureRecognizer:pan];
    
    _link = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    _availableMemory = [self availableMemory];
    return self;
}

- (void)dealloc {
    [_link invalidate];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
}

- (void)tick:(CADisplayLink *)link {
    
    CGFloat mem = [self memoryUsage];
    CGFloat progress = mem / _availableMemory;
    UIColor *color = [UIColor colorWithHue:progress saturation:1 brightness:0.9 alpha:1];
    NSString *memStr = [NSString stringWithFormat:@"%.2f MB", mem];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:memStr];
    [text setColor:color range:NSMakeRange(0, text.length - 2)];
    [text setColor:[UIColor whiteColor] range:NSMakeRange(text.length - 2, 2)];
    text.font = _font;
    [text setFont:_subFont range:NSMakeRange(text.length - 6, 3)];
    
    self.attributedText = text;
}

- (CGFloat)memoryUsage {
    
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    
    if (kernelReturn != KERN_SUCCESS) {
        return NSNotFound;
    } else {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
    }
    
    return (CGFloat)memoryUsageInByte / (1024.0 * 1024.0);
}

- (CGFloat)availableMemory {
    
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount =TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn =task_info(mach_task_self(),
                                        TASK_BASIC_INFO,
                                        (task_info_t)&taskInfo,
                                        &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
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

- (CGRect)changeXWithFrame:(CGRect)originalFrame point:(CGPoint)point {
    BOOL q1 = originalFrame.origin.x >= 0;
    BOOL q2 = originalFrame.origin.x + originalFrame.size.width <= NScreenWidth;
    
    if (q1 && q2) {
        originalFrame.origin.x += point.x;
    }
    return originalFrame;
}

- (CGRect)changeYWithFrame:(CGRect)originalFrame point:(CGPoint)point {
    
    BOOL q1 = originalFrame.origin.y >= 20;
    BOOL q2 = originalFrame.origin.y + originalFrame.size.height <= NScreenHeight;
    if (q1 && q2) {
        originalFrame.origin.y += point.y;
    }
    return originalFrame;
}

@end
