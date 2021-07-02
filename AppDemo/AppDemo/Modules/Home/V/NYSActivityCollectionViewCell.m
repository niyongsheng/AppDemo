//
//  NYSActivityCollectionViewCell.m
//  DaoCaoDui_IOS
//
//  Created by 倪永胜 on 2019/12/13.
//  Copyright © 2019 NiYongsheng. All rights reserved.
//

#import "NYSActivityCollectionViewCell.h"
#import "NYSIconTextLayer.h"
#import "UIImage+NYS.h"
#import "NYSHomeModel.h"

@interface NYSActivityCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *memberCount;
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *bgBtnView;
@property (weak, nonatomic) IBOutlet UIView *bootmView;
@property (strong, nonatomic) NYSIconTextLayer *localLayer;
@end

@implementation NYSActivityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    self.icon.layer.cornerRadius = 30;
    self.icon.layer.masksToBounds = YES;
    CALayer *layer = [self.icon layer];
    layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f].CGColor;
    layer.borderWidth = 0.2f;
    
    self.joinBtn.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_3");
    self.joinBtn.layer.cornerRadius = 10;
    self.joinBtn.layer.masksToBounds = YES;
    
    self.bgBtnView.layer.cornerRadius = 10;
    self.bgBtnView.layer.masksToBounds = YES;
}

- (void)layoutSubviews {
    self.localLayer.hidden = YES;
    self.localLayer.frame = CGRectMake(15, _bootmView.centerY - 12, 20, 15);
}

- (UICollectionViewLayoutAttributes*)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes*)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize: layoutAttributes.size];
    CGRect cellFrame = layoutAttributes.frame;
    cellFrame.size.height = size.height;
    layoutAttributes.frame = cellFrame;
    return layoutAttributes;
}

- (void)setCollectionModel:(NYSHomeModel *)collectionModel {
    _collectionModel = collectionModel;
    
    // ID随机背景色
    int x = 1 + self.collectionModel.ID % 6;
    NSString *bgimgName = [NSString stringWithFormat:@"act_%d", x];
    [self.bgBtnView setBackgroundImage:[UIImage imageNamed:bgimgName] forState:UIControlStateNormal];
    self.bgBtnView.userInteractionEnabled = NO;
//    self.bgBtnView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleRadial withFrame:self.bgBtnView.bounds andColors:@[NAppThemeColor, [UIColor colorWithHexString:@"#90B7FD"]]];
    
    [self.icon setImage:[UIImage nameImageWithNameString:collectionModel.name imageSize:CGSizeMake(60, 60)]];
    self.title.textColor = collectionModel.isRecommend ? UIColorFromHex(0xFCC430) : [UIColor whiteColor];
    self.title.text = collectionModel.name;
    self.topView.hidden = collectionModel.isRecommend ? NO : YES;
    self.memberCount.text = [NSString stringWithFormat:@"%ld", (long)collectionModel.ID];
    self.introduction.text = collectionModel.desc;
    
    self.localLayer.icon = [UIImage imageNamed:@"location_8x10_"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.localLayer.hidden = NO;
        self.localLayer.text = @"GitHub";
    });
    
}

- (IBAction)joinClicked:(UIButton *)sender {
    [NYSTools zoomToShow:sender];
    
    SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:self.collectionModel.url] entersReaderIfAvailable:YES];
    [self.fromViewController presentViewController:safariVC animated:YES completion:nil];
}

- (NYSIconTextLayer *)localLayer {
    if (!_localLayer) {
        _localLayer = [NYSIconTextLayer layer];
        _localLayer.frame = CGRectZero;
        [self.layer addSublayer:_localLayer];
    }
    return _localLayer;
}

@end
