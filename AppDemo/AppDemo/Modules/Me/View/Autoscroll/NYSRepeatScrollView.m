//
//  NYSRepeatScrollView.m
//  AppDemo
//
//  Created by niyongsheng on 2021/6/29.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSRepeatScrollView.h"
#import "NYSAutoscrollImageView.h"

@interface NYSRepeatScrollView ()

@property (nonatomic, strong) NYSAutoscrollImageView *firstView;

@property (nonatomic, strong) NYSAutoscrollImageView *secondView;

@end

@implementation NYSRepeatScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.firstView];
        
        [self addSubview:self.secondView];
        
        UIView *maskView = [[UIView alloc] initWithFrame:self.frame];
        maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        [self addSubview:maskView];
    }
    return self;
}

- (void)startAnimaiton {
    CGRect rect = self.secondView.frame;
    [UIView animateWithDuration:40 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear animations:^{
        self.secondView.frame = CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height);
        self.firstView.frame = CGRectMake(rect.origin.x, -rect.size.height, rect.size.width, rect.size.height);
    } completion:nil];
}

- (void)resumeAnimation {
    [self.firstView resumeAnimation];
    [self.secondView resumeAnimation];
}

- (void)pauseAnimation {
    [self.firstView pauseAnimation];
    [self.secondView pauseAnimation];
}

- (NYSAutoscrollImageView *)firstView {
    if (!_firstView) {
        _firstView = [self generatImageView];
    }
    return _firstView;
}

- (NYSAutoscrollImageView *)secondView {
    if (!_secondView) {
        _secondView = [self generatImageView];
        CGRect rect = _secondView.frame;
        _secondView.frame = CGRectMake(0, rect.size.height, rect.size.width, rect.size.height);
    }
    return _secondView;
}

- (NYSAutoscrollImageView *)generatImageView {
    NYSAutoscrollImageView *imageView = [[NYSAutoscrollImageView alloc] initWithImage:[UIImage imageNamed:@"scrollView"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat width = self.frame.size.width;
    CGFloat height = width * imageView.frame.size.height / imageView.frame.size.width;
    imageView.frame = CGRectMake(0, 0, width, height);
    return imageView;
}

@end
