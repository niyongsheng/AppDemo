//
//  NYSSettingViewController.m
//  DaoCaoDui_IOS
//
//  Created by 倪永胜 on 2019/12/20.
//  Copyright © 2019 NiYongsheng. All rights reserved.
//  设置

#import "NYSSettingViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface NYSSettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *datasourceArray;
/// 是否允许通知
@property (nonatomic, assign) BOOL isEnableNotification;
/// 深色主题跟随系统
@property (nonatomic, strong) UISwitch *followSysDarkModelEnSwitch;
/// 调整字号大小
@property (nonatomic, strong) UISlider *fontSizeSlider;
@end

@implementation NYSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)configTheme {
    [super configTheme];
    _tableviewStyle = UITableViewStyleGrouped;
}

#pragma mark -- initUI --
- (void)setupTableView {
    
#ifdef NAppRoundStyle
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#endif

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.refreshControl = nil;
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
    
    [self.view addSubview:self.tableView];
}

#pragma mark —- tableview delegate —-
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return 2;
    }
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = @"清理网络缓存";
//                cell.detailTextLabel.text = [NSString stringWithFormat:@"当前网络缓存大小:%.2fKB", [PPNetworkCache getAllHttpCacheSize]/1024.f];
            }
                break;
                
            case 1: {
                cell.textLabel.text = @"清理聊天缓存";
            }
                break;
                
            case 2: {
                cell.textLabel.text = @"重置所有设置";
            }
                break;
                
            case 3: {
                cell.textLabel.text = @"允许通知";
                cell.accessoryType = self.isIsEnableNotification ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = @"深色模式跟随系统";
                cell.accessoryView = self.followSysDarkModelEnSwitch;
            }
                break;
                
            case 1: {
                cell.textLabel.text = @"字体大小";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"当前字号:%.2f", self.fontSizeSlider.value];
                cell.accessoryView = self.fontSizeSlider;
            }
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
                break;
                
            case 1: {
                [[RCIM sharedRCIM] clearUserInfoCache];
                [[RCIM sharedRCIM] clearGroupInfoCache];
                [[RCIM sharedRCIM] clearGroupUserInfoCache];
            }
                break;
                
            case 2: {
                [self loadDefaultAllSettingWarningAlert];
            }
                break;
                
            case 3: {
                self.isEnableNotification = !self.isEnableNotification;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0: {
                
            }
                break;
                
            case 1: {
                
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - UI widget lazy load
- (BOOL)isIsEnableNotification {
    if (!_isEnableNotification) {
        BOOL ien = [NUserDefaults boolForKey:@""];
        
        _isEnableNotification = ien;
    }
    return _isEnableNotification;
}

- (void)setIsEnableNotification:(BOOL)isEnableNotification {
    _isEnableNotification = isEnableNotification;
    
    [NUserDefaults setBool:isEnableNotification forKey:@""];
    [NUserDefaults synchronize];
}

- (UISwitch *)followSysDarkModelEnSwitch {
    if (!_followSysDarkModelEnSwitch) {
        _followSysDarkModelEnSwitch = [[UISwitch alloc] init];
        [_followSysDarkModelEnSwitch setOn:[NUserDefaults boolForKey:@""]];
        _followSysDarkModelEnSwitch.lee_theme.LeeConfigOnTintColor(@"app_theme_color");
        [_followSysDarkModelEnSwitch addTarget:self action:@selector(bibleEnSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _followSysDarkModelEnSwitch;
}

- (UISlider *)fontSizeSlider {
    if (!_fontSizeSlider) {
        _fontSizeSlider = [[UISlider alloc] init];
        [_fontSizeSlider setMinimumValue:10.f];
        [_fontSizeSlider setMaximumValue:50.f];
        [_fontSizeSlider addTarget:self action:@selector(fontSizeSliderChanged:) forControlEvents:UIControlEventValueChanged];

    }
    return _fontSizeSlider;
}

#pragma mark - UI widget event deal
- (void)bibleEnSwitchChanged:(UISwitch *)sender {

}

- (void)_bibleFontSizeSliderChanged:(UISlider *)sender {

}

/// 重置所有设置
- (void)loadDefaultAllSetting {

    // 刷新cell
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

#pragma mark - ⚠️WARNING Alert
- (void)loadDefaultAllSettingWarningAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要重置所有设置吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"重置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self loadDefaultAllSetting];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NLog(@"Cancel Action");
    }];
    
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
