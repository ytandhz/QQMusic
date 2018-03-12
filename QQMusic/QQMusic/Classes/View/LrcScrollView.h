//
//  LrcScrollView.h
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LrcScrollView,LrclineModel;

@protocol LrcScrollViewDelegate <NSObject>

- (void)lrcScrollView:(LrcScrollView *)lrcView currentLrcText:(NSString *)lrcText lrcImage:(UIImage *)lrcimg;

- (void)lrcScrollView:(LrcScrollView *)lrcView progress:(double)progress;

@end

@interface LrcScrollView : UIScrollView

@property (nonatomic, weak) id <LrcScrollViewDelegate> customDelegate;

/// description
@property (nonatomic, strong)   NSArray<LrclineModel *>  *lrclines;

/// description
@property (nonatomic, assign)   NSInteger  currentIndex;

/// description
@property (nonatomic, strong)   NSString  *lrcfileName;

/// description
@property (nonatomic, assign)   NSTimeInterval  currentTime;


@end
