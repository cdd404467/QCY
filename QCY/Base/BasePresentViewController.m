//
//  BasePresentViewController.m
//  QCY
//
//  Created by i7colors on 2019/3/23.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BasePresentViewController.h"
#import "CustomNavigationBar.h"
#import "MacroHeader.h"
#import <Masonry.h>

@interface BasePresentViewController ()

@end

@implementation BasePresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    _navBar = [[CustomNavigationBar alloc] init];
    [_navBar.leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_navBar.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_navBar.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_navBar.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_navBar.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(48);
    }];
    [_navBar.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(58);
        make.height.mas_equalTo(32);
    }];
//    _navBar.rightBtn.backgroundColor = MainColor;
    
    [_navBar.rightBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"#ef3673", 1)] forState:UIControlStateNormal];
    [_navBar.rightBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"#ef3673", .5)] forState:UIControlStateDisabled];
    _navBar.rightBtnFont = [UIFont boldSystemFontOfSize:17];
    _navBar.leftBtnFont = [UIFont systemFontOfSize:17];
    _navBar.rightBtnTextColor = UIColor.whiteColor;
    _navBar.rightBtn.layer.cornerRadius = 3.f;
    _navBar.rightBtn.clipsToBounds = YES;
    [self.view addSubview:_navBar];
    
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBtnClick {
    if (self.rightBtnClickBlock) {
        self.rightBtnClickBlock();
    }
}
@end
