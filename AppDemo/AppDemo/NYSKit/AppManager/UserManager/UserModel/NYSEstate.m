//
//	NYSEstate.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NYSEstate.h"

NSString *const kNYSEstateAddress = @"address";
NSString *const kNYSEstateCommunity = @"community";
NSString *const kNYSEstateHouseId = @"house_id";
NSString *const kNYSEstateIdField = @"id";
NSString *const kNYSEstateInviteCode = @"invite_code";
NSString *const kNYSEstatePhone = @"phone";
NSString *const kNYSEstateStatus = @"status";
NSString *const kNYSEstateUsername = @"username";

@interface NYSEstate ()
@end
@implementation NYSEstate




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNYSEstateAddress] isKindOfClass:[NSNull class]]){
		self.address = dictionary[kNYSEstateAddress];
	}	
	if(![dictionary[kNYSEstateCommunity] isKindOfClass:[NSNull class]]){
		self.community = [[NYSCommunity alloc] initWithDictionary:dictionary[kNYSEstateCommunity]];
	}

	if(![dictionary[kNYSEstateHouseId] isKindOfClass:[NSNull class]]){
		self.houseId = [dictionary[kNYSEstateHouseId] integerValue];
	}

	if(![dictionary[kNYSEstateIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kNYSEstateIdField] integerValue];
	}

	if(![dictionary[kNYSEstateInviteCode] isKindOfClass:[NSNull class]]){
		self.inviteCode = dictionary[kNYSEstateInviteCode];
	}	
	if(![dictionary[kNYSEstatePhone] isKindOfClass:[NSNull class]]){
		self.phone = dictionary[kNYSEstatePhone];
	}	
	if(![dictionary[kNYSEstateStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kNYSEstateStatus] integerValue];
	}

	if(![dictionary[kNYSEstateUsername] isKindOfClass:[NSNull class]]){
		self.username = dictionary[kNYSEstateUsername];
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
		dictionary[kNYSEstateAddress] = self.address;
	}
	if(self.community != nil){
		dictionary[kNYSEstateCommunity] = [self.community toDictionary];
	}
	dictionary[kNYSEstateHouseId] = @(self.houseId);
	dictionary[kNYSEstateIdField] = @(self.idField);
	if(self.inviteCode != nil){
		dictionary[kNYSEstateInviteCode] = self.inviteCode;
	}
	if(self.phone != nil){
		dictionary[kNYSEstatePhone] = self.phone;
	}
	dictionary[kNYSEstateStatus] = @(self.status);
	if(self.username != nil){
		dictionary[kNYSEstateUsername] = self.username;
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
		[aCoder encodeObject:self.address forKey:kNYSEstateAddress];
	}
	if(self.community != nil){
		[aCoder encodeObject:self.community forKey:kNYSEstateCommunity];
	}
	[aCoder encodeObject:@(self.houseId) forKey:kNYSEstateHouseId];	[aCoder encodeObject:@(self.idField) forKey:kNYSEstateIdField];	if(self.inviteCode != nil){
		[aCoder encodeObject:self.inviteCode forKey:kNYSEstateInviteCode];
	}
	if(self.phone != nil){
		[aCoder encodeObject:self.phone forKey:kNYSEstatePhone];
	}
	[aCoder encodeObject:@(self.status) forKey:kNYSEstateStatus];	if(self.username != nil){
		[aCoder encodeObject:self.username forKey:kNYSEstateUsername];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.address = [aDecoder decodeObjectForKey:kNYSEstateAddress];
	self.community = [aDecoder decodeObjectForKey:kNYSEstateCommunity];
	self.houseId = [[aDecoder decodeObjectForKey:kNYSEstateHouseId] integerValue];
	self.idField = [[aDecoder decodeObjectForKey:kNYSEstateIdField] integerValue];
	self.inviteCode = [aDecoder decodeObjectForKey:kNYSEstateInviteCode];
	self.phone = [aDecoder decodeObjectForKey:kNYSEstatePhone];
	self.status = [[aDecoder decodeObjectForKey:kNYSEstateStatus] integerValue];
	self.username = [aDecoder decodeObjectForKey:kNYSEstateUsername];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NYSEstate *copy = [NYSEstate new];

	copy.address = [self.address copy];
	copy.community = [self.community copy];
	copy.houseId = self.houseId;
	copy.idField = self.idField;
	copy.inviteCode = [self.inviteCode copy];
	copy.phone = [self.phone copy];
	copy.status = self.status;
	copy.username = [self.username copy];

	return copy;
}
@end