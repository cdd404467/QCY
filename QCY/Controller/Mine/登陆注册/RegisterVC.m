//
//  RegisterVC.m
//  QCY
//
//  Created by i7colors on 2018/9/21.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "RegisterVC.h"
#import <Masonry.h>
#import "MacroHeader.h"
#import "ClassTool.h"
#import "CommonNav.h"
#import <YYText.h>
#import "MobilePhone.h"
#import "UITextField+Limit.h"
#import "UIDevice+UUID.h"
#import "NetWorkingPort.h"
#import "CountDown.h"
#import "CddHUD.h"
#import "AES128.h"
#import "UserProtocolVC.h"

@interface RegisterVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *phoneTF;
@property (nonatomic, strong)UITextField *imageCodeTF;
@property (nonatomic, strong)UITextField *msgCodeTF;
@property (nonatomic, strong)UITextField *setPassTF;
@property (nonatomic, strong)UITextField *setPassAgainTF;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIImageView *checkImage;
@property (nonatomic, strong)UIButton *countDownbtn;
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self requestImageCode];
    [self setupUI];
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
        
        //        _scrollView.delegate = self;
    }
    return _scrollView;
}


- (void)setupNav {
    CommonNav *nav = [[CommonNav alloc] init];
    nav.titleLabel.text = @"欢迎注册";
    [ClassTool addLayer:nav frame:nav.frame];
    nav.titleLabel.textColor = [UIColor whiteColor];
    nav.bottomLine.hidden = YES;
    [nav.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
}

#pragma mark - 网络请求
//图形验证码
- (void)requestImageCode {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_IMG_CODE,[UIDevice getDeviceID]];
    [ClassTool getRequestWithStream:urlString Params:nil Success:^(id json) {
        weakself.checkImage.image = [UIImage imageWithData:json];
    } Failure:^(NSError *error) {
        NSLog(@"error");
    }];
}

