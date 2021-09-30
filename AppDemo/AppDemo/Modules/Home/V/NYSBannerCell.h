//
//  NYSBannerCollectionViewCell.h
//  DaoCaoDui_IOS
//
//  Created by 倪永胜 on 2019/12/11.
//  Copyright © 2019 NiYongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NYSBannerModel;

@interface NYSBannerCell : UICollectionViewCell

@property (nonatomic, weak) NYSBannerModel *bannerModel;
@end

NS_ASSUME_NONNULL_END
