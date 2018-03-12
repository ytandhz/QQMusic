//
//  PlayingViewController.m
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import "PlayingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LrcLabel.h"
#import "LrcScrollView.h"
#import "MusicTool.h"
#import "MusicModel.h"
#import "MusicPlayerTool.h"
#import "CALayer+extention.h"

@interface PlayingViewController ()<LrcScrollViewDelegate,AVAudioPlayerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, strong) CADisplayLink   *lrcTimer;
@property (nonatomic, weak) AVAudioPlayer   *player;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressView;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet LrcLabel *lrcLabel;
@property (weak, nonatomic) IBOutlet LrcScrollView *lrcScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;


@end

static  NSString *IconViewAnim = @"IconViewAnim";

@implementation PlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.progressView setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    self.lrcScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width *2, 0);
    self.lrcScrollView.customDelegate = self;
    self.lrcScrollView.delegate = self;
    self.lrcScrollView.showsHorizontalScrollIndicator = NO;
    self.lrcScrollView.pagingEnabled = YES;
    [self startPlayingMusic];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self setupIconViewCorner];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupIconViewCorner {
    self.iconView.layer.cornerRadius = self.iconView.bounds.size.width * 0.5;
    self.iconView.layer.masksToBounds = true;
    self.iconView.layer.borderWidth = 10;
    self.iconView.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

- (void)addIconViewAnimation {
    CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 2.给动画设置属性
    rotationAnim.fromValue = 0;
    rotationAnim.toValue = @(M_PI *2.0);
    rotationAnim.repeatCount = MAXFLOAT;
    rotationAnim.duration = 30;
    
    // 3.将动画添加到layer中
    [self.iconView.layer addAnimation:rotationAnim forKey:IconViewAnim];
}

- (void)startPlayingMusic {
    // 1.获取当前正在播放歌曲
    MusicModel *currentMusic = [MusicTool shareInstance].currentMusic;
    
    // 2.给界面中控件设置属性
    self.iconView.image = [UIImage imageNamed:currentMusic.icon];
    self.bgImageView.image = [UIImage imageNamed:currentMusic.icon];
    self.songLabel.text = currentMusic.name;
    self.singerLabel.text = currentMusic.singer;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.progressView addGestureRecognizer:tap];
    // 3.播放当前歌曲
    AVAudioPlayer *player = [[MusicPlayerTool shareInstance] playMusicWithName:currentMusic.filename];
    self.player = player;
    self.player.delegate = self;
    // 4.显示总时长
    self.totalTimeLabel.text = [self timeStrWithTime:self.player.duration];
    // 5.添加动画
    if ([self.iconView.layer animationForKey:@"IconViewAnim"] != nil) {
        [self.iconView.layer removeAnimationForKey:@"IconViewAnim"];
    }
    [self addIconViewAnimation];
    
    // 6.添加监听进度的定时器
    [self removeProgressTimer];
    [self addProgressTimer];
    
    // 7.将歌词文件的名称传递LrcScrollView
    self.lrcScrollView.lrcfileName = currentMusic.lrcname;
    // 8.添加定时器
    [self removeLrcTimer];
    [self addLrcTimer];
    
    // 9.设置该歌曲的锁屏界面信息
}

- (void)removeProgressTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)addProgressTimer {
    self.progressTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];
    [self updateProgressInfo];
}

- (void)updateProgressInfo {
    // 1.获取当前播放到的时间
    self.currentTimeLabel.text = [self timeStrWithTime:self.player.currentTime];
    // 2.设置进度条
    self.progressView.value = (CGFloat)self.player.currentTime / self.player.duration;
    
}

