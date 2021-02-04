//
//  RegisterVC.m
//  QCY
//
//  Created by i7colors on 2018/9/21.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "RegisterVC.h"
#import "ClassTool.h"
#import <YYText.h>
#import "MobilePhone.h"
#import "UITextField+Limit.h"
#import "UIDevice+UUID.h"
#import "NetWorkingPort.h"
#import "CountDown.h"
#import "CddHUD.h"
#import "AES128.h"
#import "UserProtocolVC.h"
#import "BRPickerView.h"
#import "PerfectMyInfoVC.h"


@interface RegisterVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITextField *phoneTF;
@property (nonatomic, strong)UITextField *msgCodeTF;
@property (nonatomic, strong)UITextField *setPassTF;
@property (nonatomic, strong)UITextField *setPassAgainTF;
@property (nonatomic, strong)UIButton *countDownbtn;
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"欢迎注册";
    [self setupNav];
    [self setupUI];
    DDWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself goUserProtocol];
    });
}

- (void)goUserProtocol {
    UserProtocolVC *vc= [[UserProtocolVC alloc] init];
    vc.webUrl = @"http://mobile.i7colors.com/groupBuyMobile/secret.html";
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        //是否可以滚动
        _scrollView.scrollEnabled = YES;
        //禁止水平滚动
        _scrollView.alwaysBounceHorizontal = NO;
        //允许垂直滚动
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}


- (void)setupNav {
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT)];
    [ClassTool addLayer:nav frame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT) startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self vhl_setNavBarBackgroundView:nav];
    [self vhl_setNavBarTitleColor:UIColor.whiteColor];
    self.backBtnTintColor = UIColor.whiteColor;
    [self vhl_setNavigationSwitchStyle:VHLNavigationSwitchStyleFakeNavBar];
}

#pragma mark - 网络请求
//获取短信验证码
- (void)getSMSCode {
    if ([_phoneTF.text isEqualToString:@""]) {
        [CddHUD showTextOnlyDelay:@"请输入手机号" view:self.view];
        return ;
    } else if ([MobilePhone isValidMobile:_phoneTF.text] == NO) {
        [CddHUD showTextOnlyDelay:@"请输入有效的手机号" view:self.view];
        return ;
    }

    NSDictionary *dict = @{@"mobile":_phoneTF.text,
//                           @"captcha":_imageCodeTF.text,
                           @"deviceNo":[UIDevice getDeviceID]
                           };
    DDWeakSelf;
    [ClassTool postRequest:URL_Msg_Code_Register Params:[dict mutableCopy] Success:^(id json) {
        //                NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            BOOL isSuc = [json[@"data"] boolValue];
            if (isSuc == YES) {
                [weakself countDown:weakself.countDownbtn];
            }
        }else if ([json[@"code"] isEqualToString:@"CAPTCHA_ERROR"]) {
            
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

//用户注册
- (void)accountRegister {
    if ([self judgeData] == NO) {
        return ;
    };
    
    NSDictionary *dict = @{@"phone":_phoneTF.text,
                           @"password":[AES128 AES128Encrypt:_setPassTF.text],
                           @"smsCode":_msgCodeTF.text,
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    self.view.userInteractionEnabled = NO;
    [ClassTool postRequest:URLPost_User_Register Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        self.view.userInteractionEnabled = YES;
//                NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [CddHUD showTextOnlyDelay:@"注册成功" view:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    PerfectMyInfoVC *vc = [[PerfectMyInfoVC alloc] init];
                    vc.token = json[@"data"][@"token"];
                    [self.navigationController pushViewController:vc animated:YES];
                });
            });
        }else if ([json[@"code"] isEqualToString:@"REGISTER_FATL"]) {
            [CddHUD showTextOnlyDelay:@"该手机号已注册" view:weakself.view];
        }
        
    } Failure:^(NSError *error) {
        self.view.userInteractionEnabled = YES;
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
            weakself.countDownbtn.enabled = YES;
            [weakself.countDownbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }else{
            weakself.countDownbtn.enabled = NO;
            [weakself.countDownbtn setTitle:[NSString stringWithFormat:@"重新获取(%lds)",(long)totoalSecond] forState:UIControlStateNormal];
        }
    }];
}

