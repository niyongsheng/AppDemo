//
//  NYSCPSearchTableViewController.h
//  AppDemo
//
//  Created by niyongsheng on 2021/6/30.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NYSCountryModel;

NS_ASSUME_NONNULL_BEGIN

@interface NYSCPSearchTableViewController : UITableViewController
@property (nonatomic, strong) NSArray <NYSCountryModel *>*result;
@end

NS_ASSUME_NONNULL_END
