//
//  NYSBaseViewController.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSBaseViewController.h"
#import "CMPopTipView.h"
#import "NSError+NYS.h"
#import "WSScrollLabel.h"

@interface NYSBaseViewController ()
<
UIScrollViewDelegate,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate
>

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
    NLog(@"%@", [NSString stringWithFormat:@"【控制器：%@】---> viewDidLoad", NSStringFromClass(self.class)]);
    
    // 默认显示返回按钮
    self.isShowLiftBack = YES;
    // 默认显示状态栏样式
    self.customStatusBarStyle = UIStatusBarStyleDefault;
    
    // 导航栏适配
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
        barApp.shadowColor = [UIColor clearColor];
        self.navigationController.navigationBar.scrollEdgeAppearance = barApp;
        self.navigationController.navigationBar.standardAppearance = barApp;
    }

    // 配置主题
    [self configTheme];
    
    // 默认使用系统刷新样式
    [self setIsUseUIRefreshControl:YES];
    // 默认错误信息
    self.emptyError = [NSError errorCode:NSNYSErrorCodeUnKnow description:@"暂无数据" reason:@"" suggestion:@"重试" placeholderImg:@"error"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 默认tableview样式，如需要修改建议在子类configTheme方法中重写
    _tableviewStyle = UITableViewStylePlain;
    
    [NNotificationCenter postNotificationName:NNotificationBCViewWillAppear object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [NNotificationCenter postNotificationName:NNotificationBCViewDidAppear object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, NScreenHeight) style:_tableviewStyle];
        if (_tableviewStyle == UITableViewStyleGrouped) { // 处理顶部空白高度
            _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, CGFLOAT_MIN)];
        }
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.contentInset = UIEdgeInsetsMake(NTopHeight, 0, 0, 0);
        }
#ifdef NAppRoundStyle
        _tableView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
#else
        _tableView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
#endif

        _tableView.estimatedRowHeight = NCellHeight;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        static NSString *endStr = @"—— The end ——";
        if (self.isUseUIRefreshControl) {
            // header refresh
            UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
            refreshControl.tintColor = NAppThemeColor;
            [refreshControl addTarget:self action:@selector(headerRereshing) forControlEvents:UIControlEventValueChanged];
            _tableView.refreshControl = refreshControl;
            
            // footer refresh
            MJRefreshAutoNormalFooter *footter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            footter.refreshingTitleHidden = YES;
            footter.loadingView.color = NAppThemeColor;
            footter.loadingView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            footter.stateLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
            footter.stateLabel.font = [UIFont fontWithName:@"DOUYU Font" size:12.0f];
            [footter setTitle:@"" forState:MJRefreshStateIdle];
            [footter setTitle:endStr forState:MJRefreshStateNoMoreData];
            [footter afterBeginningAction:^{
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [feedBackGenertor impactOccurred];
            }];
            _tableView.mj_footer = footter;
            
        } else {
            
            // 刷新数据的帧动画
            CGSize size = CGSizeMake(RealValue(30), RealValue(30));
            NSMutableArray *refreshingImages = [NSMutableArray array];
            for (int i = 1; i <= 7; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"an_%03d", i]];
                [refreshingImages addObject:[image imageByResizeToSize:size]];
            }
            
            // header refresh
            MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
            header.stateLabel.hidden = YES;
            header.lastUpdatedTimeLabel.hidden = YES;
            header.automaticallyChangeAlpha = NO;
            [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
            [header setImages:@[[[UIImage imageNamed:@"icon_refresh_up"] imageScaledToSize:size]] duration:1.0f forState:MJRefreshStatePulling];
            [header setImages:@[UIImage.new, [[UIImage imageNamed:@"icon_refresh_dropdown"] imageScaledToSize:size]] duration:1.0f forState:MJRefreshStateIdle];
            _tableView.mj_header = header;
            
            // footer refresh
            MJRefreshAutoGifFooter *footter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            footter.refreshingTitleHidden = YES;
            footter.stateLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
            footter.stateLabel.font = [UIFont fontWithName:@"DOUYU Font" size:12.0f];
            [footter setTitle:@"" forState:MJRefreshStateIdle];
            [footter setTitle:endStr forState:MJRefreshStateNoMoreData];
            [footter setImages:refreshingImages forState:MJRefreshStateRefreshing];
            [footter afterBeginningAction:^{
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [feedBackGenertor impactOccurred];
            }];
            _tableView.mj_footer = footter;
        }
        
        _tableView.scrollsToTop = YES;
        _tableView.tableFooterView = [UIView new];
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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, NScreenHeight) collectionViewLayout:flow];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _collectionView.contentInset = UIEdgeInsetsMake(NTopHeight, 0, 0, 0);
        }
