//
//  NYSNewfeatureViewController.m
//  BaseIOS
//
//  Created by niyongsheng on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSNewfeatureViewController.h"

#define NewfeatureImageCount 3
#define NewfeatureBtnColor [UIColor whiteColor]

@interface NYSNewfeatureViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation NYSNewfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加UIScrollView
    [self setupScrollView];
    
    // 2.添加pageControll
    [self setupPagecontrol];
}

/** 设置状态栏颜色样式 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

/**
 添加pageControll
 */
- (void)setupPagecontrol {
    // 1.添加pageControl
    UIPageControl *pagecontrol = [[UIPageControl alloc] init];
    pagecontrol.numberOfPages = NewfeatureImageCount;
    pagecontrol.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.97);
    pagecontrol.bounds = CGRectMake(0, 0, 200, 50);
    pagecontrol.userInteractionEnabled = NO;
    [self.view addSubview:pagecontrol];
    
    // 2.设置圆点颜色
    pagecontrol.currentPageIndicatorTintColor = NewfeatureBtnColor;
    pagecontrol.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    self.pageControl = pagecontrol;
}

/**
 添加UIScrollView
 */
- (void)setupScrollView {
    // 1.添加scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    for (int index = 0; index < NewfeatureImageCount; index ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        // 设置图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%d", index + 1];
        imageView.image = [UIImage imageNamed:name];
        
        // 设置frame
        CGFloat imageX = index * imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        
        [scrollView addSubview:imageView];
        
        if (index == NewfeatureImageCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置滚动的内容尺寸
    scrollView.contentSize = CGSizeMake(imageW * NewfeatureImageCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
    self.scrollView = scrollView;
}

/// 添加按钮
/// @param imageView 添加的view
- (void)setupLastImageView:(UIImageView *)imageView {
    imageView.userInteractionEnabled = YES;

    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    startButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [startButton setTitle:[NSString stringWithFormat:@"开启新体验 V%@", CurrentAppVersion] forState:UIControlStateNormal];
    [startButton setTitleColor:NewfeatureBtnColor forState:UIControlStateNormal];
    startButton.layer.borderWidth = 2.f;
    startButton.layer.cornerRadius = 20.f;
    startButton.layer.borderColor = NewfeatureBtnColor.CGColor;

    // 2.设置frame
    startButton.center = CGPointMake(imageView.frame.size.width * 0.5, imageView.frame.size.height * 0.88);
    startButton.bounds = (CGRect){CGPointZero, CGSizeMake(155, 40)};
    
    // 3.设置文字
    [startButton addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startButton];
}

- (void)start:(UIButton *)sender {
    // 判断是否登陆过
    if (NIsLogin) {
        NPostNotification(NNotificationLoginStateChange, @YES)
    } else {
        NPostNotification(NNotificationLoginStateChange, @NO)
    }
}

/** scrollView的代理方法  */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 1.水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 2.页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;
}

- (void)dealloc {
    self.pageControl = nil;
    self.scrollView = nil;
}

@end
