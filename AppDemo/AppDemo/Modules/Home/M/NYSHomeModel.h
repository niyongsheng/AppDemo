//
//  NYSActivityModel.h
//  DaoCaoDui_IOS
//
//  Created by 倪永胜 on 2019/12/13.
//  Copyright © 2019 NiYongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;

NS_ASSUME_NONNULL_BEGIN

@interface NYSHomeModel : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, assign) BOOL isRecommend;
@end

NS_ASSUME_NONNULL_END
