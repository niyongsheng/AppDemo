//
//  NYSCPTableViewController.m
//  AppDemo
//
//  Created by niyongsheng on 2021/6/30.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSCPTableViewController.h"
#import "NYSCPSearchTableViewController.h"
#import "NYSCPTableViewCell.h"
#import "NYSCPModel.h"

@interface NYSCPTableViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
UISearchBarDelegate
>

@property (nonatomic, strong) UITableView *cpTableView;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSMutableArray <NYSCPModel *>*cpModelMArr;

@property (nonatomic, strong) NSMutableArray <NSString *>*sectionIndexTitles;

@property (nonatomic, strong) NYSCPSearchTableViewController *searchResultsController;

@end

@implementation NYSCPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Dial Code";
   
    [self readData];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.view addSubview:self.tableView];
    
    if (CurrentSystemVersion < 13.0) {
        self.view.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.cpTableView.frame = self.view.bounds;
}

- (void)readData {
    self.cpModelMArr = [NSMutableArray array];
    self.sectionIndexTitles = [NSMutableArray array];
    
    NSArray *dictArr = [NYSCPModel plistData];
    for (NSDictionary *dict in dictArr) {
        NYSCPModel *model = [NYSCPModel modelWithDictionary:dict];
        [self.cpModelMArr addObject:model];
        [self.sectionIndexTitles addObject:model.groupKey];
    }
}

- (UITableView *)tableView {
    if (!_cpTableView) {
        _cpTableView = [UITableView new];
        _cpTableView.delegate = self;
        _cpTableView.dataSource = self;
        [_cpTableView registerClass:[NYSCPTableViewCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _cpTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cpModelMArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cpModelMArr[section].countries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NYSCPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    [cell updateViewWithModel:self.cpModelMArr[indexPath.section].countries[indexPath.row]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.cpModelMArr[section].groupKey;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionIndexTitles;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *lowercaseString = [searchText lowercaseString];
    NSString *uppercaseString = [searchText uppercaseString];
    NSMutableArray *result = [NSMutableArray array];

    NSArray *groupKeys = @[@"热门", @"Hot"];

    for (NYSCPModel *zone in self.cpModelMArr) {
        if ([groupKeys containsObject:zone.groupKey]) {
            continue;
        }
        for (NYSCountryModel *country in zone.countries) {
            NSString *countryName = country.name;
            NSString *pinyin = [NYSTools transformToPinyin:countryName];
            if ([countryName containsString:lowercaseString] ||
                [pinyin containsString:lowercaseString] ||
                [countryName containsString:uppercaseString]) {
                [result addObject:country];
            }
        }
    }
    self.searchResultsController.result = result;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultsController];
        _searchController.searchBar.delegate = self;
    }
    return _searchController;
}

- (NYSCPSearchTableViewController *)searchResultsController {
    if (!_searchResultsController) {
        _searchResultsController = [NYSCPSearchTableViewController new];
    }
    return _searchResultsController;
}

@end
