//
//  SelectedTopicVC.m
//  QCY
//
//  Created by i7colors on 2019/4/15.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "SelectedTopicVC.h"
#import "NavControllerSet.h"
#import <SGPagingView.h>
#import "ChildTopicVC.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "FriendCricleModel.h"
#import "HelperTool.h"
#import "UIView+Border.h"
#import "PullDownTopicView.h"

@interface SelectedTopicVC ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;   //标题
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;   //文本
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)PullDownTopicView *pullDownView;
@property (nonatomic, strong)UIButton *moreBtn;
@end

@implementation SelectedTopicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择话题";
    self.view.backgroundColor = Like_Color;
    self.rightNavBtn.hidden = YES;
//    [self.rightNavBtn addTarget:self action:@selector(completeSele) forControlEvents:UIControlEventTouchUpInside];
    [self requestFirstTopicList];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (void)setupUI {
    CGFloat titleHeight = 35;
    NSMutableArray *titleArr = [NSMutableArray arrayWithCapacity:0];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:12];
    configure.titleColor = HEXColor(@"#818181", 1);
    configure.indicatorColor = MainColor;
    configure.showBottomSeparator = YES;
    configure.bottomSeparatorColor = HEXColor(@"#e3e3e3", 1);
    configure.indicatorCornerRadius = 2.f;
    configure.titleSelectedColor = MainColor;
    configure.titleFont = [UIFont systemFontOfSize:14];
    configure.titleSelectedFont = [UIFont systemFontOfSize:14];
    CGRect titleRect = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH - 40, titleHeight);
    
    NSMutableArray *childArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        ChildTopicVC *vc = [[ChildTopicVC alloc] init];
        vc.parentId = [self.dataSource[i] secondTopicID];
        [titleArr addObject:[self.dataSource[i] title]];
        DDWeakSelf;
        vc.selectTopicBlock = ^(FriendTopicModel * _Nonnull topicModel) {
            if (weakself.selectTopicBlock) {
                weakself.selectTopicBlock(topicModel);
            }
        };
        [childArr addObject:vc];
    }
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:titleRect delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    CGRect contentRect = CGRectMake(0, titleHeight + NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - titleHeight);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:contentRect parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    _pageContentScrollView.isAnimated = YES;
    
    //下拉框按钮
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.backgroundColor = UIColor.whiteColor;
    moreBtn.layer.shadowColor = RGBA(0, 0, 0, 0.5).CGColor;
    moreBtn.layer.shadowOffset = CGSizeMake(-1, 0);
    moreBtn.layer.shadowOpacity = 1.0f;
    moreBtn.frame = CGRectMake(self.pageTitleView.right, self.pageTitleView.top, 40, 35);
    [moreBtn setImage:[UIImage imageNamed:@"pf_down"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(pullMenu:) forControlEvents:UIControlEventTouchUpInside];;
    [self.view addSubview:moreBtn];
    [moreBtn addBorderView:HEXColor(@"#f1f1f1", 1) width:0.8 direction:BorderDirectionBottom];
    _moreBtn = moreBtn;
    
    _pullDownView = [[PullDownTopicView alloc] init];
    _pullDownView.frame = CGRectMake(0, self.pageTitleView.bottom,SCREEN_WIDTH ,SCREEN_HEIGHT - self.pageTitleView.bottom);
    _pullDownView.dataSource = [self.dataSource copy];
    _pullDownView.height = ceil(@(self.dataSource.count).floatValue / 4.0) * 40 + 10;
    _pullDownView.selectIndex = 0;
    DDWeakSelf;
    _pullDownView.selectedIndexBlock = ^(NSInteger index) {
        [weakself.pageContentScrollView setPageContentScrollViewCurrentIndex:index];
        weakself.pageTitleView.resetSelectedIndex = index;
        weakself.pullDownView.selectIndex = index;
        [weakself.pullDownView reloadData];
        [weakself.pullDownView pullClose];
        [weakself pullMenu:weakself.moreBtn];
    };
    _pullDownView.closeBlock = ^{
        UIImage *imgDown = [UIImage imageNamed:@"pf_down"];
        UIImage *imgUp = [UIImage imageNamed:@"pf_up"];
        [weakself.moreBtn setImage:weakself.pullDownView.hidden == YES ? imgUp : imgDown forState:UIControlStateNormal];
    };
    [self.view addSubview:_pullDownView];
}

- (void)pullMenu:(UIButton *)sender {
    
    UIImage *imgDown = [UIImage imageNamed:@"pf_down"];
    UIImage *imgUp = [UIImage imageNamed:@"pf_up"];
    [sender setImage:_pullDownView.hidden == YES ? imgUp : imgDown forState:UIControlStateNormal];
    [_pullDownView pullAction];
}

- (void)requestFirstTopicList {
    NSString *urlString = [URL_Get_Topic_List stringByAppendingString:@"&level=1"];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.dataSource = [FriendTopicModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (weakself.dataSource.count > 0) {
                [weakself setupUI];
            }
            
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
    _pullDownView.selectIndex = selectedIndex;
    [_pullDownView pullClose];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    _pullDownView.selectIndex = targetIndex;
}

- (void)pageContentScrollViewWillBeginDragging {
    _pageTitleView.userInteractionEnabled = NO;
}

- (void)pageContentScrollViewDidEndDecelerating {
    _pageTitleView.userInteractionEnabled = YES;
}


@end
