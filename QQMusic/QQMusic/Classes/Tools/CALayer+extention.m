//
//  CALayer+extention.m
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import "CALayer+extention.h"

@implementation CALayer (extention)

- (void)pauseAnim {
    CFTimeInterval pauseTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0;
    self.timeOffset = pauseTime;
}

- (void)resumeAnim {
    CFTimeInterval pauseTime = self.timeOffset;
    self.speed = 1.0;
    self.timeOffset = 0;
    self.beginTime = 0;
    CFTimeInterval timeInteval = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    self.beginTime = timeInteval;
}
@end
