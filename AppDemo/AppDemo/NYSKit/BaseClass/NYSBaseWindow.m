//
//  NYSBaseWindow.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/13.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSBaseWindow.h"
#import "LEETheme.h"

@implementation NYSBaseWindow

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // 根据系统样式变化 重新启用相应的主题 以达到同步的效果
        if (@available(iOS 13.0, *)) {
            switch (self.traitCollection.userInterfaceStyle) {
                case UIUserInterfaceStyleLight:
                    
                    [LEETheme startTheme:DAY];
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
                    
                    break;
                    
                case UIUserInterfaceStyleDark:
                    
                    [LEETheme startTheme:NIGHT];
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    
                    break;
                    
                default:
                    break;
            }
        }
    }
    return self;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    // 根据系统样式变化 重新启用相应的主题 以达到同步的效果
    if (@available(iOS 13.0, *)) {
        switch (self.traitCollection.userInterfaceStyle) {
            case UIUserInterfaceStyleLight:
                
                [LEETheme startTheme:DAY];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
                
                break;
                
            case UIUserInterfaceStyleDark:
                
                [LEETheme startTheme:NIGHT];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                
                break;
                
            default:
                break;
        }
    }
}

@end
