//
//  MusicModel.h
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject
/// 歌曲名称
@property (nonatomic, strong)   NSString  *name;
/// 歌曲对应的文件名称
@property (nonatomic, strong)   NSString  *filename;
/// 歌词文件的名称
@property (nonatomic, strong)   NSString  *lrcname;
/// 歌手的名称
@property (nonatomic, strong)   NSString  *singer;
/// 歌手的小图标
@property (nonatomic, strong)   NSString  *singerIcon;
/// 歌手的大图片
@property (nonatomic, strong)   NSString  *icon;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
