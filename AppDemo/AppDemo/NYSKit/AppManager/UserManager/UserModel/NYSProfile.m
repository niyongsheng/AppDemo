//
//	NYSProfile.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NYSProfile.h"

NSString *const kNYSProfileAge = @"age";
NSString *const kNYSProfileBirthDate = @"birth_date";
NSString *const kNYSProfileHeadPhoto = @"head_photo";
NSString *const kNYSProfileNickname = @"nickname";
NSString *const kNYSProfileRealname = @"realname";
NSString *const kNYSProfileSex = @"sex";
NSString *const kNYSProfileSignature = @"signature";

@interface NYSProfile ()
@end
@implementation NYSProfile




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNYSProfileAge] isKindOfClass:[NSNull class]]){
		self.age = [dictionary[kNYSProfileAge] integerValue];
	}

	if(![dictionary[kNYSProfileBirthDate] isKindOfClass:[NSNull class]]){
		self.birthDate = dictionary[kNYSProfileBirthDate];
	}	
	if(![dictionary[kNYSProfileHeadPhoto] isKindOfClass:[NSNull class]]){
		self.headPhoto = dictionary[kNYSProfileHeadPhoto];
	}	
	if(![dictionary[kNYSProfileNickname] isKindOfClass:[NSNull class]]){
		self.nickname = dictionary[kNYSProfileNickname];
	}	
	if(![dictionary[kNYSProfileRealname] isKindOfClass:[NSNull class]]){
		self.realname = dictionary[kNYSProfileRealname];
	}	
	if(![dictionary[kNYSProfileSex] isKindOfClass:[NSNull class]]){
		self.sex = [dictionary[kNYSProfileSex] integerValue];
	}

	if(![dictionary[kNYSProfileSignature] isKindOfClass:[NSNull class]]){
		self.signature = dictionary[kNYSProfileSignature];
	}	
	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kNYSProfileAge] = @(self.age);
	if(self.birthDate != nil){
		dictionary[kNYSProfileBirthDate] = self.birthDate;
	}
	if(self.headPhoto != nil){
		dictionary[kNYSProfileHeadPhoto] = self.headPhoto;
	}
	if(self.nickname != nil){
		dictionary[kNYSProfileNickname] = self.nickname;
	}
	if(self.realname != nil){
		dictionary[kNYSProfileRealname] = self.realname;
	}
	dictionary[kNYSProfileSex] = @(self.sex);
	if(self.signature != nil){
		dictionary[kNYSProfileSignature] = self.signature;
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
	[aCoder encodeObject:@(self.age) forKey:kNYSProfileAge];	if(self.birthDate != nil){
		[aCoder encodeObject:self.birthDate forKey:kNYSProfileBirthDate];
	}
	if(self.headPhoto != nil){
		[aCoder encodeObject:self.headPhoto forKey:kNYSProfileHeadPhoto];
	}
	if(self.nickname != nil){
		[aCoder encodeObject:self.nickname forKey:kNYSProfileNickname];
	}
	if(self.realname != nil){
		[aCoder encodeObject:self.realname forKey:kNYSProfileRealname];
	}
	[aCoder encodeObject:@(self.sex) forKey:kNYSProfileSex];	if(self.signature != nil){
		[aCoder encodeObject:self.signature forKey:kNYSProfileSignature];
	}

}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.age = [[aDecoder decodeObjectForKey:kNYSProfileAge] integerValue];
	self.birthDate = [aDecoder decodeObjectForKey:kNYSProfileBirthDate];
	self.headPhoto = [aDecoder decodeObjectForKey:kNYSProfileHeadPhoto];
	self.nickname = [aDecoder decodeObjectForKey:kNYSProfileNickname];
	self.realname = [aDecoder decodeObjectForKey:kNYSProfileRealname];
	self.sex = [[aDecoder decodeObjectForKey:kNYSProfileSex] integerValue];
	self.signature = [aDecoder decodeObjectForKey:kNYSProfileSignature];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	NYSProfile *copy = [NYSProfile new];

	copy.age = self.age;
	copy.birthDate = [self.birthDate copy];
	copy.headPhoto = [self.headPhoto copy];
	copy.nickname = [self.nickname copy];
	copy.realname = [self.realname copy];
	copy.sex = self.sex;
	copy.signature = [self.signature copy];

	return copy;
}
@end