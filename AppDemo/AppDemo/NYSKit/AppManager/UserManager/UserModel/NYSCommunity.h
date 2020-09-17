#import <UIKit/UIKit.h>

@interface NYSCommunity : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * name;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end