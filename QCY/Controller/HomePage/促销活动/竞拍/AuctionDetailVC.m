//
//  AuctionDetailVC.m
//  QCY
//
//  Created by i7colors on 2019/3/6.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AuctionDetailVC.h"
#import "MacroHeader.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "ClassTool.h"
#import <YNPageViewController.h>
#import "AuctionDetailHeader.h"
#import <WXApi.h>
#import "UIView+Geometry.h"
#import "GoodsDescribeVC.h"
#import "AuctionModel.h"
#import "AuctionPriceRecordVC.h"
#import <Masonry.h>
#import "AuctionRulesVC.h"
#import "JoinAuctionVC.h"


@interface AuctionDetailVC ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>
@property (nonatomic, strong)AuctionDetailHeader *headerView;
@property (nonatomic, strong)AuctionModel *dataSource;
@end

@implementation AuctionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"竞拍详情";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshtData) name:@"joinAuctionNFC" object:nil];
    [self requestData];
    
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URL_Auction_Detail,_jpID];
    DDWeakSelf;
//    [CddHUD show:self.view];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//        [CddHUD hideHUD:weakself.view];
//                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.dataSource = [AuctionModel mj_objectWithKeyValues:json[@"data"]];
            weakself.dataSource.attributeList = [AttributeListModel mj_objectArrayWithKeyValuesArray:weakself.dataSource.attributeList];
            weakself.dataSource.instructionsList = [InstructionsListModel mj_objectArrayWithKeyValuesArray:weakself.dataSource.instructionsList];
            weakself.dataSource.detailList = [DetailPcPicModel mj_objectArrayWithKeyValuesArray:weakself.dataSource.detailList];
            weakself.dataSource.videoList = [VideoListModel mj_objectArrayWithKeyValuesArray:weakself.dataSource.videoList];
            [weakself setupPageVC];
            [weakself setupBottomView:weakself.dataSource.isType];
        }
        
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        
    }];
}
//刷新
- (void)refreshtData {
    NSString *urlString = [NSString stringWithFormat:URL_Auction_Detail,_jpID];
    DDWeakSelf;
    //    [CddHUD show:self.view];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        //        [CddHUD hideHUD:weakself.view];
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.dataSource = [AuctionModel mj_objectWithKeyValues:json[@"data"]];
            weakself.headerView.model = weakself.dataSource;
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
    configration.cutOutHeight = TABBAR_HEIGHT;
    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = 0;
    
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;
    
    AuctionDetailHeader *header = [[AuctionDetailHeader alloc] init];
    header.model = _dataSource;
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, floor(header.viewHeight));
    vc.headerView = header;
    _headerView = header;
    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    vc.view.top = NAV_HEIGHT;
//    vc.view.height = SCREEN_HEIGHT - NAV_HEIGHT;
}


//控制器数组
- (NSArray *)getArrayVCs {
    GoodsDescribeVC *vc_1 = [[GoodsDescribeVC alloc] init];
    vc_1.dataSource = _dataSource;
    AuctionRulesVC *vc_2 = [[AuctionRulesVC alloc] init];
    vc_2.dataSource = _dataSource.instructionsList;
    AuctionPriceRecordVC *vc_3 = [[AuctionPriceRecordVC alloc] init];
    vc_3.jpID = _jpID;
    return @[vc_1, vc_2, vc_3];
}

- (NSArray *)getArrayTitles {
    return @[@"拍品描述", @"竞拍须知", @"出价记录"];
}


- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[GoodsDescribeVC class]]) {
        return [(GoodsDescribeVC *)vc tableView];
    } else if ([vc isKindOfClass:[GoodsDescribeVC class]]) {
        return [(AuctionRulesVC *)vc tableView];
    } else {
        return [(AuctionPriceRecordVC *)vc tableView];
    }
}

- (void)setupBottomView:(NSString *)type {
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(joinPrice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:joinBtn];
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
    NSString *title = [NSString string];
    switch ([type integerValue]) {
        case 0:
            title = @"竞拍已流拍";
            joinBtn.enabled = NO;
            joinBtn.backgroundColor = HEXColor(@"#BBBBBB", 1);
            break;
        case 1:
            title = @"竞拍尚未开始";
            joinBtn.enabled = NO;
            joinBtn.backgroundColor = HEXColor(@"#BBBBBB", 1);
            break;
        case 2:
            title = @"参与竞拍";
            joinBtn.enabled = YES;
            [ClassTool addLayer:joinBtn];
            break;
        case 3:
            title = @"竞拍已成交";
            joinBtn.enabled = NO;
            joinBtn.backgroundColor = HEXColor(@"#BBBBBB", 1);
            break;
        default:
            break;
    }
    [joinBtn setTitle:title forState:UIControlStateNormal];
}

- (void)joinPrice {
    JoinAuctionVC *vc = [[JoinAuctionVC alloc] init];
    vc.jpID = _jpID;
    vc.jpCount = [_dataSource.count integerValue];
    vc.startPrice = _dataSource.price;
    vc.nowPrice = _dataSource.maxPrice;
    vc.addPrice = _dataSource.addPrice;
    vc.numUnit = _dataSource.priceUnit;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
