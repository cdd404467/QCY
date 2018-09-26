//
//  ProductDetailsVC.m
//  QCY
//
//  Created by i7colors on 2018/9/25.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProductDetailsVC.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "WRNavigationBar.h"
#import "ProductDetailsView.h"

@interface ProductDetailsVC ()
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation ProductDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品详情";
    [self wr_setNavBarTintColor:[UIColor blackColor]];
    [self.view addSubview:self.scrollView];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT - 11);
        sv.contentSize = CGSizeMake(SCREEN_WIDTH, 40 + KFit_H(210) + 60 + 417);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsVerticalScrollIndicator = NO;
        sv.bounces = NO;
        ProductDetailsView *view = [[ProductDetailsView alloc] init];
        view.frame = CGRectMake(0, 0, sv.frame.size.width, sv.frame.size.height);
        [sv addSubview:view];
        _scrollView = sv;
    }
    
    return _scrollView;
}



@end
