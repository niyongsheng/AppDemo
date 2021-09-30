//
//  NYSSliderHeaderView.m
//  NYS
//
//  Created by niyongsheng on 2021/8/9.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSSliderHeaderView.h"

@interface NYSSliderHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageV;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation NYSSliderHeaderView

- (void)setupView {
    
    self.bgImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageV.image = [[UIImage imageNamed:@"slider_bg"] imageByBlurLight];
    
    self.moreInfoLabel.lee_theme.LeeConfigTextColor(@"app_theme_color");
    self.nicknameLabel.textColor = [UIColor whiteColor];
    self.statusLabel.textColor = [UIColor whiteColor];
    
    self.nicknameLabel.font = [UIFont fontWithName:@"DOUYU Font" size:15.0f];
    
    self.userIconImageV.cornerRadius = 50;
    
    [self.statusLabel tab_startAnimationWithConfigBlock:^(TABViewAnimated * _Nonnull tabAnimated) {
        tabAnimated.superAnimationType = TABViewSuperAnimationTypeDrop;
    } adjustBlock:^(TABComponentManager * _Nonnull manager) {
//        manager.animation(0).penetrate();
//        manager.animation(2).penetrate();
//        manager.animation(3).penetrate();
//        manager.animation(4).width(200);
    } completion:^{
        [self.statusLabel tab_endAnimationEaseOut];
    }];
}

- (IBAction)btnOnclicked:(UIButton *)sender {
    _block ? self.block(@"0") : nil;
}

@end
