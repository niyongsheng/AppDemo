//
//  NYSForgetPasswordViewController.m
//  AppDemo
//
//  Created by 倪永胜 on 2018/10/24.
//  Copyright © 2018 NiYongsheng. All rights reserved.
//

#import "NYSForgetPasswordViewController.h"

@interface NYSForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *close;
@property (weak, nonatomic) IBOutlet UIView *getCodeView;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
- (IBAction)getCodeButtonClicked:(id)sender;
- (IBAction)closeBtnClicked:(id)sender;
- (IBAction)resetButtonClicked:(id)sender;

@property (nonatomic,assign) NSInteger secondsCountDownInput;
@property (nonatomic,strong) NSTimer *countDownTimer;

@end

@implementation NYSForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.close.layer.cornerRadius = 15;
    self.getCodeView.layer.cornerRadius = 7;
    
    UIScreenEdgePanGestureRecognizer *gobackRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(closeBtnClicked:)];
    gobackRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:gobackRecognizer];
}

- (IBAction)getCodeButtonClicked:(id)sender {
    self.getCodeView.backgroundColor = [UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.00];
    self.getCodeButton.userInteractionEnabled = NO;
    self.secondsCountDownInput = 60;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTriggerMethon) userInfo:nil repeats:YES];
}

- (void)timerTriggerMethon {
    self.secondsCountDownInput --;
    [NYSTools animateTextChange:1.f withLayer:self.getCodeButton.layer];
    [self.getCodeButton setTitle:[NSString stringWithFormat:@"Rese %ldS", self.secondsCountDownInput] forState:UIControlStateNormal];
    if (self.secondsCountDownInput <= 0) {
        [self.countDownTimer invalidate];
        [self.getCodeButton setTitle:@"Once Code" forState:UIControlStateNormal];
        self.getCodeView.backgroundColor = [UIColor colorWithRed:0.04 green:0.46 blue:0.88 alpha:1.00];
        self.getCodeButton.userInteractionEnabled = YES;
    }
}

- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resetButtonClicked:(id)sender {
    [NYSTools zoomToShow:sender];
}

@end
