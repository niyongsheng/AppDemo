#import "WMTabBar.h"

#import "WMTabBarItem.h"

@interface WMTabBar ()

@property (nonatomic, assign) NSInteger lastSelectIndex;//记录上一次点击index
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation WMTabBar

// 删除系统tabbar的UITabBarButton
- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [view removeFromSuperview];
        }
    }
}


+ (instancetype)tabBarWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray selectedImageArray:(NSArray *)selectedImageArray {
    WMTabBar *tabBar = [[WMTabBar alloc] init];
    tabBar.titleArray = titleArray;
    tabBar.imageArray = imageArray;
    tabBar.selectedImageArray = selectedImageArray;
    [tabBar setupUI];
    return tabBar;
}

- (void)setupUI {
    if (@available(iOS 13, *)) {
        UITabBarAppearance *appearance = [self.standardAppearance copy];
        appearance.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
        // 重置阴影为透明
//        [appearance configureWithTransparentBackground];
        self.standardAppearance = appearance;
    } else {
        self.shadowImage = [UIImage new];
    }
    self.lastSelectIndex = 100; // 默认为100
    for (int i = 0; i < self.titleArray.count; i++) {
        CGFloat itemWidth = (NScreenWidth/self.titleArray.count);
        CGRect frame = CGRectMake(i*itemWidth, 0, itemWidth, 56);
        WMTabBarItem *tabBarItem = [[WMTabBarItem alloc] initWithFrame:frame index:i];
        tabBarItem.tag = i ;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTabBarItemAction:)];
        [tabBarItem addGestureRecognizer:tap];
        [self addSubview:tabBarItem];
        [self.itemArray addObject:tabBarItem];
    }
    self.selectedIndex = 0;
}

- (void)selectTabBarItemAction:(UITapGestureRecognizer *)sender {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(selectedTabbarAtIndex:) object:@(sender.view.tag)];
    [self performSelector:@selector(selectedTabbarAtIndex:) withObject:@(sender.view.tag) afterDelay:0.15f];
}

- (void)selectedTabbarAtIndex:(NSNumber *)index {
    self.selectedIndex = [index integerValue];
    if ([self.tabBarDelegate respondsToSelector:@selector(selectedWMTabBarItemAtIndex:)]) {
        [self.tabBarDelegate selectedWMTabBarItemAtIndex:[index integerValue]];
    }
}

- (void)setSelectedIndex:(NSInteger )selectedIndex {
    _selectedIndex = selectedIndex;
    [self.itemArray enumerateObjectsUsingBlock:^(WMTabBarItem *tabBarItem, NSUInteger idx, BOOL * _Nonnull stop) {
        // 当遍历的idx=selectedIndex时，记录选中状态
        BOOL selected = (idx == selectedIndex);
        // 配置tabBarItem的内容信息
        [tabBarItem configTitle:self.titleArray[idx] normalImage:self.imageArray[idx] selectedImage:self.selectedImageArray[idx] index:idx selected:selected lastSelectIndex:self.lastSelectIndex];
        // 当遍历到最后一个时，赋值lastSelectIndex
        if (idx == (self.itemArray.count-1)) {
            self.lastSelectIndex = selectedIndex;
        }
    }];
}

// 暴露外部的切换动画logo和火箭的方法
- (void)pushHomeTabBarAnimationType:(anmationDirection )anmationDirection {
    if (self.itemArray.count > 0) {
        WMTabBarItem *tabBarItem = self.itemArray[0];
        if (anmationDirection == anmationDirectionUp) {
            [tabBarItem pushHomeTabAnimationUp];
        }else {
            [tabBarItem pushHomeTabAnimationDown];
        }
    }
}

#pragma mark - lazy
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSArray array];
    }
    return _imageArray;
}

- (NSArray *)selectedImageArray {
    if (!_selectedImageArray) {
        _selectedImageArray = [NSArray array];
    }
    return _selectedImageArray;
}

@end
