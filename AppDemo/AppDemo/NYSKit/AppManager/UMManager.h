//
//  UMManager.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UShareUI/UShareUI.h>

@interface UMManager : NSObject

SINGLETON_FOR_HEADER(UMManager);

/** 分享弹框 */
- (void)showShareView;

/// 第三方登录
/// @param loginType 登录方式
/// @param currentViewController 控制器
/// @param completion 回调
- (void)thirdSignInWithPlatform:(UserLoginType)loginType currentViewController:(id)currentViewController completion:(UMSocialRequestCompletionHandler)completion;

@end

