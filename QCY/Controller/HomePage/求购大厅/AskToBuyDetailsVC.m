//
//  AskToBuyDetailsVC.m
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuyDetailsVC.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "AskToBuyDetailsHeaderView.h"
#import "AskToBuyInfoCell.h"
#import "AskToBuySectionHeader.h"
#import "HelperTool.h"
#import "ExplainCell.h"
#import "supplierQuotationCell.h"
#import "ClassTool.h"
#import "UIView+Border.h"
#import "JoinPriceVC.h"
#import "NetWorkingPort.h"
#import "HomePageModel.h"
#import <MJExtension.h>
#import "CddHUD.h"
#import "Alert.h"
#import "CommonNav.h"
#import <YYLabel.h>
#import "UIView+Geometry.h"
#import <WXApi.h>


@interface AskToBuyDetailsVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)AskToBuyDetailModel *firstDateSource;
@property (nonatomic, strong)NSMutableArray *secondDateSource;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NSMutableArray *infoArr;
@property (nonatomic, strong)AskToBuyModel *infoDataSource;
@property (nonatomic, strong)UIButton *btBtn;
@property (nonatomic, strong)AskToBuyDetailsHeaderView *headerView;
@end

@implementation AskToBuyDetailsVC {
    CGFloat _tbHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"求购详情";
    if (self.navigationController.navigationBar.isHidden == YES) {
        CommonNav *nav = [[CommonNav alloc] init];
        [nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        nav.titleLabel.text = @"求购详情";
        if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
            nav.rightBtn.hidden = NO;
            [nav.rightBtn setTitle:@"分享" forState:UIControlStateNormal];
            [nav.rightBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.view addSubview:nav];
    } else {
        if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            rightBtn.frame = CGRectMake(0, 0, 50, 44);
            [rightBtn setTitle:@"分享" forState:UIControlStateNormal];
            [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [rightBtn sizeToFit];
            [rightBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
            self.navigationItem.rightBarButtonItem = rightItem;
        }
    }
    
    [self requestMultiData];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.originHeight, SCREEN_WIDTH, _tbHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        //取消垂直滚动条
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        
        AskToBuyDetailsHeaderView *headerView = [[AskToBuyDetailsHeaderView alloc] init];
        if (GET_USER_TOKEN) {
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        } else {
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
        }
        [headerView setupUIWithStarNumber:[_firstDateSource.creditLevel integerValue]];
        headerView.model = _firstDateSource;
        _headerView = headerView;
        _tableView.tableHeaderView = headerView;
        
        UIView *footer = [[UIView alloc] init];
        footer.backgroundColor = RGBA(0, 0, 0, 0.08);
        footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
        _tableView.tableFooterView = footer;
        
    }
    return _tableView;
}

- (void)share{
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    [imageArray addObject:Logo];
    NSString *shareStr = [NSString stringWithFormat:@"http://%@.i7colors.com/groupBuyMobile/openApp/industryChain.html?enquiryId=%@",ShareString,_buyID];
    NSString *text = [NSString stringWithFormat:@"地区:%@ %@ 求购重量:%@KG",_infoDataSource.locationProvince,_infoDataSource.locationCity,_infoDataSource.num];
    
    [ClassTool shareSomething:imageArray urlStr:shareStr title:_firstDateSource.productName text:text];
}

- (NSMutableArray *)infoArr {
    if (!_infoArr) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _infoArr = mArr;
    }
    return _infoArr;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        _dataSource = arr;
    }
    return _dataSource;
}

- (NSMutableArray *)secondDateSource {
    if (!_secondDateSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _secondDateSource = mArr;
    }
    return _secondDateSource;
}


- (void)setupUI {
    AskToBuyDetailModel *model = _firstDateSource;
    if (GET_USER_TOKEN) {
        //是我自己发布的
        if ([model.isCharger isEqualToString:@"1"]) {
            //并且在进行中，显示关闭求购
            if ([model.status isEqualToString:@"1"]) {
                _tbHeight = SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT;
                _btBtn = [self addBottonBtn];
                [_btBtn setTitle:@"关闭求购" forState:UIControlStateNormal];
                [_btBtn addTarget:self action:@selector(closeBuy) forControlEvents:UIControlEventTouchUpInside];
            } else {
                _tbHeight = SCREEN_HEIGHT - NAV_HEIGHT;
            }
            //不是自己发布，在进行中
        } else {
            //参与报价
            if ([model.status isEqualToString:@"1"]) {
                _tbHeight = SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT;
                _btBtn = [self addBottonBtn];
                [_btBtn setTitle:@"参与报价" forState:UIControlStateNormal];
                [_btBtn addTarget:self action:@selector(jumpToJoinPrice) forControlEvents:UIControlEventTouchUpInside];
            } else {
                _tbHeight = SCREEN_HEIGHT - NAV_HEIGHT;
            }
        }
    }
    //用户未登录,还在进行中的就显示报价按钮
    else {
        if ([model.status isEqualToString:@"1"]) {
            _tbHeight = SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT;
            UIButton *btn = [self addBottonBtn];
            [btn setTitle:@"参与报价" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(jumpToJoinPrice) forControlEvents:UIControlEventTouchUpInside];
        } else {
            _tbHeight = SCREEN_HEIGHT - NAV_HEIGHT;
        }
    }
    [self.view addSubview:self.tableView];
}

