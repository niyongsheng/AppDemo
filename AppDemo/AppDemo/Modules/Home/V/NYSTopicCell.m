//
//  NYSTopicCell.m
//  NYS
//
//  Created by niyongsheng on 2021/8/7.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSTopicCell.h"
#import "NYSHomeModel.h"

@interface NYSTopicCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *notes;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIView *iconesView;
@end

@implementation NYSTopicCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:[self className] owner:self options:nil] firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgImgView.layer.cornerRadius = NRadius;
    self.contentView.layer.cornerRadius = NRadius;
    self.contentView.layer.masksToBounds = YES;
}

- (void)setTopicModel:(NYSTopicModel *)topicModel {
    _topicModel = topicModel;
    
    NSArray <NSString *> *bgImageNames = @[@"activity_bg_1", @"activity_bg_2"];
    [self.bgImgView setImage:[UIImage imageNamed:bgImageNames[topicModel.ID % 2]]];
    
    self.title.text = topicModel.title;
    self.notes.text = topicModel.notice;
    
    [self.iconesView removeAllSubviews];
    for (int i = 0; i<topicModel.memberAvatar.count; i++) {
        UIImageView *icon = [UIImageView new];
        [self.iconesView addSubview:icon];
        icon.layer.cornerRadius = 12.5f;
        icon.layer.masksToBounds = YES;
        icon.layer.borderWidth = 0.4f;
        icon.layer.borderColor = [UIColor whiteColor].CGColor;
        [icon setImageWithURL:[NSURL URLWithString:topicModel.memberAvatar[i]] placeholder:NPImageFillet];
        CGFloat leftSpace = i * 22 + 5;
        icon.sd_layout
        .rightSpaceToView(_iconesView, leftSpace)
        .centerYEqualToView(_iconesView)
        .widthIs(25)
        .heightIs(25);
    }
}

@end
