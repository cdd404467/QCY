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


@interface ResetPassword ()<UITextFieldDelegate>
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

- (void)setupUI {
    
    //重新设置密码
    UITextField *setPassTF = [[UITextField alloc] init];
    [self.view addSubview:setPassTF];
    [setPassTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KFit_H(206) + NAV_HEIGHT);
        make.height.mas_equalTo(@(50 * Scale_H));
        make.left.mas_equalTo(@(KFit_W(38)));
        make.right.mas_equalTo(@(KFit_W(-38)));
    }];
    _setPassTF = setPassTF;
    [self setTextField:setPassTF];
    
    //再次输入密码
    UITextField *setPassAgainTF = [[UITextField alloc] init];
    [self.view addSubview:setPassAgainTF];
    [setPassAgainTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(setPassTF.mas_bottom).offset(KFit_H(15));
        make.height.mas_equalTo(setPassTF.mas_height);
        make.left.mas_equalTo(setPassTF.mas_left);
        make.right.mas_equalTo(setPassTF.mas_right);
    }];
    _setPassAgainTF = setPassAgainTF;
    [self setTextField:setPassAgainTF];
    
    //注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH - KFit_W(38 * 2), 49);
    [ClassTool addLayer:registerBtn frame:rect];
    registerBtn.layer.cornerRadius = 5;
    registerBtn.clipsToBounds = YES;
    [registerBtn setTitle:@"确认重置密码" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitleColor:RGBA(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(setPassAgainTF.mas_left);
        make.right.mas_equalTo(setPassAgainTF.mas_right);
        make.height.mas_equalTo(@49);
        make.top.mas_equalTo(setPassAgainTF.mas_bottom).offset(KFit_H(18));
    }];
    
}

//设置textfield
- (void)setTextField:(UITextField *)tf {
    if ([tf isEqual:_setPassTF]) {
        tf.placeholder = @"请重新设置密码";
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
    tf.layer.borderWidth = 1;
    tf.layer.cornerRadius = 3;
    tf.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
