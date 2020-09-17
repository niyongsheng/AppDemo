//
//  IMDataSource.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/10.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "IMDataSource.h"
#define DefaultGroupName @"未知群聊"
#define DefaultGroupIcon @"http://zhaijidi.qmook.com/icon-1024.png"
#define DefaultUserName @"未知私聊"
#define DefaultUserIcon @"http://zhaijidi.qmook.com/morentouxiang@3x.png"

@interface GroupMember : NSObject
@property (nonatomic, strong) NSString *member;
@end

@implementation IMDataSource

SINGLETON_FOR_CLASS(IMDataSource);

#pragma mark - GroupInfoFetcherDelegate
- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *groupInfo))completion; {
    RCGroup *groupInfo = [RCGroup new];
    groupInfo.groupId = groupId;
    groupInfo.groupName = DefaultGroupName;
    groupInfo.portraitUri = DefaultGroupIcon;
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = NUserManager.userInfo.token;
    parames[@"id"] = @(groupId.intValue);
    NYSRequest *request = [[NYSRequest alloc] initWithMethod:YTKRequestMethodGET
                                                         Url:@"/activity/group_info"
                                                    Argument:parames];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        id response = request.responseJSONObject;
        NSDictionary *activityDetailDict = [response objectForKey:@"activity"];
        if (![activityDetailDict isKindOfClass:[NSNull class]]) {
            groupInfo.groupName = activityDetailDict[@"title"];
            groupInfo.portraitUri = activityDetailDict[@"cover_image"];
        }
        completion(groupInfo);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completion(groupInfo);
    }];
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    RCUserInfo *user = [RCUserInfo new];
    user.userId = userId;
    user.name = DefaultUserName;
    user.portraitUri = DefaultUserIcon;
    if (!NUserManager.userInfo.token) {
        completion(user);
        return;
    }
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = NUserManager.userInfo.token;
    NSArray<NSString *> *strArr = [userId componentsSeparatedByString:@"_"];
    parames[@"contact_id"] = @([[strArr lastObject] intValue]);
    parames[@"channel"] = @(2);
    parames[@"type"] = [[strArr firstObject] isEqual:@"acc"] ? @(1) : @(2);
    NYSRequest *request = [[NYSRequest alloc] initWithMethod:YTKRequestMethodGET
                                                         Url:@"/activity/contact_info"
                                                    Argument:parames];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        id response = request.responseJSONObject;
        NSDictionary *userInfoDict = response;
        if (![userInfoDict isKindOfClass:[NSNull class]]) {
            user.name = [[userInfoDict objectForKey:@"contact"] objectForKey:@"nickname"];
            user.portraitUri = [[userInfoDict objectForKey:@"contact"] objectForKey:@"head_photo"];
        }
        completion(user);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completion(user);
    }];
}

#pragma mark - RCIMGroupMemberDataSource
- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *))resultBlock {
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"token"] = NUserManager.userInfo.token;
    parames[@"page"] = @(1);
    parames[@"limit"] = @(2000);
    parames[@"id"] = @(groupId.intValue);
    NYSRequest *request = [[NYSRequest alloc] initWithMethod:YTKRequestMethodGET
                                                         Url:@"/activity/member_list"
                                                    Argument:parames];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        id response = request.responseJSONObject;
        NSArray *dictArr = [response objectForKey:@"memberList"];
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *activity in dictArr) {
            NSString *userId = [NSString stringWithFormat:@"acc_%ld", [[activity objectForKey:@"id"] integerValue]];
            [mutableArray addObject:userId];
        }
        resultBlock(mutableArray);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

@end
