//
//  NYSVoteCell.h
//  NewAnju_IOS
//
//  Created by 倪永胜 on 2020/11/2.
//  Copyright © 2020 NiYongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NYSVoteModel;

@interface NYSVoteCell : UICollectionViewCell

@property (strong, nonatomic) NYSVoteModel *voteModel;

@property (strong, nonatomic) UIViewController *fromViewController;

@end

NS_ASSUME_NONNULL_END
