//
//  NSError+NYS.h
//  NYS
//
//  Created by niyongsheng on 2021/8/10.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//domain
FOUNDATION_EXPORT NSString *const NSNYSErrorDomain;

/**错误状态码*/
typedef NS_ENUM(NSInteger, NSNYSErrorCode){
    NSNYSErrorCodeUnKnow = -1000,
    NSNYSErrorCodeSuccess = -1001,
    NSNYSErrorCodefailed = -1002,
};

@interface NSError (NYS)

+ (NSError*)errorCode:(NSNYSErrorCode)code;

+ (NSError*)errorCode:(NSNYSErrorCode)code userInfo:(nullable NSDictionary*)userInfo;

+ (NSError*)errorCode:(NSNYSErrorCode)code description:(NSString*)description reason:(NSString*)reason suggestion:(NSString*)suggestion;

/// 自定义错误
/// @param code 错误代码
/// @param description 描述
/// @param reason 原因
/// @param suggestion 建议
/// @param imageName 图片名key:@"NSLocalizedPlaceholderImageName"
+ (NSError*)errorCode:(NSNYSErrorCode)code description:(NSString *)description reason:(NSString *)reason suggestion:(NSString *)suggestion placeholderImg:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
