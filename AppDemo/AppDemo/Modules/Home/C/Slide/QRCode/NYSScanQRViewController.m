//
//  NYSScanQRViewController.m
//  NYS
//
//  Created by niyongsheng on 2021/8/21.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSScanQRViewController.h"
#import <SGQRCode/SGQRCode.h>

@interface NYSScanQRViewController () {
    SGScanCode *scanCode;
}
@property (nonatomic, strong) SGScanView *scanView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL stop;

@end

@implementation NYSScanQRViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_stop) {
        [scanCode startRunningWithBefore:nil completion:nil];
    }
}

- (void)dealloc {
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scanCode = [SGScanCode scanCode];
    
    [self setupQRCodeScan];
    [self setupNavigationBar];
    [self.view addSubview:self.scanView];
    [self.scanView startScanning];
    [self.view addSubview:self.promptLabel];
}

- (void)setupQRCodeScan {
    __weak typeof(self) weakSelf = self;
    
    [scanCode scanWithController:self resultBlock:^(SGScanCode *scanCode, NSString *result) {
        if (result) {
            [scanCode stopRunning];
            weakSelf.stop = YES;
            [scanCode playSoundName:@"SGQRCode.bundle/scanEndSound.caf"];
//            ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//            [weakSelf.navigationController pushViewController:jumpVC animated:YES];
//
//            if ([result hasPrefix:@"http"]) {
//                jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
//                jumpVC.jump_URL = result;
//            } else {
//                jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
//                jumpVC.jump_bar_code = result;
//            }
        }
    }];
    
    [scanCode startRunningWithBefore:^{
        [NYSTKAlert clearDefaultValue];
        [NYSTKAlert showToastWithMessage:@"加载中..." animationType:NYSTKAnimationTypeNative themeModel:NYSTKThemeModelDark];
    } completion:^{
        [NYSTKAlert dismiss];
    }];
}

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
}

- (void)rightBarButtonItenAction {
    __weak typeof(self) weakSelf = self;
    
    [scanCode readWithResultBlock:^(SGScanCode *scanCode, NSString *result) {
        if (result == nil) {
            NSLog(@"暂未识别出二维码");
        } else {
//            if ([result hasPrefix:@"http"]) {
//                ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//                jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
//                jumpVC.jump_URL = result;
//                [weakSelf.navigationController pushViewController:jumpVC animated:YES];
//
//            } else {
//                ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//                jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
//                jumpVC.jump_bar_code = result;
//                [weakSelf.navigationController pushViewController:jumpVC animated:YES];
//            }
        }
    }];
}

- (SGScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scanView.scanLineName = @"SGQRCode.bundle/scanLineGrid";
        _scanView.scanStyle = ScanStyleGrid;
        _scanView.cornerLocation = CornerLoactionOutside;
        _scanView.cornerColor = NAppThemeColor;
    }
    return _scanView;
}
- (void)removeScanningView {
    [self.scanView stopScanning];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}

@end
