//
//  NYSJXCategoryItemViewController.m
//  AppDemo
//
//  Created by 倪永胜 on 2020/9/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSJXCategoryItemViewController.h"
#import "NYSRepeatScrollView.h"
#import "NYSIconTextLayer.h"

@interface NYSJXCategoryItemViewController ()
<
UISearchBarDelegate
>
{
    UIColor *_randomColor;
}
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NYSIconTextLayer *iconTextLayer;
@end

@implementation NYSJXCategoryItemViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    if ([[LEETheme currentThemeTag] isEqualToString:NIGHT]) {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualView.frame = self.view.frame;
    [self.view addSubview:visualView];
    
    [self.view.layer addSublayer:self.iconTextLayer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _randomColor = NRandomColor;
    
    self.iconTextLayer.icon = [UIImage imageNamed:@"location_8x10_"];
    self.iconTextLayer.textColor = _randomColor;
    self.iconTextLayer.text = @"Je pense, donc je suis";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [feedBackGenertor impactOccurred];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    self.view.backgroundColor = _randomColor;
    switch (_index) {
        case 0: {
            if (_searchBar) {
                [_searchBar removeFromSuperview];
            }
            _searchBar = [UISearchBar new];
            _searchBar.tintColor = _randomColor;
            _searchBar.barTintColor = [UIColor colorWithWhite:1 alpha:0.75];
            _searchBar.delegate = self;
            [self.view addSubview:_searchBar];
            [_searchBar setShowsCancelButton:YES animated:YES];
            [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.mas_equalTo(0);
                make.top.mas_equalTo(0);
            }];
        }
            break;
            
        default:
            break;
    }
    return self.view;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (NYSIconTextLayer *)iconTextLayer {
    if (!_iconTextLayer) {
        _iconTextLayer = [NYSIconTextLayer layer];
        CGFloat w = 300;
        _iconTextLayer.maxWidth = w;
        _iconTextLayer.frame = CGRectMake(NScreenWidth/2 - w/2, 150, w, 24);
    }
    return _iconTextLayer;
}

@end
