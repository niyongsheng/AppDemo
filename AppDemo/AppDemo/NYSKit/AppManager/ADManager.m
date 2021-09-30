//
//  ADManager.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/16.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "ADManager.h"
#import <XHLaunchAd/XHLaunchAd.h>

static NSString *ADF = @"AD_Flag";

@interface ADManager () <XHLaunchAdDelegate>
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@end

@implementation ADManager

SINGLETON_FOR_CLASS(ADManager);

/// 启动广告
- (void)showAD {
    [NNotificationCenter addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
#if !defined(DEBUG)
        // 播放本地开屏动画
//        [self showLocalVideo];
        [self getADData];
#endif
    }];
}

#pragma mark - 图片开屏广告-网络数据-示例
- (void)showImageAD:(NSArray *)dictArr {
    
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
    [XHLaunchAd setWaitDataDuration:2];
    
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.85);
    imageAdconfiguration.duration = 2.0f;
    imageAdconfiguration.imageNameOrURLString = @"icon_sunnyday.png";
    imageAdconfiguration.openModel = @"https://github.com/niyongsheng/NYSKit";
    imageAdconfiguration.GIFImageCycleOnce = NO;
    imageAdconfiguration.imageOption = XHLaunchAdImageCacheInBackground;
    imageAdconfiguration.contentMode = UIViewContentModeCenter;
    imageAdconfiguration.showFinishAnimate = ShowFinishAnimateFadein;
    imageAdconfiguration.showFinishAnimateTime = 0.77;
    imageAdconfiguration.skipButtonType = SkipTypeRoundProgressText;
    imageAdconfiguration.showEnterForeground = NO;
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}

#pragma mark - 视频开屏广告-网络数据-示例
- (void)showVideoAD:(NSArray *)dictArr {
    
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
    
    [XHLaunchAd setWaitDataDuration:2];
    
    XHLaunchVideoAdConfiguration *videoAdconfiguration = [XHLaunchVideoAdConfiguration new];
    videoAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    videoAdconfiguration.duration = 5.0f;
    videoAdconfiguration.videoNameOrURLString = @"https://www.apple.com.cn/105/media/us/homepod/2018/dc73c1ef_eae9_4146_b080_5fbb3684b99e/overview/hey-siri/video/small.mp4";
    videoAdconfiguration.openModel = @"https://github.com/niyongsheng/NYSKit";
    videoAdconfiguration.muted = NO;
    videoAdconfiguration.videoGravity = AVLayerVideoGravityResizeAspect;
    videoAdconfiguration.videoCycleOnce = NO;
    videoAdconfiguration.showFinishAnimate = ShowFinishAnimateFadein;
    videoAdconfiguration.showFinishAnimateTime = 0.77;
    videoAdconfiguration.showEnterForeground = NO;
    videoAdconfiguration.skipButtonType = SkipTypeTimeText;
    
    [XHLaunchAd videoAdWithVideoAdConfiguration:videoAdconfiguration delegate:self];
}

#pragma mark - 视频开屏广告-本地数据
- (void)showLocalVideo {
    // 1 创建一个播放item
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lauchVideo.mp4" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:url];
    // 2 播放的设置
    AVPlayer *localVideoPlayer = [AVPlayer playerWithPlayerItem:playItem];
    localVideoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    // 3 将图层嵌入到0层
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:localVideoPlayer];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = CGRectMake(0, 0, NScreenWidth, NScreenHeight);
    [NRootViewController.view.layer addSublayer:layer];
    self.playerLayer = layer;
    // 4 播放完成/中断处理
    [NNotificationCenter addObserver:self selector:@selector(playToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [NNotificationCenter addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [localVideoPlayer play];
    }];
    // 5 设置声音模式
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    if (!success) {
        NLog(@"设置失败！");
    }
    // 6 播放
    [localVideoPlayer play];
}

#pragma mark - 视频播放结束 触发
- (void)playToEnd {
    [NNotificationCenter removeObserver:self];
    [self.playerLayer removeFromSuperlayer];
}

- (void)getADData {
    // 广告数据请求
    if (arc4random() % 2) {
        [self showImageAD:nil];
    } else {
        [self showVideoAD:nil];
    }
}

#pragma mark - XHLaunchAd delegate - 其他
/**
 广告点击事件回调(return YES移除广告,NO不移除广告)
 */
- (BOOL)xhLaunchAd:(XHLaunchAd *)launchAd clickAtOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint {
    if(openModel == nil) return NO;
    
    NSString *targetUrl = [(NSString *)openModel stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];
    SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:targetUrl]];
    safariVc.modalPresentationStyle = UIModalPresentationPageSheet;
    [NRootViewController presentViewController:safariVc animated:YES completion:nil];
    
    return YES;
}

/**
 *  图片本地读取/或下载完成回调
 *
 *  @param launchAd  XHLaunchAd
 *  @param image 读取/下载的image
 *  @param imageData 读取/下载的imageData
 */
- (void)xhLaunchAd:(XHLaunchAd *)launchAd imageDownLoadFinish:(UIImage *)image imageData:(NSData *)imageData {
    
    NLog(@"图片下载完成/或本地图片读取完成回调");
}

/**
 *  视频本地读取/或下载完成回调
 *
 *  @param launchAd XHLaunchAd
 *  @param pathURL  视频保存在本地的path
 */
- (void)xhLaunchAd:(XHLaunchAd *)launchAd videoDownLoadFinish:(NSURL *)pathURL {
    
    NLog(@"video下载/加载完成 path = %@",pathURL.absoluteString);
}

/**
 *  视频下载进度回调
 */
- (void)xhLaunchAd:(XHLaunchAd *)launchAd videoDownLoadProgress:(float)progress total:(unsigned long long)total current:(unsigned long long)current {
    
    NLog(@"总大小=%lld,已下载大小=%lld,下载进度=%f",total,current,progress);
}

/**
 *  广告显示完成
 */
- (void)xhLaunchAdShowFinish:(XHLaunchAd *)launchAd {
    
    NLog(@"广告显示完成");
}

@end
