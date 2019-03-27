//
//  DiscountSalesDetailVC.m
//  QCY
//
//  Created by i7colors on 2019/1/16.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "DiscountSalesDetailVC.h"
#import "MacroHeader.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "ClassTool.h"
#import "DiscountSalesModel.h"
#import <YNPageViewController.h>
#import "DiscountSalesDetailHV.h"
#import "GroupBuyRecordVC.h"
#import <Masonry.h>
#import "DiscountBuyVC.h"
#import "BaseParameterTextVC.h"

@interface DiscountSalesDetailVC ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>
@property (nonatomic, strong)DiscountSalesModel *dataSource;
@end

@implementation DiscountSalesDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"展销详情";
    
    [self requestData];
}



- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URL_DisCount_Sales_Detail,_productID];
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.dataSource = [DiscountSalesModel mj_objectWithKeyValues:json[@"data"]];
            weakself.dataSource.listPrice = [ListPrice mj_objectArrayWithKeyValuesArray:weakself.dataSource.listPrice];
            weakself.dataSource.listSale = [listSaleModel mj_objectArrayWithKeyValuesArray:weakself.dataSource.listSale];
            [weakself setupPageVC];
        }
        
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        
    }];
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
    configration.cutOutHeight = TABBAR_HEIGHT;
    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = NAV_HEIGHT;
    
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;
    
    DiscountSalesDetailHV *header = [[DiscountSalesDetailHV alloc] init];
    header.dataSource = _dataSource;
    header.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, floor(KFit_W(250)) + 150 + NAV_HEIGHT);
    vc.headerView = header;
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    
    
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    
    //底部按钮
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setTitle:@"我要购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(iwillBuy) forControlEvents:UIControlEventTouchUpInside];
    [ClassTool addLayer:buyBtn];
    [self.view addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
}

//控制器数组
- (NSArray *)getArrayVCs {
    BaseParameterTextVC *vc_1 = [[BaseParameterTextVC alloc] init];
    vc_1.dataSource = _dataSource.listSale;
    GroupBuyRecordVC *vc_2 = [[GroupBuyRecordVC alloc] init];
    vc_2.groupID = _productID;
    vc_2.titleArray = @[@"序号",@"公司名称",@"联系方式",@"购买量"];
    vc_2.type = @"sales";
    return @[vc_1, vc_2];
}

- (NSArray *)getArrayTitles {
    return @[@"基本参数", @"购买记录"];
}

- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[BaseParameterTextVC class]]) {
        return [(BaseParameterTextVC *)vc tableView];
    } else {
        return [(GroupBuyRecordVC *)vc tableView];
    }
      
}

- (void)iwillBuy {
    DiscountBuyVC *vc = [[DiscountBuyVC alloc] init];
    vc.productID = _productID;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
