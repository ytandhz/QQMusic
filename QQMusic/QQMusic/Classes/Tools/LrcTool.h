//
//  LrcTool.h
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LrclineModel;

@interface LrcTool : NSObject

+ (instancetype)shareInstance;

- (NSArray<LrclineModel *> *)lrcToolWithLrcName:(NSString *)lrcname;

@end
