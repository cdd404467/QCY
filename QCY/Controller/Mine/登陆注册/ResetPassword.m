//
//  ResetPassword.m
//  QCY
//
//  Created by i7colors on 2018/10/10.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ResetPassword.h"
#import "CommonNav.h"
#import "ClassTool.h"
#import <Masonry.h>
#import "MacroHeader.h"
#import "UITextField+Limit.h"
#import "NetWorkingPort.h"
#import "AES128.h"
#import "CddHUD.h"
#import "MobilePhone.h"


@interface ResetPassword ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *oriPassTF;
@property (nonatomic, strong)UITextField *setPassTF;
@property (nonatomic, strong)UITextField *setPassAgainTF;
@end

@implementation ResetPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupUI];
    
}

- (void)setupNav {
    CommonNav *nav = [[CommonNav alloc] init];
    nav.titleLabel.text = @"重置密码";
    [ClassTool addLayer:nav frame:nav.frame];
    nav.titleLabel.textColor = [UIColor whiteColor];
    nav.bottomLine.hidden = YES;
    [nav.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
}

#pragma mark - 提交新密码
//重置密码
- (void)submitNewPassWord {
    if ([self judgeData] == NO) {
        return ;
    };

    NSDictionary *dict = @{@"mobile":_phoneNum,
                           @"password":[AES128 AES128Encrypt:_setPassTF.text],
                           @"rePassword":[AES128 AES128Encrypt:_setPassAgainTF.text]
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Reset_PassWord Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [CddHUD showTextOnlyDelay:@"新密码设置成功" view:weakself.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController popToRootViewControllerAnimated:YES];
            });
            
        }

    } Failure:^(NSError *error) {
        
    }];
}

//修改密码
- (void)changePassWord {
    if ([self judgeData] == NO) {
        return ;
    };
    
    NSDictionary *dict = @{@"token":User_Token,
                           @"password":[AES128 AES128Encrypt:_oriPassTF.text],
                           @"newPassword":[AES128 AES128Encrypt:_setPassTF.text],
                           @"reNewPassword":[AES128 AES128Encrypt:_setPassAgainTF.text]
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Change_PassWord Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        //        NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [CddHUD showTextOnlyDelay:@"新密码设置成功" view:weakself.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself changeAfter];
            });
            
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

//修改成功后删除本地token，跳回首页，并通知首页弹出登录框
- (void)changeAfter {
    if (GET_USER_TOKEN) {
        [UserDefault removeObjectForKey:@"userInfo"];
    }
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSString *notiName = @"notifiReLogin";
    [[NSNotificationCenter defaultCenter]postNotificationName:notiName object:nil userInfo:nil];
}



- (BOOL)judgeData {
    if ([_passType isEqualToString:@"changePW"]) {
        if ([_oriPassTF.text isEqualToString:@""]) {
            [CddHUD showTextOnlyDelay:@"原密码" view:self.view];
            return NO;
        }
    }
    
    if ([_setPassTF.text isEqualToString:@""]) {
        [CddHUD showTextOnlyDelay:@"请设置密码" view:self.view];
        return NO;
    } else if ([_setPassAgainTF.text isEqualToString:@""]) {
        [CddHUD showTextOnlyDelay:@"请输入确认密码" view:self.view];
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

- (void)setupUI {
    //手机号
    UITextField *oriPassTF = [[UITextField alloc] init];
    oriPassTF.secureTextEntry = YES;
    oriPassTF.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:oriPassTF];
    [oriPassTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(150 + NAV_HEIGHT);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(@(KFit_W(38)));
        make.right.mas_equalTo(@(KFit_W(-38)));
    }];
    //限制字数
    [oriPassTF lengthLimit:^{
        if (oriPassTF.text.length > 11) {
            oriPassTF.text = [oriPassTF.text substringToIndex:11];
        }
    }];
    _oriPassTF = oriPassTF;
    [self setTextField:oriPassTF];
    
    //判断是重置密码还是修改密码
    if ([_passType isEqualToString:@"resetPW"]) {
        _oriPassTF.hidden = YES;
    }
    
    //重新设置密码
    UITextField *setPassTF = [[UITextField alloc] init];
    setPassTF.secureTextEntry = YES;
    setPassTF.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:setPassTF];
    [setPassTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(oriPassTF.mas_bottom).offset(15);
        make.height.mas_equalTo(50);
        make.left.mas_equalTo(@(KFit_W(38)));
        make.right.mas_equalTo(@(KFit_W(-38)));
    }];
    _setPassTF = setPassTF;
    [self setTextField:setPassTF];
    
    //再次输入密码
    UITextField *setPassAgainTF = [[UITextField alloc] init];
    setPassAgainTF.secureTextEntry = YES;
    setPassAgainTF.keyboardType = UIKeyboardTypeASCIICapable;
    [self.view addSubview:setPassAgainTF];
    [setPassAgainTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(setPassTF.mas_bottom).offset(15);
        make.height.mas_equalTo(setPassTF.mas_height);
        make.left.mas_equalTo(setPassTF.mas_left);
        make.right.mas_equalTo(setPassTF.mas_right);
    }];
    _setPassAgainTF = setPassAgainTF;
    [self setTextField:setPassAgainTF];
    
    NSString *btnTitle = [NSString string];
    if ([_passType isEqualToString:@""]) {
        btnTitle = @"重置密码";
    } else {
        btnTitle = @"修改密码";
    }
    
    //注册按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH - KFit_W(38 * 2), 49);
    [ClassTool addLayer:submitBtn frame:rect];
    submitBtn.layer.cornerRadius = 5;
    submitBtn.clipsToBounds = YES;
    [submitBtn setTitle:btnTitle forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:RGBA(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    if ([_passType isEqualToString:@"resetPW"]) {
        [submitBtn addTarget:self action:@selector(submitNewPassWord) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [submitBtn addTarget:self action:@selector(changePassWord) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(setPassAgainTF.mas_left);
        make.right.mas_equalTo(setPassAgainTF.mas_right);
        make.height.mas_equalTo(@49);
        make.top.mas_equalTo(setPassAgainTF.mas_bottom).offset(18);
    }];
    
}

//设置textfield
- (void)setTextField:(UITextField *)tf {
    if ([tf isEqual:_oriPassTF]) {
        tf.placeholder = @"请输入原密码";
    } else if ([tf isEqual:_setPassTF]) {
        tf.placeholder = @"请输入新密码";
    } else {
        tf.placeholder = @"再次输入新密码";
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
    tf.layer.borderWidth = 1;
    tf.layer.cornerRadius = 3;
    tf.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}
@end
