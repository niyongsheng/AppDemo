//
//  TableViewAnimationKitConfig.h
//  TableViewAnimationKit-OC
//
//  Created by 王小树 on 17/9/9.
//  Copyright © 2017年 com.cn.fql. All rights reserved.
//

#ifndef TableViewAnimationKitConfig_h
#define TableViewAnimationKitConfig_h

typedef NS_ENUM(NSInteger,XSTableViewAnimationType){
    XSTableViewAnimationTypeMove = 0, // 从左至右依次滑入
    XSTableViewAnimationTypeMoveSpring = 0, // 类似上一个
    XSTableViewAnimationTypeAlpha, // 从左至右依次滑入 回弹
    XSTableViewAnimationTypeFall, // 渐变从上至下依次进入
    XSTableViewAnimationTypeShake, // 从下自上依次堆叠
    XSTableViewAnimationTypeOverTurn, // 左右穿插
    XSTableViewAnimationTypeToTop, // 从上至下依次翻转
    XSTableViewAnimationTypeSpringList, // 从下自上依次堆叠
    XSTableViewAnimationTypeShrinkToTop, // 从上至下依次翻转 弹性
    XSTableViewAnimationTypeLayDown, // 从下自上收缩
    XSTableViewAnimationTypeRote, // 从上至下滚动展开
};

#endif /* TableViewAnimationKitConfig_h */
