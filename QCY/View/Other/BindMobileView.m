//
//  BindMobileView.m
//  DSXS
//
//  Created by 李明哲 on 2018/7/14.
//  Copyright © 2018年 李明哲. All rights reserved.
//

#import "BindMobileView.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "CountDown.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "MobilePhone.h"
#import "CddHUD.h"

@interface BindMobileView()<UITextFieldDelegate>

@end

@implementation BindMobileView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    __weak typeof(self)weakself = self;
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    self.frame = SCREEN_BOUNDS;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.backgroundColor = RGBA(0, 0, 0, 0.8);
    }];
    
    UIView *bindView = [[UIView alloc]init];
    bindView.backgroundColor = [UIColor whiteColor];
    bindView.layer.cornerRadius = 8;
    [self addSubview:bindView];
    
    CGFloat width = KFit_W(290);
    CGFloat height = KFit_W(260);
    bindView.frame = CGRectMake( (SCREEN_WIDTH - width) / 2 , SCREEN_HEIGHT + height, width, height);
    [UIView animateWithDuration:0.3 animations:^{
//        bindView.center = weakself.center;
        CGFloat dis = SCREEN_HEIGHT / 2 - height / 2 - KFit_W(25);
        bindView.frame = CGRectMake( (SCREEN_WIDTH - width) / 2 , dis, width, height);
    }];
    
    UILabel *bindText = [[UILabel alloc]init];
    bindText.font = [UIFont systemFontOfSize:18];
    bindText.text = @"绑定手机号";
    bindText.textAlignment = NSTextAlignmentCenter;
    bindText.textColor = [UIColor blackColor];
    [bindView addSubview:bindText];
    [bindText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(KFit_W(18)));
        make.top.mas_equalTo(@(KFit_W(20)));
        make.centerX.equalTo(bindView);
    }];
    
    //手机号tf
    UITextField *phoneTF = [[UITextField alloc]init];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 19, 30)];
    phoneTF.leftView = leftView;
    phoneTF.leftViewMode = UITextFieldViewModeAlways;
    phoneTF.backgroundColor = RGBA(239, 244, 248, 1);
    phoneTF.layer.cornerRadius = 5;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.font = [UIFont systemFontOfSize:14];
    [phoneTF setValue:RGBA(122, 122, 122, 1) forKeyPath:@"_placeholderLabel.textColor"];
    phoneTF.layer.borderColor= RGBA(219, 222, 224, 1).CGColor;
    phoneTF.layer.borderWidth= 0.5f;
    phoneTF.placeholder = @"手机号";
    phoneTF.tag = 1;
    phoneTF.tintColor = MainColor;
    phoneTF.delegate = self;
    [phoneTF addTarget:self action:@selector(phoneTFChange:) forControlEvents:UIControlEventEditingChanged];
    [bindView addSubview:phoneTF];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(KFit_W(60)));
        make.left.equalTo(@(KFit_W(20)));
        make.right.equalTo(@(KFit_W(-20)));
        make.height.equalTo(@(KFit_W(40)));
    }];
    _phoneTF = phoneTF;
    
    //验证码tf
    UITextField *passwdTF = [[UITextField alloc]init];
    UIView *leftView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 19, 30)];
    passwdTF.leftView = leftView1;
    passwdTF.leftViewMode = UITextFieldViewModeAlways;
    passwdTF.backgroundColor = RGBA(239, 244, 248, 1);
    passwdTF.layer.cornerRadius = 5;
    passwdTF.tintColor = MainColor;
    passwdTF.delegate = self;
    passwdTF.font = [UIFont systemFontOfSize:14];
    passwdTF.keyboardType = UIKeyboardTypeNumberPad;
    [passwdTF setValue:RGBA(122, 122, 122, 1) forKeyPath:@"_placeholderLabel.textColor"];
    passwdTF.placeholder = @"短信验证码";
    passwdTF.layer.borderWidth = 0.5f;
    passwdTF.layer.borderColor = RGBA(219, 222, 224, 1).CGColor;
    passwdTF.delegate = self;
    [passwdTF addTarget:self action:@selector(passTFChange:) forControlEvents:UIControlEventEditingChanged];
    [bindView addSubview:passwdTF];
    [passwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTF.mas_bottom).with.offset(KFit_W(20));
        make.left.equalTo(@(KFit_W(20)));
        make.width.equalTo(@((width - KFit_W(50)) / 2 ));
        make.height.equalTo(@(KFit_W(40)));
    }];
    _passwdTF = passwdTF;
    
    //获取验证码按钮
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    codeBtn.layer.cornerRadius = 5;
    codeBtn.clipsToBounds = YES;
    codeBtn.enabled = NO;
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [codeBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"#708090", 1)] forState:UIControlStateNormal];
    [codeBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"#708090", 0.3)] forState:UIControlStateDisabled];
    [codeBtn addTarget:self action:@selector(getSMSCode) forControlEvents:UIControlEventTouchUpInside];
    [bindView addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(passwdTF);
        make.left.equalTo(passwdTF.mas_right).with.offset(KFit_W(10));
        make.right.equalTo(@(KFit_W(-20)));
    }];
    _codeBtn = codeBtn;
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:MainColor forState:UIControlStateNormal];
    cancelBtn.layer.borderWidth = 1.0f;
    cancelBtn.layer.borderColor = MainColor.CGColor;
    cancelBtn.layer.cornerRadius = 20;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bindView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(KFit_W(40)));
        make.left.equalTo(@(KFit_W(20)));
        make.width.equalTo(@((width - KFit_W(50)) / 2 ));
        make.top.mas_equalTo(self.passwdTF.mas_bottom).with.offset(KFit_W(30));
    }];
    _cancelBtn = cancelBtn;
    
    //登陆按钮
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    loginBtn.layer.cornerRadius = 20;
    loginBtn.clipsToBounds = YES;
    [loginBtn setBackgroundImage:[UIImage imageWithColor:MainColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"ef3673", 0.2)] forState:UIControlStateDisabled];
