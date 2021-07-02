//
//  NYSOpenViewController.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSOpenViewController.h"
#import "NYSOpenViewProtocol.h"
#import "NYSOpenPresenter.h"

@interface NYSOpenViewController () <NYSOpenViewProtocol>
@property (nonatomic, strong) NYSOpenPresenter *openpresenter;

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *darkModeBrn;

@end

@implementation NYSOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ViewRadius(_darkModeBrn, 7.0f);
    self.content.font = [UIFont fontWithName:@"04b_03b" size:25.0f];
    if (CurrentSystemVersion < 13.0) {
        self.content.lee_theme
        .LeeAddTextColor(DAY , [UIColor blackColor])
        .LeeAddTextColor(NIGHT, [UIColor whiteColor]);
    }
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self setupData];
}

- (void)setupData {
    [self.openpresenter fetchData];
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

- (IBAction)darkModeBtnOnclicked:(UIButton *)sender {

//    NSURL *url = [NSURL URLWithString:@"app-Prefs:root=Brightness"];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end