#pragma mark - 检测信息是否填写正确
- (BOOL)judgeData {
    if ([_phoneTF.text isEqualToString:@""]) {
        [CddHUD showTextOnlyDelay:@"请输入手机号" view:self.view];
        return NO;
    } else if ([_msgCodeTF.text isEqualToString:@""]) {
        [CddHUD showTextOnlyDelay:@"请输入短信验证码" view:self.view];
        return NO;
    } else if ([_setPassTF.text isEqualToString:@""]) {
        [CddHUD showTextOnlyDelay:@"请设置密码" view:self.view];
        return NO;
    } else if ([_setPassAgainTF.text isEqualToString:@""]) {
        [CddHUD showTextOnlyDelay:@"请输入确认密码" view:self.view];
        return NO;
    } else if ([MobilePhone isValidMobile:_phoneTF.text] == NO) {
        [CddHUD showTextOnlyDelay:@"请输入有效的手机号" view:self.view];
        return NO;
    } else if (_msgCodeTF.text.length != 6) {
        [CddHUD showTextOnlyDelay:@"请输入6位短信验证码" view:self.view];
        return NO;
    } else if([self isEmpty:_setPassTF.text] == YES) {
        [CddHUD showTextOnlyDelay:@"密码不能包含空格" view:self.view];
        return NO;
    } else if(![_setPassTF.text isEqualToString:_setPassAgainTF.text]) {
        [CddHUD showTextOnlyDelay:@"两次密码输入不一致" view:self.view];
        return NO;
    } else if(_setPassTF.text.length < 6 || _setPassTF.text.length > 16) {
        [CddHUD showTextOnlyDelay:@"密码长度为6-16位" view:self.view];
        return NO;
    }
    
    return YES;
}

//检测是否能包含空格
- (BOOL)isEmpty:(NSString *) str {
    NSRange range = [str rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES; //yes代表包含空格
    }else {
        return NO; //反之
    }
}