#ifdef NAppRoundStyle
        _collectionView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
#else
        _collectionView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
#endif
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;

        static NSString *endStr = @"—— The end ——";
        if (self.isUseUIRefreshControl) {
            // header refresh
            UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
            refreshControl.tintColor = NAppThemeColor;
            [refreshControl addTarget:self action:@selector(headerRereshing) forControlEvents:UIControlEventValueChanged];
            _collectionView.refreshControl = refreshControl;
            
            // footer refresh
            MJRefreshAutoNormalFooter *footter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
//            [footter setAnimationDisabled];
            footter.refreshingTitleHidden = YES;
            footter.loadingView.color = NAppThemeColor;
            footter.loadingView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            footter.stateLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
            footter.stateLabel.font = [UIFont fontWithName:@"DOUYU Font" size:12.0f];
            [footter setTitle:@"" forState:MJRefreshStateIdle];
            [footter setTitle:endStr forState:MJRefreshStateNoMoreData];
            [footter afterBeginningAction:^{
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [feedBackGenertor impactOccurred];
            }];
            _collectionView.mj_footer = footter;
            
        } else {
            // 刷新数据的帧动画
            CGSize size = CGSizeMake(RealValue(30), RealValue(30));
            NSMutableArray *refreshingImages = [NSMutableArray array];
            for (int i = 1; i <= 7; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"an_%03d", i]];
                [refreshingImages addObject:[image imageByResizeToSize:size]];
            }
            
            // header refresh
            MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
            header.stateLabel.hidden = YES;
            header.lastUpdatedTimeLabel.hidden = YES;
            header.automaticallyChangeAlpha = NO;
            [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
            [header setImages:@[[[UIImage imageNamed:@"icon_refresh_up"] imageScaledToSize:size]] duration:1.0f forState:MJRefreshStatePulling];
            [header setImages:@[UIImage.new, [[UIImage imageNamed:@"icon_refresh_dropdown"] imageScaledToSize:size]] duration:1.0f forState:MJRefreshStateIdle];
            _collectionView.mj_header = header;
            
            // footer refresh
            MJRefreshAutoGifFooter *footter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            footter.refreshingTitleHidden = YES;
            footter.stateLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
            footter.stateLabel.font = [UIFont fontWithName:@"DOUYU Font" size:12.0f];
            [footter setTitle:@"" forState:MJRefreshStateIdle];
            [footter setTitle:endStr forState:MJRefreshStateNoMoreData];
            [footter setImages:refreshingImages forState:MJRefreshStateRefreshing];
            [footter afterBeginningAction:^{
                UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [feedBackGenertor impactOccurred];
            }];
            _collectionView.mj_footer = footter;
        }
        
        _collectionView.scrollsToTop = YES;
    }
    return _collectionView;
}

#pragma mark - MJRefresh Methods
- (void)headerRereshing {
    self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:@"加载中..." reason:@"" suggestion:@"" placeholderImg:@"linkedin_binding_magnifier"];
}

- (void)footerRereshing {
    self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:@"加载中..." reason:@"" suggestion:@"" placeholderImg:@"linkedin_binding_magnifier"];
}

