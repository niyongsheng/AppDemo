//
//  NYSSquareCollectionVC.m
//  NYS
//
//  Created by niyongsheng on 2021/8/6.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSSquareCollectionVC.h"
#import "NYSHomeModel.h"
#import "XRWaterfallLayout.h"
#import "NYSActivityCollectionViewCell.h"

static float Magin = 15;
static NSInteger pageSize = 7;

@interface NYSSquareCollectionVC ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
XRWaterfallLayoutDelegate
>
@property (strong, nonatomic) NSMutableArray *collectionDataArray;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation NYSSquareCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
//    [self.collectionView.mj_footer beginRefreshing];
}

#pragma mark — 初始化页面
- (void)initNav {
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = NO;
        self.navigationController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
}

- (void)initUI {
    
    // 创建瀑布流布局
    XRWaterfallLayout *waterfall = [XRWaterfallLayout waterFallLayoutWithColumnCount:2];
    [waterfall setColumnSpacing:Magin rowSpacing:Magin sectionInset:UIEdgeInsetsMake(0, Magin, Magin, Magin)];
    waterfall.delegate = self;

    [self.collectionView setCollectionViewLayout:waterfall];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NYSActivityCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"NYSActivityCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.frame = CGRectMake(0, 0, NScreenWidth, NScreenHeight);
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

//    self.collectionView.mj_header.ignoredScrollViewContentInsetTop = 20.0f;
//    self.collectionView.mj_header.isCollectionViewAnimationBug = YES;
    self.collectionView.mj_header = nil;
    self.collectionView.refreshControl = nil;
    [self.view addSubview:self.collectionView];
}

- (void)updateUI {
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.7f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (NSMutableArray *)collectionDataArray {
    if (!_collectionDataArray) {
        _collectionDataArray = [NSMutableArray array];
    }
    return _collectionDataArray;
}

- (void)headerRereshing {
    [super headerRereshing];
    self.pageNum = 1;
    NSArray *dictArr = @[
        @"{\"id\":2, \"name\":\"NsYSTK\", \"desc\":\"Lorem it amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqipsum dolor sit amet, consectetur adipisicing elit\", \"url\":\"https://github.com/niyongsheng/NYSTK\"}"
    ];
    
    // 模拟网络加载
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSString *json in dictArr) {
            [weakSelf.collectionDataArray insertObject:[NYSHomeModel modelWithJSON:json] atIndex:0];
        }
        [weakSelf.collectionView.mj_footer resetNoMoreData];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView reloadData];
    });
}

- (void)footerRereshing {
    [super footerRereshing];
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

#pragma mark — UICollectionViewDataSource
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

#pragma mark - XRWaterfallLayoutDelegate
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemHeight = itemWidth - 20 + [[self.collectionDataArray[indexPath.row] desc] heightForFont:[UIFont systemFontOfSize:11.f] width:itemWidth - 20];
    return itemHeight;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self NYSShowFixMessage:@"kPushDownAnimatiokPushDownAnimationScrollTopNotificationnScrollTopNotification" style:NYSShowMessageStyleInfo tapBlock:^(id  _Nullable obj) {
        
    }];
}

@end
