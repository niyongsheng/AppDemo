//
//  NYSBaseView.h
//  NYS
//
//  Created by niyongsheng on 2021/8/9.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSBaseView : UIView

@property (weak, nonatomic) UIView *view;

- (void)setupView;

@end

NS_ASSUME_NONNULL_END
