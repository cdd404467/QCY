//
//  OpenMallClassifyVC.m
//  QCY
//
//  Created by i7colors on 2019/6/21.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "OpenMallClassifyVC.h"
#import <SGPagingView.h>
#import <UMAnalytics/MobClick.h>
#import "ClassTool.h"
#import "PYSearch.h"
#import "SearchResultPageVC.h"
#import "BaseNavigationController.h"
#import "UIViewController+BarButton.h"
#import "OpenMallVC.h"
#import "NetWorkingPort.h"
#import "OpenMallModel.h"


@interface OpenMallClassifyVC ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;   //标题
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;   //文本

@end

@implementation OpenMallClassifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开放商城";
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"search"] action:@selector(jumpToSearch)];
    [self requestClassifyData];
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

- (void)jumpToSearch {
    //    NSArray *arr = @[@"阿伦",@"封金能"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"输入关键词搜索" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        SearchResultPageVC *vc = [[SearchResultPageVC alloc]init];
        vc.keyWord = searchText;
        vc.type = @"openMall";
        [searchViewController.navigationController pushViewController:vc animated:NO];
    }];
    //历史搜索风格
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchViewController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav  animated:NO completion:nil];
}

#pragma mark - 获取列表
- (void)requestClassifyData {
    NSString *urlString = [NSString stringWithFormat:URL_Shop_Classify];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            NSArray *arr = [OpenMallClassifyModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            NSMutableArray *titleArr = [NSMutableArray arrayWithCapacity:0];
            [titleArr addObject:@"全部"];
            for (OpenMallClassifyModel *model in arr) {
                [titleArr addObject:model.value];
            }
            [weakself setupUIWithArr:titleArr];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
    
}

- (void)setupUIWithArr:(NSArray *)titleArr {
    CGFloat titleHeight = 40;
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.indicatorStyle = SGIndicatorStyleCover;
    configure.indicatorAdditionalWidth = 20;
    configure.titleFont = [UIFont systemFontOfSize:12];
    configure.titleColor = HEXColor(@"#818181", 1);
    configure.indicatorColor = HEXColor(@"#F10215", .7);
    configure.indicatorAnimationTime = 0.3f;
    configure.showBottomSeparator = NO;
    configure.indicatorCornerRadius = 23 / 2;
    configure.indicatorHeight = 23;
    configure.titleSelectedColor = UIColor.whiteColor;
    configure.titleFont = [UIFont systemFontOfSize:14];
//    configure.titleSelectedFont = [UIFont systemFontOfSize:16];
    CGRect titleRect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, titleHeight);
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:titleRect delegate:self titleNames:titleArr configure:configure];
    self.pageTitleView.backgroundColor = Like_Color;
//    _pageTitleView.selectedIndex = _selectedIndex;
    [self.view addSubview:_pageTitleView];
    
    NSMutableArray *childArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        OpenMallVC *vc = [[OpenMallVC alloc] init];
        if (i == 0)
            vc.classifyValue = @" ";
        vc.classifyValue = titleArr[i];
        [childArr addObject:vc];
    }
    
    CGRect contentRect = CGRectMake(0, self.pageTitleView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.pageTitleView.bottom);
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
