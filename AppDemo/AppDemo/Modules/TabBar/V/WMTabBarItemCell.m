#import "WMTabBarItemCell.h"

@interface WMTabBarItemCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WMTabBarItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [UIImageView new];
        [self.contentView addSubview:self.imageView];
        self.imageView.frame = CGRectMake(0, 0, 42.f, 42.f);
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)configItemImageString:(NSString *)imgString {
    [self.imageView setImage:[UIImage imageNamed:imgString]];
}

@end
