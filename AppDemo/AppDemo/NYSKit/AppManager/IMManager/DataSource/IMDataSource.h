//
//  IMDataSource.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
*  此类写了一个provider的具体示例，开发者可以根据此类结构实现provider
*  用户信息和群组信息都要通过回传id请求服务器获取，参考具体实现代码。
*/
@interface IMDataSource : NSObject <RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCIMGroupMemberDataSource>

SINGLETON_FOR_HEADER(IMDataSource);

@end

NS_ASSUME_NONNULL_END
