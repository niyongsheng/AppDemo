//
//  NYSInviteViewController.m
//  NYS
//
//  Created by niyongsheng on 2021/8/21.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSInviteViewController.h"
#import <SGQRCode/SGQRCode.h>

@interface NYSInviteViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *qrImageV;

@end

@implementation NYSInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.qrImageV.image = [SGCreateCode createQRCodeWithData:@"https://github.com/kingsic" size:RealValue(200) logoImage:[UIImage imageNamed:@"logo"] ratio:NRadius];
}

@end
