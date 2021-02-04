//
//  CustomNavigationBar.m
//  QCY
//
//  Created by i7colors on 2019/3/23.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "CustomNavigationBar.h"

@interface CustomNavigationBar()
@property (nonatomic, strong)UIView *backgroundView;
@end

@implementation CustomNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT);
        self.userInteractionEnabled = YES;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.frame = CGRectMake(4, STATEBAR_HEIGHT, SCREEN_WIDTH - 8, 44);
    [self addSubview:backgroundView];
    _backgroundView = backgroundView;
    
    //左边返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [leftBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [backgroundView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(backgroundView);
        make.width.mas_equalTo(38);
    }];
    _leftBtn = leftBtn;
    
    
    //右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    rightBtn.adjustsImageWhenHighlighted = NO;
    [backgroundView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(backgroundView);
        make.width.mas_equalTo(38);
    }];
    _rightBtn = rightBtn;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(44);
        make.center.mas_equalTo(backgroundView);
        make.width.mas_equalTo(SCREEN_WIDTH -100);
    }];
    _titleLabel = titleLabel;
    
    
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
    [_leftBtn setImage:[image imageWithTintColor_My:leftBtnTintColor] forState:UIControlStateNormal];
    _leftBtn.tintColor = leftBtnTintColor;
}

- (void)setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    _titleLabel.text = navTitle;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    _titleLabel.textColor = titleColor;
}

- (void)setLeftBtnTextColor:(UIColor *)leftBtnTextColor {
    _leftBtnTextColor = leftBtnTextColor;
    [_leftBtn setTitleColor:leftBtnTextColor forState:UIControlStateNormal];
}

- (void)setRightBtnTextColor:(UIColor *)rightBtnTextColor {
    _rightBtnTextColor = rightBtnTextColor;
    [_rightBtn setTitleColor:rightBtnTextColor forState:UIControlStateNormal];
}


- (void)setLeftBtnFont:(UIFont *)leftBtnFont {
    _leftBtnFont = leftBtnFont;
    _leftBtn.titleLabel.font = leftBtnFont;
}

- (void)setRightBtnFont:(UIFont *)rightBtnFont {
    _rightBtnFont = rightBtnFont;
    _rightBtn.titleLabel.font = rightBtnFont;
}


@end
