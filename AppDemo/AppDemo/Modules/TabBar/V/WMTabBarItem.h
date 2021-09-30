#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMTabBarItem : UIView

- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger )index;

- (void)configTitle:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage index:(NSInteger)index selected:(BOOL)selected lastSelectIndex:(NSInteger )lastSelectIndex;

// push动画 - 火箭头上来，logo下来
- (void)pushHomeTabAnimationUp;
// push动画 - 火箭头落下, logo上来
- (void)pushHomeTabAnimationDown;

@end

NS_ASSUME_NONNULL_END
