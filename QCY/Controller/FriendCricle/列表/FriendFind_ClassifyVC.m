//
//  FriendFind_ClassifyVC.m
//  QCY
//
//  Created by i7colors on 2019/4/19.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FriendFind_ClassifyVC.h"
#import "NetWorkingPort.h"
#import "FriendHeaderView.h"
#import "FriendCircleVC.h"
#import "ClassTool.h"
#import "FriendCricleModel.h"
#import "HelperTool.h"
#import "MyFriendCircleInfoVC.h"
#import <SGPagingView.h>
#import "PullDownTopicView.h"
#import "UIView+Border.h"


#define HeaderHeight (56 + 35)
#define TBHeight (SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT - HeaderHeight)

@interface FriendFind_ClassifyVC ()

@end

@interface FriendFind_ClassifyVC ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>
@property (nonatomic, strong)FriendCricleInfoModel *myInfoDataSource;
@property (nonatomic, strong)NSMutableArray *topicDataSource;
@property (nonatomic, strong)FriendHeaderView *headerView;
@property (nonatomic, strong) SGPageTitleView *pageTitleView;   //标题
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;   //文本
@property (nonatomic, strong)PullDownTopicView *pullDownView;
@property (nonatomic, strong)UIButton *moreBtn;

@end

@implementation FriendFind_ClassifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    //修改头像或昵称监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo:) name:@"changeFCInfo" object:nil];
    NSString *nfcNameAll = @"refreshAllDataWithThis";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshIfo) name:nfcNameAll object:nil];
    
}

- (NSMutableArray *)topicDataSource {
    if (!_topicDataSource) {
        _topicDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _topicDataSource;
}


- (void)setupUI {
    if (self.topicDataSource.count == 0) return;
        
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
    CGRect titleRect = CGRectMake(0, self.headerView.bottom, SCREEN_WIDTH - 40, titleHeight);
    
    NSMutableArray *childArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < self.topicDataSource.count; i++) {
        FriendCircleVC *vc = [[FriendCircleVC alloc] init];
        vc.firstTopicID = [self.topicDataSource[i] secondTopicID];
        vc.type = @"topic";
        vc.tbFrame = CGRectMake(0, 0, SCREEN_WIDTH, TBHeight);
        vc.secondTopicID = @"";
        vc.firstType = @"find";
        [titleArr addObject:[self.topicDataSource[i] title]];
        [childArr addObject:vc];
    }
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:titleRect delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    CGRect contentRect = CGRectMake(0, titleHeight + self.headerView.height, SCREEN_WIDTH, SCREEN_HEIGHT - titleHeight);
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
    _pullDownView.dataSource = [self.topicDataSource copy];
    _pullDownView.height = ceil(@(self.topicDataSource.count).floatValue / 4.0) * 40 + 10;
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

//改变头像的通知方法
- (void)changeInfo:(NSNotification *)notification {
    //头像
    if ([notification.object isEqualToString:@"header"]) {
        if isRightData(notification.userInfo[@"fcDict"]) {
            NSURL *header = notification.userInfo[@"fcDict"];
            _myInfoDataSource.communityPhoto = To_String(header);
        }
    } else if ([notification.object isEqualToString:@"nickName"]) {
        _myInfoDataSource.nickName = notification.userInfo[@"fcDict"];
    }
    
    _headerView.model = _myInfoDataSource;
}

- (FriendHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FriendHeaderView alloc] init];
        if (GET_USER_TOKEN) {
            _headerView.model = self.myInfoDataSource;
            _headerView.noLoginLabel.hidden = YES;
        } else {
            _headerView.noLoginLabel.hidden = NO;
        }
        [HelperTool addTapGesture:_headerView withTarget:self andSEL:@selector(jumpToMyInfo)];
    }
    return _headerView;
}

- (void)pullMenu:(UIButton *)sender {
    NSString *notiName = @"hiddenKeyBoard";
    [[NSNotificationCenter defaultCenter]postNotificationName:notiName object:nil userInfo:nil];
    UIImage *imgDown = [UIImage imageNamed:@"pf_down"];
    UIImage *imgUp = [UIImage imageNamed:@"pf_up"];
    [sender setImage:_pullDownView.hidden == YES ? imgUp : imgDown forState:UIControlStateNormal];
    [_pullDownView pullAction];
}

//进入我的详情页面
- (void)jumpToMyInfo {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    MyFriendCircleInfoVC *vc = [[MyFriendCircleInfoVC alloc] init];
    vc.ofType = @"mine";
    [self.navigationController pushViewController:vc animated:YES];
}

//获取个人详情
- (void)requestMyInfo:(dispatch_group_t)group {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_Friend_MyInfo,User_Token];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                                NSLog(@"---===- %@",json);
        weakself.myInfoDataSource = [FriendCricleInfoModel mj_objectWithKeyValues:json[@"data"]];
        dispatch_group_leave(group);
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        dispatch_group_leave(group);
    }];
}

- (void)refreshIfo {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_Friend_MyInfo,User_Token];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        //                        NSLog(@"---===- %@",json);
        weakself.myInfoDataSource = [FriendCricleInfoModel mj_objectWithKeyValues:json[@"data"]];
        if (GET_USER_TOKEN) {
            weakself.headerView.model = weakself.myInfoDataSource;
            weakself.headerView.noLoginLabel.hidden = YES;
        } else {
            weakself.headerView.noLoginLabel.hidden = NO;
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        
    }];
}


//获取一级分类
- (void)requestFirstTopicList:(dispatch_group_t)group {
    NSString *urlString = [URL_Get_Topic_List stringByAppendingString:@"&level=1"];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        //                        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.topicDataSource = [FriendTopicModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            FriendTopicModel *model = [[FriendTopicModel alloc] init];
            model.title = @"全部";
            model.secondTopicID = @"no";
            [weakself.topicDataSource insertObject:model atIndex:0];
        }
        dispatch_group_leave(group);
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        dispatch_group_leave(group);
    }];
}

- (void)requestData {
    DDWeakSelf;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    //第一个线程获取详情
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        if (GET_USER_TOKEN) {
            [weakself requestMyInfo:group];
        } else {
            dispatch_group_leave(group);
        }
    });
    
    //第二个线程，获取列表
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        [weakself requestFirstTopicList:group];
    });
    
    //全部任务完成后，就可以在这吊了
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.view addSubview:weakself.headerView];
            weakself.headerView.model = weakself.myInfoDataSource;
            [weakself setupUI];
            NSString *notiName = @"FC_Uread_Msg_message";
            [[NSNotificationCenter defaultCenter]postNotificationName:notiName object:nil userInfo:nil];
        });
    });
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
    NSString *notiName = @"hiddenKeyBoard";
    [[NSNotificationCenter defaultCenter]postNotificationName:notiName object:nil userInfo:nil];
    _pullDownView.selectIndex = selectedIndex;
    [_pullDownView pullClose];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
    _pullDownView.selectIndex = targetIndex;
}

- (void)pageContentScrollViewWillBeginDragging {
    _pageTitleView.userInteractionEnabled = NO;
    NSString *notiName = @"hiddenKeyBoard";
    [[NSNotificationCenter defaultCenter]postNotificationName:notiName object:nil userInfo:nil];
}

- (void)pageContentScrollViewDidEndDecelerating {
    _pageTitleView.userInteractionEnabled = YES;
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
