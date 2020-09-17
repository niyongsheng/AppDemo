#import <UIKit/UIKit.h>

@interface NYSProfile : NSObject

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString * birthDate;
@property (nonatomic, strong) NSString * headPhoto;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * realname;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString * signature;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end