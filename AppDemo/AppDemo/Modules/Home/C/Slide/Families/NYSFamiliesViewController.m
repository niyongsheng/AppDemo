//
//  NYSFamiliesViewController.m
//  NYS
//
//  Created by niyongsheng on 2021/8/13.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSFamiliesViewController.h"
#import <SGPagingView/SGPagingView.h>

#import "NYSScanQRViewController.h"
#import "NYSInviteViewController.h"
#import "NYSFamilyListViewController.h"

@interface NYSFamiliesViewController ()
<
SGPageTitleViewDelegate,
SGPageContentCollectionViewDelegate
>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;

@end

@implementation NYSFamiliesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0.导航栏
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"cm8_nav_icn_scan"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStyleDone target:self action:nil];
    WS(weakSelf)
    [rightItem setActionBlock:^(id _Nonnull sender) {
        NYSScanQRViewController *scanQRVC = [NYSScanQRViewController new];
        scanQRVC.title = @"邀请码";
        [weakSelf.navigationController pushViewController:scanQRVC animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 1.分页栏配置
    NSArray *titleArr = @[@"邀请", @"记录"];
    SGPageTitleViewConfigure *segmentConfigure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    segmentConfigure.indicatorStyle = SGIndicatorStyleCover;
    segmentConfigure.indicatorColor = NAppThemeColor;
    segmentConfigure.titleFont = [UIFont boldSystemFontOfSize:15];
    segmentConfigure.titleColor = NAppThemeColor;
    segmentConfigure.titleSelectedColor = [UIColor whiteColor];
    segmentConfigure.indicatorHeight = 30;
    segmentConfigure.indicatorAdditionalWidth = 120;
    
    // 2.分页栏view
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, NScreenWidth*0.5, 30) delegate:self titleNames:titleArr configure:segmentConfigure];
    _pageTitleView.layer.borderWidth = 1;
    _pageTitleView.layer.borderColor = [NAppThemeColor CGColor];
    _pageTitleView.layer.cornerRadius = 3;
    _pageTitleView.layer.masksToBounds = YES;
    self.pageTitleView.backgroundColor = [UIColor clearColor];

    self.navigationItem.titleView = _pageTitleView;
    
    // 3.分页控制器
    NSArray *childArr = @[[[NYSInviteViewController alloc] init],
                          [[NYSFamilyListViewController alloc] init],
    ];
    self.pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, NScreenHeight) parentVC:self childVCs:childArr];
    self.pageContentCollectionView.isAnimated = YES;
    self.pageContentCollectionView.isScrollEnabled = NO;
    self.pageContentCollectionView.delegatePageContentCollectionView = self;
    [self.view addSubview:_pageContentCollectionView];
}

#pragma mark - SGPageTitleViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentCollectionView setPageContentCollectionViewCurrentIndex:selectedIndex];
}

#pragma mark - SGPageContentCollectionViewDelegate
- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}
@end
