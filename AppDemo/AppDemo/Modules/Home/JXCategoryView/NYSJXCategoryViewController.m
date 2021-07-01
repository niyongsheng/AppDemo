//
//  NYSJXCategoryViewController.m
//  AppDemo
//
//  Created by 倪永胜 on 2020/9/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSJXCategoryViewController.h"
#import <JXCategoryTitleView.h>
#import <JXCategoryListContainerView.h>
#import <JXCategoryIndicatorImageView.h>
#import "NYSJXCategoryItemViewController.h"

@interface NYSJXCategoryViewController () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *myCategoryView;
@property (nonatomic, strong) UIImageView *bgSelectedImageView;
@property (nonatomic, strong) UIImageView *bgUnselectedImageView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) JXCategoryBaseView *categoryView;

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, assign) BOOL isNeedIndicatorPositionChangeItem;

- (JXCategoryBaseView *)preferredCategoryView;

- (CGFloat)preferredCategoryViewHeight;

@end

@implementation NYSJXCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScreenEdgePanGestureRecognizer *gobackRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(closeBtnClicked:)];
    gobackRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:gobackRecognizer];
    
    [self.view addSubview:self.listContainerView];

    self.categoryView.listContainer = self.listContainerView;
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    
    self.titles = @[@"荷花", @"河流", @"海洋", @"城市"];
    self.isNeedIndicatorPositionChangeItem = YES;
    self.categoryView.frame = CGRectMake(30, 20, NScreenWidth - 30*2, 60);
    self.myCategoryView.titles = self.titles;
    self.myCategoryView.titleColor = [UIColor whiteColor];
    self.myCategoryView.titleSelectedColor = NAppThemeColor;
    self.myCategoryView.titleColorGradientEnabled = YES;
    self.myCategoryView.titleLabelZoomEnabled = YES;

    JXCategoryIndicatorImageView *indicatorImageView = [[JXCategoryIndicatorImageView alloc] init];
    indicatorImageView.indicatorImageView.image = [UIImage imageNamed:@"boat"];
    self.myCategoryView.indicators = @[indicatorImageView];

    CGRect bgImageViewFrame = CGRectMake(0, 0, NScreenWidth, 100);
    _bgSelectedImageView = [[UIImageView alloc] initWithFrame:bgImageViewFrame];
    self.bgSelectedImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgSelectedImageView.image = [self getImageWithIndex:0];
    [self.view addSubview:self.bgSelectedImageView];

    _bgUnselectedImageView = [[UIImageView alloc] initWithFrame:bgImageViewFrame];
    self.bgUnselectedImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgUnselectedImageView.image = [self getImageWithIndex:1];
    [self.view addSubview:self.bgUnselectedImageView];

    [self.view sendSubviewToBack:self.bgSelectedImageView];
    [self.view sendSubviewToBack:self.bgUnselectedImageView];
}

- (void)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.categoryView.frame = CGRectMake(30, 20, NScreenWidth - 30*2, 60);
    self.listContainerView.frame = CGRectMake(0, [self preferredCategoryViewHeight], self.view.bounds.size.width, self.view.bounds.size.height);
}

- (JXCategoryTitleView *)myCategoryView {
    return (JXCategoryTitleView *)self.categoryView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}

//- (CGFloat)preferredCategoryViewHeight {
//    return 100;
//}

- (UIImage *)getImageWithIndex:(NSInteger)index {
    NSArray <UIImage *> *images = @[[UIImage imageNamed:@"lotus"],
                        [UIImage imageNamed:@"river"],
                        [UIImage imageNamed:@"seaWave"],
                        [UIImage imageNamed:@"city"]];
    return images[index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    if (self.categoryView.selectedIndex == leftIndex) {
        //从左往右滑动
        self.bgUnselectedImageView.image = [self getImageWithIndex:rightIndex];
        self.bgSelectedImageView.alpha = 1 - ratio;
        self.bgUnselectedImageView.alpha = ratio;
    }else {
        //从右往左滑动
        self.bgUnselectedImageView.image = [self getImageWithIndex:leftIndex];
        self.bgSelectedImageView.alpha = ratio;
        self.bgUnselectedImageView.alpha = 1 - ratio;
    }
}

//- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
//    //侧滑手势处理
//    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
//
//    self.bgSelectedImageView.alpha = 1;
//    self.bgUnselectedImageView.alpha = 0;
//    self.bgSelectedImageView.image = [self getImageWithIndex:index];
//}

//- (JXCategoryBaseView *)preferredCategoryView {
//    return [[JXCategoryBaseView alloc] init];
//}

- (CGFloat)preferredCategoryViewHeight {
    return 100;
}

- (JXCategoryBaseView *)categoryView {
    if (_categoryView == nil) {
        _categoryView = [self preferredCategoryView];
    }
    return _categoryView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (_listContainerView == nil) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    NYSJXCategoryItemViewController *list = [[NYSJXCategoryItemViewController alloc] init];
    list.index = index;
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}


@end
