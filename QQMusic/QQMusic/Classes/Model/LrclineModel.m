//
//  LrclineModel.m
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import "LrclineModel.h"

@implementation LrclineModel

- (instancetype)initWithLrclineString:(NSString *)lrclineString {
    self = [super init];
    if (self) {
        if (lrclineString.length < 8) {
            return nil;
        }
        self.lrcText = [[lrclineString componentsSeparatedByString:@"]"] lastObject];
        NSRange range = NSMakeRange(1, 8);
        NSString *tempStr = [lrclineString substringWithRange:range];
        double min = [[tempStr substringToIndex:2] doubleValue];
        double second = [[tempStr substringWithRange:NSMakeRange(3, 2)] doubleValue];
        double haomiao = [[tempStr substringFromIndex:6] doubleValue];
        self.lrcTime = (min * 60 + second + haomiao * 0.01);
    }
    return self;
}



@end
