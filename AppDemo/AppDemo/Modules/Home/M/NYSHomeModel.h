//
//  NYSActivityModel.h
//  DaoCaoDui_IOS
//
//  Created by 倪永胜 on 2019/12/13.
//  Copyright © 2019 NiYongsheng. All rights reserved.
//

#import "NYSBaseObject.h"

@class UserInfo;

NS_ASSUME_NONNULL_BEGIN

@interface NYSHomeModel : NYSBaseObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, assign) BOOL isRecommend;
@end

/// 轮播
@interface NYSBannerModel : NYSBaseObject
@property (nonatomic, strong) NSString * mediaLink;
@property (nonatomic, assign) NSInteger showSecond;
@property (nonatomic, strong) NSString * targetLink;
@property (nonatomic, strong) NSString * title;
@end

/// 公告
@interface NYSBillboardModel : NYSBaseObject
@property (nonatomic, strong) NSString * targetLink;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * richContent;
@end

/// 业务
@interface NYSBusinessModel : NYSBaseObject
@property (nonatomic, strong) NSString * defaultIconName;
@property (nonatomic, strong) NSString * icon_url;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * subtitle;
@end

/// 投票
@interface NYSVoteModel : NYSBaseObject
@property (nonatomic, strong) NSString * communityName;
@property (nonatomic, strong) NSString * describe;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString * title;
@end

/// 话题
@interface NYSTopicModel : NYSBaseObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger memberNum;
@property (nonatomic, strong) NSString * notice;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger isIn;
@property (nonatomic, strong) NSArray * memberAvatar;
@end

/// 新闻
@interface NYSNewsModel : NYSBaseObject
@property (nonatomic, strong) NSString * creater;
@property (nonatomic, strong) NSString * coverImage;
@property (nonatomic, strong) NSString * createTime;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * subtitle;
@end

NS_ASSUME_NONNULL_END
