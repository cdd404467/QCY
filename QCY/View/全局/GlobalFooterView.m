//
//  GlobalFooterView.m
//  QCY
//
//  Created by i7colors on 2018/11/21.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GlobalFooterView.h"

@implementation GlobalFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
        self.backgroundColor = Like_Color;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGFloat width = SCREEN_WIDTH / 3;
    UILabel *tip = [[UILabel alloc] init];
    tip.text = @"已经到底了";
    tip.textAlignment = NSTextAlignmentCenter;
    tip.font = [UIFont systemFontOfSize:14];
    tip.textColor = RGBA(0, 0, 0, 0.4);
    [self addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.mas_equalTo(0);
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(width);
    }];
    [self addSubview:tip];
    _tip = tip;
    
    CGFloat margin = 40;
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = RGBA(0, 0, 0, 0.4);
    [self addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(margin);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(- width * 2);
    }];

    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = RGBA(0, 0, 0, 0.4);
    [self addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-margin);
        make.centerY.mas_equalTo(self);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(width * 2);
    }];
    
}



@end
