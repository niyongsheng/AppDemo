#import <UIKit/UIKit.h>
#import "NYSEstate.h"
#import "NYSCommunity.h"

@interface NYSUserInfo : NSObject

@property (nonatomic, strong) NSString * alias;
@property (nonatomic, strong) NYSEstate * estate;
@property (nonatomic, assign) NSInteger expireTime;
@property (nonatomic, assign) NSInteger lastCommunity;
@property (nonatomic, strong) NYSCommunity * lastStoreCommunity;
@property (nonatomic, strong) NSString * token;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end