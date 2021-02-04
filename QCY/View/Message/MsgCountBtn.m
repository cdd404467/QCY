//
//  MsgCountBtn.m
//  QCY
//
//  Created by i7colors on 2019/8/26.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MsgCountBtn.h"


@interface MsgCountBtn()

@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation MsgCountBtn

//buttonWithType需要重写initWithFrame方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI {
    _countLabel = [[UILabel alloc] init];
    _countLabel.backgroundColor = UIColor.redColor;
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.font = [UIFont systemFontOfSize:13];
    _countLabel.layer.cornerRadius = 9;
    _countLabel.clipsToBounds = YES;
    _countLabel.textColor = UIColor.whiteColor;
    _countLabel.hidden = YES;
    [self addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX).offset(10);
        make.width.height.mas_equalTo(18);
        make.top.mas_equalTo(self.mas_top).offset(4);
    }];
}


//设置数量
- (void)setBadgeValue:(NSInteger)badgeValue {
    
    _badgeValue = badgeValue;
    _countLabel.hidden = badgeValue > 0 ? NO : YES;
    NSString *text = @(badgeValue).stringValue;
    if (badgeValue >= 100)
        text = @"99+";
    
    _countLabel.text = text;
    
    CGFloat width = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 18)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:_countLabel.font}
                                       context:nil].size.width;
    
    if (width < 18 && text.length < 2) {
        width = 18;
    } else {
        width = width + 10;
    }
    
    [_countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}


@end
