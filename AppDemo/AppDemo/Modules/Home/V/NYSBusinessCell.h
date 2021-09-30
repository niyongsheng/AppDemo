//
//  NYSBusinessCell.h
//  NewAnju_IOS
//
//  Created by 倪永胜 on 2020/4/6.
//  Copyright © 2020 NiYongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NYSBusinessModel;

@interface NYSBusinessCell : UICollectionViewCell
@property (nonatomic, weak) NYSBusinessModel *businessModel;
@end

NS_ASSUME_NONNULL_END
