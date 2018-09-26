//
//  MineVC.m
//  QCY
//
//  Created by zz on 2018/9/4.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MineVC.h"
#import "MacroHeader.h"
#import "WRNavigationBar.h"
#import "HelperTool.h"
#import <Masonry.h>
#import "BaseNavigationController.h"

//跳转的页面
#import "LoginVC.h"



@interface MineVC ()

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UIImageView *lineImageView = [HelperTool findNavLine:self.navigationController.navigationBar];
    lineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)setupNav {
    //导航栏不透明时要不要延伸到bar的下面
    self.extendedLayoutIncludesOpaqueBars = YES;
    //根视图延展
    self.edgesForExtendedLayout = UIRectEdgeAll;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self wr_setNavBarBackgroundAlpha:0];
    [self wr_setNavBarTitleColor:[UIColor whiteColor]];
   
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupUI {
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT + 106 * Scale_H);
    [self.view addSubview:topView];
    
    //上方彩色背景
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#f26c27"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#ee2788"].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0.0, 0.3);
    gradientLayer.endPoint = CGPointMake(1.0,0.7);
    gradientLayer.frame = topView.frame;
    [topView.layer addSublayer:gradientLayer];
    
    //头像
    UIImageView *userHeader = [[UIImageView alloc] init];
    [HelperTool addTapGesture:userHeader withTarget:self andSEL:@selector(userHeaderClick)];
    userHeader.layer.cornerRadius = KFit_W(58) / 2;
    userHeader.clipsToBounds = YES;
    userHeader.backgroundColor = [UIColor whiteColor];
    [topView addSubview:userHeader];
    [userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(58 * Scale_W));
        make.bottom.mas_equalTo(@(-46 * Scale_H));
        make.left.mas_equalTo(@(27 * Scale_W));
    }];
    
    //公司名字
    UILabel *userName = [[UILabel alloc] init];
    userName.text = @"未登录";
    userName.font = [UIFont boldSystemFontOfSize:15];
    userName.textColor = [UIColor whiteColor];
    [topView addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userHeader.mas_right).offset(KFit_W(18));
        make.top.mas_equalTo(@(NAV_HEIGHT + 13 * Scale_H));
        make.height.mas_equalTo(@(16 * Scale_H));
    }];
    
    
}

- (void)userHeaderClick {
    LoginVC *vc = [[LoginVC alloc] init];
    BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
