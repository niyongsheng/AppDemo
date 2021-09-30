//
//  NYSHomeViewController.m
//  AppDemo
//
//  Created by 倪永胜 on 2020/9/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSHomeViewController.h"
#import "NYSSlideViewController.h"
#import <UIViewController+CWLateralSlide.h>
#import <WMZBannerView.h>

#import "NYSHomeModel.h"
#import "NYSTitleButton.h"
#import "NYSBannerCell.h"
#import "NYSBillboardCell.h"
#import "NYSBusinessCell.h"
#import "NYSVoteCell.h"
#import "NYSTopicCell.h"
#import "NYSNewsTableViewCell.h"

#import "NYSConversationListViewController.h"
#import "NYSJXCategoryViewController.h"

#define HomeBannerHeight RealValue(180)
#define HomeBillboardHeight RealValue(70)
#define HomeBusinessHeight RealValue(100)
#define HomeVoteHeight RealValue(210)
#define HomeTopicHeight RealValue(200)

#define MoreTextColor @"#2B2B2B"
#define HomeSpace NNormalSpace - RealValue(5.0f)

@interface NYSHomeViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate
>
@property (strong, nonatomic) NYSSlideViewController *slideVC;

@property (nonatomic, strong) WMZBannerParam *bannerParam;
@property (nonatomic, strong) WMZBannerParam *billboardParam;
@property (nonatomic, strong) WMZBannerParam *businessParam;
@property (nonatomic, strong) WMZBannerParam *voteParam;
@property (nonatomic, strong) WMZBannerParam *topicParam;

@property (nonatomic, strong) WMZBannerView *bannerView;
@property (nonatomic, strong) WMZBannerView *billboardView;
@property (nonatomic, strong) WMZBannerView *businessView;
@property (nonatomic, strong) WMZBannerView *voteView;
@property (nonatomic, strong) WMZBannerView *topicView;

@property (nonatomic, strong) UIView *bannerContainerView;
@property (nonatomic, strong) UIView *billboardContainerView;
@property (nonatomic, strong) UIView *businessContainerView;
@property (nonatomic, strong) UIView *voteContainerView;
@property (nonatomic, strong) UIView *topicContainerView;
@property (nonatomic, strong) UIView *newsHeaderContainerView;

@property (nonatomic, strong) NYSHomeModel *homeModel;
@property (nonatomic, strong) NSArray<NYSBannerModel *> *bannerArray;
@property (nonatomic, strong) NSArray<NYSBillboardModel *> *billboardArray;
@property (nonatomic, strong) NSArray<NYSBusinessModel *> *businessArray;
@property (nonatomic, strong) NSArray<NYSVoteModel *> *voteArray;
@property (nonatomic, strong) NSMutableArray<NYSTopicModel *> *topicMArray;
/// 新闻数据源
@property (nonatomic, strong) NSMutableArray<NYSNewsModel *> *newsDataSourceMArray;

/** Tabbar联动相关 */
@property (nonatomic, assign) BOOL tabAnimateOnceScrollFlag;
@property (nonatomic, assign) CGFloat lastPositionOffestY;

@end

@implementation NYSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavItem];
    [self initUI];
    [self.tableView.mj_footer beginRefreshing];
    
    WS(weakSelf)
    [[NNotificationCenter rac_addObserverForName:@"kPushDownAnimationScrollTopNotification" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }];
}

- (void)configTheme {
    [super configTheme];
    _tableviewStyle = UITableViewStylePlain;
    self.isUseUIRefreshControl = YES;
}

