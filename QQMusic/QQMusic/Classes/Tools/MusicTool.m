//
//  MusicTool.m
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import "MusicTool.h"
#import "MusicModel.h"



@implementation MusicTool

+ (instancetype)shareInstance {
    static MusicTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MusicTool alloc]init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self musics];
    }
    return self;
}
- (NSArray *)musics {
    if (!_musics) {
        NSString    *filePath = [[NSBundle mainBundle] pathForResource:@"Musics.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray  *temp = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            MusicModel *model = [[MusicModel alloc]initWithDict:dict];
            [temp addObject:model];
        }
        _musics = temp.mutableCopy;
        self.currentMusic = [_musics objectAtIndex:2];
    }
    return _musics;
}


- (MusicModel *)getPreviousMusic {
    if (!_currentMusic) {
        return nil;
    }
    NSInteger currentIndex = [self.musics indexOfObject:_currentMusic];
    NSInteger previousIndex = currentIndex - 1;
    if (previousIndex < 0) {
        previousIndex = _musics.count - 1;
    }
    return _musics[previousIndex];
}

- (MusicModel *)getNextMusic {
    NSInteger currentIndex = [self.musics indexOfObject:_currentMusic];
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex > _musics.count - 1) {
        nextIndex = 0;
    }
    return _musics[nextIndex];
}

@end
