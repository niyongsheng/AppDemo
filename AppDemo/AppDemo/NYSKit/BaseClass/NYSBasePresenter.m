//
//  NYSBasePresenter.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/18.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSBasePresenter.h"

@implementation NYSBasePresenter

/**
 初始化函数
 */
- (instancetype)initWithView:(id)attachView {
    
    if (self = [super init]) {
        _attachView = attachView;
    }
    return self;
}

/**
 * 绑定视图
 * @param attachView 要绑定的视图
 */
- (void)attachView:(id)attachView {
    _attachView = attachView;
}

/**
 解绑视图
 */
- (void)detachAttachView {
    _attachView = nil;
}

@end