#pragma mark — 初始化导航栏
- (void)initNavItem {
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = NO;
        self.navigationController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"notification_icon"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStyleDone target:self action:nil];
    WS(weakSelf);
    [rightItem setActionBlock:^(id _Nonnull sender) {
        NYSConversationListViewController *conversationListVC = [[NYSConversationListViewController alloc] init];
        [weakSelf.navigationController pushViewController:conversationListVC animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"person_24_regular"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStyleDone target:self action:nil];
    [leftItem setActionBlock:^(id _Nonnull sender) {
        [weakSelf cw_showDefaultDrawerViewController:weakSelf.slideVC];
    }];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self cw_registerShowIntractiveWithEdgeGesture:YES transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        if (direction == CWDrawerTransitionFromLeft) {
            [weakSelf cw_showDefaultDrawerViewController:weakSelf.slideVC];
        }
    }];
}

#pragma mark — 初始化页面
- (void)initUI {
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = nil;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, NScreenWidth, NScreenHeight);
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView.mj_header beginRefreshing];
    
    UIView *headerView = [UIView new];
    headerView.width = NScreenWidth;
    self.tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, 80)];
    self.tableView.tableFooterView = footerView;
    
    YYLabel *infoLabel = [[YYLabel alloc] initWithFrame:footerView.bounds];
    infoLabel.numberOfLines = 0;
    infoLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
    NSString *tel = @"400-0000-0000";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [[UIApplication  sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:tel]] options:@{} completionHandler:nil];
    }];
    infoLabel.userInteractionEnabled = YES;
    [infoLabel addGestureRecognizer:tap];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"客服电话\n%@", tel]];
    attr.color = [LEETheme getValueWithTag:[LEETheme currentThemeTag] Identifier:@"common_font_color_1"];
    attr.lineSpacing = 5;
    attr.alignment = NSTextAlignmentCenter;
    attr.kern = [NSNumber numberWithFloat:1.0];
    attr.font = [UIFont fontWithName:@"DOUYU Font" size:12.0f];
    infoLabel.attributedText = attr;
    [footerView addSubview:infoLabel];

    // 轮播
    self.bannerContainerView = [UIView new];
    self.bannerContainerView.hidden = !self.bannerArray.count;
    [headerView addSubview:self.bannerContainerView];
    self.bannerView = [[WMZBannerView alloc] initConfigureWithModel:self.bannerParam withView:self.bannerContainerView];
    
    // 公告
    self.billboardContainerView = [UIView new];
    self.billboardContainerView.hidden = !self.billboardArray.count;
    self.billboardContainerView.layer.cornerRadius = NRadius;
    [headerView addSubview:self.billboardContainerView];
    
    UIView *spaceLine = [UIView new];
    spaceLine.backgroundColor = [UIColor colorWithHexString:@"#E2E0E0"];
    [_billboardContainerView addSubview:spaceLine];
    
    UIImageView *arrowImageV = [UIImageView new];
    arrowImageV.lee_theme.LeeAddImage(DAY, [[UIImage imageNamed:@"open_info"] imageByTintColor:[UIColor colorWithHexString:MoreTextColor]]);
    arrowImageV.lee_theme.LeeAddImage(NIGHT, [[UIImage imageNamed:@"open_info"] imageByTintColor:[UIColor whiteColor]]);
    [_billboardContainerView addSubview:arrowImageV];
    UIImageView *carouselImageView = [UIImageView new];
    [carouselImageView setImage:[[UIImage imageNamed:@"zuixingonggao"] imageByTintColor:NAppThemeColor]];
    [_billboardContainerView addSubview:carouselImageView];
    self.billboardView = [[WMZBannerView alloc] initConfigureWithModel:self.billboardParam withView:self.billboardContainerView];
    
    UIView *separator = [UIView new];
    separator.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
    [headerView addSubview:separator];
    
    // 业务
    self.businessContainerView = [UIView new];
    self.businessContainerView.hidden = !self.businessArray.count;
    self.businessContainerView.layer.cornerRadius = NRadius;
    [headerView addSubview:self.businessContainerView];
    self.businessView = [[WMZBannerView alloc] initConfigureWithModel:self.businessParam withView:self.businessContainerView];
    
    // 投票
    self.voteContainerView = [UIView new];
    self.voteContainerView.hidden = !self.voteArray.count;
    self.voteContainerView.layer.cornerRadius = NRadius;
    [headerView addSubview:self.voteContainerView];
    UILabel *voteTitle = [UILabel new];
    voteTitle.text = @"投票";
    voteTitle.font = [UIFont boldSystemFontOfSize:18.f];
    voteTitle.lee_theme.LeeConfigTextColor(@"common_font_color_0");
    [_voteContainerView addSubview:voteTitle];
    
    NYSTitleButton *voteMoreBtn = [NYSTitleButton new];
    voteMoreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [voteMoreBtn setTitle:@"更多" forState:UIControlStateNormal];
    voteMoreBtn.lee_theme.LeeConfigButtonTitleColor(@"common_font_color_0", UIControlStateNormal);
    voteMoreBtn.lee_theme.LeeAddButtonImage(DAY, [[UIImage imageNamed:@"open_info"] imageChangeColor:[UIColor colorWithHexString:MoreTextColor]], UIControlStateNormal);
    voteMoreBtn.lee_theme.LeeAddButtonImage(NIGHT, [[UIImage imageNamed:@"open_info"] imageChangeColor:[UIColor whiteColor]], UIControlStateNormal);
    [voteMoreBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController pushViewController:[NYSBaseViewController new] animated:YES];
    }];
    [_voteContainerView addSubview:voteMoreBtn];
    
    self.voteView = [[WMZBannerView alloc] initConfigureWithModel:self.voteParam withView:_voteContainerView];
    
    // 话题
    self.topicContainerView = [UIView new];
    self.topicContainerView.hidden = !self.topicMArray.count;
    self.topicContainerView.layer.cornerRadius = NRadius;
    [headerView addSubview:self.topicContainerView];
    UILabel *topicTitle = [UILabel new];
    topicTitle.text = @"话题";
    topicTitle.font = [UIFont boldSystemFontOfSize:18.f];
    topicTitle.lee_theme.LeeConfigTextColor(@"common_font_color_0");
    [_topicContainerView addSubview:topicTitle];
    
    NYSTitleButton *topicMoreBtn = [NYSTitleButton new];
    topicMoreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [topicMoreBtn setTitle:@"更多" forState:UIControlStateNormal];
    topicMoreBtn.lee_theme.LeeConfigButtonTitleColor(@"common_font_color_0", UIControlStateNormal);
    topicMoreBtn.lee_theme.LeeAddButtonImage(DAY, [[UIImage imageNamed:@"open_info"] imageChangeColor:[UIColor colorWithHexString:MoreTextColor]], UIControlStateNormal);
    topicMoreBtn.lee_theme.LeeAddButtonImage(NIGHT, [[UIImage imageNamed:@"open_info"] imageChangeColor:[UIColor whiteColor]], UIControlStateNormal);
    [topicMoreBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController pushViewController:[NYSBaseViewController new] animated:YES];
    }];
    [_topicContainerView addSubview:topicMoreBtn];
    
    self.topicView = [[WMZBannerView alloc] initConfigureWithModel:self.topicParam withView:_topicContainerView];
    
