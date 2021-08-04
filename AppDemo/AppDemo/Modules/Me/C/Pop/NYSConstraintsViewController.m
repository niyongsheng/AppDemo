//
//  NYSConstraintsViewController.m
//  AppDemo
//
//  Created by niyongsheng on 2021/8/4.
//  Copyright © 2021 niyongsheng. All rights reserved.
//

#import "NYSConstraintsViewController.h"
#import "PaperButton.h"

@interface NYSConstraintsViewController ()
@property(nonatomic) UILabel *titleLabel;

@property(nonatomic) UIView *redView;
@property(nonatomic) UIView *greenView;
@property(nonatomic) UIView *blueView;
@property(nonatomic) UIView *contentView;
@end

@implementation NYSConstraintsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    
    [self addViews];
    [self addBarButton];
    [self buttonOnclicked:nil];
}

- (void)addBarButton {
    PaperButton *button = [PaperButton button];
    [button addTarget:self action:@selector(buttonOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor = NAppThemeColor;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)buttonOnclicked:(id)sender {
    NSString *title = @"List";
    if ([self.title isEqualToString:title]) {
        title = @"Menu";
    }
    self.title = title;
    
    [self updateConstraints:sender];
}

#pragma mark - Private Instance methods

- (void)addViews {
    self.contentView = [UIView new];
    self.contentView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.contentView];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[_contentView]|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_contentView)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[_contentView]|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_contentView)]];

    self.redView = [UIView new];
    self.redView.backgroundColor = rgb(231, 76, 60);
    self.redView.translatesAutoresizingMaskIntoConstraints = NO;
    self.redView.layer.cornerRadius = 8.f;
    self.greenView = [UIView new];
    self.greenView.backgroundColor = rgb(46, 204, 113);
    self.greenView.translatesAutoresizingMaskIntoConstraints = NO;
    self.greenView.layer.cornerRadius = 8.f;
    self.blueView = [UIView new];
    self.blueView.backgroundColor = rgb(52, 152, 219);
    self.blueView.translatesAutoresizingMaskIntoConstraints = NO;
    self.blueView.layer.cornerRadius = 8.f;

    [self.contentView addSubview:self.redView];
    [self.contentView addSubview:self.greenView];
    [self.contentView addSubview:self.blueView];
}

- (void)updateConstraints:(id)sender {

    [self.contentView layoutIfNeeded];
    [self.contentView removeConstraints:self.contentView.constraints];

    NSDictionary *views = NSDictionaryOfVariableBindings(_redView, _greenView, _blueView);
    NSArray *viewNames = [self shuffledArrayFromArray:views.allKeys];

    NSString *firstViewKey= viewNames[0];
    NSString *secondViewKey = viewNames[1];
    NSString *thirdViewKey = viewNames[2];

    NSString *horizontalFormat = [NSString stringWithFormat:@"H:|-(20)-[%@]-(20)-|", firstViewKey];
    NSString *additionalHorizontalFormat = [NSString stringWithFormat:@"H:|-(20)-[%1$@]-(20)-[%2$@(==%1$@)]-(20)-|", secondViewKey, thirdViewKey];
    NSString *verticalFormat = [NSString stringWithFormat:@"V:|-(88)-[%1$@]-(20)-[%2$@(==%1$@)]-(20)-|", firstViewKey, secondViewKey];
    NSString *additionalVerticalFormat = [NSString stringWithFormat:@"V:|-(88)-[%1$@]-(20)-[%2$@(==%1$@)]-(20)-|", firstViewKey, thirdViewKey];

    [self.contentView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:horizontalFormat
                               options:0
                               metrics:nil
                               views:views]];

    [self.contentView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:additionalHorizontalFormat
                               options:NSLayoutFormatAlignAllTop
                               metrics:nil
                               views:views]];

    [self.contentView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:verticalFormat
                               options:0
                               metrics:nil
                               views:views]];

    [self.contentView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:additionalVerticalFormat
                               options:0
                               metrics:nil
                               views:views]];

    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.7
                        options:0
                     animations:^{
        [self.contentView layoutIfNeeded];
    } completion:NULL];
}

- (NSArray *)shuffledArrayFromArray:(NSArray *)array {
    NSMutableArray *shuffleArray = [array mutableCopy];
    NSUInteger count = [shuffleArray count];

    for (NSUInteger i = 0; i < count; ++i) {
        NSUInteger nElements = count - i;
        NSUInteger n = arc4random_uniform((uint32_t)nElements) + i;
        [shuffleArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }

    return [shuffleArray copy];
}

@end