- (UIButton *)addBottonBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [ClassTool addLayer:btn];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
    
    return btn;
}

#pragma mark - 获取列表数据
- (void)requestMultiData {
    DDWeakSelf;
    
    NSString *token;
    if (GET_USER_TOKEN) {
        token = GET_USER_TOKEN;
    } else {
        token = @"";
    }
    
    [CddHUD show:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    //详情
    dispatch_group_enter(group);
    //多线程耗时操作
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_ASKTOBUY_DETAIL,token,weakself.buyID];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//            NSLog(@"---- %@",json);
            weakself.infoDataSource = [AskToBuyModel mj_objectWithKeyValues:json[@"data"]];
            [weakself addInfo:json];
            weakself.firstDateSource = [AskToBuyDetailModel mj_objectWithKeyValues:json[@"data"]];
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            NSLog(@" Error : %@",error);
            dispatch_group_leave(group);
        }];
    });
    //已报价供应商
    dispatch_group_enter(group);
    //多线程耗时操作
    
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_OFFERLIST_SUPPLIER,token,weakself.buyID];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//            NSLog(@"----  %@",json);
            weakself.secondDateSource = [supOrrerModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            NSLog(@" Error : %@",error);
            dispatch_group_leave(group);
        }];
    });
    
    //全部任务完成后，就可以在这吊了
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself setupUI];
            [CddHUD hideHUD:weakself.view];
        });
    });

}
//刷新时获取的数据
- (void)getOffrtList {
    DDWeakSelf;
    NSString *token;
    if (GET_USER_TOKEN) {
        token = GET_USER_TOKEN;
    } else {
        token = @"";
    }
    NSString *urlString = [NSString stringWithFormat:URL_OFFERLIST_SUPPLIER,token,_buyID];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        weakself.secondDateSource = [supOrrerModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        //section刷新
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
        [weakself.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

//关闭求购
- (void)closeBuy {
    NSDictionary *dict = @{@"token":GET_USER_TOKEN,
                           @"id":_buyID
                           };
    DDWeakSelf;
    [Alert alertTwo:@"确定要关闭求购吗?" cancelBtn:@"取消" okBtn:@"确定" OKCallBack:^{
        [CddHUD showWithText:@"关闭求购中..." view:self.view];
        [ClassTool postRequest:URL_CLOSE_BUYING Params:[dict mutableCopy] Success:^(id json) {
            [CddHUD hideHUD:weakself.view];
            if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                BOOL isSuc = [json[@"data"] boolValue];
                if (isSuc == YES) {
                    [CddHUD showTextOnlyDelay:@"关闭成功" view:weakself.view];
                    [weakself.btBtn removeFromSuperview];
                    weakself.tableView.frame = CGRectMake(0, weakself.originHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
                    [ClassTool addLayer:weakself.headerView.stateLabel frame:weakself.headerView.stateLabel.frame];
                    weakself.headerView.sLabel.hidden = NO;
                } else if (isSuc == NO){
                    
                }
            }
        } Failure:^(NSError *error) {
            
        }];
    }];
    
}

//采纳报价
- (void)acceptOffer:(NSString *)offerID {

    NSDictionary *dict = @{@"token":GET_USER_TOKEN,
                           @"enquiryOfferId":offerID
                           };
    DDWeakSelf;
    [Alert alertTwo:@"确定要采纳报价吗?" cancelBtn:@"取消" okBtn:@"确定" OKCallBack:^{
        [CddHUD showWithText:@"采纳报价中..." view:weakself.view];
        [ClassTool postRequest:URL_Accept_Offer Params:[dict mutableCopy] Success:^(id json) {
            [CddHUD hideHUD:weakself.view];
            if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
                BOOL isSuc = [json[@"data"] boolValue];
                if (isSuc == YES) {
                    [weakself getOffrtList];
                    //去掉关闭求购按钮
                    [weakself.btBtn removeFromSuperview];
                    weakself.tableView.frame = CGRectMake(0, weakself.originHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
                    [ClassTool addLayer:weakself.headerView.stateLabel frame:weakself.headerView.stateLabel.frame];
                    weakself.headerView.sLabel.hidden = NO;
                    
                    [CddHUD showTextOnlyDelay:@"采纳成功" view:weakself.view];
                } else if (isSuc == NO){
                    
                }
            }
        } Failure:^(NSError *error) {
            
        }];
    }];
    
}



#pragma mark - 点击按钮事件
- (void)jumpToJoinPrice {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    
    DDWeakSelf;
    JoinPriceVC *vc = [[JoinPriceVC alloc] init];
    vc.productID = _buyID;
    vc.productName = _firstDateSource.productName;
    vc.refreshDataBlock = ^{
        [weakself getOffrtList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - tableView代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _infoArr.count;
    } else if (section == 1) {
        return 1;
    } else {
        if (_secondDateSource.count == 0) {
            return 1;
        } else {
            return _secondDateSource.count;
        }
    }
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 35;
    } else if (indexPath.section == 1){
        return 80;
       

    } else {
        return 105;
        
    }
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *titleArr = @[@"求购信息",@"采购说明",@"已报价供应商"];
    AskToBuySectionHeader *header = [AskToBuySectionHeader headerWithTableView:tableView];
    header.titleLabel.text = titleArr[section];
    if (section == 0) {
        [HelperTool setRound:header.titleLabel corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:5];
    }
    return header;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSArray *arrLeft = @[@"发布时间",@"产品名称",@"包装规格",@"采购数量",@"产品分类",@"交货日期",@"付款方式",@"所在地区",@"付款期限"];
//        NSArray *arrRight = @[@"2017-12-20 15:17:57",@"分散黑EBT 300%",@"纸箱 打托",@"15000",@"染料",@"2017-12-24",@"现款",@"上海市",@"2017-12-23"];
        AskToBuyInfoCell *cell = [AskToBuyInfoCell cellWithTableView:tableView];
        cell.productExplain.text = arrLeft[indexPath.row];
        cell.detailLabel.text = _infoArr[indexPath.row];
        return cell;
    } else if (indexPath.section == 1){
        ExplainCell *cell = [ExplainCell cellWithTableView:tableView];
        cell.model = _firstDateSource;
        return cell;
    } else {
        supplierQuotationCell *cell = [supplierQuotationCell cellWithTableView:tableView];
        if (_secondDateSource.count == 0) {
            cell.noneLabel.hidden = NO;
            
        } else {
            cell.noneLabel.hidden = YES;
            cell.model = _firstDateSource;
            cell.model_sup = _secondDateSource[indexPath.row];
            DDWeakSelf;
            cell.cbtnClickBlock = ^(NSString * _Nonnull offerID) {
                [weakself acceptOffer:offerID];
            };
        }
        return cell;
        
    }
}


//求购信息添加数组
- (void)addInfo:(id)json {
    //发布时间
    [self.infoArr addObject:[self judgeStr:json[@"data"][@"createAtString"]]];
    //产品名称
    [self.infoArr addObject:[self judgeStr:json[@"data"][@"productName"]]];
    //包装规格
    [self.infoArr addObject:[self judgeStr:json[@"data"][@"pack"]]];
    //采购数量
    [self.infoArr addObject:[self judgeStr:[NSString stringWithFormat:@"%@KG",To_String(json[@"data"][@"num"])]]];
    //产品分类
    NSString *s1 = json[@"data"][@"productCli1Name"];
    NSString *s2 = json[@"data"][@"productCli2Name"];
//    if (![s2 isEqualToString:@""]) {
    [self.infoArr addObject:[self judgeStr:[NSString stringWithFormat:@"%@ %@",s1,s2]]];
//    } else {
//        [self.infoArr addObject:[self judgeStr:[NSString stringWithFormat:@"%@ %@",s1,s2]]];
//    }
    //交货日期
    [self.infoArr addObject:[self judgeStr:json[@"data"][@"deliveryDateString"]]];
    //付款方式
    [self.infoArr addObject:[self judgeStr:json[@"data"][@"paymentType"]]];
    //所在地区
    NSString *sheng = json[@"data"][@"locationProvince"];
    NSString *shi = json[@"data"][@"locationCity"];
    [self.infoArr addObject:[self judgeStr:[NSString stringWithFormat:@"%@ %@",sheng,shi]]];
    //付款期限
    [self.infoArr addObject:[self judgeStr:json[@"data"][@"paymentPeriodString"]]];
}


- (NSString *)judgeStr:(NSString *)string {
    if isRightData(string) {
        return string;
    } else {
        return @" ";
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
