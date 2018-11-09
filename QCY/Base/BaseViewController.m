//
//  BaseViewController.m
//  QCY
//
//  Created by i7colors on 2018/9/17.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "CddHUD.h"
#import "CommonNav.h"
#import "LoginVC.h"
#import "BaseNavigationController.h"
#import "MacroHeader.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController.navigationBar.isHidden == YES) {
        _originHeight = NAV_HEIGHT;
    } else {
        _originHeight = 0;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [CddHUD hideHUD];
}

- (void)jumpToLogin {
    LoginVC *vc = [[LoginVC alloc] init];
    vc.isJump = NO;
    BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
