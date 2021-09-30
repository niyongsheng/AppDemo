//
//  NYSBannerCollectionViewCell.m
//  DaoCaoDui_IOS
//
//  Created by 倪永胜 on 2019/12/11.
//  Copyright © 2019 NiYongsheng. All rights reserved.
//

#import "NYSBannerCell.h"
#import "NYSHomeModel.h"

@interface NYSBannerCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *bannerImageV;
@end

@implementation NYSBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.bannerImageV = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.bannerImageV.contentMode = UIViewContentModeScaleToFill;
        self.bannerImageV.layer.masksToBounds = YES;
        [self.contentView addSubview:self.bannerImageV];
        
//        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - RealValue(35), self.contentView.frame.size.width, RealValue(35))];
//        UIColor *color = [[UIColor blackColor] colorWithAlphaComponent:0.2];
//        self.title.backgroundColor = color;
//        self.title.textColor = [UIColor whiteColor];
//        self.title.numberOfLines = 1;
//        self.title.textAlignment = NSTextAlignmentLeft;
//        [self.icon addSubview:self.title];
        
        self.contentView.layer.cornerRadius = NRadius;
        self.contentView.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setBannerModel:(NYSBannerModel *)bannerModel {
    _bannerModel = bannerModel;
    
    self.titleLabel.text = [NSString stringWithFormat:@"  %@", bannerModel.title];
    [self.bannerImageV setImageWithURL:[NSURL URLWithString:bannerModel.mediaLink] placeholder:[UIImage imageNamed:@"activity_bg_2"]];
}

@end
