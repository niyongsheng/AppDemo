//
//  NYSBusinessCell.m
//  NewAnju_IOS
//
//  Created by 倪永胜 on 2020/4/6.
//  Copyright © 2020 NiYongsheng. All rights reserved.
//

#import "NYSBusinessCell.h"
#import "NYSHomeModel.h"

@interface NYSBusinessCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation NYSBusinessCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.bgView.layer.cornerRadius = 10.f;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"NYSBusinessCell" owner:self options:nil] firstObject];
    }
    return self;
}

- (void)setBusinessModel:(NYSBusinessModel *)businessModel {
    _businessModel = businessModel;
    
    self.title.text = businessModel.title;
    [self.icon setImageWithURL:[NSURL URLWithString:businessModel.icon_url] placeholder:[UIImage imageNamed:businessModel.defaultIconName]];
}

- (void)setIdField:(NSInteger)idField {
    
//    NSArray <UIColor *> *Colors = @[
//        [UIColor colorWithHexString:@"#ffcab1"],
//        [UIColor colorWithHexString:@"#B1C6F3"],
//        [UIColor colorWithHexString:@"#FEE5BA"],
//        [UIColor colorWithHexString:@"#FAC2C0"],
//        [UIColor colorWithHexString:@"#A8EDD0"],
//        [UIColor colorWithHexString:@"#D19CEC"]
//    ];
//    self.contentView.layer.shadowColor = Colors[idField].CGColor;
//    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
//    self.contentView.layer.shadowOpacity = 1.0f;
//    self.contentView.layer.shadowRadius = 5.0f;
}

@end
