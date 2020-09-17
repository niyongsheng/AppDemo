#import <UIKit/UIKit.h>
#import "NYSEstate.h"
#import "NYSCommunity.h"
#import "NYSProfile.h"

@interface NYSUpdateUserInfo : NSObject

@property (nonatomic, strong) NSString * account;
@property (nonatomic, strong) NSString * alias;
@property (nonatomic, strong) NYSEstate * estate;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger lastCommunity;
@property (nonatomic, strong) NYSCommunity * lastStoreCommunity;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NYSProfile * profile;
@property (nonatomic, strong) NSString * rongyunToken;
@property (nonatomic, strong) NSArray * tags;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end