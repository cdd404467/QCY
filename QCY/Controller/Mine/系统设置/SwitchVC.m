//
//  SwitchVC.m
//  QCY
//
//  Created by i7colors on 2018/10/24.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "SwitchVC.h"
#import <Masonry.h>
#import "MacroHeader.h"

@interface SwitchVC ()

@end

@implementation SwitchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupUI];
}

- (void)setupUI {
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:15.1f];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(20 + Top_Height_Dif);
    }];
    
    //买家按钮
    UIButton *buyerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyerBtn.backgroundColor = [UIColor whiteColor];
    buyerBtn.adjustsImageWhenHighlighted = NO;
    buyerBtn.layer.cornerRadius = 5.f;
    buyerBtn.tag = 0;
    [buyerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    buyerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [buyerBtn setImage:[UIImage imageNamed:@"buyer_icon"] forState:UIControlStateNormal];
    [buyerBtn setTitle:@"买家中心" forState:UIControlStateNormal];
    buyerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
    buyerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 7);
    [self.view addSubview:buyerBtn];
    [buyerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(130);
        make.bottom.mas_equalTo(self.view.mas_centerY).offset(-20);
    }];
    
    //卖家
    UIButton *sellerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sellerBtn.backgroundColor = [UIColor whiteColor];
    sellerBtn.adjustsImageWhenHighlighted = NO;
    sellerBtn.tag = 1;
    [sellerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sellerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sellerBtn setImage:[UIImage imageNamed:@"seller_icon"] forState:UIControlStateNormal];
    [sellerBtn setTitle:@"卖家中心" forState:UIControlStateNormal];
    sellerBtn.layer.cornerRadius = 5.f;
    sellerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
    sellerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 7);
    [self.view addSubview:sellerBtn];
    [sellerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(130);
        make.top.mas_equalTo(self.view.mas_centerY).offset(20);
    }];
    
    [buyerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sellerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_sID == 0) {
        buyerBtn.layer.borderWidth = 3.f;
        buyerBtn.layer.borderColor = MainColor.CGColor;
    } else {
        sellerBtn.layer.borderWidth = 3.f;
        sellerBtn.layer.borderColor = MainColor.CGColor;
    }
    
}

- (void)btnClick:(UIButton *)sender {
    //传值
    if (self.switchBlock) {
        self.switchBlock(sender.tag);
    }
    [self dismiss];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
