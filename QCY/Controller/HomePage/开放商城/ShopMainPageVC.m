//
//  ShopMainPageVC.m
//  QCY
//
//  Created by i7colors on 2018/10/30.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ShopMainPageVC.h"
#import "ShopMainPageHeaderView.h"
#import <YNPageViewController.h>
#import "AllProductsVC.h"
#import "CompanyInfoVC.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "OpenMallModel.h"
#import <WXApi.h>
#import "NavControllerSet.h"
#import "CheckForBusinessVC.h"


@interface ShopMainPageVC ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>

@property (nonatomic, assign)int page;
@property (nonatomic, strong)OpenMallModel *firstDateSource;
@property (nonatomic, strong)NSMutableArray *secondDataSource;
@property (nonatomic, assign)int totalNum;
@end

@implementation ShopMainPageVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"店铺主页";
    [self setNavBar];
    [self requestData];
    
}

- (void)setNavBar {
    if([WXApi isWXAppInstalled]) {//判断用户是否已安装微信App
        [self addRightBarButtonItemWithTitle:@"分享" action:@selector(share)];
    }
    
}

//初始化数据源
- (NSMutableArray *)secondDataSource {
    if (!_secondDataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _secondDataSource = mArr;
    }
    return _secondDataSource;
}

- (void)share{
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    if isRightData(_firstDateSource.logo) {
        [imageArray addObject:ImgStr(_firstDateSource.logo)];
    } else {
        [imageArray addObject:Logo];
    }
    
    NSString *shareStr = [NSString stringWithFormat:@"http://%@.i7colors.com/groupBuyMobile/openApp/preferredShop.html?id=%@",ShareString,_storeID];
    NSString *text = [NSString string];
    if isRightData(_firstDateSource.descriptionStr) {
        text = _firstDateSource.descriptionStr;
    } else {
        text = @"暂无介绍";
    }
    [ClassTool shareSomething:imageArray urlStr:shareStr title:_firstDateSource.companyName text:text];
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
//            NSLog(@"----aaaa     %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"] && isRightData(To_String(json[@"data"]))) {
                weakself.totalNum = [json[@"totalCount"] intValue];
                NSArray *tempArr  = [ProductInfoModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [weakself.secondDataSource addObjectsFromArray:tempArr];
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
//                        NSLog(@"----bbbb  %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                weakself.firstDateSource = [OpenMallModel mj_objectWithKeyValues:json[@"data"]];
                weakself.firstDateSource.businessList = [BusinessList mj_objectArrayWithKeyValuesArray:weakself.firstDateSource.businessList];
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
    
    ////    configration.showBottomLine = YES;
    //    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = 0;
    //
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;
    
    //
    ShopMainPageHeaderView *header = [[ShopMainPageHeaderView alloc] init];
    DDWeakSelf
    header.jumpToCheckBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!GET_USER_TOKEN) {
                [self jumpToLogin];
                return ;
            }
            
            CheckForBusinessVC *vc = [[CheckForBusinessVC alloc] init];
            vc.imgUrl = weakself.firstDateSource.busInformation;
            [weakself.navigationController pushViewController:vc animated:YES];
        });
    };
    [header setupUI:_firstDateSource.creditLevel model:_firstDateSource];
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, floor(KFit_W(210)) + 50);
    vc.headerView = header;
    //    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    vc.view.top = NAV_HEIGHT;
    //    [_nav removeFromSuperview];
    //    [self.view addSubview:self.nav];
    
    /// 如果隐藏了导航条可以 适当改y值
    //    pageVC.view.yn_y = kYNPAGE_NAVHEIGHT;
    
}


- (NSArray *)getArrayVCs {
    
    AllProductsVC *vc_1 = [[AllProductsVC alloc] init];
    vc_1.dataSource = _secondDataSource;
    vc_1.storeID = _storeID;
    vc_1.totalNum = _totalNum;
    CompanyInfoVC *vc_2 = [[CompanyInfoVC alloc] init];
    vc_2.navModel = _navModel;
    vc_2.dataSource = _firstDateSource;
    
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
    
    //    NSLog(@"--- contentOffset = %f, progress = %f", contentOffset, progress);
//    [self vhl_setNavBarBackgroundAlpha:progress];
//    [self vhl_setNavBarTitleColor:RGBA(0, 0, 0, progress)];
//    if (progress == 1.0) {
//        [self vhl_setNavBarShadowImageHidden:NO];
//    } else {
//        [self vhl_setNavBarShadowImageHidden:YES];
//    }
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end




