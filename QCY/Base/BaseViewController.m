//
//  BaseViewController.m
//  QCY
//
//  Created by i7colors on 2018/9/17.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginVC.h"

typedef void(^LoginComplete)(void);
@interface BaseViewController ()
@property (nonatomic, copy, nullable) LoginComplete loginComplete;
@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pageNumber = 1;
        _isRefreshList = NO;
        _isFirstLoadData = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {

    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _backBtn = self.mainNavController.backBtn;
    [self vhl_setNavigationSwitchStyle:VHLNavigationSwitchStyleTransition];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setBackBtnTintColor:(UIColor *)backBtnTintColor {
    _backBtnTintColor = backBtnTintColor;
    UIImage *image = [UIImage imageNamed:@"back_black"];
    [_backBtn setImage:[image imageWithTintColor_My:backBtnTintColor] forState:UIControlStateNormal];
    _backBtn.tintColor = backBtnTintColor;
}

- (void)setBackBtnBgColor:(UIColor *)backBtnBgColor {
    _backBtnBgColor = backBtnBgColor;
    _backBtn.backgroundColor = backBtnBgColor;
}

- (void)jumpToLogin {
    LoginVC *vc = [[LoginVC alloc] init];
    vc.isJump = NO;
    BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)jumpToLogin:(NSInteger)index {
    LoginVC *vc = [[LoginVC alloc] init];
    vc.isJump = YES;
    vc.jumpIndex = index;
    BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)jumpToLoginWithComplete:(void (^ __nullable)(void))handler {
    LoginVC *vc = [[LoginVC alloc] init];
    vc.isJump = NO;
    vc.loginCompleteBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler();
            }
        });
    };
    BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    navVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
