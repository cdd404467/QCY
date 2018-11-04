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

@interface RegisterVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *phoneTF;
@property (nonatomic, strong)UITextField *usernameTF;
@property (nonatomic, strong)UITextField *imageCodeTF;
@property (nonatomic, strong)UITextField *msgCodeTF;
@property (nonatomic, strong)UITextField *setPassTF;
@property (nonatomic, strong)UITextField *setPassAgainTF;
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

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

- (void)setupUI {
    //手机号
    UITextField *phoneTF = [[UITextField alloc] init];
    [self.view addSubview:phoneTF];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KFit_H(42) + NAV_HEIGHT);
        make.height.mas_equalTo(@(50 * Scale_H));
        make.left.mas_equalTo(@(KFit_W(38)));
        make.right.mas_equalTo(@(KFit_W(-38)));
    }];
    _phoneTF = phoneTF;
    [self setTextField:phoneTF];
    
    //用户名
    UITextField *usernameTF = [[UITextField alloc] init];
    [self.view addSubview:usernameTF];
    [usernameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneTF.mas_bottom).offset(KFit_H(15));
        make.height.mas_equalTo(phoneTF.mas_height);
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
    }];
    _usernameTF = usernameTF;
    [self setTextField:usernameTF];
    
    //图片验证码底框
    UIView *bgView1 = [[UIView alloc] init];
    bgView1.layer.borderWidth = 1;
    bgView1.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
    bgView1.layer.cornerRadius = 3;
    [self.view addSubview:bgView1];
    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(usernameTF.mas_bottom).offset(KFit_H(15));
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
    [self.view addSubview:bgView2];
    [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView1.mas_bottom).offset(KFit_H(15));
        make.height.mas_equalTo(phoneTF.mas_height);
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
    }];
    
    //图片验证码
    UITextField *imageCodeTF = [[UITextField alloc] init];
    [bgView1 addSubview:imageCodeTF];
    [imageCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(@0);
        make.width.mas_equalTo(@(KFit_W(170)));
    }];
    _imageCodeTF = imageCodeTF;
    [self setTextField:imageCodeTF];
    
    //分割线 - 1
    UIView *sLine_1 = [[UIView alloc] init];
    sLine_1.backgroundColor = HEXColor(@"#D7D7D7", 1);
    [bgView1 addSubview:sLine_1];
    [sLine_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageCodeTF.mas_right);
        make.height.mas_equalTo(@(30 * Scale_H));
        make.width.mas_equalTo(@0.5);
        make.centerY.mas_equalTo(imageCodeTF.mas_centerY);
    }];
    
    //图片验证码
    UIImageView *checkImage = [[UIImageView alloc] init];
    checkImage.backgroundColor = [UIColor grayColor];
    [bgView1 addSubview:checkImage];
    [checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sLine_1.mas_right).offset(13 * Scale_W);
        make.height.mas_equalTo(@(30 * Scale_H));
        make.width.mas_equalTo(@(65 * Scale_W));
        make.centerY.mas_equalTo(sLine_1.mas_centerY);
    }];
    
    //换一张按钮
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setImage:[UIImage imageNamed:@"change_next"] forState:UIControlStateNormal];
    [bgView1 addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(checkImage.mas_right);
        make.right.mas_equalTo(@0);
        make.height.mas_equalTo(@(30 * Scale_H));
        make.centerY.mas_equalTo(sLine_1.mas_centerY);
    }];
    
    //手机验证码
    UITextField *msgCodeTF = [[UITextField alloc] init];
    [bgView2 addSubview:msgCodeTF];
    [msgCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(@0);
        make.width.mas_equalTo(@(KFit_W(170)));
    }];
    _msgCodeTF = msgCodeTF;
    [self setTextField:msgCodeTF];
    
    //分割线 - 1
    UIView *sLine_2 = [[UIView alloc] init];
    sLine_2.backgroundColor = HEXColor(@"#D7D7D7", 1);
    [bgView2 addSubview:sLine_2];
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
    [bgView2 addSubview:countDownbtn];
    [countDownbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sLine_2.mas_right);
        make.top.bottom.right.mas_equalTo(@0);
    }];
    
    //设置密码
    UITextField *setPassTF = [[UITextField alloc] init];
    [self.view addSubview:setPassTF];
    [setPassTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView2.mas_bottom).offset(KFit_H(15));
        make.height.mas_equalTo(phoneTF.mas_height);
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
    }];
    _setPassTF = setPassTF;
    [self setTextField:setPassTF];
    
    //再次输入密码
    UITextField *setPassAgainTF = [[UITextField alloc] init];
    [self.view addSubview:setPassAgainTF];
    [setPassAgainTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(setPassTF.mas_bottom).offset(KFit_H(15));
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
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneTF.mas_left);
        make.right.mas_equalTo(phoneTF.mas_right);
        make.height.mas_equalTo(@49);
        make.top.mas_equalTo(setPassAgainTF.mas_bottom).offset(KFit_H(18));
    }];
    //协议
    YYLabel *agreementLabel = [[YYLabel alloc] init];
    [self.view addSubview:agreementLabel];
    [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(registerBtn.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    NSString *text = @"注册即代表您已阅读并同意《七彩云协议》";
    NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:text];
    mText.yy_font = [UIFont systemFontOfSize:15];
    mText.yy_color = HEXColor(@"#B6B6B6", 1);
    [mText yy_setTextHighlightRange:NSMakeRange(12, 7) color:MainColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
    }];
    agreementLabel.attributedText = mText;
    
}

//设置textfield
- (void)setTextField:(UITextField *)tf {
    if ([tf isEqual:_phoneTF]) {
        tf.placeholder = @"请输入手机号(用于登陆/找回密码)";
    } else if ([tf isEqual:_usernameTF]) {
        tf.placeholder = @"用户名(3-16位数字、字母、汉字)";
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
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KFit_W(18), KFit_H(50))];
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

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
