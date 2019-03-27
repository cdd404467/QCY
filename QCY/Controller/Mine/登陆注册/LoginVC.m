//
//  LoginVC.m
//  QCY
//
//  Created by i7colors on 2018/9/20.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "LoginVC.h"
#import "MacroHeader.h"
#import "ClassTool.h"
#import <Masonry.h>
#import "RegisterVC.h"
#import "CommonNav.h"
#import "FindPasswordVC.h"
#import "NetWorkingPort.h"
#import "UIDevice+UUID.h"
#import "AES128.h"
#import "CddHUD.h"
#import "UITextField+Limit.h"
#import "WXAuth.h"
#import <WXApi.h>
#import "HelperTool.h"
#import "BindMobileView.h"
#import "UIView+Geometry.h"


@interface LoginVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *userNameTF;
@property (nonatomic, strong)UITextField *passwdTF;
@property (nonatomic, strong)UITextField *checkCodeTF;
@property (nonatomic,strong) UIImageView *checkImage;
@property (nonatomic, strong)BindMobileView *bindView;
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    [self setupNav];
    [self setupUI];
    [self requestImageCode];
    [self registerNoti];
}

//懒加载scrollview
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        //150 + 680 + 6
        sv.contentSize = CGSizeMake(SCREEN_WIDTH, 600);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}


-(void)registerNoti {
    NSString *notiName = @"weixinLogin";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginWithWeiChat:) name:notiName object:nil];
}