#pragma mark - 设置UI
- (void)setupUI {
    
    [self.view addSubview:self.scrollView];
    //手机号
    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH - KFit_W(38) * 2, 50)];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.centerX = SCREEN_WIDTH / 2;
    [_scrollView addSubview:phoneTF];
    //限制字数
    [phoneTF lengthLimit:^{
        if (phoneTF.text.length > 11) {
            phoneTF.text = [phoneTF.text substringToIndex:11];
        }
    }];
    _phoneTF = phoneTF;
    [self setTextField:phoneTF];
    
    //加个星星
    for (int i = 0; i < 4; i++) {
        UIImageView *tabIcon = [[UIImageView alloc] init];
        tabIcon.image = [UIImage imageNamed:@"tab_icon"];
        [_scrollView addSubview:tabIcon];
        [tabIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(phoneTF.mas_centerY).offset(i * 65);
            make.left.mas_equalTo(20);
            make.width.height.mas_equalTo(4);
        }];
    }
    
    //短信验证码底框
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, phoneTF.bottom + 15, phoneTF.width, phoneTF.height)];
    bgView1.layer.borderWidth = 1;
    bgView1.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
    bgView1.layer.cornerRadius = 3;
    bgView1.centerX = phoneTF.centerX;
    [_scrollView addSubview:bgView1];
    
    //手机验证码
    UITextField *msgCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, KFit_W(180), bgView1.height)];
    msgCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    [bgView1 addSubview:msgCodeTF];
    [msgCodeTF lengthLimit:^{
        if (msgCodeTF.text.length > 6) {
            msgCodeTF.text = [msgCodeTF.text substringToIndex:6];
        }
    }];
    _msgCodeTF = msgCodeTF;
    [self setTextField:msgCodeTF];
    
    //分割线 - 1
    UIView *sLine_1 = [[UIView alloc] init];
    sLine_1.backgroundColor = HEXColor(@"#D7D7D7", 1);
    [bgView1 addSubview:sLine_1];
    [sLine_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(msgCodeTF.mas_right);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(1);
        make.centerY.mas_equalTo(msgCodeTF.mas_centerY);
    }];
    
    //获取验证码按钮
    UIButton *countDownbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [countDownbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [countDownbtn addTarget:self action:@selector(getSMSCode) forControlEvents:UIControlEventTouchUpInside];
    [countDownbtn setTitleColor:MainColor forState:UIControlStateNormal];
    [countDownbtn setTitleColor:HEXColor(@"ef3673", 0.5) forState:UIControlStateHighlighted];
    [countDownbtn setTitleColor:HEXColor(@"#C8C8C8", 1) forState:UIControlStateDisabled];
    countDownbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView1 addSubview:countDownbtn];
    [countDownbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sLine_1.mas_right);
        make.top.bottom.right.mas_equalTo(@0);
    }];
    _countDownbtn = countDownbtn;
    
    //设置密码
    UITextField *setPassTF = [[UITextField alloc] initWithFrame:CGRectMake(0, bgView1.bottom + 15, phoneTF.width, phoneTF.height)];
    setPassTF.keyboardType = UIKeyboardTypeASCIICapable;
    setPassTF.secureTextEntry = YES;
    setPassTF.centerX = phoneTF.centerX;
    [_scrollView addSubview:setPassTF];
    _setPassTF = setPassTF;
    [self setTextField:setPassTF];

    //再次输入密码
    UITextField *setPassAgainTF = [[UITextField alloc] initWithFrame:CGRectMake(0, setPassTF.bottom + 15, phoneTF.width, phoneTF.height)];
    setPassAgainTF.keyboardType = UIKeyboardTypeASCIICapable;
    setPassAgainTF.secureTextEntry = YES;
    setPassAgainTF.centerX = phoneTF.centerX;
    [_scrollView addSubview:setPassAgainTF];
    _setPassAgainTF = setPassAgainTF;
    [self setTextField:setPassAgainTF];

    //注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(0, setPassAgainTF.bottom + 80, phoneTF.width, 49);
    [ClassTool addLayer:registerBtn frame:CGRectMake(0, 0, registerBtn.width, registerBtn.height)];
    registerBtn.centerX = phoneTF.centerX;
    registerBtn.layer.cornerRadius = 5;
    registerBtn.clipsToBounds = YES;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitleColor:RGBA(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [registerBtn addTarget:self action:@selector(accountRegister) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:registerBtn];

    //协议
    YYLabel *agreementLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, registerBtn.bottom + 20, SCREEN_WIDTH, 20)];
    agreementLabel.centerX = phoneTF.centerX;
    [_scrollView addSubview:agreementLabel];
    NSString *text = @"注册即代表您已阅读并同意《七彩云协议》";
    NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:text];
    mText.yy_alignment = NSTextAlignmentCenter;
    mText.yy_font = [UIFont systemFontOfSize:15];
    mText.yy_color = HEXColor(@"#B6B6B6", 1);
    DDWeakSelf;
    [mText yy_setTextHighlightRange:NSMakeRange(12, 7) color:MainColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //用户协议
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself goUserProtocol];
        });
    }];
    agreementLabel.attributedText = mText;

    CGFloat contentSize = agreementLabel.bottom + Bottom_Height_Dif + 20;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentSize);
}

//设置textfield
- (void)setTextField:(UITextField *)tf {
    if ([tf isEqual:_phoneTF]) {
        tf.placeholder = @"请输入手机号(用于登录/找回密码)";
    } else if ([tf isEqual:_msgCodeTF]) {
        tf.placeholder = @"请输入手机验证码";
    } else if ([tf isEqual:_setPassTF]) {
        tf.placeholder = @"设置密码";
    } else {
        tf.placeholder = @"再次输入密码";
    }
    //添加leftView
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KFit_W(18), 50)];
    //    leftView.image = [UIImage imageNamed:imageName];
    leftView.contentMode = UIViewContentModeCenter;
    tf.leftView = leftView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.delegate = self;
    tf.font = [UIFont systemFontOfSize:15];
    if (![tf isEqual:_msgCodeTF]) {
        tf.layer.borderWidth = 1;
        tf.layer.cornerRadius = 3;
        tf.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
    }
}



//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