//获取短信验证码
- (void)getSMSCode {
    if ([_phoneTF.text isEqualToString:@""]) {
        [CddHUD showTextOnlyDelay:@"请输入手机号" view:self.view];
        return ;
    } else if ([_imageCodeTF.text isEqualToString:@""]) {
        [CddHUD showTextOnlyDelay:@"请输入图形验证码" view:self.view];
        return ;
    } else if ([MobilePhone isValidMobile:_phoneTF.text] == NO) {
        [CddHUD showTextOnlyDelay:@"请输入有效的手机号" view:self.view];
        return ;
    } else if (_imageCodeTF.text.length != 4) {
        [CddHUD showTextOnlyDelay:@"请输入正确的图形验证码" view:self.view];
        return ;
    }
    
    NSDictionary *dict = @{@"mobile":_phoneTF.text,
                           @"captcha":_imageCodeTF.text,
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
                           @"smsCode":_msgCodeTF.text
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_User_Register Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [CddHUD showTextOnlyDelay:@"注册成功" view:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.navigationController popViewControllerAnimated:YES];
                });
            });
            
        }else if ([json[@"code"] isEqualToString:@"REGISTER_FATL"]) {
            [CddHUD showTextOnlyDelay:@"该手机号已注册" view:weakself.view];
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark 倒计时
-(void)countDown:(UIButton *)sender {
    //    60s的倒计时
    NSTimeInterval aMinutes = 60;
    //    1个小时的倒计时
    //    NSTimeInterval anHour = 60*60;
    //     1天的倒计时
    //    NSTimeInterval aDay = 24*60*60;
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
    } else if ([_imageCodeTF.text isEqualToString:@""]) {
        [CddHUD showTextOnlyDelay:@"请输入图形验证码" view:self.view];
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
    } else if (_imageCodeTF.text.length != 4) {
        [CddHUD showTextOnlyDelay:@"请输入正确的图形验证码" view:self.view];
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
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [_scrollView addSubview:phoneTF];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(42);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(self.view.mas_left).offset(KFit_W(38));
        make.right.mas_equalTo(self.view.mas_right).offset(KFit_W(-38));
    }];
    //限制字数
    [phoneTF lengthLimit:^{
        if (phoneTF.text.length > 11) {
            phoneTF.text = [phoneTF.text substringToIndex:11];
        }
    }];
    _phoneTF = phoneTF;
    [self setTextField:phoneTF];
    
    
    //图片验证码底框
    UIView *bgView1 = [[UIView alloc] init];
    bgView1.layer.borderWidth = 1;
    bgView1.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
    bgView1.layer.cornerRadius = 3;
    [_scrollView addSubview:bgView1];
    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneTF.mas_bottom).offset(15);
        make.height.mas_equalTo(phoneTF.mas_height);
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
    }];
    
    //短信验证码底框
    UIView *bgView2 = [[UIView alloc] init];
    bgView2.layer.borderWidth = 1;
    bgView2.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
    bgView2.layer.cornerRadius = 3;
    bgView2.layer.cornerRadius = 3;
    [_scrollView addSubview:bgView2];
    [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView1.mas_bottom).offset(15);
        make.height.mas_equalTo(phoneTF.mas_height);
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
    }];
    
    //图片验证码
    UITextField *imageCodeTF = [[UITextField alloc] init];
    imageCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    [bgView1 addSubview:imageCodeTF];
    [imageCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(@0);
        make.width.mas_equalTo(@(KFit_W(170)));
    }];
    [imageCodeTF lengthLimit:^{
        if (imageCodeTF.text.length > 4) {
            imageCodeTF.text = [imageCodeTF.text substringToIndex:4];
        }
    }];
    _imageCodeTF = imageCodeTF;
    [self setTextField:imageCodeTF];
    
    //分割线 - 1
    UIView *sLine_1 = [[UIView alloc] init];
    sLine_1.backgroundColor = HEXColor(@"#D7D7D7", 1);
    [bgView1 addSubview:sLine_1];
    [sLine_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageCodeTF.mas_right);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(1);
        make.centerY.mas_equalTo(imageCodeTF.mas_centerY);
    }];
    
    //图片验证码
    UIImageView *checkImage = [[UIImageView alloc] init];
    checkImage.backgroundColor = [UIColor grayColor];
    [bgView1 addSubview:checkImage];
    [checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sLine_1.mas_right).offset(13 * Scale_W);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(@(65 * Scale_W));
        make.centerY.mas_equalTo(sLine_1.mas_centerY);
    }];
    _checkImage = checkImage;
    
    //换一张按钮
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setImage:[UIImage imageNamed:@"change_next"] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(requestImageCode) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(checkImage.mas_right);
        make.right.mas_equalTo(@0);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(sLine_1.mas_centerY);
    }];
    
    //手机验证码
    UITextField *msgCodeTF = [[UITextField alloc] init];
    msgCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    [bgView2 addSubview:msgCodeTF];
    [msgCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(@0);
        make.width.mas_equalTo(@(KFit_W(170)));
    }];
    [msgCodeTF lengthLimit:^{
        if (msgCodeTF.text.length > 6) {
            msgCodeTF.text = [msgCodeTF.text substringToIndex:6];
        }
    }];
    _msgCodeTF = msgCodeTF;
    [self setTextField:msgCodeTF];
    
    //分割线 - 1
    UIView *sLine_2 = [[UIView alloc] init];
    sLine_2.backgroundColor = HEXColor(@"#D7D7D7", 1);
    [bgView2 addSubview:sLine_2];
    [sLine_2 mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [bgView2 addSubview:countDownbtn];
    [countDownbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sLine_2.mas_right);
        make.top.bottom.right.mas_equalTo(@0);
    }];
    _countDownbtn = countDownbtn;
    
    //设置密码
    UITextField *setPassTF = [[UITextField alloc] init];
    setPassTF.keyboardType = UIKeyboardTypeASCIICapable;
    setPassTF.secureTextEntry = YES;
    [_scrollView addSubview:setPassTF];
    [setPassTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView2.mas_bottom).offset(15);
        make.height.mas_equalTo(phoneTF.mas_height);
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
    }];
    _setPassTF = setPassTF;
    [self setTextField:setPassTF];
    
    //再次输入密码
    UITextField *setPassAgainTF = [[UITextField alloc] init];
    setPassAgainTF.keyboardType = UIKeyboardTypeASCIICapable;
    setPassAgainTF.secureTextEntry = YES;
    [_scrollView addSubview:setPassAgainTF];
    [setPassAgainTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(setPassTF.mas_bottom).offset(15);
        make.height.mas_equalTo(phoneTF.mas_height);
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
    }];
    _setPassAgainTF = setPassAgainTF;
    [self setTextField:setPassAgainTF];
    
    //注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH - KFit_W(38 * 2), 49);
    [ClassTool addLayer:registerBtn frame:rect];
    registerBtn.layer.cornerRadius = 5;
    registerBtn.clipsToBounds = YES;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitleColor:RGBA(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [registerBtn addTarget:self action:@selector(accountRegister) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
        make.height.mas_equalTo(@49);
        make.top.mas_equalTo(setPassAgainTF.mas_bottom).offset(18);
    }];
    //协议
    YYLabel *agreementLabel = [[YYLabel alloc] init];
    [_scrollView addSubview:agreementLabel];
    [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(registerBtn.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    NSString *text = @"注册即代表您已阅读并同意《七彩云协议》";
    NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:text];
    mText.yy_font = [UIFont systemFontOfSize:15];
    mText.yy_color = HEXColor(@"#B6B6B6", 1);
    [mText yy_setTextHighlightRange:NSMakeRange(12, 7) color:MainColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        //用户协议
        UserProtocolVC *vc = [[UserProtocolVC alloc]init];
        vc.webUrl = @"http://mobile.i7colors.com/groupBuyMobile/secret.html";
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    agreementLabel.attributedText = mText;
    [agreementLabel sizeToFit];
    
    CGFloat contentSize = 439 + agreementLabel.frame.size.height + Bottom_Height_Dif + 10;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentSize);
}

//设置textfield
- (void)setTextField:(UITextField *)tf {
    if ([tf isEqual:_phoneTF]) {
        tf.placeholder = @"请输入手机号(用于登录/找回密码)";
    } else if ([tf isEqual:_imageCodeTF]) {
        tf.placeholder = @"请输入图形验证码";
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
    //placeholder颜色
    [tf setValue:HEXColor(@"#C8C8C8", 1) forKeyPath:@"_placeholderLabel.textColor"];
    tf.delegate = self;
    tf.font = [UIFont systemFontOfSize:15];
    if (![tf isEqual:_imageCodeTF] && ![tf isEqual:_msgCodeTF]) {
        tf.layer.borderWidth = 1;
        tf.layer.cornerRadius = 3;
        tf.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.hidesBackButton = NO;
}

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
