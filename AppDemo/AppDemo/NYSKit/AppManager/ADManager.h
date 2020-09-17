//
//  ADManager.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/16.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADManager : NSObject

SINGLETON_FOR_HEADER(ADManager);

/// 启动广告
- (void)showAD;

@end

NS_ASSUME_NONNULL_END
