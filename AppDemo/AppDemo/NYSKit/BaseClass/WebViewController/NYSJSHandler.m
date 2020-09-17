//
//  NYSJSHandler.m
//  DaoCaoDui_IOS
//
//  Created by 倪永胜 on 2019/5/29.
//  Copyright © 2019 NiYongsheng. All rights reserved.
//

#import "NYSJSHandler.h"

@implementation NYSJSHandler

- (instancetype)initWithViewController:(UIViewController *)webVC configuration:(WKWebViewConfiguration *)configuration {
    self = [super init];
    if (self) {
        self.webVC = webVC;
        self.configuration = configuration;
        //js handler
        //注册JS 事件
        //        [configuration.userContentController addScriptMessageHandler:self name:@"showImages"];
        [configuration.userContentController addScriptMessageHandler:self name:@"backPage"];
        //        [configuration.userContentController addScriptMessageHandler:self name:@"showVideo"];
        //        [configuration.userContentController addScriptMessageHandler:self name:@"issueMoment"];
        //        [configuration.userContentController addScriptMessageHandler:self name:@"JSShare"];
        
    }
    return self;
}

#pragma mark -  JS 调用 Native  代理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"backPage"]) {
        //返回
        if (self.webVC.presentingViewController) {
            [self.webVC dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.webVC.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark -  记得要移除
- (void)cancelHandler {
    //    [_configuration.userContentController removeScriptMessageHandlerForName:@"showImages"];
    [_configuration.userContentController removeScriptMessageHandlerForName:@"backPage"];
    //    [_configuration.userContentController removeScriptMessageHandlerForName:@"showVideo"];
    //    [_configuration.userContentController removeScriptMessageHandlerForName:@"issueMoment"];
    //    [_configuration.userContentController removeScriptMessageHandlerForName:@"JSShare"];
}

- (void)dealloc {
    
}

@end
