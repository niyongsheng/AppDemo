//
//  UMManager.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UMManager : NSObject

SINGLETON_FOR_HEADER(UMManager);

/** 分享弹框 */
- (void)showShareView;

@end

NS_ASSUME_NONNULL_END
