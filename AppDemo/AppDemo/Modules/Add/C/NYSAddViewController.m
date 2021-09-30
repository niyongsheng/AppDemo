//
//  NYSAddViewController.m
//  NYS
//
//  Created by niyongsheng on 2021/8/10.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSAddViewController.h"
#import "LayoutFittingView.h"
#import <SGPagingView/SGPagingView.h>
#import <TZImagePickerController/TZImagePickerController.h>

#import "NYSSquareCollectionVC.h"

@interface NYSAddViewController ()
<
SGPageTitleViewDelegate,
SGPageContentCollectionViewDelegate,
TZImagePickerControllerDelegate
>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;

@end

@implementation NYSAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WS(weakSelf)
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:nil];
    [rightItem setActionBlock:^(id _Nonnull sender) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:3 delegate:self pushPhotoPickerVc:NO];
        imagePickerVc.iconThemeColor = NAppThemeColor;
        imagePickerVc.allowPickingGif = YES;
        imagePickerVc.autoSelectCurrentWhenDone = NO;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowPickingMultipleVideo = NO;
        imagePickerVc.showSelectedIndex = YES;
//        imagePickerVc.naviBgColor = [UIColor whiteColor];
//        imagePickerVc.naviTitleColor = NAppThemeColor;
        imagePickerVc.barItemTextColor = NAppThemeColor;
        imagePickerVc.oKButtonTitleColorNormal = NAppThemeColor;
        imagePickerVc.oKButtonTitleColorDisabled = NAppThemeColor;
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
        }];
//        [weakSelf.navigationController pushViewController:imagePickerVc animated:YES];
        [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];

    }];
    self.navigationItem.rightBarButtonItems = @[rightItem];

    // 1.分页栏配置
    NSArray *titleArr = @[@"话题", @"广场", @"签到"];
    SGPageTitleViewConfigure *segmentConfigure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    segmentConfigure.indicatorStyle = SGIndicatorStyleDynamic;
    segmentConfigure.indicatorColor = NAppThemeColor;
    segmentConfigure.showBottomSeparator = YES;
    segmentConfigure.bottomSeparatorColor = [UIColor clearColor];
    segmentConfigure.indicatorDynamicWidth = 4;
    segmentConfigure.indicatorHeight = 4;
    segmentConfigure.indicatorCornerRadius = 2;
    segmentConfigure.indicatorToBottomDistance = 2;
    segmentConfigure.indicatorScrollStyle = SGIndicatorScrollStyleDefault;
    segmentConfigure.titleFont = [UIFont boldSystemFontOfSize:15];
    segmentConfigure.titleTextZoom = YES;
    segmentConfigure.titleTextZoomRatio = .7f;
    
    // 2.分页栏view
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, NScreenWidth*0.5, 44) delegate:self titleNames:titleArr configure:segmentConfigure];
    self.pageTitleView.backgroundColor = [UIColor clearColor];
    self.pageTitleView
    .lee_theme.LeeAddCustomConfig(DAY, ^(SGPageTitleView *item) {
        [item resetTitleColor:[UIColor blackColor] titleSelectedColor:NAppThemeColor];
    }).LeeAddCustomConfig(NIGHT, ^(SGPageTitleView *item) {
        [item resetTitleColor:[UIColor lightGrayColor] titleSelectedColor:NAppThemeColor];
    });
    LayoutFittingView *LFView = [[LayoutFittingView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, 44)];
    [LFView addSubview:_pageTitleView];
    self.navigationItem.titleView = LFView;
    
    // 3.分页控制器
    NSArray *childArr = @[[[NYSSquareCollectionVC alloc] init],
                          [[NYSSquareCollectionVC alloc] init],
                          [[NYSSquareCollectionVC alloc] init],
                          ];
    self.pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, NScreenHeight) parentVC:self childVCs:childArr];
    self.pageContentCollectionView.delegatePageContentCollectionView = self;
    [self.view addSubview:_pageContentCollectionView];
}

#pragma mark - SGPagingViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentCollectionView setPageContentCollectionViewCurrentIndex:selectedIndex];
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

#pragma mark - TZImagePickerControllerDelegate
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    return YES;
}

- (BOOL)isAssetCanBeDisplayed:(PHAsset *)asset {
    return YES;
}

@end
