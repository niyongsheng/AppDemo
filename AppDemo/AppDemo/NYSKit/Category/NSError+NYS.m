//
//  NSError+NYS.m
//  NYS
//
//  Created by niyongsheng on 2021/8/10.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NSError+NYS.h"

NSString *const NSNYSErrorDomain = @"NSNYSErrorDomain";

@implementation NSError (NYS)

+ (NSError*)errorCode:(NSNYSErrorCode)code{
    return [self errorCode:code userInfo:nil];
}

+ (NSError*)errorCode:(NSNYSErrorCode)code userInfo:(nullable NSDictionary*)userInfo{
    if (userInfo) {
        return [NSError errorWithDomain:NSNYSErrorDomain code:code userInfo:userInfo];
    }else{
        return [NSError errorWithDomain:NSNYSErrorDomain code:code userInfo:
                @{
                    NSLocalizedDescriptionKey:@"Unknow Error",
                    NSLocalizedFailureReasonErrorKey:@"Unknow reason",
                    NSLocalizedRecoverySuggestionErrorKey:@"Retry",
                    @"NSCustomInfoKey": @"It's easy.",
                }];
    }
}

+ (NSError*)errorCode:(NSNYSErrorCode)code description:(NSString *)description reason:(NSString *)reason suggestion:(NSString *)suggestion {
    return [NSError errorWithDomain:NSNYSErrorDomain code:code userInfo:
            @{
                NSLocalizedDescriptionKey:description,
                NSLocalizedFailureReasonErrorKey:reason,
                NSLocalizedRecoverySuggestionErrorKey:suggestion
            }];
}

+ (NSError*)errorCode:(NSNYSErrorCode)code description:(NSString *)description reason:(NSString *)reason suggestion:(NSString *)suggestion placeholderImg:(NSString *)imageName {
    return [NSError errorWithDomain:NSNYSErrorDomain code:code userInfo:
            @{
                NSLocalizedDescriptionKey:description,
                NSLocalizedFailureReasonErrorKey:reason,
                NSLocalizedRecoverySuggestionErrorKey:suggestion,
                @"NSLocalizedPlaceholderImageName": imageName
            }];
}

@end
