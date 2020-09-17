//
//  NYSJSHandler.h
//  DaoCaoDui_IOS
//
//  Created by 倪永胜 on 2019/5/29.
//  Copyright © 2019 NiYongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSJSHandler : NSObject <WKScriptMessageHandler>
@property (nonatomic, strong) UIViewController * webVC;
@property (nonatomic, strong) WKWebViewConfiguration * configuration;

- (instancetype)initWithViewController:(UIViewController *)webVC configuration:(WKWebViewConfiguration *)configuration;

- (void)cancelHandler;

@end

NS_ASSUME_NONNULL_END
