//
//  NYSOpenPresenter.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/18.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSBasePresenter.h"
#import "NYSOpenViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NYSOpenPresenter : NYSBasePresenter <id<NYSOpenViewProtocol>>

/**
 这个是对外的入口，通过这个入口，实现多个对内部的操作，外部只要调用这个接口就可以了
 */
- (void)fetchData;

@end

NS_ASSUME_NONNULL_END
