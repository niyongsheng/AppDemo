//
//	NYSUserInfo.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NYSUserInfo.h"

NSString *const kNYSUserInfoAlias = @"alias";
NSString *const kNYSUserInfoEstate = @"estate";
NSString *const kNYSUserInfoExpireTime = @"expire_time";
NSString *const kNYSUserInfoLastCommunity = @"last_community";
NSString *const kNYSUserInfoLastStoreCommunity = @"last_store_community";
NSString *const kNYSUserInfoToken = @"token";

@interface NYSUserInfo ()
@end
@implementation NYSUserInfo




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNYSUserInfoAlias] isKindOfClass:[NSNull class]]){
		self.alias = dictionary[kNYSUserInfoAlias];
	}	
	if(![dictionary[kNYSUserInfoEstate] isKindOfClass:[NSNull class]]){
		self.estate = [[NYSEstate alloc] initWithDictionary:dictionary[kNYSUserInfoEstate]];
	}

	if(![dictionary[kNYSUserInfoExpireTime] isKindOfClass:[NSNull class]]){
		self.expireTime = [dictionary[kNYSUserInfoExpireTime] integerValue];
	}

	if(![dictionary[kNYSUserInfoLastCommunity] isKindOfClass:[NSNull class]]){
		self.lastCommunity = [dictionary[kNYSUserInfoLastCommunity] integerValue];
	}

	if(![dictionary[kNYSUserInfoLastStoreCommunity] isKindOfClass:[NSNull class]]){
		self.lastStoreCommunity = [[NYSCommunity alloc] initWithDictionary:dictionary[kNYSUserInfoLastStoreCommunity]];
	}

	if(![dictionary[kNYSUserInfoToken] isKindOfClass:[NSNull class]]){
		self.token = dictionary[kNYSUserInfoToken];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.alias != nil){
		dictionary[kNYSUserInfoAlias] = self.alias;
	}
	if(self.estate != nil){
		dictionary[kNYSUserInfoEstate] = [self.estate toDictionary];
	}
	dictionary[kNYSUserInfoExpireTime] = @(self.expireTime);
	dictionary[kNYSUserInfoLastCommunity] = @(self.lastCommunity);
	if(self.lastStoreCommunity != nil){
		dictionary[kNYSUserInfoLastStoreCommunity] = [self.lastStoreCommunity toDictionary];
	}
	if(self.token != nil){
		dictionary[kNYSUserInfoToken] = self.token;
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
	if(self.alias != nil){
		[aCoder encodeObject:self.alias forKey:kNYSUserInfoAlias];
	}
	if(self.estate != nil){
		[aCoder encodeObject:self.estate forKey:kNYSUserInfoEstate];
	}
	[aCoder encodeObject:@(self.expireTime) forKey:kNYSUserInfoExpireTime];	[aCoder encodeObject:@(self.lastCommunity) forKey:kNYSUserInfoLastCommunity];	if(self.lastStoreCommunity != nil){
		[aCoder encodeObject:self.lastStoreCommunity forKey:kNYSUserInfoLastStoreCommunity];
	}
	if(self.token != nil){
		[aCoder encodeObject:self.token forKey:kNYSUserInfoToken];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.alias = [aDecoder decodeObjectForKey:kNYSUserInfoAlias];
	self.estate = [aDecoder decodeObjectForKey:kNYSUserInfoEstate];
	self.expireTime = [[aDecoder decodeObjectForKey:kNYSUserInfoExpireTime] integerValue];
	self.lastCommunity = [[aDecoder decodeObjectForKey:kNYSUserInfoLastCommunity] integerValue];
	self.lastStoreCommunity = [aDecoder decodeObjectForKey:kNYSUserInfoLastStoreCommunity];
	self.token = [aDecoder decodeObjectForKey:kNYSUserInfoToken];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NYSUserInfo *copy = [NYSUserInfo new];

	copy.alias = [self.alias copy];
	copy.estate = [self.estate copy];
	copy.expireTime = self.expireTime;
	copy.lastCommunity = self.lastCommunity;
	copy.lastStoreCommunity = [self.lastStoreCommunity copy];
	copy.token = [self.token copy];

	return copy;
}
@end