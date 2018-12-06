//  AskToBuyOfferVC.m
//  QCY
//
//  Created by i7colors on 2018/10/22.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyOfferPriceVC.h"
#import "HelperTool.h"
#import <SGPagingView.h>
#import "MacroHeader.h"
#import "MyOfferPriceAllVC.h"


@interface MyOfferPriceVC ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;   //标题
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;   //文本
@end

@implementation MyOfferPriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav.titleLabel.text = @"我的报价";
    
    [self setupUI];
}

- (void)setupNav {
    //导航栏不透明时要不要延伸到bar的下面
    self.extendedLayoutIncludesOpaqueBars = NO;
    //根视图延展
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    UIImageView *lineImageView = [HelperTool findNavLine:self.navigationController.navigationBar];
    lineImageView.hidden = NO;
    
}


- (void)setupUI {
    NSArray *titleArr = @[@"全部", @"报价中", @"已采纳", @"已关闭"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:12];
    configure.titleColor = HEXColor(@"#818181", 1);
    configure.indicatorColor = MainColor;
    CGRect titleRect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 40);
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:titleRect delegate:self titleNames:titleArr configure:configure];
    _pageTitleView.selectedIndex = _selectedIndex;
    [self.view addSubview:_pageTitleView];
    
    MyOfferPriceAllVC *vc1 = [[MyOfferPriceAllVC alloc] init];
    MyOfferPriceAllVC *vc2 = [[MyOfferPriceAllVC alloc] init];
    MyOfferPriceAllVC *vc3 = [[MyOfferPriceAllVC alloc] init];
    MyOfferPriceAllVC *vc4 = [[MyOfferPriceAllVC alloc] init];
    vc1.offrtType = @"";
    vc2.offrtType = @"0";
    vc3.offrtType = @"1";
    vc4.offrtType = @"2";
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
