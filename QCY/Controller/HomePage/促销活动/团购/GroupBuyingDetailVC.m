//
//  GroupBuyingDetailVC.m
//  QCY
//
//  Created by i7colors on 2018/11/2.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GroupBuyingDetailVC.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "ClassTool.h"
#import "GroupBuyDetailHeaderView.h"
#import <YNPageViewController.h>
#import "BaseParameterVC.h"
#import "GroupBuyNeedKnowVC.h"
#import "GroupBuyRecordVC.h"
#import "GroupBuyingModel.h"
#import "GoToGroupBuyVC.h"
#import "UIView+YNPageExtend.h"
#import <UMAnalytics/MobClick.h>
#import "BargainAlertView.h"

@interface GroupBuyingDetailVC ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>

@property (nonatomic, strong)GroupBuyingModel *dataSource;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) UIButton *clickBtn;
@property (nonatomic, strong) UIButton *notClickBtn;
@end

@implementation GroupBuyingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"团购详情";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupBuySuc) name:@"groupBuySuc" object:nil];
    [self requestData:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@-%@",self.title,_productName]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithFormat:@"%@-%@",self.title,_productName]];
}

- (UIButton *)clickBtn {
    if (!_clickBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.frame = CGRectMake(0, SCREEN_HEIGHT - Bottom_Height_Dif - 49, SCREEN_WIDTH, 49);
        [ClassTool addLayer:btn];
        _clickBtn = btn;
    }
    
    return _clickBtn;
}

- (UIButton *)notClickBtn {
    if (!_notClickBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn setTitle:@"已参团" forState:UIControlStateNormal];
        btn.enabled = NO;
        btn.backgroundColor = HEXColor(@"#868686", 1);
        btn.frame = CGRectMake(0, SCREEN_HEIGHT - Bottom_Height_Dif - 49, SCREEN_WIDTH, 49);
        _notClickBtn = btn;
    }
    
    return _notClickBtn;
}

//分享
- (void)share {
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    [imageArray addObject:ImgStr(_dataSource.productPic)];
    NSString *shareStr = [NSString stringWithFormat:@"http://%@.i7colors.com/groupBuyMobile/openApp/cut.html?mainId=%@&buyerId=%@",ShareString,_dataSource.groupID,_dataSource.buyerId];
    
    NSString *text = [NSString stringWithFormat:@"亲们帮帮忙,我正在参与七彩云电商\"%@\"砍价活动",_dataSource.productName];
    [ClassTool shareSomething:imageArray urlStr:shareStr title:@"【团购砍价】" text:text];
}

//团购成功回调
- (void)groupBuySuc {
    [self requestData:YES];
    DDWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            BargainAlertView *alert = [[BargainAlertView alloc] init];
            alert.shareBlock = ^{
                [weakself share];
            };
            [[[UIApplication sharedApplication] keyWindow] addSubview:alert];
        });
    });
}

