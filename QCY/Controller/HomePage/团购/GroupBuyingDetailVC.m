//
//  GroupBuyingDetailVC.m
//  QCY
//
//  Created by i7colors on 2018/11/2.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GroupBuyingDetailVC.h"
#import "CommonNav.h"
#import "MacroHeader.h"
#import "MacroHeader.h"
#import <Masonry.h>
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

@interface GroupBuyingDetailVC ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>

@property (nonatomic, strong)GroupBuyingModel *dataSource;
@property (nonatomic, strong)CommonNav *nav;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)CGFloat tbHeight;
@end



@implementation GroupBuyingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
  
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (CommonNav *)nav {
    if (!_nav) {
        _nav = [[CommonNav alloc] init];
        _nav.titleLabel.text = @"团购详情";
//        _nav.bottomLine.hidden = YES;
//        _nav.titleLabel.textColor = RGBA(0, 0, 0, 0);
        [_nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nav;
}


- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URL_GroupBuy_Detail,_groupID];
    
    [CddHUD show];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.dataSource = [GroupBuyingModel mj_objectWithKeyValues:json[@"data"]];
            [weakself setupUI];
        }
        [CddHUD hideHUD];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        
    }];
}

- (void)setupUI {
    
    if ([_dataSource.endCode isEqualToString:@"10"] || [_dataSource.endCode isEqualToString:@"11"]) {
        _tbHeight = SCREEN_HEIGHT - TABBAR_HEIGHT - NAV_HEIGHT - 49;
    } else {
        _tbHeight = SCREEN_HEIGHT - TABBAR_HEIGHT - NAV_HEIGHT;
    }
    
    [self setupPageVC];
    
    if ([_dataSource.endCode isEqualToString:@"10"] || [_dataSource.endCode isEqualToString:@"11"]) {
        UIButton *btn = [self addBottonBtn];
        [btn setTitle:@"我要团购" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(jumpToBuy) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (UIButton *)addBottonBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
//    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 3);
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
    [ClassTool addLayer:btn];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
    
    return btn;
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
    
    //    configration.showBottomLine = YES;
    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = NAV_HEIGHT;
    
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;
    
    GroupBuyDetailHeaderView *header = [[GroupBuyDetailHeaderView alloc] initWithDataSource:_dataSource];
    header.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, KFit_W(250) + 120 + self.originHeight);
    vc.headerView = header;
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    
    
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    
    [self.view addSubview:self.nav];
    /// 如果隐藏了导航条可以 适当改y值
    //    pageVC.view.yn_y = kYNPAGE_NAVHEIGHT;
    
}

//控制器数组
- (NSArray *)getArrayVCs {
    BaseParameterVC *vc_1 = [[BaseParameterVC alloc] init];
    vc_1.cellImage = _dataSource.detailMobilePic;
    GroupBuyNeedKnowVC *vc_2 = [[GroupBuyNeedKnowVC alloc] init];
    vc_2.cellImage = _dataSource.noteMobilePic;
    GroupBuyRecordVC *vc_3 = [[GroupBuyRecordVC alloc] init];
    vc_3.groupID = _groupID;
    
    vc_1.tbHeight = _tbHeight;
    vc_2.tbHeight = _tbHeight;
    vc_3.tbHeight = _tbHeight;
    
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
    GoToGroupBuyVC *vc = [[GoToGroupBuyVC alloc] init];
    vc.groupID = _groupID;
    vc.numUnit = _dataSource.numUnit;
    vc.minNum = _dataSource.minNum;
    vc.maxNum = _dataSource.maxNum;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
