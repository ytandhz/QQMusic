//
//  MusicTool.h
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MusicModel;
@interface MusicTool : NSObject

+ (instancetype)shareInstance;

/// 模型数组
@property (nonatomic, strong)   NSArray  *musics;

/// 当前模型
@property (nonatomic, strong)   MusicModel  *currentMusic;

- (MusicModel *)getPreviousMusic;

- (MusicModel *)getNextMusic;

@end