- (void)jumpToRegisterVC {
    RegisterVC *vc = [[RegisterVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToFindPassVC {
    FindPasswordVC *vc = [[FindPasswordVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupNav {
    CommonNav *nav = [[CommonNav alloc] init];
    nav.titleLabel.text = @"登录";
    [nav.backBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
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

//登录
- (void)requestLogin {
    [self.view endEditing:YES];
    
    if (_userNameTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入账号" view:self.view];
        return;
    } else if (_passwdTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入密码" view:self.view];
        return;
    }
    
    DDWeakSelf;
    NSDictionary *dict = @{@"username":_userNameTF.text,
                           @"aesPass":[AES128 AES128Encrypt:_passwdTF.text],
//                           @"captcha":_checkCodeTF.text,
                           @"deviceNo":[UIDevice getDeviceID]
                           };
    [CddHUD showWithText:@"登录中..." view:self.view];
    [ClassTool postRequest:URL_USER_LOGIN Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"-----ppp %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            //用户信息存入字典
            [weakself saveInfo:json];
            [weakself disMiss];
            UITabBarController *tb=(UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            if (weakself.isJump == YES) {
                tb.selectedIndex = weakself.jumpIndex;
            }
            
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

//微信登录
- (void)loginWithWeiChat:(NSNotification *)notification {
    [self.view endEditing:YES];
    
    NSDictionary *dict = @{@"code":notification.userInfo[@"weixinCode"]
                           };
    DDWeakSelf;
    [CddHUD showWithText:@"登录中..." view:self.view];
    [ClassTool postRequest:URL_WeiChat_Login Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                NSLog(@"-----ppp %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            if ([To_String(json[@"data"][@"needPhone"]) isEqualToString:@"1"]) {
                [weakself alertBindMobile:To_String(json[@"data"][@"token"])];
            } else {
                //用户信息存入字典
                [weakself saveInfo:json];
                [weakself disMiss];
                UITabBarController *tb=(UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                if (weakself.isJump == YES) {
                    tb.selectedIndex = weakself.jumpIndex;
                }
            }
       
        }
        
    } Failure:^(NSError *error) {
        
    }];
    
}

//绑定手机号
- (void)bindPhone {
    NSDictionary *dict = @{@"phone":_bindView.phoneTF.text,
                           @"token":_bindView.bToken,
                           @"smsCode":_bindView.passwdTF.text,
                           @"inviteCode":_bindView.inviteTF.text,
                           @"from":@"app_ios"
                            };
    
    DDWeakSelf;
    [CddHUD show:_bindView];
    [ClassTool postRequest:URL_Bind_PhoneNum Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.bindView];
//        NSLog(@"-----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            //用户信息存入字典
            [weakself saveInfo:json];
            dispatch_async(dispatch_get_main_queue(), ^{
                [CddHUD showTextOnlyDelay:@"绑定成功" view:weakself.bindView];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.bindView removeSignView];
                    [weakself disMiss];
                });
            });
            UITabBarController *tb=(UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            if (weakself.isJump == YES) {
                tb.selectedIndex = weakself.jumpIndex;
            }
        }
    } Failure:^(NSError *error) {
        
    }];
}

//弹框
- (void)alertBindMobile:(NSString *)token {
    BindMobileView *bindView = [[BindMobileView alloc]init];
    bindView.bToken = token;
    [bindView.loginBtn addTarget:self action:@selector(bindPhone) forControlEvents:UIControlEventTouchUpInside];
    [bindView.cancelBtn addTarget:self action:@selector(cancelBind) forControlEvents:UIControlEventTouchUpInside];
    [UIApplication.sharedApplication.keyWindow addSubview:bindView];
    _bindView = bindView;
}

//取消
- (void)cancelBind {
    [CddHUD hideHUD:_bindView];
    [_bindView removeSignView];
}


//第三方登录,获取微信信息
- (void)getWeixinInfo {
    [WXAUTH sendWXAuthReq];
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

- (void)setupUI {
    //app图标
    UIImageView *appHeader = [[UIImageView alloc] init];
    appHeader.layer.cornerRadius = KFit_W(87) / 2;
    appHeader.clipsToBounds = YES;
    appHeader.image = [UIImage imageNamed:@"login_header"];
    [self.view addSubview:appHeader];
    [appHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(37 + NAV_HEIGHT);
        make.width.height.mas_equalTo(@(87 * Scale_W));
    }];
    
    UIView *tfView = [[UIView alloc] init];
    tfView.layer.borderWidth = 1.0f;
    tfView.layer.borderColor = HEXColor(@"#D6D6D6", 0.5).CGColor;
    tfView.layer.cornerRadius = 5;
    tfView.clipsToBounds = YES;
    [self.view addSubview:tfView];
    [tfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(appHeader.mas_bottom).offset(37);
        make.height.mas_equalTo(100);
        make.left.mas_equalTo(@(38 * Scale_W));
        make.right.mas_equalTo(@(-38 * Scale_W));
    }];
    
    //账号TF
    UITextField *userNameTF = [[UITextField alloc] init];
    userNameTF.keyboardType = UIKeyboardTypeDefault;
    [tfView addSubview:userNameTF];
    [userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(50);
    }];
    _userNameTF = userNameTF;
    [self setTextField:userNameTF];
    
    //账号TF黑线
    UIView *line_1 = [[UIView alloc] init];
    line_1.backgroundColor = HEXColor(@"#D6D6D6", 0.5);
    [userNameTF addSubview:line_1];
    [line_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(@0);
        make.height.mas_equalTo(@1);
    }];
    //密码TF
    UITextField *passwdTF = [[UITextField alloc] init];
    passwdTF.keyboardType = UIKeyboardTypeASCIICapable;
    [tfView addSubview:passwdTF];
    [passwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(@0);
        make.top.mas_equalTo(userNameTF.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    _passwdTF = passwdTF;
    [self setTextField:passwdTF];
    
//    //密码TF黑线
//    UIView *line_2 = [[UIView alloc] init];
//    line_2.backgroundColor = HEXColor(@"#D6D6D6", 0.5);
//    [passwdTF addSubview:line_2];
//    [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(@0);
//        make.height.mas_equalTo(@1);
//    }];
    
//    //验证码TF
//    UITextField *checkCodeTF = [[UITextField alloc] init];
//    [tfView addSubview:checkCodeTF];
//    [checkCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(@0);
//        make.width.mas_equalTo(@(158 * Scale_W));
//        make.top.mas_equalTo(passwdTF.mas_bottom);
//        make.height.mas_equalTo(50);
//    }];
//    [checkCodeTF lengthLimit:^{
//        if (checkCodeTF.text.length > 4) {
//            checkCodeTF.text = [checkCodeTF.text substringToIndex:4];
//        }
//    }];
//    _checkCodeTF = checkCodeTF;
//    [self setTextField:checkCodeTF];
//
//    //分割线
//    UIView *sLine = [[UIView alloc] init];
//    sLine.backgroundColor = HEXColor(@"#D7D7D7", 1);
//    [tfView addSubview:sLine];
//    [sLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(checkCodeTF.mas_right);
//        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(1);
//        make.centerY.mas_equalTo(checkCodeTF.mas_centerY);
//    }];
    
//    //图片验证码
//    UIImageView *checkImage = [[UIImageView alloc] init];
//    checkImage.backgroundColor = [UIColor grayColor];
//    [tfView addSubview:checkImage];
//    [checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(sLine.mas_right).offset(13 * Scale_W);
//        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(@(65 * Scale_W));
//        make.centerY.mas_equalTo(sLine.mas_centerY);
//    }];
//    _checkImage = checkImage;
//
//    //换一张按钮
//    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [changeBtn setImage:[UIImage imageNamed:@"change_next"] forState:UIControlStateNormal];
//    [changeBtn addTarget:self action:@selector(requestImageCode) forControlEvents:UIControlEventTouchUpInside];
//    [tfView addSubview:changeBtn];
//    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(checkImage.mas_right);
//        make.right.mas_equalTo(@0);
//        make.height.mas_equalTo(30);
//        make.centerY.mas_equalTo(sLine.mas_centerY);
//    }];
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH - KFit_W(38 * 2), 49);
    [ClassTool addLayer:loginBtn frame:rect];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.clipsToBounds = YES;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:RGBA(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [loginBtn addTarget:self action:@selector(requestLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tfView.mas_left);
        make.right.mas_equalTo(tfView.mas_right);
        make.height.mas_equalTo(@49);
        make.top.mas_equalTo(tfView.mas_bottom).offset(18);
    }];
    
    //立即注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [registerBtn setTitleColor:HEXColor(@"#B6B6B6", 1) forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(jumpToRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(loginBtn.mas_left);
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(15);
        make.height.mas_equalTo(30);
    }];
    
    //忘记密码按钮
    UIButton *forgetpwBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetpwBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgetpwBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [forgetpwBtn setTitleColor:HEXColor(@"#B6B6B6", 1) forState:UIControlStateNormal];
    [forgetpwBtn addTarget:self action:@selector(jumpToFindPassVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetpwBtn];
    [forgetpwBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(loginBtn.mas_right);
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(15);
        make.height.mas_equalTo(30);
    }];
    
    /*** 如果已经安装微信了，再显示第三方登录 ***/
    if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
        //快速登录
        UILabel *thirdLogin = [[UILabel alloc] init];
        thirdLogin.text = @"快速登录";
        thirdLogin.textColor = HEXColor(@"#C8C8C8", 1);
        thirdLogin.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:thirdLogin];
        [thirdLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(loginBtn.mas_bottom).offset(97);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.height.mas_equalTo(12);
        }];
        
        //left line
        UIView *leftLine = [[UIView alloc] init];
        leftLine.backgroundColor = HEXColor(@"#C8C8C8", 1);
        [self.view addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@(36 * Scale_W));
            make.right.mas_equalTo(thirdLogin.mas_left).offset(-8);
            make.centerY.mas_equalTo(thirdLogin.mas_centerY);
            make.height.mas_equalTo(@1);
        }];
        
        //right line
        UIView *rightLine = [[UIView alloc] init];
        rightLine.backgroundColor = HEXColor(@"#C8C8C8", 1);
        [self.view addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(thirdLogin.mas_right).offset(8);
            make.right.mas_equalTo(@(-36 * Scale_W));
            make.centerY.mas_equalTo(thirdLogin.mas_centerY);
            make.height.mas_equalTo(@1);
        }];
        
        //微信登录
        UIImageView *weiChat = [[UIImageView alloc] init];
        [HelperTool addTapGesture:weiChat withTarget:self andSEL:@selector(getWeixinInfo)];
        weiChat.image = [UIImage imageNamed:@"weixin"];
        [self.view addSubview:weiChat];
        [weiChat mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(thirdLogin.mas_bottom).offset(20);
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.height.mas_equalTo(@(44 * Scale_W));
        }];
    }
    
}



//设置textfield
- (void)setTextField:(UITextField *)tf {
    NSString *imageName = @"";
    if ([tf isEqual:_userNameTF]) {
        imageName = @"tf_icon1";
        tf.placeholder = @"请输入用户名";
    } else if ([tf isEqual:_passwdTF]) {
        imageName = @"tf_icon2";
        tf.secureTextEntry = YES;
        tf.placeholder = @"请输入密码";
    } else {
        imageName = @"tf_icon3";
        tf.placeholder = @"请输入验证码";
        tf.keyboardType = UIKeyboardTypeNumberPad;
    }
    //添加leftView
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KFit_W(50), 50)];
    leftView.image = [UIImage imageNamed:imageName];
    leftView.contentMode = UIViewContentModeCenter;
    tf.leftView = leftView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    //placeholder颜色
    [tf setValue:HEXColor(@"#C8C8C8", 1) forKeyPath:@"_placeholderLabel.textColor"];
    tf.delegate = self;
    tf.font = [UIFont systemFontOfSize:15];
}

#pragma mark - 关于输入框的各种代理事件
//点击空白结束编辑
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)disMiss {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
