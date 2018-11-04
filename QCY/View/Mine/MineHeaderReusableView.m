//
//  MineHeaderReusableView.m
//  QCY
//
//  Created by i7colors on 2018/10/21.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MineHeaderReusableView.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import <SDAutoLayout.h>


@implementation MineHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = HEXColor(@"#EDEDED", 1);
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI {
    
    //背景
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(11);
        make.height.mas_equalTo(40);
    }];
    
    //横线
    UIView *hView = [[UIView alloc] init];
    hView.backgroundColor = LineColor;
    hView.frame = CGRectMake(0, 39, SCREEN_WIDTH, 1);
    [bgView addSubview:hView];
    
    //左边icion
    UIImageView *leftImageView = [[UIImageView alloc] init];
    [bgView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(49));
        make.centerY.mas_equalTo(bgView);
        make.width.height.mas_equalTo(18);
    }];
    _leftImageView = leftImageView;
    
    //左边label
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.font = [UIFont systemFontOfSize:12];
    leftLabel.textColor = HEXColor(@"#333333", 1);
    [bgView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftImageView.mas_right).offset(KFit_W(23));
        make.centerY.mas_equalTo(leftImageView);
    }];
    _leftLabel = leftLabel;
    
    //右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.adjustsImageWhenHighlighted = NO;
    [rightBtn setTitleColor:HEXColor(@"#BCBCBC", 1) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [bgView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KFit_W(-30));
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(bgView);
        make.width.mas_equalTo(68);
    }];
    _rightBtn = rightBtn;
    
    rightBtn.imageView.sd_layout
    .rightSpaceToView(rightBtn, 0)
    .centerYEqualToView(rightBtn)
    .widthIs(6)   //设置6的时候，居中
    .heightIs(11);
    
    rightBtn.titleLabel.sd_layout
    .leftSpaceToView(rightBtn, 0)
    .centerYEqualToView(rightBtn);
}

@end
