//
//  UIButton+NYS.m
//  NewAnju_IOS
//
//  Created by 倪永胜 on 2020/5/26.
//  Copyright © 2020 NiYongsheng. All rights reserved.
//

#import "UIButton+NYS.h"
#import <objc/runtime.h>

@implementation UIButton (NYS)

static char edgeKey;

- (NSString *)enlargeEdge {
    return objc_getAssociatedObject(self, &edgeKey);
}

- (void)enlargeTouchEdge:(UIEdgeInsets)edge {
    NSString *edgeStr = NSStringFromUIEdgeInsets(edge);
    objc_setAssociatedObject(self, &edgeKey, edgeStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIEdgeInsets changeInsets = UIEdgeInsetsFromString([self enlargeEdge]);
    CGFloat x = self.bounds.origin.x + changeInsets.left;
    CGFloat y = self.bounds.origin.y + changeInsets.top;
    CGFloat width = self.bounds.size.width - changeInsets.left - changeInsets.right;
    CGFloat height = self.bounds.size.height - changeInsets.top - changeInsets.bottom;
    CGRect rect = CGRectMake(x, y, width, height);
    
    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
