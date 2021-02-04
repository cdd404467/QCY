//
//  LoginVC.m
//  QCY
//
//  Created by i7colors on 2018/9/20.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "LoginVC.h"
#import "ClassTool.h"
#import "RegisterVC.h"
#import "FindPasswordVC.h"
#import "NetWorkingPort.h"
#import "UIDevice+UUID.h"
#import "AES128.h"
#import "CddHUD.h"
#import "UITextField+Limit.h"
#import "WXAuth.h"
#import <WXApi.h>
#import "HelperTool.h"
#import <JPUSHService.h>
#import "BindPhoneNumberVC.h"

@interface LoginVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *userNameTF;
@property (nonatomic, strong)UITextField *passwdTF;
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation LoginVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        [super useImgMode];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
//    [self setNavBar];
    [self setupUI];
    [self registerNoti];
}

- (void)setNavBar {
    [self vhl_setNavBarBackgroundColor:Like_Color];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self.backBtn setImage:[UIImage imageNamed:@"close_back"] forState:UIControlStateNormal];
    self.backBtn.left = self.backBtn.left + 2;
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

#pragma mark - 网络请求
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
    NSString *jpushStr = [NSString string];
    if (JPushID) {
        jpushStr = JPushID;
    } else {
        jpushStr = [JPUSHService registrationID];
    }
    
    DDWeakSelf;
    NSDictionary *dict = @{@"username":_userNameTF.text,
                           @"aesPass":[AES128 AES128Encrypt:_passwdTF.text],
                           @"deviceNo":[UIDevice getDeviceID],
                           @"from":@"app_ios"
                           };
    NSMutableDictionary *mDict = [dict mutableCopy];
    if (isRightData(jpushStr)) {
        [mDict setObject:jpushStr forKey:@"registrationId"];
    }
    
    [CddHUD showWithText:@"登录中..." view:self.view];
    [ClassTool postRequest:URLPost_User_Login Params:mDict Success:^(id json) {
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
    NSString *jpushStr = [NSString string];
    if (JPushID) {
        jpushStr = JPushID;
    } else {
        jpushStr = [JPUSHService registrationID];
    }
    NSDictionary *dict = @{@"code":notification.userInfo[@"weixinCode"],
                           @"from":@"app_ios"
                           };
    NSMutableDictionary *mDict = [dict mutableCopy];
    if (isRightData(jpushStr)) {
        [mDict setObject:jpushStr forKey:@"registrationId"];
    }
    DDWeakSelf;
    [CddHUD showWithText:@"登录中..." view:self.view];
    [ClassTool postRequest:URL_WeiChat_Login Params:mDict Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                NSLog(@"-----ppp %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            if ([To_String(json[@"data"][@"needPhone"]) isEqualToString:@"1"]) {
                [weakself goBindVC:To_String(json[@"data"][@"token"])];
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


//弹框
- (void)goBindVC:(NSString *)token {
    BindPhoneNumberVC *vc = [[BindPhoneNumberVC alloc] init];
    vc.bindToken = token;
    vc.isJump = _isJump;
    vc.jumpIndex = _jumpIndex;
    DDWeakSelf;
    vc.bindCompleteBlock = ^{
        [weakself disMiss];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//第三方登录,获取微信信息
- (void)getWeixinInfo {
    [WXAUTH sendWXAuthReq];
}

- (void)saveInfo:(id)json {
    //登录成功回调
    if (self.loginCompleteBlock) {
        self.loginCompleteBlock();
    }
    NSString *companyName = [json[@"data"][@"isCompany"] boolValue] ? json[@"data"][@"companyName"] : @"";
    NSDictionary *userDict = @{@"userName":json[@"data"][@"loginName"],
                               @"token":json[@"data"][@"token"],
                               @"companyName":companyName,
                               @"isCompany":json[@"data"][@"isCompany"]
                               };
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:userDict];
    //用户类型
    if (isRightData(To_String(json[@"data"][@"userType"]))) {
        [mDict setObject:json[@"data"][@"userType"] forKey:@"userType"];
    }
    
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
    tf.tintColor = MainColor;
    tf.textColor = UIColor.blackColor;
    NSString *imageName = @"";
    if ([tf isEqual:_userNameTF]) {
        imageName = @"tf_icon1";
        tf.placeholder = @"请输入用户名";
    } else if ([tf isEqual:_passwdTF]) {
        imageName = @"tf_icon2";
        tf.secureTextEntry = YES;
        tf.placeholder = @"请输入密码";
    }
    //添加leftView
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeCenter;
    [leftView addSubview:imageView];
    tf.leftView = leftView;
    tf.leftViewMode = UITextFieldViewModeAlways;
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
