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


@interface LoginVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *userNameTF;
@property (nonatomic, strong)UITextField *passwdTF;
@property (nonatomic, strong)UITextField *checkCodeTF;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登陆";
    self.navigationController.navigationBar.translucent = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    UIButton *backBtn = [ClassTool customBackBtn];
    [backBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:backBtn];
    [self setupUI];
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
        make.top.mas_equalTo(@(37 * Scale_H));
        make.width.height.mas_equalTo(@(87 * Scale_W));
    }];
    
    UIView *tfView = [[UIView alloc] init];
    tfView.layer.borderWidth = 1.0f;
    tfView.layer.borderColor = HEXColor(@"#D6D6D6", 0.5).CGColor;
    tfView.layer.cornerRadius = 5;
    tfView.clipsToBounds = YES;
    [self.view addSubview:tfView];
    [tfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(appHeader.mas_bottom).offset(37 * Scale_H);
        make.height.mas_equalTo(@(150 * Scale_H));
        make.left.mas_equalTo(@(38 * Scale_W));
        make.right.mas_equalTo(@(-38 * Scale_W));
    }];
    
    //账号TF
    UITextField *userNameTF = [[UITextField alloc] init];
    [tfView addSubview:userNameTF];
    [userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(@0);
        make.height.mas_equalTo(@(50 * Scale_H));
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
    [tfView addSubview:passwdTF];
    [passwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(@0);
        make.top.mas_equalTo(userNameTF.mas_bottom);
        make.height.mas_equalTo(@(50 * Scale_H));
    }];
    _passwdTF = passwdTF;
    [self setTextField:passwdTF];
    
    //密码TF黑线
    UIView *line_2 = [[UIView alloc] init];
    line_2.backgroundColor = HEXColor(@"#D6D6D6", 0.5);
    [passwdTF addSubview:line_2];
    [line_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(@0);
        make.height.mas_equalTo(@1);
    }];
    
    //验证码TF
    UITextField *checkCodeTF = [[UITextField alloc] init];
    [tfView addSubview:checkCodeTF];
    [checkCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@0);
        make.width.mas_equalTo(@(158 * Scale_W));
        make.top.mas_equalTo(passwdTF.mas_bottom);
        make.height.mas_equalTo(@(50 * Scale_H));
    }];
    _checkCodeTF = checkCodeTF;
    [self setTextField:checkCodeTF];
    
    //分割线
    UIView *sLine = [[UIView alloc] init];
    sLine.backgroundColor = HEXColor(@"#D7D7D7", 1);
    [tfView addSubview:sLine];
    [sLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(checkCodeTF.mas_right);
        make.height.mas_equalTo(@(30 * Scale_H));
        make.width.mas_equalTo(@0.5);
        make.centerY.mas_equalTo(checkCodeTF.mas_centerY);
    }];
    
    //图片验证码
    UIImageView *checkImage = [[UIImageView alloc] init];
    checkImage.backgroundColor = [UIColor grayColor];
    [tfView addSubview:checkImage];
    [checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sLine.mas_right).offset(13 * Scale_W);
        make.height.mas_equalTo(@(30 * Scale_H));
        make.width.mas_equalTo(@(65 * Scale_W));
        make.centerY.mas_equalTo(sLine.mas_centerY);
    }];
    
    //换一张按钮
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setImage:[UIImage imageNamed:@"change_next"] forState:UIControlStateNormal];
    [tfView addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(checkImage.mas_right);
        make.right.mas_equalTo(@0);
        make.height.mas_equalTo(@(30 * Scale_H));
        make.centerY.mas_equalTo(sLine.mas_centerY);
    }];
    
    //登陆按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH - KFit_W(38 * 2), 49);
    [ClassTool addLayer:loginBtn frame:rect];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.clipsToBounds = YES;
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:RGBA(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tfView.mas_left);
        make.right.mas_equalTo(tfView.mas_right);
        make.height.mas_equalTo(@49);
        make.top.mas_equalTo(tfView.mas_bottom).offset(KFit_H(18));
    }];
    
    //立即注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [registerBtn setTitleColor:HEXColor(@"#B6B6B6", 1) forState:UIControlStateNormal];
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
    [self.view addSubview:forgetpwBtn];
    [forgetpwBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(loginBtn.mas_right);
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(15);
        make.height.mas_equalTo(30);
    }];
    
    //快速登陆
    UILabel *thirdLogin = [[UILabel alloc] init];
    thirdLogin.text = @"快速登陆";
    thirdLogin.textColor = HEXColor(@"#C8C8C8", 1);
    thirdLogin.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:thirdLogin];
    [thirdLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(KFit_H(97));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(@(12 * Scale_H));
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
    weiChat.image = [UIImage imageNamed:@"weixin"];
    [self.view addSubview:weiChat];
    [weiChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(thirdLogin.mas_bottom).offset(KFit_H(20));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.height.mas_equalTo(@(44 * Scale_W));
    }];
}

//设置textfield
- (void)setTextField:(UITextField *)tf {
    NSString *imageName = @"";
    if ([tf isEqual:_userNameTF]) {
        imageName = @"tf_icon1";
        tf.placeholder = @"请输入用户名";
    } else if ([tf isEqual:_passwdTF]) {
        imageName = @"tf_icon2";
        tf.placeholder = @"请输入密码";
    } else {
        imageName = @"tf_icon3";
        tf.placeholder = @"请输入验证码";
    }
    //添加leftView
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KFit_W(50), KFit_H(50))];
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

@end
