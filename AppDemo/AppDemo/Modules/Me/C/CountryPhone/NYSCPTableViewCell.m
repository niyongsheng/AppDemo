//
//  NYSCPTableViewCell.m
//  AppDemo
//
//  Created by niyongsheng on 2021/6/30.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSCPTableViewCell.h"
#import "NYSCPModel.h"

@implementation NYSCPTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)updateViewWithModel:(NYSCountryModel *)model {
    self.textLabel.text = model.name;
    self.detailTextLabel.text = model.dialCode;
}

@end
