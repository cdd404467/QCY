//
//  MyZhuJiDiyListVC.m
//  QCY
//
//  Created by i7colors on 2019/8/7.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyZhuJiDiyListVC.h"
#import <SGPagingView.h>
#import "MyZhuJiDiyChildVC.h"

@interface MyZhuJiDiyListVC ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;   //标题
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;   //文本

@end

@implementation MyZhuJiDiyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的助剂定制";
    [self setupUI];
}

- (void)setupUI {
    NSArray *titleArr = @[@"全部", @"试样中", @"已采纳", @"已关闭",@"已过期"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:12];
    configure.titleColor = HEXColor(@"#818181", 1);
    configure.indicatorColor = MainColor;
    CGRect titleRect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 40);
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:titleRect delegate:self titleNames:titleArr configure:configure];
    _pageTitleView.selectedIndex = _selectedIndex;
    [self.view addSubview:_pageTitleView];
    
    MyZhuJiDiyChildVC *vc1 = [[MyZhuJiDiyChildVC alloc] init];
    MyZhuJiDiyChildVC *vc2 = [[MyZhuJiDiyChildVC alloc] init];
    MyZhuJiDiyChildVC *vc3 = [[MyZhuJiDiyChildVC alloc] init];
    MyZhuJiDiyChildVC *vc4 = [[MyZhuJiDiyChildVC alloc] init];
    MyZhuJiDiyChildVC *vc5 = [[MyZhuJiDiyChildVC alloc] init];
    
    vc1.status = @"";
    vc2.status = @"diying";
    vc3.status = @"accept";
    vc4.status = @"close";
    vc5.status = @"time_out";
    NSArray *childArr = @[vc1, vc2, vc3, vc4, vc5];
    for (MyZhuJiDiyChildVC *vc in childArr) {
        vc.type = @"0";
    }
    CGRect contentRect = CGRectMake(0, 40 + NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 40);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:contentRect parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    _pageContentScrollView.isAnimated = YES;
}



- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentScrollViewWillBeginDragging {
    _pageTitleView.userInteractionEnabled = NO;
}

- (void)pageContentScrollViewDidEndDecelerating {
    _pageTitleView.userInteractionEnabled = YES;
}

@end