#ifdef NAppRoundStyle
    headerView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
    footerView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
    
    _bannerContainerView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
    _billboardContainerView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    _businessContainerView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    _voteContainerView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    _topicContainerView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
#else
    headerView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    footerView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
#endif
    
#pragma mark - sd_autolayout
    // 轮播
    self.bannerContainerView.sd_layout
    .topSpaceToView(headerView, NNormalSpace)
    .centerXEqualToView(headerView)
    .widthIs(NScreenWidth)
    .heightIs(self.bannerArray.count ? HomeBannerHeight : 0);
    
    self.bannerView.sd_layout
    .topSpaceToView(_bannerContainerView, 0)
    .centerXEqualToView(_bannerContainerView);

    // 公告
    self.billboardContainerView.sd_layout
    .topSpaceToView(_bannerContainerView, NNormalSpace)
    .centerXEqualToView(headerView)
    .widthIs(NScreenWidth - 2*HomeSpace)
    .heightIs(self.billboardArray.count ? HomeBillboardHeight : 0);
    
    carouselImageView.sd_layout
    .centerYEqualToView(_billboardContainerView)
    .xIs(NNormalSpace)
    .heightIs(RealValue(35))
    .widthIs(RealValue(35));
    
    spaceLine.sd_layout
    .widthIs(1)
    .heightIs(30)
    .centerYEqualToView(carouselImageView)
    .leftSpaceToView(carouselImageView, HomeSpace);
    
    self.billboardView.sd_layout
    .centerYEqualToView(carouselImageView)
    .leftSpaceToView(spaceLine, 5);
    
    arrowImageV.sd_layout
    .widthIs(7)
    .heightIs(12)
    .rightSpaceToView(_billboardContainerView, HomeSpace)
    .centerYEqualToView(carouselImageView);
    
    separator.sd_layout
    .widthIs(NScreenWidth)
    .heightIs(NNormalSpace)
    .topSpaceToView(_billboardContainerView, 0);
    
    // 业务
    self.businessContainerView.sd_layout
    .topSpaceToView(_billboardContainerView, NNormalSpace)
    .centerXEqualToView(headerView)
    .widthIs(NScreenWidth - 2*HomeSpace)
    .heightIs(self.businessArray.count ? HomeBusinessHeight : 0);
    
    self.businessView.sd_layout
    .centerYEqualToView(_businessContainerView)
    .centerXEqualToView(headerView);
    
    // 投票
    self.voteContainerView.sd_layout
    .topSpaceToView(_businessContainerView, NNormalSpace)
    .centerXEqualToView(headerView)
    .widthIs(NScreenWidth - 2*HomeSpace)
    .heightIs(self.voteArray.count ? HomeVoteHeight : 0);
    
    voteTitle.sd_layout
    .widthIs(100)
    .autoHeightRatio(0)
    .leftSpaceToView(_voteContainerView, HomeSpace)
    .topSpaceToView(_voteContainerView, NNormalSpace);
    
    voteMoreBtn.sd_layout
    .widthIs(45)
    .heightIs(15)
    .centerYEqualToView(voteTitle)
    .rightSpaceToView(_voteContainerView, HomeSpace);
    
    self.voteView.sd_layout
    .topSpaceToView(voteTitle, NNormalSpace)
    .centerXEqualToView(headerView);
    
    // 话题
    self.topicContainerView.sd_layout
    .topSpaceToView(_voteContainerView, NNormalSpace)
    .centerXEqualToView(headerView)
    .widthIs(NScreenWidth - 2*HomeSpace)
    .heightIs(self.topicMArray.count ? HomeTopicHeight : 0);
    
    topicTitle.sd_layout
    .widthIs(100)
    .autoHeightRatio(0)
    .leftSpaceToView(_topicContainerView, HomeSpace)
    .topSpaceToView(_topicContainerView, NNormalSpace);
    
    topicMoreBtn.sd_layout
    .widthIs(45)
    .heightIs(15)
    .centerYEqualToView(topicTitle)
    .rightSpaceToView(_topicContainerView, HomeSpace);
    
    self.topicView.sd_layout
    .topSpaceToView(topicTitle, NNormalSpace)
    .centerXEqualToView(headerView);
    
    // 自动高度
    [headerView setupAutoHeightWithBottomView:_topicContainerView bottomMargin:NNormalSpace];
    [headerView layoutSubviews];
}

