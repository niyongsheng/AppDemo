//
//  NYSAboutViewController.m
//  AppDemo
//
//  Created by 倪永胜 on 2018/10/25.
//  Copyright © 2018 NiYongsheng. All rights reserved.
//  关于

#import "NYSAboutViewController.h"
#import <StoreKit/StoreKit.h>
#import "NYSAboutHeaderView.h"

#import "NYSWebViewController.h"

static NSString *ID = @"CellIdentifier";

@interface NYSAboutViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
SKStoreProductViewControllerDelegate
>
@property (nonatomic,strong) NSArray<NSArray *> *dataArr;

@property (nonatomic, strong) NYSAboutHeaderView *headerView;

@end

@implementation NYSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNav];
    [self setupHeader];
    [self setupFooter];
    [self setupTableView];
}

- (void)configTheme {
    [super configTheme];
    _tableviewStyle = UITableViewStyleGrouped;
}

- (void)setupNav {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"logout_icon"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStyleDone target:self action:nil];
    [rightItem setActionBlock:^(id _Nonnull sender) {
        
    }];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setupHeader {
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setupFooter {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, 80)];
    self.tableView.tableFooterView = footerView;
    
    YYLabel *infoLabel = [[YYLabel alloc] initWithFrame:footerView.bounds];
    infoLabel.numberOfLines = 0;
    infoLabel.lee_theme.LeeConfigTextColor(@"common_font_color_1");
    
    NSString *companyStr = [NSString stringWithFormat:@"%@ 版权所有\n", CompanyName];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy"];
    NSString *copyrightStr = [NSString stringWithFormat:@"Copyright © %@ %@.All Rights Reserved", [format stringFromDate:date], [NYSTools transformToPinyin:CompanyName]];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[companyStr stringByAppendingString:copyrightStr]];
    attr.color = [LEETheme getValueWithTag:[LEETheme currentThemeTag] Identifier:@"common_font_color_1"];
    attr.lineSpacing = 5;
    attr.alignment = NSTextAlignmentCenter;
//    attr.kern = [NSNumber numberWithFloat:1.0];
//    attr.font = [UIFont fontWithName:@"DOUYU Font" size:10.0f];
    infoLabel.attributedText = attr;
    [footerView addSubview:infoLabel];
}

- (void)setupTableView {
    
#ifdef NAppRoundStyle
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#endif

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.refreshControl = nil;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *dict = self.dataArr[indexPath.section][indexPath.row];
    cell.tag = [dict[@"tag"] integerValue];
    cell.textLabel.text = dict[@"title"];
    cell.detailTextLabel.text = dict[@"subtitle"];
    cell.imageView.image = [UIImage imageNamed:dict[@"icon"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.dataArr[indexPath.section][indexPath.row];
    NSString *title = dict[@"title"];
    if ([title isEqualToString:@"用户协议"]) {
        
        NYSWebViewController *userProtoclVC = [[NYSWebViewController alloc] initWithUrlStr:APP_BaseURL];
        [self.navigationController pushViewController:userProtoclVC animated:YES];
        
    } else if ([title isEqualToString:@"隐私条款"]) {
        
        NYSWebViewController *privacyProtoclVC = [[NYSWebViewController alloc] init];
        privacyProtoclVC.urlStr = @"https://baidu.com";
        [self.navigationController pushViewController:privacyProtoclVC animated:YES];
        
    } else if ([title isEqualToString:@"给个好评"]) {
        if (@available(iOS 10.3, *)) {
            [SKStoreReviewController requestReview];
        } else {
            [self openScheme:AppStoreURL];
        }
        
    } else if ([title isEqualToString:@"版本更新"]) {
        
        [SVProgressHUD showWithStatus:@"正在加载"];
        [SVProgressHUD dismissWithDelay:1.5f];
        
        // 初始化控制器
        SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
        
        // 设置代理请求为当前控制器本身
        storeProductViewContorller.delegate=self;
        
        // 加载对应的APP详情页
        [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:APPID} completionBlock:^(BOOL result, NSError * _Nullable error) {
            if(error) {
                [SVProgressHUD showErrorWithStatus:@"加载出错"];
                [SVProgressHUD dismissWithDelay:0.5f];
                NSLog(@"error %@ with userInfo %@", error, [error userInfo]);
            } else {
                [SVProgressHUD dismiss];
                // 模态弹出appstore
                [self presentViewController:storeProductViewContorller animated:YES completion:nil];
            }
        }];
    } else if ([title isEqualToString:@"官方网站"]) {
        [self openScheme:APP_BaseURL];
        
    } else if ([title isEqualToString:@""]) {
        
    }
}

/// Safari打开网页
- (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            NLog(@"Open %@: %d",scheme,success);
        }];
    } else {
        [application openURL:URL options:@{} completionHandler:nil];
    }
}

#pragma mark - getter
- (NYSAboutHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NYSAboutHeaderView alloc] initWithFrame:CGRectMake(0, 0, NScreenWidth, 200)];
    }
    return _headerView;
}

- (NSArray<NSArray *> *)dataArr {
    if (!_dataArr) {
        _dataArr = @[
            @[
                @{@"title": @"给个好评", @"subTitle": @"", @"icon": @"", @"tag": @""},
                @{@"title": @"版本更新", @"subTitle": @"", @"icon": @"", @"tag": @""},
            ],
            @[
                @{@"title": @"用户协议", @"subTitle": @"", @"icon": @"", @"tag": @""},
                @{@"title": @"隐私条款", @"subTitle": @"", @"icon": @"", @"tag": @""},
            ],
            @[
                @{@"title": @"官方网站", @"subTitle": @"", @"icon": @"", @"tag": @""},
            ],
        ];
    }
    return _dataArr;
}

@end
