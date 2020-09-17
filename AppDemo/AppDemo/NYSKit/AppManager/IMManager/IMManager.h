//
//  IMManager.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^loginBlock)(BOOL success, id _Nullable description);

NS_ASSUME_NONNULL_BEGIN

@interface IMManager : NSObject

SINGLETON_FOR_HEADER(IMManager);

/** 初始化IM */
- (void)initRongCloudIM;

/** 初始化IM
 @param completion 回调
 */
- (void)IMLoginCompletion:(loginBlock)completion;

/** 退出IM */
- (void)IMLogout;

@end

NS_ASSUME_NONNULL_END