- (void)updateUI {
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.7f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)headerRereshing {
    [super headerRereshing];
    WS(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.refreshControl endRefreshing];
    });
}

#pragma mark — tableviewdDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsDataSourceMArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RealValue(100);
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return self.newsDataSourceMArray.count ? RealValue(40) : 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(tintColor)]) {
        
        if (tableView == self.tableView) {
            CGFloat cornerRadius = NRadius;
            
            cell.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 10, 0);
            
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
            }
            
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.lee_theme.LeeConfigFillColor(@"common_bg_color_1");
            
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
        static NSString *ID = @"NYSNewsTableViewCell";
        NYSNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NYSNewsTableViewCell" owner:self options:nil] firstObject];
        }
        cell.newsModel = self.newsDataSourceMArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
        return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 新闻
    self.newsHeaderContainerView = [UIView new];
    _newsHeaderContainerView.layer.cornerRadius = NRadius;
    _newsHeaderContainerView.hidden = !self.newsDataSourceMArray.count;
    _newsHeaderContainerView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    UILabel *newsTitle = [UILabel new];
    newsTitle.text = @"新闻";
    newsTitle.font = [UIFont boldSystemFontOfSize:18.f];
    newsTitle.lee_theme.LeeConfigTextColor(@"common_font_color_0");
    [_newsHeaderContainerView addSubview:newsTitle];
    
    NYSTitleButton *newsMoreBtn = [NYSTitleButton new];
    newsMoreBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    [newsMoreBtn setTitle:@"更多" forState:UIControlStateNormal];
    newsMoreBtn.lee_theme.LeeConfigButtonTitleColor(@"common_font_color_0", UIControlStateNormal);
    newsMoreBtn.lee_theme.LeeAddButtonImage(DAY, [[UIImage imageNamed:@"open_info"] imageChangeColor:[UIColor colorWithHexString:MoreTextColor]], UIControlStateNormal);
    newsMoreBtn.lee_theme.LeeAddButtonImage(NIGHT, [[UIImage imageNamed:@"open_info"] imageChangeColor:[UIColor whiteColor]], UIControlStateNormal);
    [newsMoreBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.navigationController pushViewController:[NYSBaseViewController new] animated:YES];
    }];
    [_newsHeaderContainerView addSubview:newsMoreBtn];
    
    newsTitle.sd_layout
    .widthIs(100)
    .autoHeightRatio(0)
    .leftSpaceToView(_newsHeaderContainerView, 2*HomeSpace)
    .centerYEqualToView(_newsHeaderContainerView);
    
    newsMoreBtn.sd_layout
    .widthIs(45)
    .heightIs(15)
    .centerYEqualToView(newsTitle)
    .rightSpaceToView(_newsHeaderContainerView, 2*HomeSpace);
    
    return self.newsHeaderContainerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NYSNewsViewController *newsVC = [NYSNewsViewController new];
