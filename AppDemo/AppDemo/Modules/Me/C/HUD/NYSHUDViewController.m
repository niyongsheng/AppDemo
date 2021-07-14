//
//  NYSHUDViewController.m
//  AppDemo
//
//  Created by niyongsheng on 2021/7/7.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSHUDViewController.h"
#import "NYSHUDDetailViewController.h"

@interface NYSHUDViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic) NSArray  *dataSource;
@end

@implementation NYSHUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"HUD";
    self.dataSource = @[@"circleAnimation",
                        @"circleJoinAnimation",
                        @"dotAnimation",
                        @"customAnimation",
                        @"gifAnimations",
                        @"failure",
                        @"failure2",
                        @"classMethod",
    ];
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RealValue(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"HUD_CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _dataSource[indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NYSHUDDetailViewController *detailVC = [NYSHUDDetailViewController new];
    detailVC.title = _dataSource[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end

