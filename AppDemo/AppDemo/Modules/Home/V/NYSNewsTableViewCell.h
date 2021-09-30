//
//  NYSNewsTableViewCell.h
//  NewAnju_IOS
//
//  Created by 倪永胜 on 2020/4/9.
//  Copyright © 2020 NiYongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NYSNewsModel;

@interface NYSNewsTableViewCell : UITableViewCell
@property (nonatomic, weak) NYSNewsModel *newsModel;
@end

NS_ASSUME_NONNULL_END
