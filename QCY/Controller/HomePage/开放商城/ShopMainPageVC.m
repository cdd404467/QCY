//
//  ShopMainPageVC.m
//  QCY
//
//  Created by i7colors on 2018/10/30.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ShopMainPageVC.h"
#import "CommonNav.h"
#import "MacroHeader.h"
#import "ShopMainPageHeaderView.h"
#import <YNPageViewController.h>
#import "AllProductsVC.h"
#import "CompanyInfoVC.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "OpenMallModel.h"

@interface ShopMainPageVC ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>

@property (nonatomic, strong)CommonNav *nav;
@property (nonatomic, assign)int page;
@property (nonatomic, copy)NSArray *tempArr;
@property (nonatomic, strong)OpenMallModel *firstDateSource;
@property (nonatomic, strong)NSMutableArray *secondDataSource;
@end

@implementation ShopMainPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺主页";
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    _page = 1;
    [self.view addSubview:self.nav];
    [self requestData];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (CommonNav *)nav {
    if (!_nav) {
        _nav = [[CommonNav alloc] init];
        _nav.titleLabel.text = @"店铺主页";
        _nav.bottomLine.hidden = YES;
        _nav.backgroundColor = HEXColor(@"ffffff", 0);
        _nav.titleLabel.textColor = RGBA(0, 0, 0, 0);
        [_nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nav;
}

//初始化数据源
- (NSMutableArray *)secondDataSource {
    if (!_secondDataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _secondDataSource = mArr;
    }
    return _secondDataSource;
}

#pragma mark - 网络请求
- (void)requestData {
    DDWeakSelf;
    [CddHUD show:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    //第一个线程获取列表
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Shop_Product_List,weakself.page,Page_Count,weakself.storeID];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                weakself.tempArr  = [ProductInfoModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [weakself.secondDataSource addObjectsFromArray:weakself.tempArr];
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            NSLog(@" Error : %@",error);
            dispatch_group_leave(group);
        }];
    });
    
    //第二个线程，获取详情
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Shop_Info,weakself.storeID];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//            NSLog(@"---- %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                weakself.firstDateSource = [OpenMallModel mj_objectWithKeyValues:json[@"data"]];
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            NSLog(@" Error : %@",error);
            dispatch_group_leave(group);
        }];
    });
    
    //全部任务完成后，就可以在这吊了
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself setupPageVC];
            [CddHUD hideHUD:weakself.view];
        });
    });
}

- (void)setupPageVC {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTopPause;
    configration.headerViewCouldScale = YES;
//    /// 控制tabbar 和 nav
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

////    configration.showBottomLine = YES;
//    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = NAV_HEIGHT;
//
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;
//
    ShopMainPageHeaderView *header = [[ShopMainPageHeaderView alloc] init];
    [header setupUI:_firstDateSource.creditLevel model:_firstDateSource];
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, floor(KFit_H(210)) + 50);
    
    vc.headerView = header;
//    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    
    [_nav removeFromSuperview];
    [self.view addSubview:self.nav];
    
    /// 如果隐藏了导航条可以 适当改y值
    //    pageVC.view.yn_y = kYNPAGE_NAVHEIGHT;

}


- (NSArray *)getArrayVCs {
    
    AllProductsVC *vc_1 = [[AllProductsVC alloc] init];
    vc_1.dataSource = _secondDataSource;
    vc_1.storeID = _storeID;
    vc_1.tempArr = _tempArr;
//
    CompanyInfoVC *vc_2 = [[CompanyInfoVC alloc] init];
    vc_2.companyDesc = _firstDateSource.descriptionStr;
    
    return @[vc_1, vc_2];
}

- (NSArray *)getArrayTitles {
    return @[@"全部商品", @"公司简介"];
}

- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[AllProductsVC class]]) {
        return [(AllProductsVC *)vc tableView];
    } else {
        return [(CompanyInfoVC *)vc tableView];
    }
    
}

- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
//    NSLog(@"--- contentOffset = %f, progress = %f", contentOffset, progress);
    
    _nav.backgroundColor = HEXColor(@"ffffff", progress);
    _nav.titleLabel.textColor = RGBA(0, 0, 0, progress);
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}



@end




