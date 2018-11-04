//
//  IndustryInformationVC.m
//  QCY
//
//  Created by i7colors on 2018/11/1.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "IndustryInformationVC.h"
#import "MacroHeader.h"
#import "CommonNav.h"
#import <SGPagingView.h>
#import "InformationChildVC.h"

@interface IndustryInformationVC ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;   //标题
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;   //文本

@end

@implementation IndustryInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self setNavBar];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setNavBar {
    CommonNav *nav = [[CommonNav alloc] init];
    nav.titleLabel.text = @"产业资讯";
    [nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
}

- (void)setupUI {
    CGFloat titleHeight = 35;
    NSArray *titleArr = @[@"全部", @"行业资讯", @"人物访谈", @"政策法规", @"展会/会议", @"人才招聘"];
    NSArray *typeArr = @[@"0", @"66", @"89", @"90", @"91", @"11"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:12];
    configure.titleColor = HEXColor(@"#818181", 1);
    configure.indicatorColor = MainColor;
    configure.showBottomSeparator = NO;
    configure.indicatorCornerRadius = 2.f;
    configure.titleSelectedColor = MainColor;
    configure.titleFont = [UIFont systemFontOfSize:14];
    configure.titleSelectedFont = [UIFont systemFontOfSize:16];
    CGRect titleRect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, titleHeight);
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:titleRect delegate:self titleNames:titleArr configure:configure];
    _pageTitleView.selectedIndex = _selectedIndex;
    [self.view addSubview:_pageTitleView];
    
    NSMutableArray *childArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        InformationChildVC *vc = [[InformationChildVC alloc] init];
        vc.typeID = typeArr[i];
        [childArr addObject:vc];
    }
    
    CGRect contentRect = CGRectMake(0, titleHeight + NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - titleHeight);
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
