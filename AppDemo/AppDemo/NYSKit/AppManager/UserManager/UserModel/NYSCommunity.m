//
//	NYSCommunity.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NYSCommunity.h"

NSString *const kNYSCommunityAddress = @"address";
NSString *const kNYSCommunityIdField = @"id";
NSString *const kNYSCommunityName = @"name";

@interface NYSCommunity ()
@end
@implementation NYSCommunity




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNYSCommunityAddress] isKindOfClass:[NSNull class]]){
		self.address = dictionary[kNYSCommunityAddress];
	}	
	if(![dictionary[kNYSCommunityIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kNYSCommunityIdField] integerValue];
	}

	if(![dictionary[kNYSCommunityName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kNYSCommunityName];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.address != nil){
		dictionary[kNYSCommunityAddress] = self.address;
	}
	dictionary[kNYSCommunityIdField] = @(self.idField);
	if(self.name != nil){
		dictionary[kNYSCommunityName] = self.name;
	}
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	if(self.address != nil){
		[aCoder encodeObject:self.address forKey:kNYSCommunityAddress];
	}
	[aCoder encodeObject:@(self.idField) forKey:kNYSCommunityIdField];	if(self.name != nil){
		[aCoder encodeObject:self.name forKey:kNYSCommunityName];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.address = [aDecoder decodeObjectForKey:kNYSCommunityAddress];
	self.idField = [[aDecoder decodeObjectForKey:kNYSCommunityIdField] integerValue];
	self.name = [aDecoder decodeObjectForKey:kNYSCommunityName];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NYSCommunity *copy = [NYSCommunity new];

	copy.address = [self.address copy];
	copy.idField = self.idField;
	copy.name = [self.name copy];

	return copy;
}
@end