//
//  LrclineModel.h
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LrclineModel : NSObject

/// 时间
@property (nonatomic, assign)   NSTimeInterval  lrcTime;
/// 歌词
@property (nonatomic, strong)   NSString  *lrcText;

- (instancetype)initWithLrclineString:(NSString *)lrclineString;

@end