//    newsVC.newsId = [self.dataSourceArray[indexPath.row] idField];
//    [self.navigationController pushViewController:newsVC animated:YES];
}

#pragma mark - lazzy load
- (NSArray<NYSBannerModel *> *)bannerArray {
    if (!_bannerArray) {
        NYSBannerModel *banner = [NYSBannerModel modelWithDictionary:@{}];
        banner.mediaLink = @"";
        _bannerArray = @[banner, banner];
    }
    return _bannerArray;
}

- (NSArray<NYSBillboardModel *> *)billboardArray {
    if (!_billboardArray) {
        NYSBillboardModel *billboard = [NYSBillboardModel new];
        billboard.title = @"app demo";
        billboard.richContent = @"App Demo 1.0.0 Release^^";
        billboard.targetLink = @"https://appdemo.com/";
        _billboardArray = @[billboard, billboard];
    }
    return _billboardArray;
}

- (NSArray<NYSBusinessModel *> *)businessArray {
    if (!_businessArray) {
        NYSBusinessModel *business0 = [NYSBusinessModel modelWithDictionary:@{@"defaultIconName": @"business_icon_0", @"title": @"Iteme 1"}];
        NYSBusinessModel *business1 = [NYSBusinessModel modelWithDictionary:@{@"defaultIconName": @"business_icon_1", @"title": @"Iteme 2"}];
        NYSBusinessModel *business2 = [NYSBusinessModel modelWithDictionary:@{@"defaultIconName": @"business_icon_2", @"title": @"Iteme 3"}];
        NYSBusinessModel *business3 = [NYSBusinessModel modelWithDictionary:@{@"defaultIconName": @"business_icon_3", @"title": @"Iteme 4"}];
        NYSBusinessModel *business4 = [NYSBusinessModel modelWithDictionary:@{@"defaultIconName": @"business_icon_1", @"title": @"Iteme 5"}];
        _businessArray = @[business0, business1, business2, business3, business4];
    }
    return _businessArray;
}

