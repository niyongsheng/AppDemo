//
//	NYSUpdateUserInfo.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NYSUpdateUserInfo.h"

NSString *const kNYSUpdateUserInfoAccount = @"account";
NSString *const kNYSUpdateUserInfoAlias = @"alias";
NSString *const kNYSUpdateUserInfoEstate = @"estate";
NSString *const kNYSUpdateUserInfoIdField = @"id";
NSString *const kNYSUpdateUserInfoLastCommunity = @"last_community";
NSString *const kNYSUpdateUserInfoLastStoreCommunity = @"last_store_community";
NSString *const kNYSUpdateUserInfoPhone = @"phone";
NSString *const kNYSUpdateUserInfoProfile = @"profile";
NSString *const kNYSUpdateUserInfoRongyunToken = @"rongyun_token";
NSString *const kNYSUpdateUserInfoTags = @"tags";

@interface NYSUpdateUserInfo ()
@end
@implementation NYSUpdateUserInfo




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNYSUpdateUserInfoAccount] isKindOfClass:[NSNull class]]){
		self.account = dictionary[kNYSUpdateUserInfoAccount];
	}	
	if(![dictionary[kNYSUpdateUserInfoAlias] isKindOfClass:[NSNull class]]){
		self.alias = dictionary[kNYSUpdateUserInfoAlias];
	}	
	if(![dictionary[kNYSUpdateUserInfoEstate] isKindOfClass:[NSNull class]]){
		self.estate = [[NYSEstate alloc] initWithDictionary:dictionary[kNYSUpdateUserInfoEstate]];
	}

	if(![dictionary[kNYSUpdateUserInfoIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kNYSUpdateUserInfoIdField] integerValue];
	}

	if(![dictionary[kNYSUpdateUserInfoLastCommunity] isKindOfClass:[NSNull class]]){
		self.lastCommunity = [dictionary[kNYSUpdateUserInfoLastCommunity] integerValue];
	}

	if(![dictionary[kNYSUpdateUserInfoLastStoreCommunity] isKindOfClass:[NSNull class]]){
		self.lastStoreCommunity = [[NYSCommunity alloc] initWithDictionary:dictionary[kNYSUpdateUserInfoLastStoreCommunity]];
	}

	if(![dictionary[kNYSUpdateUserInfoPhone] isKindOfClass:[NSNull class]]){
		self.phone = dictionary[kNYSUpdateUserInfoPhone];
	}	
	if(![dictionary[kNYSUpdateUserInfoProfile] isKindOfClass:[NSNull class]]){
		self.profile = [[NYSProfile alloc] initWithDictionary:dictionary[kNYSUpdateUserInfoProfile]];
	}

	if(![dictionary[kNYSUpdateUserInfoRongyunToken] isKindOfClass:[NSNull class]]){
		self.rongyunToken = dictionary[kNYSUpdateUserInfoRongyunToken];
	}	
	if(![dictionary[kNYSUpdateUserInfoTags] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[kNYSUpdateUserInfoTags];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	if(self.account != nil){
		dictionary[kNYSUpdateUserInfoAccount] = self.account;
	}
	if(self.alias != nil){
		dictionary[kNYSUpdateUserInfoAlias] = self.alias;
	}
	if(self.estate != nil){
		dictionary[kNYSUpdateUserInfoEstate] = [self.estate toDictionary];
	}
	dictionary[kNYSUpdateUserInfoIdField] = @(self.idField);
	dictionary[kNYSUpdateUserInfoLastCommunity] = @(self.lastCommunity);
	if(self.lastStoreCommunity != nil){
		dictionary[kNYSUpdateUserInfoLastStoreCommunity] = [self.lastStoreCommunity toDictionary];
	}
	if(self.phone != nil){
		dictionary[kNYSUpdateUserInfoPhone] = self.phone;
	}
	if(self.profile != nil){
		dictionary[kNYSUpdateUserInfoProfile] = [self.profile toDictionary];
	}
	if(self.rongyunToken != nil){
		dictionary[kNYSUpdateUserInfoRongyunToken] = self.rongyunToken;
	}
	if(self.tags != nil){
		dictionary[kNYSUpdateUserInfoTags] = self.tags;
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
	if(self.account != nil){
		[aCoder encodeObject:self.account forKey:kNYSUpdateUserInfoAccount];
	}
	if(self.alias != nil){
		[aCoder encodeObject:self.alias forKey:kNYSUpdateUserInfoAlias];
	}
	if(self.estate != nil){
		[aCoder encodeObject:self.estate forKey:kNYSUpdateUserInfoEstate];
	}
	[aCoder encodeObject:@(self.idField) forKey:kNYSUpdateUserInfoIdField];	[aCoder encodeObject:@(self.lastCommunity) forKey:kNYSUpdateUserInfoLastCommunity];	if(self.lastStoreCommunity != nil){
		[aCoder encodeObject:self.lastStoreCommunity forKey:kNYSUpdateUserInfoLastStoreCommunity];
	}
	if(self.phone != nil){
		[aCoder encodeObject:self.phone forKey:kNYSUpdateUserInfoPhone];
	}
	if(self.profile != nil){
		[aCoder encodeObject:self.profile forKey:kNYSUpdateUserInfoProfile];
	}
	if(self.rongyunToken != nil){
		[aCoder encodeObject:self.rongyunToken forKey:kNYSUpdateUserInfoRongyunToken];
	}
	if(self.tags != nil){
		[aCoder encodeObject:self.tags forKey:kNYSUpdateUserInfoTags];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.account = [aDecoder decodeObjectForKey:kNYSUpdateUserInfoAccount];
	self.alias = [aDecoder decodeObjectForKey:kNYSUpdateUserInfoAlias];
	self.estate = [aDecoder decodeObjectForKey:kNYSUpdateUserInfoEstate];
	self.idField = [[aDecoder decodeObjectForKey:kNYSUpdateUserInfoIdField] integerValue];
	self.lastCommunity = [[aDecoder decodeObjectForKey:kNYSUpdateUserInfoLastCommunity] integerValue];
	self.lastStoreCommunity = [aDecoder decodeObjectForKey:kNYSUpdateUserInfoLastStoreCommunity];
	self.phone = [aDecoder decodeObjectForKey:kNYSUpdateUserInfoPhone];
	self.profile = [aDecoder decodeObjectForKey:kNYSUpdateUserInfoProfile];
	self.rongyunToken = [aDecoder decodeObjectForKey:kNYSUpdateUserInfoRongyunToken];
	self.tags = [aDecoder decodeObjectForKey:kNYSUpdateUserInfoTags];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NYSUpdateUserInfo *copy = [NYSUpdateUserInfo new];

	copy.account = [self.account copy];
	copy.alias = [self.alias copy];
	copy.estate = [self.estate copy];
	copy.idField = self.idField;
	copy.lastCommunity = self.lastCommunity;
	copy.lastStoreCommunity = [self.lastStoreCommunity copy];
	copy.phone = [self.phone copy];
	copy.profile = [self.profile copy];
	copy.rongyunToken = [self.rongyunToken copy];
	copy.tags = [self.tags copy];

	return copy;
}
@end