#import <UIKit/UIKit.h>
#import "NYSCommunity.h"

@interface NYSEstate : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NYSCommunity * community;
@property (nonatomic, assign) NSInteger houseId;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * inviteCode;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * username;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end