//
//  NYSBaseViewController.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSBaseViewController.h"
#import "CMPopTipView.h"

@interface NYSBaseViewController ()
@property (nonatomic,strong) UIImageView* noDataView;

@end

@implementation NYSBaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _customStatusBarStyle;
}

- (void)setCustomStatusBarStyle:(UIStatusBarStyle)StatusBarStyle {
    _customStatusBarStyle = StatusBarStyle;
    // 动态更新状态栏颜色
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 默认显示返回按钮
    self.isShowLiftBack = YES;
    // 默认显示状态栏样式
    self.customStatusBarStyle = UIStatusBarStyleDefault;
    // 默认禁用自动设置内边距
//    self.automaticallyAdjustsScrollViewInsets = NO;
    // 视图延伸延伸方向
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeTop;
    // 配置主题
    [self configTheme];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)showNoDataView {
    _noDataView = [[UIImageView alloc] init];
    [_noDataView setImage:[UIImage imageNamed:@"webloaderrorview"]];
    WS(weakSelf);
    [self.view.subviews enumerateObjectsUsingBlock:^(UITableView* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            [weakSelf.noDataView setFrame:CGRectMake(0, 0,obj.frame.size.width, obj.frame.size.height)];
            [obj addSubview:weakSelf.noDataView];
        }
    }];
}

- (void)removeNoDataView {
    if (_noDataView) {
        [_noDataView removeFromSuperview];
        _noDataView = nil;
    }
}

/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, NScreenHeight - NTabBarHeight) style:UITableViewStyleGrouped];
        _tableView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        // 头部刷新
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.stateLabel.hidden = YES;
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.labelLeftInset = 5.f;
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (int i = 1; i <= 7; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"an_%03d", i]];
            [refreshingImages addObject:[image imageByResizeToSize:CGSizeMake(RealValue(30), RealValue(30))]];
        }
        [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
        _tableView.mj_header = header;
        
        // 底部刷新
        MJRefreshAutoGifFooter *footter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        footter.labelLeftInset = 5.f;
        [footter setImages:refreshingImages forState:MJRefreshStateRefreshing];
        _tableView.mj_footer = footter;
        //        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        //        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
        
        _tableView.scrollsToTop = YES;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

/**
 *  懒加载collectionView
 *
 *  @return collectionView
 */
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, NScreenHeight - NTopHeight) collectionViewLayout:flow];
        _collectionView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
        
        // 头部刷新
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.stateLabel.hidden = YES;
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.labelLeftInset = 5.f;
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (int i = 1; i <= 7; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"an_%03d", i]];
            [refreshingImages addObject:[image imageByResizeToSize:CGSizeMake(RealValue(30), RealValue(30))]];
        }
        [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
        _collectionView.mj_header = header;
        
        // 底部刷新
        MJRefreshAutoGifFooter *footter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        footter.labelLeftInset = 5.f;
        [footter setImages:refreshingImages forState:MJRefreshStateRefreshing];
        _collectionView.mj_footer = footter;
        
        _collectionView.scrollsToTop = YES;
    }
    return _collectionView;
}

- (void)headerRereshing {
}

- (void)footerRereshing {
}

/// 是否显示返回按钮
- (void)setIsShowLiftBack:(BOOL)isShowLiftBack {
    _isShowLiftBack = isShowLiftBack;
    NSInteger VCCount = self.navigationController.viewControllers.count;
    // 当VC所在的导航控制器栈中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
        [self addNavigationItemWithImageNames:@[@"back_icon"] isLeft:YES target:self action:@selector(backBtnClicked) tags:@[@"1"]];
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem *NULLBar = [[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}

- (void)backBtnClicked {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark — 导航栏添加图片按钮方法
/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标控制器
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray<NSString *> *)tags {
    NSMutableArray *items = [[NSMutableArray alloc] init];
    // 调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    NSInteger i = 0;
    for (NSString *imageName in imageNames) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.lee_theme
        .LeeAddCustomConfig(DAY, ^(id  _Nonnull item) {
            [(UIButton *)item setImage:[UIImage imageNamed:[imageName stringByAppendingString:@"_day"]] forState:UIControlStateNormal];
        })
        .LeeAddCustomConfig(NIGHT, ^(id  _Nonnull item) {
            [(UIButton *)item setImage:[UIImage imageNamed:[imageName stringByAppendingString:@"_night"]] forState:UIControlStateNormal];
        });
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        } else {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        btn.tag = [tags[i++] integerValue];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

#pragma mark — 导航栏添加文字按钮方法
/**
 导航栏添加文字按钮

 @param titles 文字数组
 @param isLeft 是否是左边 非左即右
 @param target 目标控制器
 @param action 点击方法
 @param tags tags数组 回调区分用
 @return 文字按钮数组
 */
- (NSMutableArray<UIBarButtonItem *> *)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray<NSString *> *)tags {
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    // 调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    
    NSMutableArray * buttonArray = [NSMutableArray array];
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        btn.lee_theme.LeeConfigButtonTitleColor(@"common_nav_font_color_1", UIControlStateNormal);
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        
        // 设置偏移
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        } else {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        [buttonArray addObject:btn];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
    return buttonArray;
}

#pragma mark - 设置主题
- (void)configTheme {
    if (CurrentSystemVersion < 13.0) {
        self.view.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    }
}

#pragma mark - 屏幕旋转
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    // 支持的旋转方向
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    // 默认显示方向
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // 清空内存中的图片缓存
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
