//
//  BindPhoneNumberVC.m
//  QCY
//
//  Created by i7colors on 2019/6/11.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BindPhoneNumberVC.h"
#import "CountDown.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "CddHUD.h"
#import "MobilePhone.h"
#import <JPUSHService.h>
#import "PerfectMyInfoVC.h"


@interface BindPhoneNumberVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITextField *phoneTF;
@property (nonatomic, strong)UITextField *passwdTF;
@property (nonatomic, strong)UIButton *codeBtn;
@property (nonatomic, strong)UIButton *bindBtn;
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;
@end

@implementation BindPhoneNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
    [self setNavBar];
    [self setupUI];
}

//懒加载scrollview
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        //150 + 680 + 6
        sv.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        sv.scrollIndicatorInsets = sv.contentInset;
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

#pragma mark - 网络请求
//获取短信验证码
- (void)getSMSCode {
    if ([MobilePhone isValidMobile:_phoneTF.text] == NO) {
        [CddHUD showTextOnlyDelay:@"请输入有效的手机号" view:self.view];
        return ;
    }
    NSDictionary *dict = @{@"mobile":_phoneTF.text,
                           };
    
    self.codeBtn.enabled = NO;
    [self.codeBtn setTitle:nil forState:UIControlStateNormal];
    [self.activityIndicator startAnimating];
    DDWeakSelf;
    [ClassTool postRequest:URL_Msg_Code_BindPhone Params:[dict mutableCopy] Success:^(id json) {
//                                NSLog(@"----- %@",json);
        
        [weakself.activityIndicator stopAnimating];
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            BOOL isSuc = [json[@"data"] boolValue];
            if (isSuc == YES) {
                [weakself countDown:weakself.codeBtn];
            }
        } else if ([json[@"code"] isEqualToString:@"CAPTCHA_ERROR"]) {
            weakself.codeBtn.enabled = YES;
        }
    } Failure:^(NSError *error) {
        weakself.codeBtn.enabled = YES;
    }];
}

//绑定手机号
- (void)bindPhone {
    [self.view endEditing:YES];
    NSString *jpushStr = [NSString string];
    if (JPushID) {
        jpushStr = JPushID;
    } else {
        jpushStr = [JPUSHService registrationID];
    }
    NSDictionary *dict = @{@"phone":_phoneTF.text,
                           @"token":_bindToken,
                           @"smsCode":_passwdTF.text,
                           };
    NSMutableDictionary *mDict = [dict mutableCopy];
    if (isRightData(jpushStr)) {
        [mDict setObject:jpushStr forKey:@"registrationId"];
    }
    
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Bind_PhoneNum Params:mDict Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        //        NSLog(@"-----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            //用户信息存入字典
            [weakself saveInfo:json];
            dispatch_async(dispatch_get_main_queue(), ^{
                [CddHUD showTextOnlyDelay:@"绑定成功" view:weakself.view];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    PerfectMyInfoVC *vc = [[PerfectMyInfoVC alloc] init];
                    vc.token = json[@"data"][@"token"];
                    vc.completeBlock = ^{
                        if(weakself.bindCompleteBlock) {
                            weakself.bindCompleteBlock();
                        }
                    };
                    [weakself.navigationController pushViewController:vc animated:YES];
                });
            });
            UITabBarController *tb= (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            if (weakself.isJump == YES) {
                tb.selectedIndex = weakself.jumpIndex;
            }
        }
    } Failure:^(NSError *error) {
        
    }];
}

- (void)saveInfo:(id)json {
    NSString *companyName = [json[@"data"][@"isCompany"] boolValue] ? json[@"data"][@"companyName"] : @"";
    NSDictionary *userDict = @{@"userName":json[@"data"][@"loginName"],
                               @"token":json[@"data"][@"token"],
                               @"companyName":companyName,
                               @"isCompany":json[@"data"][@"isCompany"]
                               };
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:userDict];
    //我的头像
    if isRightData(To_String(json[@"data"][@"photo"])) {
        [mDict setObject:json[@"data"][@"photo"] forKey:@"userHeaderImage"];
    }
    
    [UserDefault setObject:[mDict copy] forKey:@"userInfo"];
    [self refreshMainData_notifi];
}

