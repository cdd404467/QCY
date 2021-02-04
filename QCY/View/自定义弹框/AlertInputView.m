//
//  AlertInputView.m
//  QCY
//
//  Created by i7colors on 2020/4/14.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AlertInputView.h"
#import "UITextField+Limit.h"
#import "UIButton+Extension.h"

static CGFloat aniTime = 0.4f;

@interface AlertInputView()


@end

@implementation AlertInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.frame = SCREEN_BOUNDS;
    CGFloat width = SCREEN_WIDTH - 15 * 2;
    CGFloat height = 250.f;
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, width, height)];
    alertView.layer.cornerRadius = 5.f;
    alertView.clipsToBounds = YES;
    alertView.backgroundColor = UIColor.whiteColor;
    [self addSubview:alertView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"立即预约";
    titleLab.textColor = UIColor.blackColor;
    titleLab.font = [UIFont boldSystemFontOfSize:21];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.numberOfLines = 2;
    [alertView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(54);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
    }];
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.font = [UIFont systemFontOfSize:18];
    textLab.text = @"手机号码:";
    [alertView addSubview:textLab];
    [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    
    UITextField *phoneNumberTF = [[UITextField alloc] init];
    phoneNumberTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
    phoneNumberTF.maxLength = 11;
    phoneNumberTF.tintColor = MainColor;
    phoneNumberTF.font = [UIFont systemFontOfSize:18];
    [alertView addSubview:phoneNumberTF];
    [phoneNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textLab.mas_right).offset(13);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(36);
        make.centerY.mas_equalTo(textLab);
    }];
    _phoneNumberTF = phoneNumberTF;
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.backgroundColor = HEXColor(@"#ED3851", 1);
    [_leftBtn setTitle:@"提交" forState:UIControlStateNormal];
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_leftBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [alertView addSubview:_leftBtn];
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(alertView.width / 2);
    }];
    
    _rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightbtn.backgroundColor = HEXColor(@"#f9f9f9", 1);
    [_rightbtn setTitle:@"取消" forState:UIControlStateNormal];
    _rightbtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_rightbtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [alertView addSubview:_rightbtn];
    DDWeakSelf;
    [_rightbtn addEventHandler:^{
        [weakself remove];
    }];
    
    [_rightbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(alertView.width / 2);
    }];
    
    alertView.center = self.center;
    alertView.centerY = self.centerY - 60;
    alertView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:aniTime delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
        alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
    
}

- (void)show {
    [UIApplication.sharedApplication.keyWindow addSubview:self];
}

- (void)remove {
    [UIView animateWithDuration:aniTime animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
