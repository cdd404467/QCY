//
//  IndustryInformationVC.m
//  QCY
//
//  Created by i7colors on 2018/11/1.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "IndustryInformationVC.h"
#import <SGPagingView.h>
#import "InformationChildVC.h"
#import <UMAnalytics/MobClick.h>

@interface IndustryInformationVC ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;   //标题
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;   //文本

@end

@implementation IndustryInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产业资讯";
    //从发布朋友圈页面过来的
    if ([_fromPage isEqualToString:@"pfPage"]) {
        [self setCancelBtn];
        [self vhl_setNavBarBackgroundColor:Like_Color];
        [self vhl_setNavBarShadowImageHidden:YES];
    }
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
}

- (void)setCancelBtn {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [leftBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(5, 0, 45, 44);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftBtn];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupUI {
    CGFloat titleHeight = 40;
    NSArray *titleArr = @[@"全部", @"行业资讯", @"人物访谈", @"政策法规", @"展会/会议", @"人才招聘"];
    NSArray *typeArr = @[@"0", @"66", @"89", @"90", @"91", @"11"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
//    configure.indicatorStyle = SGIndicatorStyleCover;
//    configure.indicatorAdditionalWidth = 10;
    configure.titleColor = HEXColor(@"#818181", 1);
    configure.indicatorColor = MainColor;
    configure.indicatorAnimationTime = 0.3f;
    configure.showBottomSeparator = NO;
    configure.indicatorCornerRadius = 2.f;
//    configure.indicatorHeight = 30;
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
        vc.fromPage = _fromPage;
        DDWeakSelf;
        vc.selectedZXBlock = ^(InfomationModel * _Nonnull model) {
            if (weakself.selectedZXBlock) {
                weakself.selectedZXBlock(model);
            }
        };
        [childArr addObject:vc];
    }
    
    CGRect contentRect = CGRectMake(0, titleHeight + NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - titleHeight);
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
