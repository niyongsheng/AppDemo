//
//  NYSNewsTableViewCell.m
//  NewAnju_IOS
//
//  Created by 倪永胜 on 2020/4/9.
//  Copyright © 2020 NiYongsheng. All rights reserved.
//

#import "NYSNewsTableViewCell.h"
#import "NYSHomeModel.h"

@interface NYSNewsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
@implementation NYSNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.icon.layer.cornerRadius = NRadius;
    self.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
}

- (void)setNewsModel:(NYSNewsModel *)newsModel {
    _newsModel = newsModel;
    
    self.title.text = newsModel.title;
    self.time.text = newsModel.createTime;
    [self.icon setImageWithURL:[NSURL URLWithString:newsModel.coverImage] placeholder:NPImageFillet];
}

@end