#pragma mark - UITableViewDataSource Methods
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *placeholderStr = self.emptyError.userInfo[@"NSLocalizedPlaceholderImageName"];
    if ([NYSTools stringIsNull:placeholderStr]) {
        return [UIImage imageNamed:@"error"];
    } else {
        return [UIImage imageNamed:placeholderStr];
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:self.emptyError.localizedDescription attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
                                 
    return [[NSAttributedString alloc] initWithString:self.emptyError.localizedFailureReason attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSMutableAttributedString *buttonAttStr = [[NSMutableAttributedString alloc] initWithString:self.emptyError.localizedRecoverySuggestion];
    buttonAttStr.font = [UIFont boldSystemFontOfSize:17];
    buttonAttStr.color = NAppThemeColor;
    buttonAttStr.underlineStyle = NSUnderlineStyleSingle;

    return buttonAttStr;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    UIEdgeInsets insets = scrollView.contentInset;
//    return (insets.top == 0.0f) ? -64.0f : 0.0f;
    return 0;
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    
    
    NSAssert(_tableView || _collectionView, @"请先实例化页面组件");
    
    if (_tableView) {
        if (self.tableView.mj_header) {
            [self.tableView.mj_header beginRefreshing];
        } else if (self.tableView.mj_footer) {
            [self.tableView.mj_footer beginRefreshing];
        } else {
            [NYSTools showBottomToast:@"没有实现TableView刷新方法"];
        }
    } else if (_collectionView) {
        if (self.collectionView.mj_header) {
            [self.collectionView.mj_header beginRefreshing];
        } else if (self.collectionView.mj_footer) {
            [self.collectionView.mj_footer beginRefreshing];
        } else {
            [NYSTools showBottomToast:@"没有实现CollectionView刷新方法"];
        }
    } else {
        self.emptyError = [NSError errorCode:NSNYSErrorCodefailed description:@"加载中..." reason:@"" suggestion:@"" placeholderImg:@"linkedin_binding_magnifier"];
    }
}

#pragma mark - seter/getter
- (void)setEmptyError:(NSError *)emptyError {
    _emptyError = emptyError;
    
    if (_tableView) {
        [self.tableView reloadEmptyDataSet];
    } else if (_collectionView) {
        [self.collectionView reloadEmptyDataSet];
    }
}

#pragma mark - 是否显示返回按钮
- (void)setIsShowLiftBack:(BOOL)isShowLiftBack {
    _isShowLiftBack = isShowLiftBack;
    
    NSInteger VCCount = self.navigationController.viewControllers.count;
    // 当VC所在的导航控制器栈中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil || self.tabBarController == nil)) {
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

#pragma mark - 页面提示信息
- (void)NYSShowMessage:(NSString *)msg {
    CGFloat padding = 10;
    
    YYLabel *label = [YYLabel new];
    label.text = msg;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [NAppThemeColor colorWithAlphaComponent:0.730];
    label.width = self.view.width;
    label.textContainerInset = UIEdgeInsetsMake(padding, padding, padding, padding);
    label.height = [msg heightForFont:label.font width:label.width] + 2 * padding;
    
    label.bottom = NTopHeight;
    [self.view addSubview:label];
    [UIView animateWithDuration:0.3 animations:^{
        label.top = NTopHeight;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.bottom = NTopHeight;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

#pragma mark - 页面固定提示信息
- (void)NYSShowFixMessage:(NSString *)msg tapBlock:(NYSAction)tapBlock {
    [self NYSShowFixMessage:msg style:NYSShowMessageStyleDefault tapBlock:tapBlock];
}

- (void)NYSShowFixMessage:(NSString *)msg style:(NYSShowMessageStyle)style tapBlock:(NYSAction)tapBlock {
    CGFloat padding = 10;
    CGFloat height = 40;
    CGFloat bgAlpha = 0.95f;
    BOOL isTableview = _tableView;
    BOOL isCollection = _collectionView;
    WS(weakSelf)
    
    UIColor *bgColor = [UIColor new];
    switch (style) {
        case NYSShowMessageStyleDefault:
            bgColor = [[UIColor colorWithHexString:@"#007bff"] colorWithAlphaComponent:bgAlpha];
            break;
            
        case NYSShowMessageStyleSecondary:
            bgColor = [[UIColor colorWithHexString:@"#6c757d"] colorWithAlphaComponent:bgAlpha];
            break;
            
        case NYSShowMessageStyleLight:
            bgColor = [[UIColor colorWithHexString:@"#f8f9fa"] colorWithAlphaComponent:bgAlpha];
            break;
            
        case NYSShowMessageStyleSuccess:
            bgColor = [[UIColor colorWithHexString:@"#28a745"] colorWithAlphaComponent:bgAlpha];
            break;
            
        case NYSShowMessageStyleInfo:
            bgColor = [[UIColor colorWithHexString:@"#17a2b8"] colorWithAlphaComponent:bgAlpha];
            break;
            
        case NYSShowMessageStyleWarning:
            bgColor = [[UIColor colorWithHexString:@"#FC3876"] colorWithAlphaComponent:bgAlpha];
            break;
            
        case NYSShowMessageStyleDanger:
            bgColor = [[UIColor colorWithHexString:@"#F56C6C"] colorWithAlphaComponent:bgAlpha];
            break;
            
        default:
            break;
    }
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, height)];
    bgview.backgroundColor = bgColor;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(padding, 0, height/2, height/2)];
    [icon setImage:[UIImage imageNamed:@"notice_icon_top"]];
    WSScrollLabel *label = [[WSScrollLabel alloc] initWithFrame:CGRectMake(height, 0, NScreenWidth-2*height, height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        tapBlock(sender);
    }];
    [label addGestureRecognizer:tap];
    label.text = msg;
    label.space = padding;
    label.textColor = [UIColor whiteColor];
    label.pauseTimeIntervalBeforeScroll = 0.7;
    label.textFont = [UIFont systemFontOfSize:16];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(NScreenWidth-height, 0, height, height)];
    [btn setImage:[UIImage imageNamed:@"close_icon_top"] forState:UIControlStateNormal];
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (isTableview) weakSelf.tableView.contentInset = UIEdgeInsetsMake(weakSelf.tableView.contentInset.top - height, 0, 0, 0);
            if (isCollection) weakSelf.collectionView.contentInset = UIEdgeInsetsMake(weakSelf.collectionView.contentInset.top - height, 0, 0, 0);
            
            bgview.bottom = NTopHeight;
        } completion:^(BOOL finished) {
            [bgview removeFromSuperview];
        }];
    }];
    
    [bgview sd_addSubviews:@[icon, label, btn]];
    [self.view addSubview:bgview];

    bgview.bottom = NTopHeight;
    icon.centerY = label.centerY;
 
    if (isTableview) {
        CGFloat top = self.tableView.contentInset.top;
        self.tableView.contentInset = UIEdgeInsetsMake(top + height, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
        if (self.tableView.contentOffset.y <= NTopHeight) {
            [self.tableView setContentOffset:CGPointMake(0, -NTopHeight-height) animated:YES];
        }
        
    } else if (isCollection) {
        CGFloat top = self.collectionView.contentInset.top;
        self.collectionView.contentInset = UIEdgeInsetsMake(top + height, 0, 0, 0);
        self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
        if (self.collectionView.contentOffset.y <= NTopHeight) {
            [self.collectionView setContentOffset:CGPointMake(0, -NTopHeight-height) animated:YES];
        }
        
    }
    [UIView animateWithDuration:0.3 animations:^{
        bgview.top = NTopHeight;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 设置主题
- (void)configTheme {
    if (CurrentSystemVersion < 13.0) {
    }
    self.view.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [feedBackGenertor impactOccurred];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - 控制器销毁
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NLog(@"%@", [NSString stringWithFormat:@"【控制器：%@】---> dealloc", NSStringFromClass(self.class)]);
}

@end