- (void)requestData:(BOOL)isRefresh {
    NSString *urlString = [NSString stringWithFormat:URL_GroupBuy_Detail,_groupID,User_Token];
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.dataSource = [GroupBuyingModel mj_objectWithKeyValues:json[@"data"]];
            if (!isRefresh) {
                [weakself setupPageVC];
            }
            [weakself.view addSubview:weakself.notClickBtn];
            [weakself.view addSubview:weakself.clickBtn];
            [weakself setBtnState];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (void)setBtnState {
    [self.clickBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    //进行中的团购
    if ([_dataSource.endCode isEqualToString:@"10"]) {
        self.notClickBtn.hidden = NO;
        self.clickBtn.hidden = NO;
        //如果登陆了
        if (GET_USER_TOKEN) {
            //用户参与过团购了
            if ([_dataSource.loginUserHasBuy integerValue] == 1) {
                //这个团购可以砍价
                if ([_dataSource.isCutPrice integerValue] == 1) {
                    self.notClickBtn.width = SCREEN_WIDTH / 4;
                    self.clickBtn.left = SCREEN_WIDTH / 4;
                    self.clickBtn.width = SCREEN_WIDTH / 4 * 3;
                    [self.clickBtn setTitle:@"分享砍价" forState:UIControlStateNormal];
                    [self.clickBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
                }
                //这个团购不能砍价
                else {
                    self.notClickBtn.width = SCREEN_WIDTH;
                    self.clickBtn.hidden = YES;
                }
            }
            //没参与过，显示我要团购
            else {
                self.notClickBtn.width = 0;
                self.clickBtn.left = 0;
                self.clickBtn.width = SCREEN_WIDTH;
                [self.clickBtn setTitle:@"我要团购" forState:UIControlStateNormal];
                [self.clickBtn addTarget:self action:@selector(jumpToBuy) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        //没登录
        else {
            self.notClickBtn.width = 0;
            self.clickBtn.left = 0;
            self.clickBtn.width = SCREEN_WIDTH;
            [self.clickBtn setTitle:@"我要团购" forState:UIControlStateNormal];
            [self.clickBtn addTarget:self action:@selector(jumpToBuy) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //已结束
    else {
        self.notClickBtn.hidden = YES;
        self.clickBtn.hidden = YES;
        self.notClickBtn.width = 0;
        self.clickBtn.width = 0;
    }
}


- (void)setupPageVC {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTopPause;
    configration.headerViewCouldScale = YES;
    /// 控制tabbar 和 nav
    configration.showTabbar = NO;
    configration.showNavigation = NO;
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
    configration.suspenOffsetY = NAV_HEIGHT;
    
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;
    
    GroupBuyDetailHeaderView *header = [[GroupBuyDetailHeaderView alloc] initWithDataSource:_dataSource];
    if ([_dataSource.isCutPrice integerValue] == 1) {
        header.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, floor(KFit_W(250)) + 190 + NAV_HEIGHT);
    } else {
        header.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, floor(KFit_W(250)) + 120 + NAV_HEIGHT);
    }
    
    vc.headerView = header;
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    
    
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    
    if ([_dataSource.endCode isEqualToString:@"10"]) {
        configration.cutOutHeight = TABBAR_HEIGHT;
    }
    
}

//控制器数组
- (NSArray *)getArrayVCs {
    BaseParameterVC *vc_1 = [[BaseParameterVC alloc] init];
    vc_1.cellImage = _dataSource.detailMobilePic;
    GroupBuyNeedKnowVC *vc_2 = [[GroupBuyNeedKnowVC alloc] init];
    vc_2.cellImage = _dataSource.noteMobilePic;
    GroupBuyRecordVC *vc_3 = [[GroupBuyRecordVC alloc] init];
    vc_3.groupID = _groupID;
    vc_3.layoutStr = _dataSource.endCode;
    vc_3.titleArray = @[@"序号",@"公司名称",@"联系方式",@"认领量"];
    vc_3.type = @"group";
    
    return @[vc_1, vc_2, vc_3];
}

- (NSArray *)getArrayTitles {
    return @[@"基本参数", @"团购须知", @"团购记录"];
}


- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    //    NSLog(@"--- contentOffset = %f, progress = %f", contentOffset, progress);
    
//    _nav.backgroundColor = HEXColor(@"ffffff", progress);
//    _nav.titleLabel.textColor = RGBA(0, 0, 0, progress);
}

- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[BaseParameterVC class]]) {
        return [(BaseParameterVC *)vc tableView];
    } else if ([vc isKindOfClass:[GroupBuyNeedKnowVC class]]) {
        return [(GroupBuyNeedKnowVC *)vc tableView];
    } else {
        return [(GroupBuyRecordVC *)vc tableView];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)jumpToBuy {
    if (!GET_USER_TOKEN) {
        DDWeakSelf;
        [self jumpToLoginWithComplete:^{
            [weakself requestData:YES];
        }];
        return;
    }
    GoToGroupBuyVC *vc = [[GoToGroupBuyVC alloc] init];
    vc.groupID = _groupID;
    vc.numUnit = _dataSource.numUnit;
    vc.minNum = _dataSource.minNum;
    vc.maxNum = _dataSource.maxNum;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
