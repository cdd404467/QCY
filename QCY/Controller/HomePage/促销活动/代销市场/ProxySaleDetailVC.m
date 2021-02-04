//
//  ProxySaleDetailVC.m
//  QCY
//
//  Created by i7colors on 2020/3/24.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProxySaleDetailVC.h"
#import <YNPageViewController.h>
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "ProxySaleDetailHV.h"
#import "ProxySaleModel.h"
#import "BaseParameterTextVC.h"
#import "ProxySaleModel.h"
#import "AskForDemoVC.h"
#import "AuctionRulesVC.h"
#import <WXApi.h>

@interface ProxySaleDetailVC ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>
@property (nonatomic, strong)ProxySaleDetailHV *headerView;
@property (nonatomic, strong)ProxySaleModel *dataSource;

@end

@implementation ProxySaleDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代销详情";
    
    
    [self requestData];
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URLGet_ProxtSale_Detail,_proxyID];
    DDWeakSelf;
//    [CddHUD show:self.view];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//        [CddHUD hideHUD:weakself.view];
//                NSLog(@"json---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.dataSource = [ProxySaleModel mj_objectWithKeyValues:json[@"data"]];
            weakself.dataSource.dictMap = [DictMapModel mj_objectArrayWithKeyValuesArray:weakself.dataSource.dictMap];
            [weakself setupPageVC];
            if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
                [self addRightBarButtonItemWithTitle:@"分享" action:@selector(share)];
            }
        }
        
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        
    }];
}

#pragma mark - 分享
- (void)share {
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    if isRightData(_dataSource.productPic) {
        [imageArray addObject:ImgStr(_dataSource.productPic)];
    } else {
        [imageArray addObject:Logo];
    }
    NSString *shareStr = [NSString stringWithFormat:@"http://%@.i7colors.com/groupBuyMobile/openApp/consignment.html?id=%@",ShareString,_proxyID];
    NSString *text = @"代销市场,一大波便宜又丰富的产品正等你拿！！！";
    NSString *title = [NSString stringWithFormat:@"【产品】%@",_dataSource.productName];
    [ClassTool shareSomething:imageArray urlStr:shareStr title:title text:text];
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
    
    ProxySaleDetailHV *header = [[ProxySaleDetailHV alloc] init];
    header.dataSource = _dataSource;
    header.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, floor(header.viewHeight));
    vc.headerView = header;
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    
    //底部按钮
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.tag = 100;
    [buyBtn setTitle:@"我要购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(demoOrBuy:) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.backgroundColor = HEXColor(@"#ED3851", 1);
    [buyBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"#ED3851", 1)] forState:UIControlStateNormal];
    [buyBtn setBackgroundImage:[UIImage imageWithColor:HEXColor(@"#C0C0C0", 1)] forState:UIControlStateDisabled];
//    [ClassTool addLayer:buyBtn];
    [self.view addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH / 2);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
    
    if (_dataSource.remainNum.doubleValue <= 0) {
        buyBtn.enabled = NO;
    }
    
    UIButton *askForBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    askForBtn.tag = 101;
    [askForBtn setTitle:@"申请样品" forState:UIControlStateNormal];
    [askForBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [askForBtn addTarget:self action:@selector(demoOrBuy:) forControlEvents:UIControlEventTouchUpInside];
    askForBtn.backgroundColor = HEXColor(@"#FF771C", 1);
    [self.view addSubview:askForBtn];
    [askForBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(buyBtn.mas_right);
        make.height.width.bottom.mas_equalTo(buyBtn);
    }];
}

- (NSArray *)getArrayTitles {
    return @[@"基本参数", @"代销市场须知"];
}

//控制器数组
- (NSArray *)getArrayVCs {
    BaseParameterTextVC *vc_1 = [[BaseParameterTextVC alloc] init];
    vc_1.dataSource = _dataSource.dictMap;
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];

    for (NSString *text in self.dataSource.noteList) {
        [tempArr addObject:@{@"relatedInstructions":text}];
    }
    tempArr = [RuleModel mj_objectArrayWithKeyValuesArray:tempArr];
    _dataSource.rulesList = [tempArr copy];
    
    AuctionRulesVC *vc_2 = [[AuctionRulesVC alloc] init];
    vc_2.dataSource = _dataSource.rulesList;
    return @[vc_1, vc_2];
}

- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[BaseParameterTextVC class]]) {
        return [(BaseParameterTextVC *)vc tableView];
    } else {
        return [(AuctionRulesVC *)vc tableView];
    }
    
}


- (void)demoOrBuy:(UIButton *)sender {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    AskForDemoVC *vc = [[AskForDemoVC alloc] init];
    vc.dataSource = _dataSource;
    vc.pageType = sender.tag == 100 ? @"buy" : @"demo";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
