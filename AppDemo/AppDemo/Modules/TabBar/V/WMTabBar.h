#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// logo和火箭切换动画的枚举anmationDirection
typedef NS_ENUM(NSUInteger, anmationDirection) {
    anmationDirectionUp,//push动画，火箭头出来，logo下去
    anmationDirectionDown,//push动画，火箭头下去，logo出来
};

@protocol WMTabBarDelegate <NSObject>

/** 选中tabbar */
- (void)selectedWMTabBarItemAtIndex:(NSInteger)index;

@end

@interface WMTabBar : UITabBar

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *selectedImageArray;
@property (nonatomic, weak) id <WMTabBarDelegate> tabBarDelegate;
/** 实例化 */
+ (instancetype)tabBarWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray selectedImageArray:(NSArray *)selectedImageArray;

// 外部指定跳转到某个tab时调用
- (void)selectedTabbarAtIndex:(NSNumber *)index;

// 暴露外部的切换动画logo和火箭的方法
- (void)pushHomeTabBarAnimationType:(anmationDirection )anmationDirection;

@end

NS_ASSUME_NONNULL_END
