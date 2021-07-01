//
//  NYSCPModel.h
//  AppDemo
//
//  Created by niyongsheng on 2021/6/30.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYSCountryModel : NSObject
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *dialCode;
@end


@interface NYSCPModel : NSObject
@property (nonatomic, copy) NSString *groupKey;

@property (nonatomic, strong) NSArray <NYSCountryModel *> *countries;

+ (NSArray *)plistData;

+ (NSString *)localizedWithString:(NSString *)str;

@end




NS_ASSUME_NONNULL_END
