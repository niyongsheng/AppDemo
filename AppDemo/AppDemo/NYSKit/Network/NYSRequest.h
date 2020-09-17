//
//  NYSRequest.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSRequest : YTKBaseRequest

- (id)initWithMethod:(YTKRequestMethod)method Url:(NSString *)url Argument:(id)argument;

@end

NS_ASSUME_NONNULL_END