- (NSArray<NYSVoteModel *> *)voteArray {
    if (!_voteArray) {
        NYSVoteModel *vote = [NYSVoteModel modelWithDictionary:@{}];
        _voteArray = @[vote, vote];
    }
    return _voteArray;
}

- (NSMutableArray<NYSTopicModel *> *)topicMArray {
    if (!_topicMArray) {
        NYSTopicModel *topic1 = [NYSTopicModel modelWithDictionary:@{}];
        NYSTopicModel *topic2 = [NYSTopicModel modelWithDictionary:@{}];
        NYSTopicModel *topic3 = [NYSTopicModel modelWithDictionary:@{}];
        _topicMArray = @[topic1, topic2, topic3].mutableCopy;
    }
    return _topicMArray;
}

- (NSMutableArray<NYSNewsModel *> *)newsDataSourceMArray {
    if (!_newsDataSourceMArray) {
        NYSNewsModel *news = [NYSNewsModel modelWithDictionary:@{}];
        _newsDataSourceMArray = @[news, news, news, news, news, news, news, news].mutableCopy;
    }
    return _newsDataSourceMArray;
}

- (WMZBannerParam *)bannerParam {
    if (!_bannerParam) {
        _bannerParam = BannerParam()
        .wMyCellClassNameSet(@"NYSBannerCell")
        .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView, NSArray *dataArr) {
            NYSBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NYSBannerCell class]) forIndexPath:indexPath];
            cell.bannerModel = model;
            return cell;
        })
        .wEventClickSet(^(id anyID, NSInteger index) {
            
        })
        .wFrameSet(CGRectMake(0, 0, NScreenWidth, HomeBannerHeight))
        .wItemSizeSet(CGSizeMake(NScreenWidth*0.85, HomeBannerHeight))
        .wScaleFactorSet(0.15f)
        .wScaleSet(YES)
        .wLineSpacingSet(NNormalSpace)
        .wRepeatSet(YES)
        .wAutoScrollSet(YES)
        .wAutoScrollSecondSet(5.0f)
        .wHideBannerControlSet(YES)
        .wDataSet(self.bannerArray);
    }
    return _bannerParam;
}

- (WMZBannerParam *)billboardParam {
    if (!_billboardParam) {
        _billboardParam = BannerParam()
        .wFrameSet(CGRectMake(0, 0, RealValue(280), RealValue(40)))
        .wMyCellClassNameSet(@"NYSBillboardCell")
        .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView,NSArray*dataArr) {
            NYSBillboardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NYSBillboardCell class]) forIndexPath:indexPath];
            cell.billboardModel = model;
            return cell;
        })
        .wCanFingerSlidingSet(YES)
        .wVerticalSet(YES)
        .wMarqueeSet(YES)
        .wMarqueeRateSet(0.2f)
        .wDataSet(self.billboardArray);
    }
    return _billboardParam;
}

- (WMZBannerParam *)businessParam {
    if (!_businessParam) {
        _businessParam = BannerParam()
        .wMyCellClassNameSet(@"NYSBusinessCell")
        .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView ,NSArray*dataArr) {
            NYSBusinessCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NYSBusinessCell class]) forIndexPath:indexPath];
            cell.businessModel = model;
            return cell;
        })
        .wEventClickSet(^(id anyID, NSInteger index) {
            [self NYSShowFixMessage:@"kPushDownAnimatiokPushDownAnimationScrollTopNotificationnScrollTopNotification" style:NYSShowMessageStyleDanger tapBlock:^(id  _Nullable obj) {
                
            }];
        })
        .wFrameSet(CGRectMake(0, 0, NScreenWidth, HomeBusinessHeight))
        .wItemSizeSet(CGSizeMake((NScreenWidth-2*NNormalSpace)/4, HomeBusinessHeight))
        .wSectionInsetSet(UIEdgeInsetsMake(0, 0, 0, 0))
        .wLineSpacingSet(0)
        .wHideBannerControlSet(YES)
        .wDataSet(self.businessArray);
    }
    return _businessParam;
}

