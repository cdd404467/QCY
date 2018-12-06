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
#import "CountDown.h"
#import "MobilePhone.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "UIDevice+UUID.h"
#import "UITextField+Limit.h"
#import "CddHUD.h"

@interface FindPasswordVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *phoneTF;
@property (nonatomic, strong)UITextField *msgCodeTF;
@property (nonatomic, strong)UIButton *countDownbtn;
@property (nonatomic, strong)UITextField *imageCodeTF;
@property (nonatomic, strong)UIImageView *checkImage;
@end

@implementation FindPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
    [self requestImageCode];
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
    [ClassTool postRequest:URL_Msg_Code_Findpass Params:[dict mutableCopy] Success:^(id json) {
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

//校验短信验证码
- (void)checkMsgPassWord {
    if ([self judgeData] == NO) {
        return ;
    };
    
    NSDictionary *dict = @{@"mobile":_phoneTF.text,
                           @"smsCode":_msgCodeTF.text
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Msg_Code_Check Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                        NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            BOOL isSuc = [json[@"data"] boolValue];
            if (isSuc == YES) {
                [weakself jumpToResetPassVC];
            }
        }else if ([json[@"code"] isEqualToString:@"CAPTCHA_ERROR"]) {
            
        }
        
    } Failure:^(NSError *error) {
        
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
    } else if ([MobilePhone isValidMobile:_phoneTF.text] == NO) {
        [CddHUD showTextOnlyDelay:@"请输入有效的手机号" view:self.view];
        return NO;
    } else if (_imageCodeTF.text.length != 4) {
        [CddHUD showTextOnlyDelay:@"请输入正确的图形验证码" view:self.view];
        return NO;
    } else if (_msgCodeTF.text.length != 6) {
        [CddHUD showTextOnlyDelay:@"请输入6位短信验证码" view:self.view];
        return NO;
    }
    
    return YES;
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
            [weakself.countDownbtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        }else{
            weakself.countDownbtn.enabled = NO;
            [weakself.countDownbtn setTitle:[NSString stringWithFormat:@"重新获取(%lds)",(long)totoalSecond] forState:UIControlStateNormal];
        }
        
    }];
}

- (void)setupUI {
    //手机号
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneTF];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150 + NAV_HEIGHT);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(@(KFit_W(38)));
        make.right.mas_equalTo(@(KFit_W(-38)));
    }];
    //限制字数
    [phoneTF lengthLimit:^{
        if (phoneTF.text.length > 11) {
            phoneTF.text = [phoneTF.text substringToIndex:11];
        }
    }];
    _phoneTF = phoneTF;
    [self setTextField:phoneTF];

    //图片验证码bg
    UIView *bgView1 = [[UIView alloc] init];
    bgView1.layer.borderWidth = 1;
    bgView1.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
    bgView1.layer.cornerRadius = 3;
    [self.view addSubview:bgView1];
    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneTF.mas_bottom).offset(15);
        make.height.mas_equalTo(phoneTF.mas_height);
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
    }];
    
    //短信验证码bg
    UIView *bgView2 = [[UIView alloc] init];
    bgView2.layer.borderWidth = 1;
    bgView2.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
    bgView2.layer.cornerRadius = 3;
    bgView2.layer.cornerRadius = 3;
    [self.view addSubview:bgView2];
    [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView1.mas_bottom).offset(15);
        make.height.mas_equalTo(phoneTF.mas_height);
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
    }];
    
    //图片验证码输入框
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
        make.width.mas_equalTo(170);
    }];
    [msgCodeTF lengthLimit:^{
        if (msgCodeTF.text.length > 6) {
            msgCodeTF.text = [msgCodeTF.text substringToIndex:6];
        }
    }];
    _msgCodeTF = msgCodeTF;
    [self setTextField:msgCodeTF];
    
    
    //分割线 - 2
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
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH - KFit_W(38 * 2), 49);
    [ClassTool addLayer:loginBtn frame:rect];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.clipsToBounds = YES;
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:RGBA(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(checkMsgPassWord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
        make.height.mas_equalTo(@49);
        make.top.mas_equalTo(bgView2.mas_bottom).offset(18);
    }];
    
}

//设置textfield
- (void)setTextField:(UITextField *)tf {
    if ([tf isEqual:_phoneTF]) {
        tf.placeholder = @"请输入手机号";
    } else if ([tf isEqual:_imageCodeTF]){
        tf.placeholder = @"请输入图形验证码";
    } else {
        tf.placeholder = @"请输入验证码";
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
    if ([tf isEqual:_phoneTF]) {
        tf.layer.borderWidth = 1;
        tf.layer.cornerRadius = 3;
        tf.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
    }
    
}

- (void)jumpToResetPassVC {
    ResetPassword *vc = [[ResetPassword alloc] init];
    vc.phoneNum = _phoneTF.text;
    vc.passType = @"resetPW";
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}

@end
