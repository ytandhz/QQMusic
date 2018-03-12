//
//  MusicPlayerTool.h
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicPlayerTool : NSObject

+ (instancetype)shareInstance;

- (AVAudioPlayer *)playMusicWithName:(NSString *)musicName;

- (void)pauseMusic;

- (void)stopMusic;

@end
