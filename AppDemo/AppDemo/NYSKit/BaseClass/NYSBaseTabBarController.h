//
//  NYSBaseTabBarController.h
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/14.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSBaseTabBarController : UITabBarController
/// sub view controllers
@property (nonatomic, strong) NSArray <NSDictionary *> *VCArray;
@end

NS_ASSUME_NONNULL_END
