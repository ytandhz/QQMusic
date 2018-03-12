//
//  LrcLabel.m
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import "LrcLabel.h"

@implementation LrcLabel

- (void)setProgress:(double)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGRect drawRect = CGRectMake(0, 0, rect.size.width *self.progress, rect.size.height);
    [[UIColor greenColor] set];
    // /* R = S*Da */ s : 画图的透明度 da : label中原有的透明
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);
}
@end
