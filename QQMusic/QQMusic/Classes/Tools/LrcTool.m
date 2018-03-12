//
//  LrcTool.m
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import "LrcTool.h"
#import "LrclineModel.h"

@implementation LrcTool

+ (instancetype)shareInstance {
    static LrcTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LrcTool alloc]init];
    });
    return _instance;
}

- (NSArray<LrclineModel *> *)lrcToolWithLrcName:(NSString *)lrcname {
    NSString    *lrcPath = [[NSBundle mainBundle] pathForResource:lrcname ofType:nil];
    NSString *lrcString = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    NSMutableArray  *tempArray = [NSMutableArray array];
    for (NSString *lrc in lrcArray) {
        
        if ([lrc containsString:@"[ti:"] || [lrc containsString:@"[ar:"] || [lrc containsString:@"[al:"] || ![lrc containsString:@"["]) {
            continue;
        }
        LrclineModel *model = [[LrclineModel alloc]initWithLrclineString:lrc];
        [tempArray addObject:model];
    }
    
    return tempArray.mutableCopy;
}


@end
