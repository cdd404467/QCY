//
//  AskToBuyDetailsVC.m
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuyDetailsVC.h"
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
#import <YYLabel.h>
#import <WXApi.h>
#import "NavControllerSet.h"
#import "QCYAlertView.h"
#import "JudgeTools.h"
#import "UpgradeVIPVC.h"
#import "MyInfoCenterVC.h"

@interface AskToBuyDetailsVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)AskToBuyModel *firstDateSource;
@property (nonatomic, strong)NSMutableArray *secondDateSource;
@property (nonatomic, strong)AskToBuyDetailsHeaderView *headerView;
@property (nonatomic, strong)NSMutableArray<AskDetailInfoModel *> *infoDataSource;
//关闭或报价按钮
@property (nonatomic, strong) UIButton *closeOrPriceBtn;
//查看联系方式按钮
@property (nonatomic, strong) UIButton *lookOverBtn;

@end

@implementation AskToBuyDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self requestMultiData];
}

- (void)setNavBar {
    self.title = @"求购详情";
    if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
        [self addRightBarButtonItemWithTitle:@"分享" action:@selector(share)];
    }
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        //取消垂直滚动条
//        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            //            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
//        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        AskToBuyDetailsHeaderView *headerView = [[AskToBuyDetailsHeaderView alloc] init];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
        [headerView setupUIWithStarNumber:[_firstDateSource.creditLevel integerValue]];
        headerView.model = _firstDateSource;
        _headerView = headerView;
        _tableView.tableHeaderView = headerView;
        UIView *footer = [[UIView alloc] init];
        footer.backgroundColor = RGBA(0, 0, 0, 0.08);
        footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        _tableView.tableFooterView = footer;
        
    }
    return _tableView;
}

- (void)share {
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    [imageArray addObject:Logo];
    NSString *shareStr = [NSString stringWithFormat:@"http://%@.i7colors.com/groupBuyMobile/openApp/industryChain.html?enquiryId=%@",ShareString,_buyID];
    NSString *text = [NSString stringWithFormat:@"地区:%@ %@ 求购重量:%@KG",_firstDateSource.locationProvince,_firstDateSource.locationCity,_firstDateSource.num];
    [ClassTool shareSomething:imageArray urlStr:shareStr title:_firstDateSource.productName text:text];
}

- (NSMutableArray *)infoDataSource {
    if (!_infoDataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _infoDataSource = mArr;
    }
    return _infoDataSource;
}

- (NSMutableArray *)secondDateSource {
    if (!_secondDateSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _secondDateSource = mArr;
    }
    return _secondDateSource;
}


- (void)setupUI {
    [self.view addSubview:self.tableView];
    /*** 创建按钮 **/
    //进行中
    if (_firstDateSource.status.integerValue == 1) {
        _tableView.height = SCREEN_HEIGHT - TABBAR_HEIGHT;
        //并且是直通车
        if (_firstDateSource.showInfo.integerValue == 1) {
            [self.view addSubview:self.lookOverBtn];
            self.lookOverBtn.width = SCREEN_WIDTH / 2;
            [self.view addSubview:self.closeOrPriceBtn];
            self.closeOrPriceBtn.width = SCREEN_WIDTH / 2;
            self.closeOrPriceBtn.left = SCREEN_WIDTH / 2;
        } else {
            [self.view addSubview:self.closeOrPriceBtn];
            self.closeOrPriceBtn.width = SCREEN_WIDTH;
        }
    } else {
        //并且是直通车
        if (_firstDateSource.showInfo.integerValue == 1) {
            [self.view addSubview:self.lookOverBtn];
            self.lookOverBtn.width = SCREEN_WIDTH;
            _tableView.height = SCREEN_HEIGHT - TABBAR_HEIGHT;
        } else {
            _tableView.height = SCREEN_HEIGHT;
        }
    }
    [ClassTool addLayerAutoSize:_closeOrPriceBtn];
    
    [self bindEvent];
}

