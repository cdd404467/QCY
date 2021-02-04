//
//  FCMapLeftNavView.m
//  QCY
//
//  Created by i7colors on 2019/7/16.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCMapLeftNavView.h"
#import "FriendCricleModel.h"

static const CGFloat width = 40;

@interface FCMapLeftNavView()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTtleLab;
@end

@implementation FCMapLeftNavView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.isLeft = YES;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    self.backgroundColor = RGBA(0, 0, 0, 0);
    //伸缩按钮
    self.touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.touchBtn.frame = CGRectMake(SCREEN_WIDTH - width - 10, (60 - width) / 2, width, width);
    self.touchBtn.backgroundColor = RGBA(0, 0, 0, 0.4);
    self.touchBtn.layer.cornerRadius = 5;
    self.touchBtn.adjustsImageWhenHighlighted = NO;
    [self.touchBtn setImage:[UIImage imageNamed:@"fc_left_navBtn"] forState:UIControlStateNormal];
    [self addSubview:self.touchBtn];
    //导航按钮
    self.navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navBtn.backgroundColor = UIColor.clearColor;
    self.navBtn.adjustsImageWhenHighlighted = NO;
    [self.navBtn setImage:[UIImage imageNamed:@"fc_left_navimg"] forState:UIControlStateNormal];
    [self addSubview:self.navBtn];
    [self.navBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.right.mas_equalTo(-50);
        make.centerY.mas_equalTo(self);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textColor = UIColor.whiteColor;
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(-90);
        make.top.mas_equalTo(5);
    }];
    _titleLab = titleLab;
    
    UILabel *subTtleLab = [[UILabel alloc] init];
    subTtleLab.font = [UIFont systemFontOfSize:13];
    subTtleLab.textColor = UIColor.whiteColor;
    [self addSubview:subTtleLab];
    [subTtleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(titleLab);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(0);
    }];
    _subTtleLab = subTtleLab;
    [self startAnimating];
}

- (void)startAnimating {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    animation.fromValue =  [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    animation.duration = 4;
    animation.repeatCount = ULLONG_MAX;
    animation.removedOnCompletion = NO;
    animation.cumulative = YES;
//    animation.autoreverses = YES;
//    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.touchBtn.imageView.layer addAnimation:animation forKey:@"transform.rotation.x"];
}

- (void)setModel:(FriendCricleModel *)model {
    _model = model;
    _titleLab.text = model.locationTitle;
    
    _subTtleLab.text = model.locationAddress;
}

@end
