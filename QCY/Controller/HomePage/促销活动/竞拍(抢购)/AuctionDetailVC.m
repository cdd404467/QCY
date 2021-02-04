//
//  AuctionDetailVC.m
//  QCY
//
//  Created by i7colors on 2019/3/6.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AuctionDetailVC.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "ClassTool.h"
#import <YNPageViewController.h>
#import "AuctionDetailHeader.h"
#import <WXApi.h>
#import "GoodsDescribeVC.h"
#import "AuctionModel.h"
#import "AuctionPriceRecordVC.h"
#import "AuctionRulesVC.h"
#import "JoinAuctionVC.h"


@interface AuctionDetailVC ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>
@property (nonatomic, strong)AuctionDetailHeader *headerView;
@property (nonatomic, strong)AuctionModel *dataSource;
@end

@implementation AuctionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抢购详情";
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
//            [weakself setupBottomView:weakself.dataSource.isType];
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
//    configration.cutOutHeight = TABBAR_HEIGHT;
    configration.cutOutHeight = Bottom_Height_Dif;
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
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    if ([_dataSource.from isEqualToString:@"pc"]) {
        if (isRightData(_dataSource.remark)) {
            [tempArr addObject:@{@"relatedInstructions":_dataSource.remark}];
        }
        NSArray *arr = @[@"最终商品以现场交付实物数量为准。",
                         @"抢购者在出价前应自行认真核实，查验标的信息，自行判断产品的现状是否符合其相关资料或描述。七彩云平台不对商品的数量、质量、种类、规格、实用性等情况作任何承诺，如抢购成功，买卖双方应自行协商交易。",
                         @"商品成交后，买卖双方自行协商办理成交商品的移交等一切事宜。",
                         @"费用负担情况：商品转让手续由买卖双方自行办理。本次交易过程中产生的税费依照税法等相关法律法规和政策的规定，由双方各自承担。",
                         @"至少一人报名且出价不低于最低价，方可成交。"];
        for (NSString *text in arr) {
            [tempArr addObject:@{@"relatedInstructions":text}];
        }
        tempArr = [InstructionsListModel mj_objectArrayWithKeyValuesArray:tempArr];
        NSArray *chineseNumArr = @[@"一、",@"二、",@"三、",@"四、",@"五、",@"六、",@"七、",@"八、",@"九、",@"十、"];
        for (NSInteger i = 0; i < tempArr.count; i++) {
            if (i > 9)
                break;
            InstructionsListModel *model = tempArr[i];
            model.relatedInstructions = [chineseNumArr[i] stringByAppendingString:model.relatedInstructions];
        }
        _dataSource.instructionsList = [tempArr copy];
    }
    
    vc_2.dataSource = _dataSource.instructionsList;
//    AuctionPriceRecordVC *vc_3 = [[AuctionPriceRecordVC alloc] init];
//    vc_3.jpID = _jpID;
//    return @[vc_1, vc_2, vc_3];
    return @[vc_1, vc_2];
}

- (NSArray *)getArrayTitles {
    return @[@"商品详情", @"抢购须知"];
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
            title = @"无人抢购";
            joinBtn.enabled = NO;
            joinBtn.backgroundColor = HEXColor(@"#BBBBBB", 1);
            break;
        case 1:
            title = @"尚未开始";
            joinBtn.enabled = NO;
            joinBtn.backgroundColor = HEXColor(@"#BBBBBB", 1);
            break;
        case 2:
            title = @"参与抢购";
            joinBtn.enabled = YES;
            [ClassTool addLayer:joinBtn];
            break;
        case 3:
            title = @"已成交";
            joinBtn.enabled = NO;
            joinBtn.backgroundColor = HEXColor(@"#BBBBBB", 1);
            break;
        default:
            break;
    }
    [joinBtn setTitle:title forState:UIControlStateNormal];
}

- (void)joinPrice {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    JoinAuctionVC *vc = [[JoinAuctionVC alloc] init];
    vc.jpID = _jpID;
    vc.jpCount = [_dataSource.count integerValue];
    vc.startPrice = _dataSource.price;
    vc.nowPrice = _dataSource.maxPrice;
    vc.addPrice = _dataSource.addPrice;
    vc.priceUnit = _dataSource.priceUnit;
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
