//
//  NYSJXCategoryItemViewController.m
//  AppDemo
//
//  Created by 倪永胜 on 2020/9/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSJXCategoryItemViewController.h"

#define COLOR_WITH_RGB(R,G,B,A) [UIColor colorWithRed:R green:G blue:B alpha:A]

@interface NYSJXCategoryItemViewController ()

@end

@implementation NYSJXCategoryItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = NRandomColor;

}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

@end