- (void)bindEvent {
    [_closeOrPriceBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    //是我自己发布的
    if ([_firstDateSource.isCharger isEqualToString:@"1"]) {
        //并且在进行中，显示关闭求购
        if ([_firstDateSource.status isEqualToString:@"1"]) {
            [_closeOrPriceBtn setTitle:@"关闭求购" forState:UIControlStateNormal];
            [_closeOrPriceBtn addTarget:self action:@selector(closeBuy) forControlEvents:UIControlEventTouchUpInside];
        }
        //不是自己发布，在进行中
    } else {
        //参与报价
        if ([_firstDateSource.status isEqualToString:@"1"]) {
            [_closeOrPriceBtn setTitle:@"参与报价" forState:UIControlStateNormal];
            [_closeOrPriceBtn addTarget:self action:@selector(jumpToJoinPrice) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (UIButton *)closeOrPriceBtn {
    if (!_closeOrPriceBtn) {
        _closeOrPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeOrPriceBtn.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT, 0, 49);
        [_closeOrPriceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeOrPriceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _closeOrPriceBtn;
}

- (UIButton *)lookOverBtn {
    if (!_lookOverBtn) {
        _lookOverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lookOverBtn setTitle:@"查看联系方式" forState:UIControlStateNormal];
        _lookOverBtn.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT, 0, 49);
        [_lookOverBtn setTitleColor:MainColor forState:UIControlStateNormal];
        _lookOverBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _lookOverBtn.backgroundColor = Like_Color;
        [_lookOverBtn addTarget:self action:@selector(lookForContact) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookOverBtn;
}

#pragma mark - 获取列表数据
- (void)requestMultiData {
    DDWeakSelf;
    
    [CddHUD show:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    //详情
    dispatch_group_enter(group);
    //多线程耗时操作
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_ASKTOBUY_DETAIL,User_Token,weakself.buyID];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//            NSLog(@"---- %@",json);
            [weakself addInfo:json];
            weakself.firstDateSource = [AskToBuyModel mj_objectWithKeyValues:json[@"data"]];
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            NSLog(@" Error : %@",error);
            dispatch_group_leave(group);
        }];
    });
    //已报价供应商
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_OFFERLIST_SUPPLIER,User_Token,weakself.buyID];
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
            if (weakself.isFirstLoadData == YES) {
                [weakself setupUI];
            } else {
                [weakself.tableView reloadData];
                [weakself bindEvent];
            }
            [CddHUD hideHUD:weakself.view];
        });
    });

}
//刷新时获取的数据
- (void)getOffrtList {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_OFFERLIST_SUPPLIER,User_Token,_buyID];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        weakself.secondDateSource = [supOrrerModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
        //section刷新
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:2];
        [weakself.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

//查看联系方式
- (void)lookForContact {
    DDWeakSelf;
    if (!GET_USER_TOKEN) {
        [self jumpToLoginWithComplete:^{
            [weakself requestMultiData];
        }];
        return;
    }
    
    if (User_Type == 3) {
        //如果本次查看是要消耗次数的
        if (self.firstDateSource.loginUserIsShowInfo.integerValue == 1 || self.firstDateSource.isCharger.intValue == 1) {
            [self requestZTCInfo];
        } else {
            NSString *text = @"本次查看将会消耗一次机会，是否确定查看?";
            [QCYAlertView showWithTitle:@"提示" text:text btnTitle:@"确定" handler:^{
                [self requestZTCInfo];
            } cancel:nil];
        }
    } else {
        NSString *title = @"提示";
        NSString *text = @"您还不是付费会员,无法查看。如果您已是付费会员无法查看,请联系客服!";
        [QCYAlertView showWithTitle:title text:text leftBtnTitle:@"联系客服" rightBtnTitle:@"付费会员" leftHandler:^{
            [JudgeTools callService];
        } rightHandler:^{
            [weakself clickUpgrade];
            UpgradeVIPVC *vc = [[UpgradeVIPVC alloc] init];
            [weakself.navigationController pushViewController:vc animated:YES];
        } cancel:nil];
    }
}


//点击了付费账户按钮
- (void)clickUpgrade {
    NSDictionary *dict = @{@"token":User_Token};
    [ClassTool postRequest:URLPost_Click_UpgradeVIP Params:[dict mutableCopy] Success:^(id json) {
        
    } Failure:^(NSError *error) {
    }];
}


//查看直通车信息
- (void)requestZTCInfo {
    [CddHUD show:self.view];
    NSString *urlString = [NSString stringWithFormat:URLGet_AskZTC_Info,User_Token,_buyID];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD:self.view];
//        NSLog(@"==== %@",json);
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            if ([json[@"data"] objectForKey:@"phone"] && [json[@"data"] objectForKey:@"remainCount"]) {
                NSString *title;
                if (self.firstDateSource.loginUserIsShowInfo.integerValue == 1 || self.firstDateSource.isCharger.intValue == 1) {
                    title = @"本次查看信息不扣除剩余次数";
                } else {
                    title = @"提示";
                }
                self.firstDateSource.loginUserIsShowInfo = @"1";
                
                if ([json[@"data"] objectForKey:@"remainCount"]) {
                    NSInteger count = [json[@"data"][@"remainCount"] integerValue];
                    if (count < 0) {
                        count = 0;
                    }
                    NSString *text = [NSString stringWithFormat:@"查看成功,您本月剩余%ld次查看采购商联系方式的机会!",(long)count];
                    [QCYAlertView showWithTitle:title text:text btnTitle:@"一键呼叫" handler:^{
                        [JudgeTools callWithPhoneNumber:json[@"data"][@"phone"]];
                    } cancel:nil];
                }
            }
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}


