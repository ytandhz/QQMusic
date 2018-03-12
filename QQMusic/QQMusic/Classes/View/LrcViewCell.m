//
//  LrcViewCell.m
//  QQMusic
//
//  Created by huang ytand on 2018/3/12.
//  Copyright © 2018年 ytandhr. All rights reserved.
//

#import "LrcViewCell.h"
#import "LrcLabel.h"
@implementation LrcViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self lrcLabel];
    }
    return self;
}

- (LrcLabel *)lrcLabel {
    if (!_lrcLabel) {
        _lrcLabel = [[LrcLabel alloc]init];
        _lrcLabel.font = [UIFont systemFontOfSize:13.f];
        _lrcLabel.textAlignment = NSTextAlignmentCenter;
        _lrcLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_lrcLabel];
    }
    return _lrcLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_lrcLabel sizeToFit];
    _lrcLabel.center = self.contentView.center;
}

@end
