//
//  NYSBaseObject.m
//  NYS
//
//  Created by niyongsheng on 2021/8/7.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSBaseObject.h"

@implementation NYSBaseObject
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"des" : @"ext.desc",
        @"ID" : @"id",
        @"xid" : @[@"id"]
    };
}
@end