/*** 通知刷新数据 ***/
- (void)refreshMainData_notifi {
    NSString *notiName = @"refreshAllDataWithThis";
    [[NSNotificationCenter defaultCenter]postNotificationName:notiName object:@"loginRefresh" userInfo:nil];
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
            [weakself.codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%ld)",(long)totoalSecond] forState:UIControlStateNormal];
        }
        
    }];
}

- (void)setNavBar {
    [self vhl_setNavBarBackgroundColor:Like_Color];
    [self vhl_setNavBarShadowImageHidden:YES];
    self.backBtn.left = self.backBtn.left + 2;
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    //手机号tf
    UITextField *phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(20, 44, SCREEN_WIDTH - 40, 40)];
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self setupTFUIWith:phoneTF];
    phoneTF.placeholder = @"手机号";
    phoneTF.tag = 1;
    phoneTF.delegate = self;
    [phoneTF addTarget:self action:@selector(phoneTFChange:) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:phoneTF];
    _phoneTF = phoneTF;
    
    //验证码tf
    
    CGFloat width = (SCREEN_WIDTH - 40 - 20) / 3 * 2 - 20;
    UITextField *passwdTF = [[UITextField alloc]init];
    [self setupTFUIWith:passwdTF];
    passwdTF.delegate = self;
    passwdTF.keyboardType = UIKeyboardTypeNumberPad;
    passwdTF.placeholder = @"短信验证码";
    [passwdTF addTarget:self action:@selector(judgeEnable) forControlEvents:UIControlEventEditingChanged];
    [self.scrollView addSubview:passwdTF];
    [passwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTF.mas_bottom).with.offset(20);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(40);
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
    [codeBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"#708090", 0.5)] forState:UIControlStateDisabled];
    [codeBtn addTarget:self action:@selector(getSMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:codeBtn];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(passwdTF);
        make.left.mas_equalTo(passwdTF.mas_right).with.offset(20);
        make.right.mas_equalTo(phoneTF);
    }];
    [codeBtn layoutIfNeeded];
    _codeBtn = codeBtn;
    
    //绑定按钮
    UIButton *bindBtn = [[UIButton alloc]init];
    [bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [bindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bindBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    bindBtn.layer.cornerRadius = 20;
    bindBtn.clipsToBounds = YES;
    [bindBtn setBackgroundImage:[UIImage imageWithColor:MainColor] forState:UIControlStateNormal];
    [bindBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"ef3673", 0.2)] forState:UIControlStateDisabled];
    bindBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bindBtn addTarget:self action:@selector(bindPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:bindBtn];
    bindBtn.enabled = NO;
    [bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(codeBtn.mas_bottom).with.offset(30);
        make.height.width.right.mas_equalTo(phoneTF);
    }];
    _bindBtn = bindBtn;
    
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    [codeBtn addSubview:self.activityIndicator];
    //设置小菊花的frame
    self.activityIndicator.frame= CGRectMake((codeBtn.width - 24) / 2, (codeBtn.height - 24) / 2, 24, 24);

    //设置小菊花颜色
    self.activityIndicator.color = UIColor.whiteColor;
    //设置背景颜色
    self.activityIndicator.backgroundColor = UIColor.clearColor;
}



#pragma mark - 键盘监听事件
//点击空白结束编辑
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
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
        //        [self.passwdTF becomeFirstResponder];
    } else {
        self.codeBtn.enabled = NO;
    }
    [self judgeEnable];
}

- (void)judgeEnable {
    if (self.phoneTF.text.length == 11 && self.passwdTF.text.length == 6) {
        self.bindBtn.enabled = YES;
    } else {
        self.bindBtn.enabled = NO;
    }
}
//设置输入框外观
- (void)setupTFUIWith:(UITextField *)textField {
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 19, 30)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.backgroundColor = RGBA(239, 244, 248, 1);
    textField.layer.cornerRadius = 5;
    textField.font = [UIFont systemFontOfSize:14];
    textField.layer.borderColor= RGBA(219, 222, 224, 1).CGColor;
    textField.layer.borderWidth= 0.5f;
    textField.tintColor = MainColor;
}
@end
