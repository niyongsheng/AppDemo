//
//  NYSLoginViewController.m
//  BaseIOS
//
//  Created by niyongsheng on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSLoginViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>
#import "NYSRegisterViewController.h"
#import "NYSForgetPasswordViewController.h"

API_AVAILABLE(ios(13.0))
@interface NYSLoginViewController ()
<
ASAuthorizationControllerDelegate,
ASAuthorizationControllerPresentationContextProviding
>
@property (strong, nonatomic) ASAuthorizationAppleIDButton *appleSignBtn;

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation NYSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTheme];
    ViewRadius(_loginBtn, 7.0f);
    
    if (@available(iOS 13.0, *)) {
        [self appleSignBtn];
    }
}

#pragma mark - Sign With Apple
- (ASAuthorizationAppleIDButton *)appleSignBtn API_AVAILABLE(ios(13.0)) {
    if (!_appleSignBtn) {
        _appleSignBtn = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleBlack];
        _appleSignBtn.layer.cornerRadius = 7.0f;
        _appleSignBtn.layer.masksToBounds = YES;
        [_appleSignBtn addTarget:self action:@selector(appleSignBtnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_appleSignBtn];
        _appleSignBtn.sd_layout
        .centerXEqualToView(_loginBtn)
        .topSpaceToView(_loginBtn, 20.0f)
        .widthRatioToView(_loginBtn, 1)
        .heightRatioToView(_loginBtn, 1);
    }
    return _appleSignBtn;
}

- (void)appleSignBtnOnClicked:(ASAuthorizationAppleIDButton *)sender API_AVAILABLE(ios(13.0)) {
    ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
    appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    
    ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest]];
    authorizationController.delegate = self;
    authorizationController.presentationContextProvider = self;
    [authorizationController performRequests];
}

/// 通知代理在哪个window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)) {
    for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            UIWindow *window = windowScene.windows.firstObject;
            return window;
        }
    }
    return nil;
}

#pragma mark - ASAuthorizationControllerDelegate
/// 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
    NSString *errorMsg = nil;
    
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
            
        default:
            break;
    }
    [SVProgressHUD showErrorWithStatus:errorMsg];
    [SVProgressHUD dismissWithDelay:1.0f];
}

/// 授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential *appleIDCredential = (ASAuthorizationAppleIDCredential *)authorization.credential;
        NSString *appleUserId = appleIDCredential.user;
        // 钥匙串的方式保存
        [NYSSignHandleKeyChain save:KEYCHAIN_IDENTIFIER(@"SignInWithApple") data:appleUserId];
        // 登录请求
        [NUserManager login:NUserLoginTypeApple
                     params:@{@"oauth_key" : appleUserId ? appleUserId : @"",
                              @"oauth_type":@"apple"
                     }
                 completion:^(BOOL success, id description) {
            
        }];
    } else {
        [SVProgressHUD showInfoWithStatus:@"授权信不符"];
        [SVProgressHUD dismissWithDelay:1.f];
    }
}

- (IBAction)loginBtnOnClicked:(UIButton *)sender {
    [NYSTools zoomToShow:sender];
    
    [NUserManager login:NUserLoginTypePwd
                 params:@{@"phone" : _accountTextField.text, @"password" : _passwordTextField.text}
             completion:^(BOOL success, id description) {
        if (success) {
            [SVProgressHUD showSuccessWithStatus:@"Login success"];
            [SVProgressHUD dismissWithDelay:1.f completion:^{
                NPostNotification(NNotificationLoginStateChange, @YES)
            }];
        } else {
            [SVProgressHUD showInfoWithStatus:description];
            [SVProgressHUD dismissWithDelay:1.f];
        }
    }];
}

- (void)configTheme {
    
    if (CurrentSystemVersion < 13.0) {
        self.accountTextField.lee_theme
        .LeeAddBackgroundColor(DAY , LEEColorRGB(255, 255, 255))
        .LeeAddBackgroundColor(NIGHT, LEEColorRGB(85, 85, 85));
        
        self.passwordTextField.lee_theme
        .LeeAddBackgroundColor(DAY , LEEColorRGB(255, 255, 255))
        .LeeAddBackgroundColor(NIGHT, LEEColorRGB(85, 85, 85));
        
        self.view.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    }
}

#pragma mark - forget pd/regist
- (IBAction)forgetBtnDidClicked:(UIButton *)sender {
    NYSForgetPasswordViewController *forgetVC = [[NYSForgetPasswordViewController alloc] init];
    forgetVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:forgetVC animated:YES completion:nil];
}

- (IBAction)registBtnDidClicked:(UIButton *)sender {
    NYSRegisterViewController *registVC = [[NYSRegisterViewController alloc] init];
    registVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:registVC animated:YES completion:nil];
}

@end
