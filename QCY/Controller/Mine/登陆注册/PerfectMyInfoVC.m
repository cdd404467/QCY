//
//  PerfectMyInfoVC.m
//  QCY
//
//  Created by i7colors on 2019/8/15.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PerfectMyInfoVC.h"
#import "ClassTool.h"
#import "UITextField+Limit.h"
#import <BRPickerView.h>
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"

@interface PerfectMyInfoVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITextField *companyNameTF;
@property (nonatomic, strong)UITextField *registerNumTF;
@property (nonatomic, strong)UITextField *positionTF;
@property (nonatomic, strong)UIButton *selectBtn;
@end

@implementation PerfectMyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善信息";
    self.backBtn.hidden = YES;
    [self setNav];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
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

- (void)setNav {
    [self addRightBarButtonItemWithTitle:@"跳过" titleColor:UIColor.whiteColor action:@selector(popPage)];
    UIView *nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT)];
    [ClassTool addLayer:nav frame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT) startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self vhl_setNavBarBackgroundView:nav];
    [self vhl_setNavBarTitleColor:UIColor.whiteColor];
    self.backBtnTintColor = UIColor.whiteColor;
    [self vhl_setNavigationSwitchStyle:VHLNavigationSwitchStyleFakeNavBar];
}


- (void)submitInfo {
    
    if (_companyNameTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入公司名称" view:self.view];
        return;
    } else if (_positionTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请选择职位" view:self.view];
        return;
    }
    
    NSDictionary *dict = @{@"company":_companyNameTF.text,
                           @"positionName":_positionTF.text,
                           @"inviteCode":_registerNumTF.text,
                           @"token":_token
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URLPost_User_PerfectInfo Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [CddHUD showTextOnlyDelay:@"提交成功" view:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself popPage];                });
            });
        } else if ([json[@"code"] isEqualToString:@"REGISTER_FATL"]) {
            [CddHUD showTextOnlyDelay:@"该手机号已注册" view:weakself.view];
        }
    } Failure:^(NSError *error) {
        
    }];
}


- (void)setupUI {
    [self.view addSubview:self.scrollView];
    //公司名称
    UITextField *companyNameTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH - KFit_W(38) * 2, 50)];
    companyNameTF.centerX = SCREEN_WIDTH / 2;
    companyNameTF.placeholder = @"请输入公司全称";
    [self.scrollView addSubview:companyNameTF];
    //限制字数
    [companyNameTF lengthLimit:^{
        if (companyNameTF.text.length > 25) {
            companyNameTF.text = [companyNameTF.text substringToIndex:6];
        }
    }];
    _companyNameTF = companyNameTF;
    [self setTextField:companyNameTF];
    
    //选择职位
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, companyNameTF.bottom + 15, companyNameTF.width, companyNameTF.height)];
    bgView2.layer.borderWidth = 1;
    bgView2.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
    bgView2.layer.cornerRadius = 3;
    bgView2.centerX = companyNameTF.centerX;
    [self.scrollView addSubview:bgView2];
    
    //显示职位的label
    UITextField *positionTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, KFit_W(180), bgView2.height)];
    positionTF.userInteractionEnabled = NO;
    positionTF.placeholder = @"请选择职位";
    [bgView2 addSubview:positionTF];
    _positionTF = positionTF;
    [self setTextField:positionTF];
    
    //分割线 - 2
    UIView *sLine_2 = [[UIView alloc] init];
    sLine_2.backgroundColor = HEXColor(@"#D7D7D7", 1);
    [bgView2 addSubview:sLine_2];
    [sLine_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(positionTF.mas_right);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(1);
        make.centerY.mas_equalTo(positionTF.mas_centerY);
    }];
    
    //选择职位按钮
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setTitle:@"选择职位" forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectPosition) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [selectBtn setTitleColor:HEXColor(@"ef3673", 0.5) forState:UIControlStateHighlighted];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bgView2 addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sLine_2.mas_right);
        make.top.bottom.right.mas_equalTo(0);
    }];
    _selectBtn = selectBtn;
    
    //邀请码
    UITextField *registerNumTF = [[UITextField alloc] initWithFrame:CGRectMake(0, bgView2.bottom + 15, companyNameTF.width, companyNameTF.height)];
    registerNumTF.keyboardType = UIKeyboardTypeASCIICapable;
    registerNumTF.centerX = companyNameTF.centerX;
    registerNumTF.placeholder = @"请输入邀请码";
    [_scrollView addSubview:registerNumTF];
    //限制字数
    [registerNumTF lengthLimit:^{
        if (registerNumTF.text.length > 6) {
            registerNumTF.text = [registerNumTF.text substringToIndex:6];
        }
    }];
    _registerNumTF = registerNumTF;
    [self setTextField:registerNumTF];
    
    [registerNumTF.superview layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,registerNumTF.bottom + Bottom_Height_Dif + 20);
    
    //确认
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ensureBtn.frame = CGRectMake(0, registerNumTF.bottom + 140, companyNameTF.width, 49);
    [ClassTool addLayer:ensureBtn frame:CGRectMake(0, 0, ensureBtn.width, ensureBtn.height)];
    ensureBtn.centerX = companyNameTF.centerX;
    ensureBtn.layer.cornerRadius = 5;
    ensureBtn.clipsToBounds = YES;
    [ensureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ensureBtn setTitleColor:RGBA(255, 255, 255, 0.5) forState:UIControlStateHighlighted];
    ensureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [ensureBtn addTarget:self action:@selector(submitInfo) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:ensureBtn];
}



//设置textfield
- (void)setTextField:(UITextField *)tf {
    //添加leftView
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KFit_W(18), 50)];
    //    leftView.image = [UIImage imageNamed:imageName];
    leftView.contentMode = UIViewContentModeCenter;
    tf.leftView = leftView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.delegate = self;
    tf.font = [UIFont systemFontOfSize:15];
    if (![tf isEqual:_positionTF]) {
        tf.layer.borderWidth = 1;
        tf.layer.cornerRadius = 3;
        tf.layer.borderColor = HEXColor(@"#D7D7D7", 1).CGColor;
    }
}

- (void)selectPosition {
    [self.view endEditing:YES];
    NSArray *titleArr = @[@"采购",@"销售",@"技术",@"老板",@"生产",@"其它"];
    DDWeakSelf;
    [BRStringPickerView showStringPickerWithTitle:@"请选择职位" dataSource:titleArr defaultSelValue:nil isAutoSelect:NO themeColor:MainColor resultBlock:^(id selectValue) {
        weakself.positionTF.text = selectValue;
    }];
}

- (void)popPage {
    [self.navigationController popToRootViewControllerAnimated:YES];
    if (self.completeBlock)
        self.completeBlock();
}

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}
@end