- (void)addLrcTimer {
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updateLrc {
    self.lrcScrollView.currentTime = self.player.currentTime;
}

- (void)removeLrcTimer {
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}


- (NSString *)timeStrWithTime:(NSTimeInterval)time {
    NSInteger min = (NSInteger)(time + 0.5) / 60;
    NSInteger second =(NSInteger) (time + 0.5) % 60;
    return  [NSString stringWithFormat:@"%02ld:%02ld",(long)min,(long)second];
}

// MARK:- 设置锁屏界面的信息
- (void)setupLockScreenInfo:(UIImage *)lrcImage {
    // 0.获取当前的歌曲
    MusicModel *currentMusic = [MusicTool shareInstance].currentMusic;
    // 1.获取播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    // 2.设置中心的内容
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[MPMediaItemPropertyAlbumTitle] = currentMusic.name;
    dict[MPMediaItemPropertyArtist] = currentMusic.singer;
    dict[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.player.currentTime);
    [dict setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];//进度光标的速度（这个随 自己的播放速率调整，我默认是原速播放）
    dict[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration);
    
    dict[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc]initWithImage:lrcImage];
    center.nowPlayingInfo = dict;
    
    // 3.让应用程序可以接受远程事件
    [[UIApplication sharedApplication] canBecomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
   
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (!event) {
        return;
    }
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextMusic];
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previousMusic];
            break;
        case UIEventSubtypeRemoteControlPlay:
            [self playOrPauseBtnClick:self.playOrPauseBtn];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self playOrPauseBtnClick:self.playOrPauseBtn];
            break;
        default:
            break;
    }
}

- (IBAction)playOrPauseBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 2.1.暂停音乐
        [self.player pause];
        // 2.2.停止进度定时器
        [self removeProgressTimer];
        // 2.3.暂停动画
        [self.iconView.layer pauseAnim];
        // 2.4.停止歌词定时器
        [self removeLrcTimer];
    }else {
        // 2.1.播放歌曲
        [self.player play];
        // 2.2.添加进度的定时器
        [self addProgressTimer];
        // 2.3.恢复动画
        [self.iconView.layer resumeAnim];
        // 2.4.添加歌词定时器
        [self addLrcTimer];
    }
}

- (IBAction)previousMusic {
    // 1.获取上一首歌曲
    MusicModel *previousMusic = [[MusicTool shareInstance] getPreviousMusic];
    [MusicTool shareInstance].currentMusic = previousMusic;
    // 2.播放歌曲
    [self startPlayingMusic];
}


- (IBAction)nextMusic {
    MusicModel *nextMusic = [[MusicTool shareInstance] getNextMusic];
    [MusicTool shareInstance].currentMusic = nextMusic;
    [self startPlayingMusic];
}


- (IBAction)sliderTouchDown:(UISlider *)sender {
    [self removeProgressTimer];
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    double value = sender.value;
    double showTime = value * self.player.duration;
    self.currentTimeLabel.text = [self timeStrWithTime:showTime];
}

- (IBAction)sliderTouchupInside:(UISlider *)sender {
    double showTime = sender.value *self.player.duration;
    self.player.currentTime = showTime;
    [self addProgressTimer];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    // 1.获取点击的的位置
    CGPoint point = [tap locationInView:self.progressView];
    // 2.计算比例
    CGFloat ratio = point.x /self.progressView.bounds.size.width;
    // 3.计算当前需要播放的时间
    self.player.currentTime = self.player.duration * ratio;
    // 4.更新进度
    [self updateProgressInfo];
    // 5.添加定时器
    if (self.progressTimer == nil) {
        [self addProgressTimer];
    }
    
}

#pragma mark -- LrcScrollViewDelegate
- (void)lrcScrollView:(LrcScrollView *)lrcView currentLrcText:(NSString *)lrcText lrcImage:(UIImage *)lrcimg {
    self.lrcLabel.text = lrcText;
    [self setupLockScreenInfo:lrcimg];
    
}

- (void)lrcScrollView:(LrcScrollView *)lrcView progress:(double)progress {
    self.lrcLabel.progress = progress;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat hOffset = scrollView.contentOffset.x;
    CGFloat ratio = hOffset / scrollView.bounds.size.width;
    // 3.设置iconView和lrcLabel的透明度
    self.iconView.alpha = 1 - ratio;
    self.lrcLabel.alpha = 1 - ratio;
}

#pragma mark -- AVAudioPlayerDelegate
//自动播放下一首
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self nextMusic];
}

@end
