//
//  NYSSlideViewController.m
//  NYS
//
//  Created by niyongsheng on 2021/8/6.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSSlideViewController.h"
#import <UIViewController+CWLateralSlide.h>

#import "NYSSliderHeaderView.h"

#import "NYSPointsViewController.h"
#import "NYSHouseListViewController.h"

#import "NYSFamiliesViewController.h"
#import "NYSConversationViewController.h"
#import "NYSFeedbackViewController.h"

#import "NYSAboutViewController.h"
#import "NYSSettingViewController.h"
#import "NYSCPTableViewController.h"

#define ContentWidth (NScreenWidth * 0.75)
#define HeaderHeight 280
#define FooterHeight 0

#define LogSign @"logout"

@interface NYSSlideViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic,strong) NSArray<NSArray *> *dataArr;

@property (nonatomic, strong) NYSSliderHeaderView *headerView;
@property (nonatomic, strong) UISwitch *nightSwitch;
@property (nonatomic, strong) UIButton *signBtn;

@end

@implementation NYSSlideViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [feedBackGenertor impactOccurred];
    }
    
    [self.tableView reloadData];
    [self.nightSwitch setOn:[[LEETheme currentThemeTag] isEqualToString:NIGHT] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupHeader];
    [self setupFooter];
    [self setupTableView];
}

- (void)configTheme {
    [super configTheme];
    _tableviewStyle = UITableViewStyleGrouped;
}

- (void)setupHeader {
    WS(weakSelf)
    self.headerView.block = ^(id obj) {
        switch ([obj intValue]) {
            case 0: {
                
            }
                break;
                
            default:
                break;
        }
    };
    [self.view addSubview:self.headerView];
}

- (void)setupFooter {
    
}

- (void)setupTableView {
    self.tableView.frame = CGRectMake(0, HeaderHeight, ContentWidth, NScreenHeight-HeaderHeight-FooterHeight);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.refreshControl = nil;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NNormalSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#ifdef NAppRoundStyle
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(tintColor)]) {
        
        if (tableView == self.tableView) {
            CGFloat cornerRadius = NRadius;
            
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 10, 0);
            
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
            }
            
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.lee_theme.LeeConfigFillColor(@"common_bg_color_1");
            layer.shadowColor = [UIColor grayColor].CGColor;
            layer.shadowOffset = CGSizeZero;
            layer.shadowOpacity = 0.15f;
            
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}
#endif

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"CellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    NSDictionary *dict = self.dataArr[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dict[@"icon"]];
    cell.textLabel.text = dict[@"title"];
    cell.detailTextLabel.text = dict[@"subtitle"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
#ifdef NAppTintImage
    cell.imageView.image
    .lee_theme.LeeAddCustomConfig(DAY, ^(UIImage *item) {
        item = [item imageChangeColor:[UIColor darkGrayColor]];
    }).lee_theme.LeeAddCustomConfig(NIGHT, ^(UIImage *item) {
        item = [item imageChangeColor:[UIColor whiteColor]];
    });
#endif
    
    if ([dict[@"tag"] integerValue] == 886) {
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        switch ([dict[@"tag"] integerValue]) {
            case 0:
                cell.accessoryView = self.signBtn;
                break;
                
            case 5:
                break;
                
            case 6:
                cell.accessoryView = self.nightSwitch;
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataArr[indexPath.section][indexPath.row];
    if ([dict[@"tag"] integerValue] == 886) {
        // 退出登录
        [self showAlterView:nil];
    } else {
        switch ([dict[@"tag"] integerValue]) {
            case 0: {
                NYSPointsViewController *pointsVC = [NYSPointsViewController new];
                [self cw_pushViewController:pointsVC];
            }
                break;
                
            case 1: {
                NYSHouseListViewController *houseVC = [NYSHouseListViewController new];
                houseVC.title = dict[@"title"];
                [self cw_pushViewController:houseVC];
            }
                break;
                
            case 2: {
                NYSFamiliesViewController *familiesVC = [NYSFamiliesViewController new];
                familiesVC.title = dict[@"title"];
                [self cw_pushViewController:familiesVC];
            }
                break;
                
            case 3: {
                [self cw_pushViewController:NYSCPTableViewController.new];
            }
                break;
                
            case 4: {
                NYSConversationViewController *privateConversationVC = [[NYSConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:@"18853936112"];
                privateConversationVC.title = dict[@"title"];
                [self cw_pushViewController:privateConversationVC];
            }
                break;
                
            case 5: {
                NYSFeedbackViewController *feedbackVC = [NYSFeedbackViewController new];
                feedbackVC.title = dict[@"title"];
                [self cw_pushViewController:feedbackVC];
            }
                break;
                
            case 7: {
                NYSSettingViewController *settingVC = [NYSSettingViewController new];
                settingVC.title = dict[@"title"];
                [self cw_pushViewController:settingVC];
            }
                break;
                
            case 8: {
                NYSAboutViewController *aboutVC = [NYSAboutViewController new];
                aboutVC.title = dict[@"title"];
                [self cw_pushViewController:aboutVC];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - getter
- (NSArray<NSArray *> *)dataArr {
    if (!_dataArr) {
        _dataArr = @[
            @[
                @{@"title": @"积分", @"subtitle": @"+100", @"icon": @"icon_center_shop", @"tag": @"0"},
            ],
            @[
                @{@"title": @"Empty Data", @"subtitle": @"", @"icon": @"icon_center_service", @"tag": @"1"},
                @{@"title": @"Invate QRCode", @"subtitle": @"", @"icon": @"icon_center_service", @"tag": @"2"},
                @{@"title": @"Dial Code", @"subtitle": @"", @"icon": @"icon_center_service", @"tag": @"3"},
            ],
            @[
                @{@"title": @"在线客服", @"subtitle": @"", @"icon": @"icon_center_call", @"tag": @"4"},
                @{@"title": @"帮助中心", @"subtitle": @"", @"icon": @"icon_center_help", @"tag": @"5"},
                @{@"title": @"夜间模式", @"subtitle": @"", @"icon": @"icon_center_night", @"tag": @"6"}
            ],
            @[
                @{@"title": @"设置", @"subtitle": @"", @"icon": @"icon_center_setup", @"tag": @"7"},
                @{@"title": @"关于", @"subtitle": @"", @"icon": @"icon_center_about", @"tag": @"8"}
            ],
            @[
                @{@"title": @"退出登录", @"subtitle": @"", @"icon": @"", @"tag": @"886"}
            ],
        ];
    }
    return _dataArr;
}

- (NYSSliderHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NYSSliderHeaderView alloc] initWithFrame:CGRectMake(0, 0, ContentWidth, HeaderHeight)];
    }
    return _headerView;
}

- (UISwitch *)nightSwitch {
    if (!_nightSwitch) {
        _nightSwitch = [[UISwitch alloc] init];
        [_nightSwitch setOn:[[LEETheme currentThemeTag] isEqualToString:NIGHT]];
        _nightSwitch.lee_theme.LeeConfigOnTintColor(@"app_theme_color");
        [_nightSwitch addBlockForControlEvents:UIControlEventValueChanged block:^(id  _Nonnull sender) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[ThemeManager sharedThemeManager] changeTheme:NAppWindow];
            });
        }];
    }
    return _nightSwitch;
}

