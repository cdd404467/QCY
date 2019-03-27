//
//  VoteDetailVC.m
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "VoteDetailVC.h"
#import "MacroHeader.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "ClassTool.h"
#import <YNPageViewController.h>
#import "VoteDetailHeaderView.h"
#import "ContestantsVC.h"
#import "ApplyForJoinVC.h"
#import "ActivityRulesVC.h"
#import "VoteModel.h"
#import <UIView+YNPageExtend.h>
#import <MJRefresh.h>
#import <WXApi.h>
#import "UIViewController+BarButton.h"


@interface VoteDetailVC ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>
@property (nonatomic, strong)VoteModel *dataSource;
@property (nonatomic, strong)VoteDetailHeaderView *headerView;
@end

@implementation VoteDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"vote_header_refresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataAdd) name:@"vote_header_add" object:nil];
    [self requestData:YES];
}

- (void)setNavBar {
    self.title = [NSString stringWithFormat:@"%@%@",_pageTitle,_pageTitle];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    if([WXApi isWXAppInstalled]) {//判断用户是否已安装微信App
        [self addRightBarButtonItemWithTitle:@"分享" action:@selector(share)];
    }
}

#pragma mark - 分享
- (void)share {
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    if isRightData(_dataSource.banner) {
        [imageArray addObject:ImgStr(_dataSource.banner)];
    } else {
        [imageArray addObject:Logo];
    }
    NSString *shareStr = [NSString stringWithFormat:@"http://%@.i7colors.com/groupBuyMobile/openApp/voteList.html?id=%@",ShareString,_detailID];
    NSString *text = @"正能量 新征程 共同见证 ! 没有绝代风采，不会甜言蜜语,你的一小票，我们的一大步。";
    [ClassTool shareSomething:imageArray urlStr:shareStr title:_pageTitle text:text];
}


- (void)requestData:(BOOL)isFirst {
    NSString *urlString = [NSString stringWithFormat:URL_Vote_Detail,_detailID];
    DDWeakSelf;
   
//    [CddHUD show:self.view];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//        [CddHUD hideHUD:weakself.view];
//                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.dataSource = [VoteModel mj_objectWithKeyValues:json[@"data"]];
            weakself.dataSource.ruleList = [RuleListModel mj_objectArrayWithKeyValuesArray:weakself.dataSource.ruleList];
            if (isFirst == YES) {
                [weakself setupPageVC];
            } else {
                weakself.headerView.model = weakself.dataSource;
            }
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        
    }];
}


//刷新数据
- (void)refreshData {
    [self requestData:NO];
}

- (void)refreshDataAdd {
    NSInteger joinNum = [_dataSource.joinNum integerValue];
    joinNum ++;
    _dataSource.joinNum = @(joinNum).stringValue;
    _headerView.voteLab.text = _dataSource.joinNum;
//    _headerView.model = _dataSource;
}

- (void)setupPageVC {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTopPause;
    configration.headerViewCouldScale = YES;
    /// 控制tabbar 和 nav
    configration.showTabbar = NO;
    configration.showNavigation = YES;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = YES;
    configration.scrollViewBackgroundColor = View_Color;
    configration.normalItemColor = [UIColor blackColor];
    configration.selectedItemColor = MainColor;
    configration.lineColor = MainColor;
    configration.itemFont = [UIFont systemFontOfSize:15];
    configration.selectedItemFont = [UIFont boldSystemFontOfSize:15];
    
    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = 0;
   
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;
    
    VoteDetailHeaderView *header = [[VoteDetailHeaderView alloc] init];
    header.model = _dataSource;
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, floor(KFit_W(144)) + 80);
    vc.headerView = header;
    _headerView = header;
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    
    
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    vc.view.yn_y = NAV_HEIGHT;
//    vc.view.yn_height = SCREEN_HEIGHT;
//    DDWeakSelf;
//    vc.bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakself refreshData];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"vote_refresh_first" object:nil];
//    }];
    
//    [self.view addSubview:self.nav];
}

//控制器数组
- (NSArray *)getArrayVCs {
    ContestantsVC *vc_1 = [[ContestantsVC alloc] init];
    vc_1.voteID = _detailID;
    vc_1.voteName = _pageTitle;
//    ApplyForJoinVC *vc_2 = [[ApplyForJoinVC alloc] init];
//    vc_2.voteID = _detailID;
//    vc_2.endCode = _endCode;
    ActivityRulesVC *vc_3 = [[ActivityRulesVC alloc] init];
    vc_3.dataSource = _dataSource;
//    return @[vc_1, vc_2, vc_3];
    return @[vc_1, vc_3];
}

- (NSArray *)getArrayTitles {
//    return @[@"当前排名",@"申请参与",@"活动规则"];
    return @[@"当前排名",@"活动规则"];
}

- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[ContestantsVC class]]) {
        return [(ContestantsVC *)vc tableView];
    }
//    else if ([vc isKindOfClass:[ApplyForJoinVC class]]) {
//        return [(ApplyForJoinVC *)vc tableView];
//    }
    else {
        return [(ActivityRulesVC *)vc tableView];
    }
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
