//
//  NYSVoteCell.m
//  NewAnju_IOS
//
//  Created by 倪永胜 on 2020/11/2.
//  Copyright © 2020 NiYongsheng. All rights reserved.
//

#import "NYSVoteCell.h"
#import "NYSHomeModel.h"

@interface NYSVoteCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *comName;
@property (weak, nonatomic) IBOutlet UIButton *joinVoteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;

@end

@implementation NYSVoteCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"NYSVoteCell" owner:self options:nil] firstObject];
    }
    return self;
}
- (IBAction)voteBtnOnclicked:(UIButton *)sender {
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.comName.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    self.joinVoteBtn.layer.cornerRadius = 13.0f;
    self.joinVoteBtn.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    
    self.bgImageV.layer.cornerRadius = NRadius;
}

- (IBAction)joinVotBtn:(UIButton *)sender {
    [NYSTools zoomToShow:sender];
    
}

- (void)setVoteModel:(NYSVoteModel *)voteModel {
    _voteModel = voteModel;
    
    self.title.text = voteModel.title;
    self.comName.text = voteModel.communityName;
    self.joinVoteBtn.tag = voteModel.ID;
}

@end