//    [loginBtn addTarget:self action:@selector(bindPhone) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bindView addSubview:loginBtn];
    loginBtn.enabled = NO;
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(KFit_W(40)));
        make.left.equalTo(cancelBtn.mas_right).with.offset(KFit_W(10));
        make.right.equalTo(@(KFit_W(-20)));
        make.top.mas_equalTo(cancelBtn.mas_top);
    }];
    _loginBtn = loginBtn;
}

#pragma mark - 网络请求
//获取短信验证码
- (void)getSMSCode {
    if ([MobilePhone isValidMobile:_phoneTF.text] == NO) {
        [CddHUD showTextOnlyDelay:@"请输入有效的手机号" view:self];
        return ;
    }
    NSDictionary *dict = @{@"mobile":_phoneTF.text,
                           };
    DDWeakSelf;
    [ClassTool postRequest:URL_Msg_Code_BindPhone Params:[dict mutableCopy] Success:^(id json) {
//                        NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            BOOL isSuc = [json[@"data"] boolValue];
            if (isSuc == YES) {
                [weakself countDown:weakself.codeBtn];
            }
        }else if ([json[@"code"] isEqualToString:@"CAPTCHA_ERROR"]) {
            
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark 倒计时
-(void)countDown:(UIButton *)sender {
    //    60s的倒计时
    NSTimeInterval aMinutes = 60;
    [self startWithStartDate:[NSDate date] finishDate:[NSDate dateWithTimeIntervalSinceNow:aMinutes]];
}

-(void)startWithStartDate:(NSDate *)strtDate finishDate:(NSDate *)finishDate{
    DDWeakSelf;
    CountDown *countDown = [[CountDown alloc] init];
    [countDown countDownWithStratDate:strtDate finishDate:finishDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        //        NSLog(@"second = %li",second);
        NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
        if (totoalSecond == 0) {
            weakself.codeBtn.enabled = YES;
            [weakself.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }else{
            weakself.codeBtn.enabled = NO;
            [weakself.codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%lds)",(long)totoalSecond] forState:UIControlStateNormal];
        }
        
    }];
}

//移除视图
- (void)removeSignView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}

#pragma mark - 键盘监听事件
//点击空白结束编辑
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self endEditing:YES];
}

//监听键盘输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *currentText = textField.text ?: @"";
    NSString *newText = [currentText stringByReplacingCharactersInRange:range withString:string];

    if (textField == self.phoneTF) {
        return newText.length <= 11;
    } else {
        return newText.length <= 6;
    }

    return YES;
}

//监听phoneTF
- (void)phoneTFChange:(UITextField *)textField{

    if (textField.text.length == 11 && [_codeBtn.titleLabel.text isEqualToString:@"获取验证码"]) {
        self.codeBtn.enabled = YES;
        [self.passwdTF becomeFirstResponder];
    } else {
        self.codeBtn.enabled = NO;
    }

    if (self.phoneTF.text.length == 11 && self.passwdTF.text.length == 6) {
        self.loginBtn.enabled = YES;

    } else {
        self.loginBtn.enabled = NO;
    }
}


//监听passTF
- (void)passTFChange:(UITextField *)textField{
    if (self.phoneTF.text.length == 11 && self.passwdTF.text.length == 6) {
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.enabled = NO;
    }
}

@end