- (WMZBannerParam *)voteParam {
    WS(weakSelf)
    if (!_voteParam) {
        _voteParam = BannerParam()
        .wMyCellClassNameSet(@"NYSVoteCell")
        .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView ,NSArray*dataArr) {
            NYSVoteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NYSVoteCell class]) forIndexPath:indexPath];
            cell.voteModel = self.voteArray[indexPath.row];
            return cell;
        })
        .wEventClickSet(^(id anyID, NSInteger index) {
            [weakSelf presentViewController:[NYSJXCategoryViewController new] animated:YES completion:^{
                
            }];
        })
        .wFrameSet(CGRectMake(0, 0, NScreenWidth, RealValue(150)))
        .wItemSizeSet(CGSizeMake(NScreenWidth-NNormalSpace*2, RealValue(150)))
        .wSectionInsetSet(UIEdgeInsetsMake(0, 0, 0, NNormalSpace*2))
        .wLineSpacingSet(0)
        .wHideBannerControlSet(YES)
        .wDataSet(self.voteArray);
    }
    return _voteParam;
}

- (WMZBannerParam *)topicParam {
    if (!_topicParam) {
        _topicParam = BannerParam()
        .wMyCellClassNameSet(@"NYSTopicCell")
        .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView ,NSArray*dataArr) {
            NYSTopicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NYSTopicCell class]) forIndexPath:indexPath];
            cell.topicModel = model;
            return cell;
        })
        .wEventClickSet(^(id anyID, NSInteger index) {
            
        })
        .wFrameSet(CGRectMake(0, 0, NScreenWidth, RealValue(145)))
        .wItemSizeSet(CGSizeMake(RealValue(200), RealValue(145)))
        .wSectionInsetSet(UIEdgeInsetsMake(0, 0, 0, NNormalSpace*2))
        .wLineSpacingSet(0)
        .wHideBannerControlSet(YES)
        .wDataSet(self.topicMArray);
    }
    return _topicParam;
}

#pragma mark - Getter
- (NYSSlideViewController *)slideVC {
    if (!_slideVC) {
        _slideVC = [NYSSlideViewController new];
    }
    return _slideVC;
}

#pragma mark ----------- scrollviewDelegate -------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual: self.tableView]) {
        CGFloat currentPostionOffsetY = scrollView.contentOffset.y;
        if (currentPostionOffsetY > self.lastPositionOffestY) { // 上滑
            if (self.tabAnimateOnceScrollFlag) {
                // 上一次lastPositionOffestY<300.f, 且currentPostionOffsetY>300.f
                if ((self.lastPositionOffestY < 300.f) && (currentPostionOffsetY > 300.f)) {
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate.tabBarVC pushHomeTabBarAnimationType:anmationDirectionUp];
                    self.tabAnimateOnceScrollFlag = NO;
                }
            }
        } else {
            if (self.tabAnimateOnceScrollFlag) {
                if ((self.lastPositionOffestY >= 300.f) && (currentPostionOffsetY < 300.f)) {
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDelegate.tabBarVC pushHomeTabBarAnimationType:anmationDirectionDown];
                    self.tabAnimateOnceScrollFlag = NO;
                }
            }
            
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView]) {
        self.tabAnimateOnceScrollFlag = YES;
        self.lastPositionOffestY = scrollView.contentOffset.y;
    }
}

- (void)dealloc {
    
}

@end
