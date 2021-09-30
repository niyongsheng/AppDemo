#import "WMTabBarItem.h"

#import "WMTabBarItemCell.h"

@interface WMTabBarItem ()<UICollectionViewDelegate, UICollectionViewDataSource>

/** tabbar的文字title */
@property (nonatomic, strong) UILabel *titleLabel;
/** tabbar的图片 */
@property (nonatomic, strong) UIImageView *imageView;

/*
 *  index=0时，即首页tababr 选中时的背景图片
 *  效果图细节：背景原图片没有变化，只是背景图片上的火箭🚀和logo 两个切换动画，
 *  所以: 隔离开背景部分和动画部分
 */
@property (nonatomic, strong) UIImageView *homeTabSelectedBgView;

/*
 *  动画部分
 *  用的是collectionView, 通过滑动到某个item进行动画
 *  结果：完美实现功能
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/*
 *  flag，用以点击首页tabbar时 如果是火箭状态，则进行切换logo动画，且界面滑到顶部
 */
@property (nonatomic, assign) BOOL flag;
@end

@implementation WMTabBarItem

- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger )index {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.imageView];
        [self addSubview:self.homeTabSelectedBgView];
        
        self.imageView.frame  = CGRectMake(self.bounds.size.width/2-14, 7, 28, 28);
        self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+2, self.bounds.size.width, 14);
        self.homeTabSelectedBgView.frame = CGRectMake(self.bounds.size.width/2-21, 7, 42, 42);

        if (index == 0) {
            // 当为首页tab时，加上以下内容
            [self addSubview:self.homeTabSelectedBgView];
            
            [self.homeTabSelectedBgView addSubview:self.collectionView];
            self.homeTabSelectedBgView.frame  = CGRectMake(self.bounds.size.width/2-21, 7, 42, 42);
            self.collectionView.frame  = CGRectMake(0, 0, 42, 42);
            self.collectionView.center = CGPointMake(self.homeTabSelectedBgView.frame.size.width/2, self.homeTabSelectedBgView.frame.size.height/2);

            [self.collectionView registerClass:[WMTabBarItemCell class]
                    forCellWithReuseIdentifier:NSStringFromClass([WMTabBarItemCell class])];
        }
    }
    return self;
}

#pragma mark - collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WMTabBarItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([WMTabBarItemCell class]) forIndexPath:indexPath];
    NSString *imageStr = (indexPath.item == 0) ? @"tabbar_home_selecetedLogo" : @"tabbar_home_selecetedPush";
    [cell configItemImageString:imageStr];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark ----------- Action -------------

// 当点击tab的item时，执行
- (void)configTitle:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage index:(NSInteger)index selected:(BOOL)selected lastSelectIndex:(NSInteger )lastSelectIndex {
//    if (@available(iOS 10.0, *)) {
//        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
//        [feedBackGenertor impactOccurred];
//    }
    
    self.titleLabel.text = title;
    // 当index == 0, 即首页tab
    if (index == 0) {
        if (selected) {
            [self.homeTabSelectedBgView setImage:[[UIImage imageNamed:@"tabbar_home_selecetedBg"] imageByTintColor:NAppThemeColor]];
            self.homeTabSelectedBgView.hidden = NO;
             YES;self.imageView.hidden = self.titleLabel.hidden = YES;
            
            // 如果本次点击和上次是同一个tab 都是第0个，则执行push动画，否则执行放大缩小动画
            if (lastSelectIndex == index) {
                if (self.flag) {
                    // 如果已经是火箭状态，则点击切换logo，且发通知 让首页滑到顶部
                    [self pushHomeTabAnimationDown];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kPushDownAnimationScrollTopNotification" object:nil];
                }
            }else {
                [self animationWithHomeTab];
            }
        }else {
            [self.imageView setImage:[[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            self.homeTabSelectedBgView.hidden = YES;
            self.imageView.hidden = self.titleLabel.hidden = NO;
        }
    }else {
        // 其他tab
        self.homeTabSelectedBgView.hidden = YES;
        self.imageView.hidden = self.titleLabel.hidden = NO;
        if (selected) {
            [self.imageView setImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            self.titleLabel.lee_theme.LeeConfigTextColor(@"app_theme_color");
            // 如果本次点击和上次是同一个tab 则无反应，否则执行放大缩小动画
            if (lastSelectIndex != index) {
                [self animationWithNormalTab];
            }
        } else {
            [self.imageView setImage:[[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            self.titleLabel.textColor = [UIColor grayColor];
        }
    }
}

/** tab之间切换动画 */
- (void)animationWithHomeTab {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration  = 0.2f;
    animation.fromValue = [NSNumber numberWithFloat:0.5f];
    animation.toValue   = [NSNumber numberWithFloat:1.f];
    [self.homeTabSelectedBgView.layer addAnimation:animation forKey:nil];
}

- (void)animationWithNormalTab {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration  = 0.25f;
    animation.fromValue = [NSNumber numberWithFloat:0.5f];
    animation.toValue   = [NSNumber numberWithFloat:1.f];
    [self.imageView.layer  addAnimation:animation forKey:nil];
    [self.titleLabel.layer addAnimation:animation forKey:nil];
}

// push动画，火箭头出来
-(void)pushHomeTabAnimationUp {
    self.flag = YES;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

// push动画，火箭头落下
-(void)pushHomeTabAnimationDown {
    self.flag = NO;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}


#pragma mark ----------- lazy Load -------------

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIView *)homeTabSelectedBgView {
    if (!_homeTabSelectedBgView) {
        _homeTabSelectedBgView = [UIImageView new];
        _homeTabSelectedBgView.userInteractionEnabled = YES;
        _homeTabSelectedBgView.hidden = YES;
    }
    return _homeTabSelectedBgView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(42.f, 42.f);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

@end
