//
//  LrcScrollView.m
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import "LrcScrollView.h"
#import "LrcTool.h"
#import "LrclineModel.h"
#import "MusicModel.h"
#import "MusicTool.h"
#import "LrcViewCell.h"
#import "LrcLabel.h"

@interface LrcScrollView  ()<UITableViewDelegate,UITableViewDataSource>
/// description
@property (nonatomic, strong)   UITableView  *tableView;


@end

@implementation LrcScrollView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[LrcViewCell class] forCellReuseIdentifier:@"LrcViewCell"];
        _tableView.rowHeight = 35.f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.lrclines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LrcViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LrcViewCell"];
    if (indexPath.row == self.currentIndex) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:16.0f];
    }else {
        cell.lrcLabel.font = [UIFont systemFontOfSize:13.0f];
        cell.lrcLabel.progress = 0;
    }
    // 2.给cell设置数据
    cell.lrcLabel.text = [self.lrclines[indexPath.row] lrcText];
    
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    CGRect frame = self.tableView.frame;
    frame.origin.x = self.bounds.size.width;
    self.tableView.frame = frame;
    self.tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.height*0.5, 0, self.bounds.size.height *0.5, 0);
    
}

- (void)setLrcfileName:(NSString *)lrcfileName {
    _lrcfileName = lrcfileName;
    // 1.获取歌词
    self.lrclines = [[LrcTool shareInstance] lrcToolWithLrcName:_lrcfileName];
    [self.tableView reloadData];
    // 3.将currentIndex重置
    self.currentIndex = 0;
    // 4.tableView滚动到最上面
    self.tableView.contentOffset = CGPointMake(0, -self.bounds.size.height*0.5);
    
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    NSInteger count = self.lrclines.count;
    
    for (NSInteger i = 0; i < count; i++) {
        // 2.1.获取i位置的歌词
        LrclineModel *currentLrcline = self.lrclines[i];
        
        NSInteger nextIndex = i+1;
        if (nextIndex > count -1) {
            break;
        }
        LrclineModel *nextLrcline = _lrclines[nextIndex];
        // 2.3.判断当前时间是否是大于i位置的时间,并且小于i+1位置的时间
        if (currentTime >= currentLrcline.lrcTime && currentTime < nextLrcline.lrcTime && currentTime != i) {
            // 2.3.1.根据i创建对应的indexPath
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath *previousPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            // 2.3.2.计算当前的i
            self.currentIndex = i;
            // 2.3.3.刷新i位置的cell
            [self.tableView reloadRowsAtIndexPaths:@[previousPath, indexPath] withRowAnimation:UITableViewRowAnimationNone];
            // 滚动到对应的位置
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            // 画图有歌词的图片
            UIImage *lrcImage = [self createLrcImageAtIndex:i];
            // 通知代理,切换歌词
            if ([self.customDelegate respondsToSelector:@selector(lrcScrollView:currentLrcText:lrcImage:)]) {
                [_customDelegate lrcScrollView:self currentLrcText:currentLrcline.lrcText lrcImage:lrcImage];
            }
            
            // 2.4.如果正在显示某一句歌词,那么就给label添加颜色的进度
            if (i == self.currentIndex) {
                // 2.4.1.获取当前的进度
                double progress = (currentTime - currentLrcline.lrcTime) / (nextLrcline.lrcTime - currentLrcline.lrcTime);
                
                // 2.4.2.将进度给lrcLabel,让label根据进度显示颜色
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                LrcViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.lrcLabel.progress = progress;
                
                // 2.4.3.通知代理,当前的进度
                if ([self.customDelegate respondsToSelector:@selector(lrcScrollView:progress:)]) {
                    [_customDelegate lrcScrollView:self progress:progress];
                }
            }
        }
    }
}


- (UIImage *)createLrcImageAtIndex:(NSInteger)index {
    // 1.获取当前显示的图片
    MusicModel  *currentMusic = [[MusicTool shareInstance] currentMusic];
    if (!currentMusic) {
        return nil;
    }
    UIImage *currentImage = [UIImage imageNamed:currentMusic.icon];
    // 2.开启图像上下文
    UIGraphicsBeginImageContextWithOptions(currentImage.size, YES, 0.0);
    // 3.将图片画到上下文中
    [currentImage drawInRect:CGRectMake(0, 0, currentImage.size.width, currentImage.size.height)];
    // 4.获取歌词
    // 4.1.获取当前句的歌词
    NSString *currentLrc =(NSString *) [self.lrclines[index] lrcText];
    // 4.2.获取上一句的歌词
    NSInteger previousIndex = index - 1;
    NSString    *previousLrc;
    if (previousIndex > 0) {
        previousLrc =(NSString *) [self.lrclines[previousIndex] lrcText];
    }
    
    // 4.3.获取下一句的歌词
    NSInteger   nextIndex = index + 1;
    NSString *nextLrc;
    if (nextIndex <= _lrclines.count - 1) {
        nextLrc = (NSString *)[self.lrclines[nextIndex] lrcText];
    }
    // 5.将歌词画到上下文中
    // 5.0.定义文字的属性
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.f],NSParagraphStyleAttributeName:style};
    // 5.2.定义常量
    CGFloat h = 30.f;
    CGFloat imageW = currentImage.size.width;
    CGFloat imageH = currentImage.size.height;
    // 5.1.将下一句歌词画到上下文中
    CGRect nextRect = CGRectMake(0, imageH-h, imageW, h);
    [nextLrc drawInRect:nextRect withAttributes:attributes];
    // 5.2.将当前句歌词画到上下文中
    CGRect currentRect = CGRectMake(0, imageH-2*h, imageW, h);
    [currentLrc drawInRect:currentRect withAttributes:attributes];
    // 5.3.将上一句歌词画到上下文中
    CGRect previousRect = CGRectMake(0, imageH-3*h, imageW, h);
    [previousLrc drawInRect:previousRect withAttributes:attributes];
    // 6.从上下文中获取图片
    UIImage *lrcImage = UIGraphicsGetImageFromCurrentImageContext();
    // 7.关闭上下文
    UIGraphicsEndImageContext();
    return lrcImage;
}

@end
