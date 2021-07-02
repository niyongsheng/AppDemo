//
//  NYSHomeViewController.m
//  AppDemo
//
//  Created by 倪永胜 on 2020/9/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSHomeViewController.h"
#import "NYSConversationListViewController.h"
#import "NYSHomeModel.h"
#import "XRWaterfallLayout.h"

#import "NYSActivityCollectionViewCell.h"
#import "NYSJXCategoryViewController.h"

static float Magin = 15;
static NSInteger pageSize = 7;

@interface NYSHomeViewController ()
 <
UICollectionViewDelegate,
UICollectionViewDataSource,
XRWaterfallLayoutDelegate
>
@property (strong, nonatomic) NSMutableArray *collectionDataArray;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation NYSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Home"];
    
    [self initNavItem];
    [self initUI];
    [self.collectionView.mj_footer beginRefreshing];
}

#pragma mark — 初始化页面
- (void)initNavItem {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"notification_icon"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStyleDone target:self action:nil];
    WS(weakSelf);
    [rightItem setActionBlock:^(id _Nonnull sender) {
        NYSConversationListViewController *conversationListVC = [[NYSConversationListViewController alloc] init];
        [weakSelf.navigationController pushViewController:conversationListVC animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initUI {
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    }
    
    // 创建瀑布流布局
    XRWaterfallLayout *waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
    [waterfall setColumnSpacing:Magin rowSpacing:Magin sectionInset:UIEdgeInsetsMake(0, Magin, Magin, Magin)];
    waterfall.delegate = self;

    [self.collectionView setCollectionViewLayout:waterfall];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NYSActivityCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"NYSActivityCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.height = NScreenHeight;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, NTabBarHeight, 0);
//    self.collectionView.mj_header.ignoredScrollViewContentInsetTop = 20.0f;
//    self.collectionView.mj_header.isCollectionViewAnimationBug = YES;
    self.collectionView.mj_header = nil;
    [self.view addSubview:self.collectionView];
}

- (void)updateUI {
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.7f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)refreshActivityList:(NSNotification *)notification {
    [self headerRereshing];
}

- (NSMutableArray *)collectionDataArray {
    if (!_collectionDataArray) {
        _collectionDataArray = [NSMutableArray array];
    }
    return _collectionDataArray;
}

- (void)headerRereshing {
    self.pageNum = 1;
    NSArray *dictArr = @[
        @"{\"id\":2, \"name\":\"NsYSTK\", \"desc\":\"Lorem it amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqipsum dolor sit amet, consectetur adipisicing elit\", \"url\":\"https://github.com/niyongsheng/NYSTK\"}"
    ];
    
    // 模拟网络加载
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSString *json in dictArr) {
            [weakSelf.collectionDataArray insertObject:[NYSHomeModel modelWithJSON:json] atIndex:0];
        }
        [weakSelf.collectionView.mj_footer resetNoMoreData];
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_header endRefreshing];
    });
}

- (void)footerRereshing {
    self.pageNum ++;
    
    NSArray *dictArr = @[
        @"{\"id\":1, \"name\":\"sNYSTK\", \"desc\":\"NYSTK ios alert framework...\", \"url\":\"https://github.com/niyongsheng/NYSTK\"}",
        @"{\"id\":2, \"name\":\"NYSTK\", \"desc\":\"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\", \"url\":\"https://github.com/niyongsheng/NYSTK\"}",
        @"{\"id\":3, \"name\":\"hNYSTK\", \"desc\":\"NYSTK ios psum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqupsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqualert framework...\", \"url\":\"https://github.com/niyongsheng/NYSTK\"}",
        @"{\"id\":4, \"name\":\"wNYSTK\", \"desc\":\"NYSTK ios alert framework...\", \"url\":\"https://github.com/niyongsheng/NYSTK\"}",
        @"{\"id\":2, \"name\":\"NYSTK\", \"desc\":\"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\", \"url\":\"https://github.com/niyongsheng/NYSTK\"}",
        @"{\"id\":3, \"name\":\"hNYSTK\", \"desc\":\"NYSTK ios psum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqupsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqualert framework...\", \"url\":\"https://github.com/niyongsheng/NYSTK\"}",
        @"{\"id\":4, \"name\":\"wNYSTK\", \"desc\":\"NYSTK ios alert framework...\", \"url\":\"https://github.com/niyongsheng/NYSTK\"}"
    ];
    
    if (self.pageNum < pageSize) {
        WS(weakSelf);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (NSString *json in dictArr) {
                [weakSelf.collectionDataArray addObject:[NYSHomeModel modelWithJSON:json]];
            }
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_footer endRefreshing];
        });
    } else {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark — collection代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NYSActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NYSActivityCollectionViewCell" forIndexPath:indexPath];
    cell.collectionModel = self.collectionDataArray[indexPath.row];
    cell.fromViewController = self;
    [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self presentViewController:[NYSJXCategoryViewController new] animated:YES completion:^{
        
    }];
}

#pragma mark - XRWaterfallLayoutDelegate
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = itemWidth - 20 + [[self.collectionDataArray[indexPath.row] desc] heightForFont:[UIFont systemFontOfSize:11.f] width:itemWidth - 20];
    return itemHeight;
}

@end
