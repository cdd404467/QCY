//
//  MyAskToBuyVC.m
//  QCY
//
//  Created by i7colors on 2018/10/23.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyAskToBuyVC.h"
#import "HelperTool.h"
#import <SGPagingView.h>
#import "MyAskToBuyAllVC.h"

@interface MyAskToBuyVC ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;   //标题
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;   //文本

@end

@implementation MyAskToBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的求购";
    [self setupUI];
    
}

- (void)setupUI {
    NSArray *titleArr = @[@"全部", @"求购中", @"已采纳", @"已关闭"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:12];
    configure.titleColor = HEXColor(@"#818181", 1);
    configure.indicatorColor = MainColor;
    CGRect titleRect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 40);
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:titleRect delegate:self titleNames:titleArr configure:configure];
    _pageTitleView.selectedIndex = _selectedIndex;
    [self.view addSubview:_pageTitleView];
    
    MyAskToBuyAllVC *vc1 = [[MyAskToBuyAllVC alloc] init];
    MyAskToBuyAllVC *vc2 = [[MyAskToBuyAllVC alloc] init];
    MyAskToBuyAllVC *vc3 = [[MyAskToBuyAllVC alloc] init];
    MyAskToBuyAllVC *vc4 = [[MyAskToBuyAllVC alloc] init];

    vc1.buyType = @"";
    vc2.buyType = @"1";
    vc3.buyType = @"3";
    vc4.buyType = @"2";
    NSArray *childArr = @[vc1, vc2, vc3, vc4];
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
