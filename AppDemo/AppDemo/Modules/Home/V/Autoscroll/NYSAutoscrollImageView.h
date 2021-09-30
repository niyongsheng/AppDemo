//
//  NYSAutoscrollImageView.h
//  AppDemo
//
//  Created by niyongsheng on 2021/6/29.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (AnimationControl)

- (void)pauseAnimation;

- (void)resumeAnimation;

@end

@interface NYSAutoscrollImageView : UIImageView

- (void)resumeAnimation;

- (void)pauseAnimation;

@end

NS_ASSUME_NONNULL_END
