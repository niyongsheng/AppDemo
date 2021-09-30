//
//  NYSConversationViewController.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSConversationViewController.h"

@interface NYSConversationViewController ()
<
RCIMSendMessageDelegate
>
@end

@implementation NYSConversationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
        self.navigationController.navigationBar.prefersLargeTitles = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.enableAutoToolbar = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = NO;
    keyboardManager.enableAutoToolbar = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTheme];
    
    // 为保持app统一样式覆盖返回按钮样式
    [self addNavigationItemWithImageNames:@[@"back_icon"] isLeft:YES target:self action:@selector(backBtnClicked) tags:@[@"1"]];
    
//    self.automaticallyAdjustsScrollViewInsets = YES;
    // 视图延伸延伸方向
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    // 监听发送消息
    [RCIM sharedRCIM].sendMessageDelegate = self;
    
    // 移除转账和红包功能
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_TRANSFER_TAG];
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_RED_PACKET_TAG];

    self.enableNewComingMessageIcon = YES; //开启消息提醒
    
    // 会话详情
    UIImage *img = [UIImage imageNamed:@"edit"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(conversationInfo:)];
}

#pragma mark - RCIMSendMessageDelegate消息向外发送结束之后会执行
- (RCMessageContent *)willSendIMMessage:(RCMessageContent *)messageContent {
    return messageContent;
}

- (void)didSendIMMessage:(RCMessageContent *)messageContent status:(NSInteger)status {
    // 仅在群聊发送成功后调用活跃度接口
    if (status == 0 && self.conversationType == ConversationType_GROUP) {
        
    }
}

- (void)conversationInfo:(id)sender {
    if (self.conversationType == ConversationType_PRIVATE) {
        
    } else {
        
    }
}

- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray<NSString *> *)tags {
    NSMutableArray * items = [[NSMutableArray alloc] init];
    NSInteger i = 0;
    for (NSString * imageName in imageNames) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.lee_theme
        .LeeAddCustomConfig(DAY, ^(id  _Nonnull item) {
            [(UIButton *)item setImage:[UIImage imageNamed:[imageName stringByAppendingString:@"_day"]] forState:UIControlStateNormal];
        })
        .LeeAddCustomConfig(NIGHT, ^(id  _Nonnull item) {
            [(UIButton *)item setImage:[UIImage imageNamed:[imageName stringByAppendingString:@"_night"]] forState:UIControlStateNormal];
        });
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        if (isLeft) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        } else {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        
        btn.tag = [tags[i++] integerValue];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

- (void)backBtnClicked {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/// 屏幕旋转后重新布局
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    CGFloat duration = [coordinator transitionDuration];
    WS(weakSelf);
    [UIView animateWithDuration:duration animations:^{
        [weakSelf.conversationMessageCollectionView setFrame:(CGRect){{0, 0}, size}];
    }];
}

#pragma mark - 设置主题
- (void)configTheme {
    
}


@end
