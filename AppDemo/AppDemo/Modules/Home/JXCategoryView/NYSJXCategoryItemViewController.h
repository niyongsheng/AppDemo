//
//  NYSJXCategoryItemViewController.h
//  AppDemo
//
//  Created by 倪永胜 on 2020/9/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//


#import "NYSBaseViewController.h"
#import "JXCategoryListContainerView.h"

@interface NYSJXCategoryItemViewController : NYSBaseViewController <JXCategoryListContentViewDelegate>
@property (nonatomic, assign) NSInteger index;
@end
