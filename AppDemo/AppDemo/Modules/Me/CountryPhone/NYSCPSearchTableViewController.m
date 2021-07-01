//
//  NYSCPSearchTableViewController.m
//  AppDemo
//
//  Created by niyongsheng on 2021/6/30.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSCPSearchTableViewController.h"
#import "NYSCPTableViewCell.h"
#import "NYSCPModel.h"

@interface NYSCPSearchTableViewController ()

@property (nonatomic, strong) UILabel *emptyView;

@end

@implementation NYSCPSearchTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[NYSCPTableViewCell class] forCellReuseIdentifier:@"cellID"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NYSCPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    [cell updateViewWithModel:self.result[indexPath.row]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.result.count > 0 ? [NYSCPModel localizedWithString:@"bestMatch"] : @"";
}

- (void)setResult:(NSArray<NYSCountryModel *> *)result {
    _result = result;
    self.tableView.backgroundView = result.count > 0 ? nil : self.emptyView;
    [self.tableView reloadData];
}

- (UILabel *)emptyView {
    if (!_emptyView) {
        _emptyView = [UILabel new];
        _emptyView.backgroundColor = [UIColor whiteColor];
        _emptyView.text = [NYSCPModel localizedWithString:@"noResult"];
        _emptyView.font = [UIFont systemFontOfSize:30];
        _emptyView.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        _emptyView.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyView;
}

@end
