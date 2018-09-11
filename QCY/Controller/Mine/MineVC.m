//
//  MineVC.m
//  QCY
//
//  Created by zz on 2018/9/4.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MineVC.h"
#import "MacroHeader.h"

@interface MineVC ()

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#f26c27"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#ee2788"].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0,1.0);
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 170 * Scale_H);
    [self.view.layer addSublayer:gradientLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
