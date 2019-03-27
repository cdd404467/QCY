//
//  BaseViewControllerNav.m
//  QCY
//
//  Created by i7colors on 2018/10/24.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewControllerNav.h"

@interface BaseViewControllerNav ()

@end

@implementation BaseViewControllerNav

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    CommonNav *nav = [[CommonNav alloc] init];
    [nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
    _nav = nav;
}



- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
