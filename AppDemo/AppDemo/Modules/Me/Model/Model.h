//
//  Model.h
//  NYSTKDemo
//
//  Created by 倪永胜 on 2020/9/4.
//  Copyright © 2020 倪永胜. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Model : NSObject
@property (copy, nonatomic) NSString *header;
@property (assign, nonatomic) NSInteger tintModel;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *detailTitles;
@end

NS_ASSUME_NONNULL_END
