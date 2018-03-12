//
//  MusicPlayerTool.m
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import "MusicPlayerTool.h"
#import <AVFoundation/AVFoundation.h>

@interface MusicPlayerTool  ()

@property (nonatomic, strong)     AVAudioPlayer *player;


@end
@implementation MusicPlayerTool

+ (instancetype)shareInstance {
   static MusicPlayerTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MusicPlayerTool alloc]init];
    });
    return _instance;
}

- (AVAudioPlayer *)playMusicWithName:(NSString *)musicName {
    NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
    if (self.player.url != nil) {
        if ([self.player.url isEqual:url]) {
            [self.player play];
            return self.player;
        }
    }
    AVAudioPlayer   *tempPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.player = tempPlayer;
    [tempPlayer play];
    return tempPlayer;
}

- (void)pauseMusic {
    [self.player pause];
}

- (void)stopMusic {
    self.player.currentTime = 0;
    [self.player stop];
}

@end