- (UIButton *)signBtn {
    if (!_signBtn) {
        _signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signBtn setFrame:CGRectMake(0, 0, 40, 20)];
        [_signBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
        _signBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _signBtn.borderWidth = 2.0f;
        _signBtn.borderColor = [UIColor redColor];
        _signBtn.cornerRadius = 10.0f;
        [_signBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            
            NSString *amount = [NSString stringWithFormat:@"%d", 100];
            NSString *str = [NSString stringWithFormat:@"恭喜您^^\n获得%@积分", amount];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
            [attrStr setAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:[str rangeOfString:str]];
            [attrStr setAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} range:[str rangeOfString:amount]];
            
            [NYSTKConfig defaultConfig].offsetForLabel = UIOffsetMake(0, -25);
            [NYSTKConfig defaultConfig].offsetForCloseBtn = UIOffsetMake(-70, 100);
            [NYSTKConfig defaultConfig].offsetForInfoBtn = UIOffsetMake(0, 10);
            [NYSTKConfig defaultConfig].tintColor = [UIColor colorWithRed:1.00 green:0.76 blue:0.05 alpha:1.00];
            [NYSTKAlert showImageAlertWithMessage:attrStr
                           infoButtonClickedBlock:^{
                
            }];
        }];
    }
    return _signBtn;
}

/// 退出登录
/// @param sender sd
- (void)showAlterView:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出登录吗 ?" preferredStyle:UIAlertControllerStyleActionSheet];
    if (CurrentSystemVersion < 13.0) {
        [UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]].lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
        alertController.view.layer.cornerRadius = 15.0f;
        alertController.view.layer.masksToBounds = YES;
    }
    UIAlertAction *laterAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*action) {
        [NUserManager logout:^(BOOL success, id description) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    [SVProgressHUD showSuccessWithStatus:@"登出成功"];
                    [SVProgressHUD dismissWithDelay:1.0f completion:^{
                        NPostNotification(NNotificationLoginStateChange, @NO)
                    }];
                } else {
                    [SVProgressHUD showInfoWithStatus:@"登出失败"];
                    [SVProgressHUD dismissWithDelay:0.4f];
                }
            });
        }];
    }];
    [alertController addAction:laterAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
