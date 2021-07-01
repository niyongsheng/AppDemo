//
//  NYSCPModel.m
//  AppDemo
//
//  Created by niyongsheng on 2021/6/30.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSCPModel.h"

@implementation NYSCountryModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"dialCode" : @"dial_code"};
}
@end

@implementation NYSCPModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupKey" : @"group_key",
             @"countries" : @"group_items"
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"countries" : [NYSCountryModel class]};
}

+ (NSBundle *)bundle {
    NSString *bundlepath = [[NSBundle bundleForClass:[NYSCPModel class]] pathForResource:@"country_phone_number" ofType:@"bundle"];
    return [NSBundle bundleWithPath:bundlepath];
}

+ (NSString *)localizedWithString:(NSString *)str {
    return NSLocalizedStringFromTableInBundle(str, @"PhoneZones", [self bundle], @"");
}

+ (NSArray *)plistData {
    NSString *pfLanguageCode = [NSLocale preferredLanguages][0];
    NSString *name = @"country";
    if ([pfLanguageCode containsString:@"en"]) {
        name = @"country_en";
    } else if ([pfLanguageCode containsString:@"Hant"]) {
        name = @"country_hant";
    }
    NSString *path = [[self bundle] pathForResource:name ofType:@"plist"];
    
    NSArray *dicts = [[NSArray array] initWithContentsOfFile:path];
    return dicts;
}

@end

