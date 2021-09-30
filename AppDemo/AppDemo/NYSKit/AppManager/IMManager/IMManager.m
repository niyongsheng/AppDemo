//
//  IMManager.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "IMManager.h"
#import <RongIMKit/RongIMKit.h>
#import "IMDataSource.h"

@interface IMManager ()

@end

@implementation IMManager

SINGLETON_FOR_CLASS(IMManager);

#pragma mark —- 初始化IM -—
- (void)initRongCloudIM {
    
    [[RCIM sharedRCIM] initWithAppKey:RCAPPKEY_DEV];
    // 设置优先使用WebView打开URL
    [RCIM sharedRCIM].embeddedWebViewPreferred = YES;
    // 开启用户信息和群组信息的持久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    // 信息提供者
    [RCIM sharedRCIM].userInfoDataSource = [IMDataSource sharedIMDataSource];
    [RCIM sharedRCIM].groupInfoDataSource = [IMDataSource sharedIMDataSource];
    [RCIM sharedRCIM].groupMemberDataSource = [IMDataSource sharedIMDataSource];
    RCKitConfigCenter.ui.enableDarkMode = YES;
    RCKitConfigCenter.ui.globalNavigationBarTintColor = NAppThemeColor;
    // 开启多端同步未读状态
    RCKitConfigCenter.message.enableSyncReadStatus = YES;
    // 开启输入状态提醒
    RCKitConfigCenter.message.enableTypingStatus = YES;
    // 开启消息撤回功能
    RCKitConfigCenter.message.enableMessageRecall = YES;
    // 选择媒体资源时，包含视频文件
    RCKitConfigCenter.message.isMediaSelectorContainVideo = YES;
    // 开启@功能
    RCKitConfigCenter.message.enableMessageMentioned = YES;
    // 设置头像为圆形
    RCKitConfigCenter.ui.globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    RCKitConfigCenter.ui.globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    // 离线历史消息（30天）
    [[RCIMClient sharedRCIMClient] setOfflineMessageDuration:30 success:^{
        
    } failure:^(RCErrorCode nErrorCode) {
        
    }];
    // 判断是否重连
    if ([[RCIMClient sharedRCIMClient] getConnectionStatus] != ConnectionStatus_Connected) {
        [self IMLoginCompletion:^(BOOL success, id  _Nullable description) {
            
        }];
    };
}

#pragma mark —- IM登录 --
- (void)IMLoginCompletion:(loginBlock)completion {
    NSString *imToken = NUpdateUserInfo.rongyunToken;
    [[RCIM sharedRCIM] connectWithToken:imToken
                               dbOpened:^(RCDBErrorCode code) {
        
    } success:^(NSString *userId) {
        NLog(@"登陆成功。当前登录的用户ID：%@", userId);
        // 设置当前登录的用户的用户信息
        RCUserInfo *RCCurrentUserInfo = [[RCUserInfo alloc] init];
        RCCurrentUserInfo.name = NUpdateUserInfo.profile.nickname;
        RCCurrentUserInfo.portraitUri = NUpdateUserInfo.profile.headPhoto;
        RCCurrentUserInfo.userId = userId;
        [[RCIM sharedRCIM] setCurrentUserInfo:RCCurrentUserInfo];
    } error:^(RCConnectErrorCode errorCode) {
        completion(NO, [NSString stringWithFormat:@"IM登陆错误码:%zd", errorCode]);
    }];
}

#pragma mark —- IM退出 —-
- (void)IMLogout {
    [[RCIM sharedRCIM] logout];
    [[RCIMClient sharedRCIMClient] disconnect:YES];
}

@end
