//
//  FindPasswordVC.m
//  QCY
//
//  Created by i7colors on 2018/9/27.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FindPasswordVC.h"
#import "CommonNav.h"
#import "ClassTool.h"
#import <Masonry.h>
#import "MacroHeader.h"
#import "ResetPassword.h"

@interface FindPasswordVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *phoneTF;
@property (nonatomic, strong)UITextField *msgCodeTF;
@end

@implementation FindPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
}

- (void)setupNav {
    CommonNav *nav = [[CommonNav alloc] init];
    nav.titleLabel.text = @"找回密码";
    [ClassTool addLayer:nav frame:nav.frame];
    nav.titleLabel.textColor = [UIColor whiteColor];
    nav.bottomLine.hidden = YES;
    [nav.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
}

- (void)setupUI {
    //手机号
    UITextField *phoneTF = [[UITextField alloc] init];
    [self.view addSubview:phoneTF];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KFit_H(206) + NAV_HEIGHT);
        make.height.mas_equalTo(@(50 * Scale_H));
        make.left.mas_equalTo(@(KFit_W(38)));
        make.right.mas_equalTo(@(KFit_W(-38)));
    }];
    _phoneTF = phoneTF;
    [self setTextField:phoneTF];

    //短信验证码底框
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
    bgView.layer.cornerRadius = 3;
    bgView.layer.cornerRadius = 3;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneTF.mas_bottom).offset(KFit_H(15));
        make.height.mas_equalTo(phoneTF.mas_height);
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
    }];
    
    //手机验证码
    UITextField *msgCodeTF = [[UITextField alloc] init];
    [bgView addSubview:msgCodeTF];
    [msgCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(@0);
        make.width.mas_equalTo(@(KFit_W(170)));
    }];
    _msgCodeTF = msgCodeTF;
    [self setTextField:msgCodeTF];
    
    //分割线 - 1
    UIView *sLine_2 = [[UIView alloc] init];
    sLine_2.backgroundColor = HEXColor(@"#D7D7D7", 1);
    [bgView addSubview:sLine_2];
    [sLine_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(msgCodeTF.mas_right);
        make.height.mas_equalTo(@(30 * Scale_H));
        make.width.mas_equalTo(@0.5);
        make.centerY.mas_equalTo(msgCodeTF.mas_centerY);
    }];
    
    //获取验证码按钮
    UIButton *countDownbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [countDownbtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [countDownbtn setTitleColor:HEXColor(@"#C8C8C8", 1) forState:UIControlStateNormal];
    countDownbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:countDownbtn];
    [countDownbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sLine_2.mas_right);
        make.top.bottom.right.mas_equalTo(@0);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH - KFit_W(38 * 2), 49);
    [ClassTool addLayer:loginBtn frame:rect];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.clipsToBounds = YES;
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:RGBA(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(jumpToResetPassVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
        make.height.mas_equalTo(@49);
        make.top.mas_equalTo(bgView.mas_bottom).offset(KFit_H(18));
    }];
    
}

//设置textfield
- (void)setTextField:(UITextField *)tf {
    if ([tf isEqual:_phoneTF]) {
        tf.placeholder = @"请输入手机号";
    } else {
        tf.placeholder = @"请输入验证码";
    }
    
    //添加leftView
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KFit_W(18), KFit_H(50))];
    //    leftView.image = [UIImage imageNamed:imageName];
    leftView.contentMode = UIViewContentModeCenter;
    tf.leftView = leftView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    //placeholder颜色
    [tf setValue:HEXColor(@"#C8C8C8", 1) forKeyPath:@"_placeholderLabel.textColor"];
    tf.delegate = self;
    tf.font = [UIFont systemFontOfSize:15];
    if (![tf isEqual:_msgCodeTF]) {
        tf.layer.borderWidth = 1;
        tf.layer.cornerRadius = 3;
        tf.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
    }
    
}

- (void)jumpToResetPassVC {
    ResetPassword *vc = [[ResetPassword alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
