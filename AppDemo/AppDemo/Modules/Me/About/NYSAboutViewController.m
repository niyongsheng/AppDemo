//
//  NYSAboutViewController.m
//  AppDemo
//
//  Created by 倪永胜 on 2018/10/25.
//  Copyright © 2018 NiYongsheng. All rights reserved.
//

#import "NYSAboutViewController.h"
#import <StoreKit/StoreKit.h>
#import "NYSConversationViewController.h"
#import "NYSUserProtoclViewController.h"

@interface NYSAboutViewController () <SKStoreProductViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UILabel *copyright;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;

- (IBAction)btn1Clicked:(id)sender;
- (IBAction)btn2Clicked:(id)sender;
- (IBAction)btn3Clicked:(id)sender;
- (IBAction)btn4Clicked:(id)sender;

@end

@implementation NYSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
//    self.isHidenNaviBar = YES;
    
    [self initNavItem];
    
    // 0高度位置64
    //    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    self.view1.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
    self.view2.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
    self.view3.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
    self.view4.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2");
    
    self.icon.layer.cornerRadius = 12.f;
    self.icon.clipsToBounds = YES;
    
    // 添加观察者
    [self addObserver:_button1];
    [self addObserver:_button2];
    [self addObserver:_button3];
    [self addObserver:_button4];
    
    // APP版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.version.text = [NSString stringWithFormat:@"版本：V%@", app_Version];
    self.appName.text = [infoDictionary objectForKey:@"CFBundleName"];
    // APP版权
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy"];
    self.copyright.text = [NSString stringWithFormat:@"Copyright © %@ NiYongsheng.All Rights Reserved", [format stringFromDate:date]];
}

// 添加观察者
- (void)addObserver:(UIButton *)button {
    
    [button addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 观察者实现
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    UIButton *button = (UIButton *)object;
    if ([keyPath isEqualToString:@"highlighted"]) {
        if (button.highlighted) {
            [button setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:0.8]];
            return;
        }
        [button setBackgroundColor:[UIColor clearColor]];
    }
}

- (IBAction)btn1Clicked:(id)sender {
    [self loadAppStoreControllerWithAppID:APPID];
}
- (IBAction)btn2Clicked:(id)sender {
    if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    } else {
        [self openScheme:AppStoreURL];
    }
}
- (IBAction)btn3Clicked:(id)sender {
    NYSConversationViewController *privateConversationVC = [[NYSConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:@"18853936112"];
    privateConversationVC.title = @"技术支持";
    [self.navigationController pushViewController:privateConversationVC animated:YES];
}

- (IBAction)btn4Clicked:(id)sender {
    NYSUserProtoclViewController *userProtocl = [[NYSUserProtoclViewController alloc] init];
    userProtocl.title = @"用户协议";
    [self.navigationController pushViewController:userProtocl animated:YES];
}

/** 加载AppStore上详情页 */
- (void)loadAppStoreControllerWithAppID:(NSString *)appID {
    [SVProgressHUD showWithStatus:@"正在加载"];
    [SVProgressHUD dismissWithDelay:1.5f];
    
    // 初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    
    // 设置代理请求为当前控制器本身
    storeProductViewContorller.delegate=self;
    
    // 加载对应的APP详情页
    [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appID} completionBlock:^(BOOL result, NSError * _Nullable error) {
        if(error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"加载出错"];
            [SVProgressHUD dismissWithDelay:0.5f];
            NSLog(@"error %@ with userInfo %@", error, [error userInfo]);
        } else {
            [SVProgressHUD dismiss];
            // 模态弹出appstore
            [self presentViewController:storeProductViewContorller animated:YES completion:nil];
        }
    }];
}

// AppStore取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController*)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 打开网页
- (void)openScheme:(NSString *)scheme {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Open %@: %d",scheme,success);
        }];
    } else {
        [application openURL:URL options:@{} completionHandler:nil];
    }
}

- (void)initNavItem {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"logout_icon"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStyleDone target:self action:nil];
    [rightItem setActionBlock:^(id _Nonnull sender) {
        
    }];
    self.navigationItem.rightBarButtonItem = rightItem;
}

@end
