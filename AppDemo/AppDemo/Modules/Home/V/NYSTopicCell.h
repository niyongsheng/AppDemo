//
//  NYSTopicCell.h
//  NYS
//
//  Created by niyongsheng on 2021/8/7.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NYSTopicModel;

@interface NYSTopicCell : UICollectionViewCell
@property (nonatomic, weak) NYSTopicModel *topicModel;
@end

NS_ASSUME_NONNULL_END
