//
//  QCYAlertView.m
//  QCY
//
//  Created by i7colors on 2019/10/21.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "QCYAlertView.h"
#import "ClassTool.h"
#import "UIButton+Extension.h"


static CGFloat aniTime = 0.4f;

@interface QCYAlertView()
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightbtn;
@property (nonatomic, strong) QCYAlertView *alertView;
@end

@implementation QCYAlertView

- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text flag:(NSInteger)flag leftBtnTitle:(NSString *)leftBt rightBtnTitle:(NSString *)rightBt leftHandler:(void (^ __nullable)(void))leftHandler rightHandler:(void (^ __nullable)(void))rightHandler cancel:(void (^ __nullable)(void))cancel {
    if (self = [super init]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        [self setupUIWithTitle:title text:text flag:flag leftBtnTitle:leftBt rightBtnTitle:rightBt leftHandler:leftHandler rightHandler:rightHandler cancel:cancel];
    }
    return self;
}

- (void)setupUIWithTitle:(NSString *)title text:(NSString *)text flag:(NSInteger)flag leftBtnTitle:(NSString *)leftBt rightBtnTitle:(NSString *)rightBt leftHandler:(void (^ __nullable)(void))leftHandler rightHandler:(void (^ __nullable)(void))rightHandler cancel:(void (^ __nullable)(void))cancel {
    
    self.frame = SCREEN_BOUNDS;
    CGFloat width = SCREEN_WIDTH - 38 * 2;
    CGFloat height = 230.f;
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    alertView.layer.cornerRadius = 10.f;
    alertView.clipsToBounds = YES;
    alertView.backgroundColor = UIColor.whiteColor;
    [self addSubview:alertView];
    
    [ClassTool addLayer:alertView frame:CGRectMake(0, 0, alertView.width, 49)];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = title;
    titleLab.textColor = UIColor.whiteColor;
    titleLab.font = [UIFont boldSystemFontOfSize:16];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.numberOfLines = 2;
    [alertView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
    }];
    
    DDWeakSelf;
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.adjustsImageWhenHighlighted = NO;
    [closeBtn setImage:[UIImage imageNamed:@"alert_close"] forState:UIControlStateNormal];
    [alertView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(titleLab);
    }];
    [closeBtn addEventHandler:^{
        [weakself remove];
        if (cancel) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cancel();
            });
        }
    }];
    
    CGFloat labWidth = width - 18 * 2;
    UILabel *textLab = [[UILabel alloc] init];
    textLab.text = [@"" stringByAppendingFormat:@"%@",text];
    textLab.textColor = HEXColor(@"#3C3C3C", 1);
    textLab.font = [UIFont systemFontOfSize:15];
    textLab.numberOfLines = 0;
    [alertView addSubview:textLab];
    CGFloat labHeight = [textLab.text boundingRectWithSize:CGSizeMake(labWidth, 600)
       options:NSStringDrawingUsesLineFragmentOrigin
    attributes:@{NSFontAttributeName : textLab.font}
                         context:nil].size.height;
    textLab.frame = CGRectMake(18, 49 + 20, labWidth, labHeight + 1);
    
    
    CGFloat btnWidth = (width - 15 * 3) / 2;
    CGFloat btnHeight = 36.f;
    CGFloat gap = 20.f;
    if (flag == 0) {
        if (textLab.bottom + gap > height) {
            alertView.height = textLab.bottom + gap;
        } else {
            textLab.height = height - 49 - gap * 2;
        }
    } else if (flag == 1) {
        [alertView addSubview:self.leftBtn];
        self.leftBtn.frame = CGRectMake(0, textLab.bottom + gap, btnWidth, btnHeight);
        self.leftBtn.centerX = textLab.centerX;
        [self.leftBtn setTitle:leftBt forState:UIControlStateNormal];
        [self.leftBtn addEventHandler:^{
            [weakself remove];
            if (leftHandler) {
                leftHandler();
            }
        }];
        if (_leftBtn.bottom + gap > height) {
            alertView.height = _leftBtn.bottom + gap;
        } else {
            textLab.height = height - 49 - gap * 2 - btnHeight - gap;
            _leftBtn.top = textLab.bottom + gap;
        }
    } else if (flag == 2) {
        [alertView addSubview:self.leftBtn];
        self.leftBtn.frame = CGRectMake(15, textLab.bottom + gap, btnWidth, btnHeight);
        [self.leftBtn setTitle:leftBt forState:UIControlStateNormal];
        [self.leftBtn addEventHandler:^{
            [weakself remove];
            if (leftHandler) {
                leftHandler();
            }
        }];
        
        [alertView addSubview:self.rightbtn];
        self.rightbtn.frame = CGRectMake(self.leftBtn.right + 15, textLab.bottom + gap, btnWidth, btnHeight);
        [self.rightbtn setTitle:rightBt forState:UIControlStateNormal];
        [self.rightbtn addEventHandler:^{
            [weakself remove];
            if (rightHandler) {
                rightHandler();
            }
        }];
        
        if (_leftBtn.bottom + gap > height) {
            alertView.height = _leftBtn.bottom + gap;
        } else {
            textLab.height = height - 49 - gap * 2 - btnHeight - gap;
            _leftBtn.top = textLab.bottom + gap;
            _rightbtn.top = _leftBtn.top;
        }
    }
    
    alertView.center = self.center;
    
    alertView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:aniTime delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
        alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
    
    [UIApplication.sharedApplication.keyWindow addSubview:self];
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.layer.cornerRadius = 18.f;
        _leftBtn.backgroundColor = UIColor.whiteColor;
        [_leftBtn setTitleColor:MainColor forState:UIControlStateNormal];
        _leftBtn.layer.borderWidth = 2.f;
        _leftBtn.layer.borderColor = MainColor.CGColor;
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _leftBtn;
}

- (UIButton *)rightbtn {
    if (!_rightbtn) {
        _rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightbtn.layer.cornerRadius = 18.f;
        _rightbtn.backgroundColor = MainColor;
        [_rightbtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _rightbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _rightbtn;
}

//没有按钮
+ (QCYAlertView *)showWithTitle:(NSString *)title text:(NSString *)text cancel:(void (^ __nullable)(void))cancel {
    QCYAlertView *view = [[QCYAlertView alloc] initWithTitle:title text:text flag:0 leftBtnTitle:nil rightBtnTitle:nil leftHandler:nil rightHandler:nil cancel:cancel];
    return view;
}

//一个按钮
+ (QCYAlertView *)showWithTitle:(NSString *)title text:(NSString *)text btnTitle:(NSString *)btnTitle handler:(void (^ _Nullable)(void))handler cancel:(void (^ __nullable)(void))cancel {
    QCYAlertView *view = [[QCYAlertView alloc] initWithTitle:title text:text flag:1 leftBtnTitle:btnTitle rightBtnTitle:nil leftHandler:handler rightHandler:nil cancel:cancel];
    return view;
}

//两个按钮
+ (QCYAlertView *)showWithTitle:(NSString *)title text:(NSString *)text leftBtnTitle:(NSString *)leftBt rightBtnTitle:(NSString *)rightBt leftHandler:(void (^ __nullable)(void))leftHandler rightHandler:(void (^ __nullable)(void))rightHandler cancel:(void (^ __nullable)(void))cancel {
    QCYAlertView *view = [[QCYAlertView alloc] initWithTitle:title text:text flag:2 leftBtnTitle:leftBt rightBtnTitle:rightBt leftHandler:leftHandler rightHandler:rightHandler cancel:cancel];
    return view;
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
