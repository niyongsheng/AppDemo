//
//  NYSBaseView.m
//  NYS
//
//  Created by niyongsheng on 2021/8/9.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

/*
 UIViewAutoresizingNone                   不自动调整。
 UIViewAutoresizingFlexibleLeftMargin     自动调整view与父视图左边距，以保证右边距不变
 UIViewAutoresizingFlexibleWidth          自动调整view的宽度，保证左边距和右边距不变
 UIViewAutoresizingFlexibleRightMargin    自动调整view与父视图右边距，以保证左边距不变
 UIViewAutoresizingFlexibleTopMargin      自动调整view与父视图上边距，以保证下边距不变
 UIViewAutoresizingFlexibleHeight         自动调整view的高度，以保证上边距和下边距不变
 UIViewAutoresizingFlexibleBottomMargin   自动调整view与父视图下边距，以保证上边距不变
 
 custome
 
 */

#import "NYSBaseView.h"

@implementation NYSBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.view = [self loadViewFromNib];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.view = [self loadViewFromNib];
    }
    return self;
}

- (UIView*)loadViewFromNib {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class])
                                bundle:bundle];
    
    UIView *view = [nib instantiateWithOwner:self options:nil][0];
    
    view.frame = self.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:view];
    
    [self setupView];
    
    return view;
    
}

// @implementation in subview
- (void)setupView {
    NLog(@"setupView BaseXibView");
}

@end
