//
//  ProgressView.m
//  QCY
//
//  Created by i7colors on 2019/1/8.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProgressView.h"
#import "MacroHeader.h"
#import <Masonry.h>

@interface ProgressView()
@property (nonatomic, strong)UIView *alertView;
@property (nonatomic, strong)UIButton *cancelBtn;
@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self)weakself = self;
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        self.frame = SCREEN_BOUNDS;
        [UIView animateWithDuration:0.3 animations:^{
            weakself.backgroundColor = RGBA(0, 0, 0, 0.5);
        }];
        
        _alertView = [[UIView alloc]init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.frame = CGRectMake(20, (SCREEN_HEIGHT - 190) / 2, SCREEN_WIDTH - 40, 190);
        _alertView.layer.cornerRadius = 10;
        [self addSubview:_alertView];
        
        _alertView.layer.position = self.center;
        _alertView.transform = CGAffineTransformMakeScale(0.4, 0.4);
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            weakself.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
        
        UIProgressView *progressView = [[UIProgressView alloc] init];
        progressView.layer.cornerRadius = 2.5;
        progressView.clipsToBounds = YES;
        progressView.tintColor = MainColor;
        [_alertView addSubview:progressView];
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(5);
            make.top.mas_equalTo(45);
        }];
        _progressView = progressView;
        
        UILabel *percentLabel = [[UILabel alloc] init];
        percentLabel.font = [UIFont systemFontOfSize:15];
        percentLabel.textColor = [UIColor blackColor];
        percentLabel.textAlignment = NSTextAlignmentCenter;
        [_alertView addSubview:percentLabel];
        [percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(progressView.mas_bottom).offset(10);
            make.left.right.mas_equalTo(progressView);
            make.height.mas_equalTo(20);
        }];
        _percentLabel = percentLabel;
//        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [_cancelBtn addTarget:self action:@selector(touchCancelBtn) forControlEvents:UIControlEventTouchUpInside];
//        [_cancelBtn setTitleColor:MainColor forState:UIControlStateNormal];
//        _cancelBtn.layer.borderColor = MainColor.CGColor;
//        _cancelBtn.layer.cornerRadius = 20;
//        _cancelBtn.layer.borderWidth = 1.0f;
//        [_alertView addSubview:_cancelBtn];
//        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(self);
//            make.height.mas_equalTo(40);
//            make.width.mas_equalTo(120);
//            make.bottom.mas_equalTo(-25);
//        }];
        
        [UIApplication.sharedApplication.keyWindow addSubview:self];
    }
    
    return self;
}

- (void)touchCancelBtn {
    [self removeView];
}

- (void)removeView {
    for(UIView *view in [_alertView subviews]) {
        [view removeFromSuperview];
    }
    [self removeFromSuperview];
}

@end
