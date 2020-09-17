//
//  NYSBasePresenter.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/18.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSBasePresenter<E> : NSObject {
    // MVP中负责更新的视图
    __weak E _attachView;
}

/**
 初始化函数
 
 @param attachView 要绑定的视图
 */
- (instancetype)initWithView:(E)attachView;

/**
 * 绑定视图
 * @param attachView 要绑定的视图
 */
- (void)attachView:(E)attachView;

/**
 解绑视图
 */
- (void)detachAttachView;

@end

NS_ASSUME_NONNULL_END
