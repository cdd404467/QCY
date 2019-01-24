//
//  MyManifestVC.m
//  QCY
//
//  Created by i7colors on 2019/1/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyManifestVC.h"
#import "CommonNav.h"
#import <SGPagingView.h>
#import "MacroHeader.h"
#import "ManiFestChildVC.h"


@interface MyManifestVC ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;   //标题
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;   //文本
@property (nonatomic, strong)CommonNav *nav;
@end

@implementation MyManifestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nav];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (CommonNav *)nav {
    if (!_nav) {
        _nav = [[CommonNav alloc] init];
        _nav.titleLabel.text = @"我的货单";
        [_nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nav;
}

- (void)setupUI {
    NSArray *titleArr = @[@"我的用货单", @"我的供货单"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:14];
    configure.titleColor = HEXColor(@"#818181", 1);
    configure.indicatorColor = MainColor;
    CGRect titleRect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 40);
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:titleRect delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    
    ManiFestChildVC *vc1 = [[ManiFestChildVC alloc] init];
    ManiFestChildVC *vc2 = [[ManiFestChildVC alloc] init];
    vc1.listType = @"cg";
    vc2.listType = @"gh";
    
    NSArray *childArr = @[vc1, vc2];
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



- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
