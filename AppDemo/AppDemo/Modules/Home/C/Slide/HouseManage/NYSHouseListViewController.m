//
//  NYSHouseListViewController.m
//  NYS
//
//  Created by niyongsheng on 2021/8/21.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSHouseListViewController.h"

@interface NYSHouseListViewController ()

@end

@implementation NYSHouseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0.导航栏
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    [rightItem setActionBlock:^(id _Nonnull sender) {
        [self NYSShowFixMessage:@"kPushDownAnimatiokPushDownAnimationScrollTopNotificationnScrollTopNotification" style:NYSShowMessageStyleDanger tapBlock:^(id  _Nullable obj) {
            
        }];
    }];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    [self.view addSubview:self.tableView];
}

@end
