//
//  NYSAboutHeaderView.m
//  NYS
//
//  Created by niyongsheng on 2021/8/13.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSAboutHeaderView.h"

@interface NYSAboutHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *version;
@end

@implementation NYSAboutHeaderView

- (void)setupView {
    [super setupView];
    
    self.version.text = [NSString stringWithFormat:@"版本：V%@", [[AppManager sharedAppManager] getAppVersion]];
    self.appName.text = [[AppManager sharedAppManager] getAppName];
}

@end
