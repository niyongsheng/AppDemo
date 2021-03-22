//
//  NYSMeViewController.m
//  AppDemo
//
//  Created by 倪永胜 on 2020/9/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSMeViewController.h"
#import "TableViewAnimationKit.h"
#import "Model.h"
#import <CoreMotion/CoreMotion.h>
#import "NYSAboutViewController.h"

#define HEADER_HEIGHT RealValue(260)

@interface NYSMeViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation NYSMeViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [TableViewAnimationKit overTurnAnimationWithTableView:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Me"];
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(-60, 0, 0, 0);
    [self.view addSubview:self.tableView];
    
    [self.headerView addSubview:self.imgView];
    self.imgView.center = CGPointMake(self.headerView.center.x, self.headerView.center.y - 60);
    [self.headerView addSubview:self.nameLabel];
    self.nameLabel.frame = CGRectMake(0, self.imgView.frame.size.height + self.imgView.frame.origin.y + 10, self.view.frame.size.width, 25);
    [self.headerView addSubview:self.segmentedControl];
    self.segmentedControl.center = CGPointMake(self.headerView.center.x, self.nameLabel.center.y + 40);
    self.tableView.tableHeaderView = self.headerView;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightBarClicked:(UIBarButtonItem *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tip" message:@"Are you sure logout ?" preferredStyle:UIAlertControllerStyleActionSheet];
    if (CurrentSystemVersion < 13.0) {
        [UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]].lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
        alertController.view.layer.cornerRadius = 15.0f;
        alertController.view.layer.masksToBounds = YES;
    }
    UIAlertAction *laterAction = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"logout"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
        [NUserManager logout:^(BOOL success, id description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    [SVProgressHUD showSuccessWithStatus:@"logout success"];
                    [SVProgressHUD dismissWithDelay:1.0f completion:^{
                        NPostNotification(NNotificationLoginStateChange, @NO)
                    }];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"logout fail"];
                    [SVProgressHUD dismissWithDelay:0.4f];
                }
            });
        }];
    }];
    [alertController addAction:laterAction];
    [alertController addAction:okAction];
    [NRootViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Model *model = self.dataSource[section];
    return model.titles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Model *model = self.dataSource[section];
    return model.header;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *header = @"HEADER_ID";
    UITableViewHeaderFooterView *vHeader;
    vHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    
    if (!vHeader) {
        vHeader = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:header];
    }
    vHeader.tintColor = [UIColor blackColor];
    vHeader.textLabel.text = [self tableView:tableView titleForHeaderInSection:section];

    return vHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL_ID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.imageView.image = [UIImage imageNamed:@"icon_me_item"];
    
    Model *model = self.dataSource[indexPath.section];
    NSString *str = [[model titles] count] > 0 ? [model titles][indexPath.row] : [[model header] stringByAppendingFormat:@" %zd", indexPath.row];
    cell.textLabel.text = str;
    cell.textLabel.lee_theme.LeeAddTextColor(DAY, [UIColor grayColor]);
    cell.textLabel.lee_theme.LeeAddTextColor(NIGHT, [UIColor whiteColor]);
    
    NSString *detailStr = [model detailTitles][indexPath.row];
    cell.detailTextLabel.text = detailStr;
    cell.detailTextLabel.lee_theme.LeeAddTextColor(DAY, [UIColor lightGrayColor]);
    cell.detailTextLabel.lee_theme.LeeAddTextColor(NIGHT, [UIColor colorWithWhite:1.0f alpha:0.5f]);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RealValue(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                NSString *amount = [NSString stringWithFormat:@"%d", 100];
                NSString *str = [NSString stringWithFormat:@"恭喜您^^\n获得%@积分", amount];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
                [attrStr setAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} range:[str rangeOfString:amount]];
                [NYSTKAlert showSignAlertWithMessage:attrStr
                                              onView:NAppWindow
                                            signType:NYSTKSignTypeYellow
                                         emitterType:NYSTKEmitterAnimationTypeColourbar
                                          themeModel:NYSTKThemeModelLight
                              infoButtonClickedBlock:^{
                    
                } closeButtonClickedBlock:^{
                    
                }];
            }
                break;
                
            case 1: {
                self.pedometer = [[CMPedometer alloc] init];
                if ([CMPedometer isStepCountingAvailable]) {
                    // 获取昨天的步数与距离数据
                    [_pedometer queryPedometerDataFromDate:[self zeroOfDate] toDate:[NSDate dateWithTimeIntervalSinceNow:0] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                        if (error) {
                            [SVProgressHUD showErrorWithStatus:[error description]];
                            [SVProgressHUD dismissWithDelay:2.0f];
                        } else {
                            NSString *message = [NSString stringWithFormat:@"Steps Num:%@, %.1fkm.", pedometerData.numberOfSteps, pedometerData.distance.floatValue/1000];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [NYSTKAlert showColorfulToastWithMessage:message
                                      type:NYSTKColorfulToastTypeBlueFlower
                                 direction:NYSTKComeInDirectionDown
                                    onView:NAppWindow
                                themeModel:NYSTKThemeModelLight];
                            });
                        }
                    }];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"Pedometer not available!"];
                    [SVProgressHUD dismissWithDelay:1.f];
                }
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        [NYSTKAlert showToastWithMessage:@"Undefined Item !" themeModel:NYSTKThemeModelLight];
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
                break;
                
            case 1: {
                [UMManager sharedUMManager];
            }
                break;
                
            case 2: {
                
            }
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0: {
                SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:AppAPIsURL] entersReaderIfAvailable:YES];
                [self presentViewController:safariVC animated:YES completion:nil];
            }
                break;
                
            case 1: {
                NYSAboutViewController *aboutVC = [NYSAboutViewController new];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - getter / setter
- (NSArray *)dataSource {
    if (!_dataSource) {
        Model *model_1 = [Model new];
        model_1.header = @"Profession Properties";
        model_1.titles = @[@"Sign In", @"Sport Message"];
        
        Model *model_2 = [Model new];
        model_2.header = @"Business Demo";
        model_2.titles = @[@"BD_1", @"BD_2", @"BD_3", @"BD_4"];
        model_2.detailTitles = @[@"None", @"None", @"None", @"None"];
        
        Model *model_3 = [Model new];
        model_3.header = @"App Config";
        model_3.titles = @[@"Setting", @"Share Panel", @"Clear Refuse"];
        model_3.detailTitles = @[@"system", @"third", @"memory"];
        
        Model *model_4 = [Model new];
        model_4.header = @"App Info";
        model_4.titles = @[@"APIs", @"About Our"];
        model_4.detailTitles = @[@"api document", @""];
        
        _dataSource = @[model_1, model_2, model_3, model_4];
    }
    return _dataSource;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, NTopHeight, self.view.frame.size.width, HEADER_HEIGHT)];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        [_imgView setImageURL:[NSURL URLWithString:NUpdateUserInfo.profile.headPhoto]];
        _imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewOnclicked:)];
        [_imgView addGestureRecognizer:tap];
        _imgView.bounds = CGRectMake(0, 0, 90, 90);
        _imgView.layer.borderColor = [UIColor whiteColor].CGColor;
        _imgView.layer.borderWidth = 2;
        _imgView.layer.cornerRadius = 45;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [UILabel new];
        _nameLabel.lee_theme.LeeConfigTextColor(@"common_nav_font_color_1");
        _nameLabel.text = NUpdateUserInfo.profile.nickname;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:22];
    }
    return _nameLabel;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Light Model", @"Dark Model"]];
        _segmentedControl.tintColor = [UIColor lightGrayColor];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (void)didClicksegmentedControlAction:(UISegmentedControl *)seg {
    if (seg.selectedSegmentIndex == 0) {
        [[ThemeManager sharedThemeManager] setThemeWithTag:DAY];
    } else {
        [[ThemeManager sharedThemeManager] setThemeWithTag:NIGHT];
    }
}

- (void)iconViewOnclicked:(UIImageView *)imageView {
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:FrameworkURL] entersReaderIfAvailable:YES];
    [self presentViewController:safariVC animated:YES completion:nil];
}

/** 获取0点钟NSDate */
- (NSDate *)zeroOfDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:[NSDate date]];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:ts];
}

@end

