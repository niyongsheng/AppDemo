//
//  NYSBillboardCell.h
//  NYS
//
//  Created by niyongsheng on 2021/8/7.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NYSBillboardModel;

@interface NYSBillboardCell : UICollectionViewCell
@property (nonatomic, weak) NYSBillboardModel *billboardModel;
@end

NS_ASSUME_NONNULL_END