//关闭求购
- (void)closeBuy {
    NSDictionary *dict = @{@"token":User_Token,
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
                    [weakself.closeOrPriceBtn removeFromSuperview];
                    if (self.firstDateSource.showInfo.integerValue == 1) {
                        self.lookOverBtn.width = SCREEN_WIDTH;
                    } else {
                        weakself.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                    }
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

    NSDictionary *dict = @{@"token":User_Token,
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
                    [weakself.closeOrPriceBtn removeFromSuperview];
                    if (self.firstDateSource.showInfo.integerValue == 1) {
                        self.lookOverBtn.width = SCREEN_WIDTH;
                    } else {
                        weakself.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                    }
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
    DDWeakSelf;
    if (!GET_USER_TOKEN) {
        [self jumpToLoginWithComplete:^{
            [weakself requestMultiData];
        }];
        return;
    }
    
    NSInteger count = _firstDateSource.loginUserRemainOfferCount.integerValue;
    //个人
    if (User_Type == 1) {
        if (count <= 0) {
            NSString *text = @"您的报价次数不足，请升级为企业用户!";
            [QCYAlertView showWithTitle:@"提示" text:text btnTitle:@"认证企业账户" handler:^{
                MyInfoCenterVC *vc = [[MyInfoCenterVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            } cancel:nil];
            return;
        }
    }
    //普通企业
    else if (User_Type == 2) {
        if (count <= 0) {
            NSString *text = @"您本月剩余报价次数0次，请先成为付费企业账户获取更多权益。";
            [QCYAlertView showWithTitle:@"提示" text:text btnTitle:@"付费企业账户" handler:^{
                [weakself clickUpgrade];
                UpgradeVIPVC *vc = [[UpgradeVIPVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            } cancel:nil];
            return;
        }
    }
    //付费企业
    else if (User_Type == 3) {
        //暂时无限制，为所欲为
    }
    
    JoinPriceVC *vc = [[JoinPriceVC alloc] init];
    vc.productID = _buyID;
    vc.productName = _firstDateSource.productName;
    vc.refreshDataBlock = ^{
        [weakself getOffrtList];
        NSInteger newCount = weakself.firstDateSource.loginUserRemainOfferCount.integerValue - 1;
        weakself.firstDateSource.loginUserRemainOfferCount = @(newCount).stringValue;
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
        return _infoDataSource.count;
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
        return [self.infoDataSource[indexPath.row] cellHeight];
    } else if (indexPath.section == 1){
        return self.firstDateSource.cellHeight;
    } else {
        if (self.secondDateSource.count == 0)
            return 105;
        return [self.secondDateSource[indexPath.row] cellHeight];
    }
}

//给出cell的估计高度，主要目的是优化cell高度的计算次数
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
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
        AskToBuyInfoCell *cell = [AskToBuyInfoCell cellWithTableView:tableView];
        cell.model = self.infoDataSource[indexPath.row];
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
    NSMutableArray *infoArr = [NSMutableArray arrayWithCapacity:0];
    //发布时间
    [infoArr addObject:[self judgeStr:json[@"data"][@"createAtString"]]];
    //产品名称
    [infoArr addObject:[self judgeStr:json[@"data"][@"productName"]]];
    //包装规格
    [infoArr addObject:[self judgeStr:json[@"data"][@"pack"]]];
    //采购数量
    [infoArr addObject:[self judgeStr:[NSString stringWithFormat:@"%@KG",To_String(json[@"data"][@"num"])]]];
    //产品分类
    NSString *s1 = json[@"data"][@"productCli1Name"];
    NSString *s2 = json[@"data"][@"productCli2Name"];
    [infoArr addObject:[self judgeStr:[NSString stringWithFormat:@"%@ %@",s1,s2]]];
    //交货日期
    [infoArr addObject:[self judgeStr:json[@"data"][@"deliveryDateString"]]];
    //付款方式
    [infoArr addObject:[self judgeStr:json[@"data"][@"paymentType"]]];
    //所在地区
    NSString *sheng = json[@"data"][@"locationProvince"];
    NSString *shi = json[@"data"][@"locationCity"];
    [infoArr addObject:[self judgeStr:[NSString stringWithFormat:@"%@ %@",sheng,shi]]];
    //付款期限
    [infoArr addObject:[self judgeStr:json[@"data"][@"paymentPeriodString"]]];
    
    NSArray *arrLeft = @[@"发布时间",@"产品名称",@"包装规格",@"采购数量",@"产品分类",@"交货日期",@"付款方式",@"所在地区",@"付款期限"];
    for (NSInteger i = 0; i < arrLeft.count; i++) {
        AskDetailInfoModel *model = [[AskDetailInfoModel alloc] init];
        model.leftText = arrLeft[i];
        model.rightText = infoArr[i];
        [self.infoDataSource addObject:model];
    }
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
