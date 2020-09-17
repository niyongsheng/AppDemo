//
//  NYSRequest.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSRequest.h"

@implementation NYSRequest {
    YTKRequestMethod _method;
    NSString *_url;
    id _argument;
    
}

- (id)initWithMethod:(YTKRequestMethod)method Url:(NSString *)url Argument:(id)argument {
    self = [super init];
    if (self) {
        _method = method;
        _url = url;
        _argument = argument;
        
    }
    return self;
}

- (NSString *)requestUrl {
    return _url;
}

- (YTKRequestMethod)requestMethod {
    return _method;
}

- (id)requestArgument {
    return _argument;
}

/// 服务器返回数据检查并返回
- (id)responseJSONObject {
    id responseObject = [super responseJSONObject];
    NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        if (code == 0) {
            // 0.正常无异常
            return [responseObject objectForKey:@"data"];
        } else {
            // x.其他服务器返回异常
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *exceptionStr = [responseObject objectForKey:@"message"];
                [SVProgressHUD showInfoWithStatus:exceptionStr];
                [SVProgressHUD dismissWithDelay:1.5f];
            });
            return nil;
        }
}

@end
