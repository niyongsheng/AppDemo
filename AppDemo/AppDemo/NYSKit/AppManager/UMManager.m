//
//  UMManager.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "UMManager.h"
#import <UShareUI/UShareUI.h>

@implementation UMManager

SINGLETON_FOR_CLASS(UMManager);

- (void)showShareView {
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    // 显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType {
    // 创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    // 创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【安居公社】" descr:@"安居公社，让社区生活更简单。" thumImage:[UIImage imageNamed:@"share_item"]];
    // 设置网页地址
    shareObject.webpageUrl = AppStoreURL;
    
    // 分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    // 调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
#if defined(DEBUG)
        [self alertWithError:error];
#endif
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        } else {
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                // 分享结果消息
                UMSocialLogInfo(@"response message is %@", resp.message);
                // 第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@", resp.originalResponse);
            } else {
                UMSocialLogInfo(@"response data is %@", data);
            }
        }
    }];
}

- (void)alertWithError:(NSError *)error {
    NSString *result = nil;
    if (error) {
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        result = [NSString stringWithFormat:@"失败: %d\n%@",(int)error.code, str];
    } else {
        result = [NSString stringWithFormat:@"成功"];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分享结果" message:result preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"确定") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:alertAction];
    [NRootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
