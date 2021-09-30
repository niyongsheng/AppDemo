//
//  NYSBillboardCell.m
//  NYS
//
//  Created by niyongsheng on 2021/8/7.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSBillboardCell.h"
#import "NYSHomeModel.h"

@interface NYSBillboardCell ()
@property (nonatomic, strong) UIView *billboardView;
@property (nonatomic, strong) YYLabel *billboardLabel;
@end

@implementation NYSBillboardCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.billboardView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        self.billboardView.backgroundColor = [UIColor clearColor];
        self.contentView.layer.cornerRadius = 10.f;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.clipsToBounds = YES;
        
        self.billboardLabel = [[YYLabel alloc] initWithFrame:self.contentView.bounds];
        self.billboardLabel.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.billboardLabel.numberOfLines = 2;
        self.billboardLabel.font = [UIFont systemFontOfSize:12.f];
        
        [self.contentView addSubview:self.billboardView];
        [self.contentView addSubview:self.billboardLabel];
    }
    return self;
}

- (void)setBillboardModel:(NYSBillboardModel *)billboardModel {
    _billboardModel = billboardModel;
    
    _billboardLabel.lee_theme.LeeConfigTextColor(@"common_font_color_0");
    _billboardLabel.text = billboardModel.richContent;
}

@end
