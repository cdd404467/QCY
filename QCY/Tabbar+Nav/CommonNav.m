//
//  CommonNav.m
//  QCY
//
//  Created by i7colors on 2018/10/9.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "CommonNav.h"
#import "MacroHeader.h"
#import <Masonry.h>

@implementation CommonNav

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT);
        [self setupUI];
    }
    return self;
}

- (void)setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
}

- (void)setupUI {
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    _titleLabel = titleLabel;
    
    //左边返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(50);
    }];
    _backBtn = backBtn;
    
    //右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.1f];
//    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    rightBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(50);
    }];
    _rightBtn = rightBtn;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = RGBA(0, 0, 0, 0.3);
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    _bottomLine = bottomLine;
}

- (void)setLeftBtnTintColor:(UIColor *)leftBtnTintColor {
    _leftBtnTintColor = leftBtnTintColor;
    UIImage *image = [UIImage imageNamed:@"back_black"];
    [_backBtn setImage:[image imageWithTintColor:leftBtnTintColor] forState:UIControlStateNormal];
    _backBtn.tintColor = leftBtnTintColor;
}

@end
