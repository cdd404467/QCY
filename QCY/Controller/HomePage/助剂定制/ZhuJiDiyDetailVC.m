//
//  ZhuJiDiyDetailVC.m
//  QCY
//
//  Created by i7colors on 2019/7/31.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ZhuJiDiyDetailVC.h"
#import "ZhuJiDiyModel.h"
#import "CddHUD.h"
#import "ZhuJiDiySectionHeader.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "ZhuJiDiyInfoCell.h"
#import "ZhuJiDiyDetailHeaderView.h"
#import "HelperTool.h"
#import "ZhuJiDiyFuncDesCell.h"
#import "ZhuJiDiySubmitPlanVC.h"
#import "AskToBuySectionHeader.h"
#import "ZhuJiDiyReceiveSolutionCell.h"
#import "CddActionSheetView.h"



@interface ZhuJiDiyDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray<NSMutableArray *> *infoDataSource;
@property (nonatomic, strong)ZhuJiDiyModel *firstDateSource;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) ZhuJiDiyDetailHeaderView *header;
@end

@implementation ZhuJiDiyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_jumpFrom isEqualToString:@"home"]) {
        self.title = @"助剂定制详情";
    } else if ([_jumpFrom isEqualToString:@"myZhuJiDiy"]) {
        self.title = @"我的助剂定制详情";
    } else if ([_jumpFrom isEqualToString:@"myZhuJiSolution"]) {
        self.title = @"我的助剂定制方案详情";
    }
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitBtn];
    [self requestZhujiInfo];
}

- (NSMutableArray *)infoDataSource {
    if (!_infoDataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < 5; i++) {
            NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:0];
            [mArr addObject:tmpArr];
        }
        _infoDataSource = mArr;
    }
    return _infoDataSource;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.hidden = YES;
        _submitBtn.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT, SCREEN_WIDTH, 49);
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ClassTool addLayer:_submitBtn];
    }
    return _submitBtn;
}

//设置按钮文字状态和绑定的点击事件
- (void)setBtnState {
    [self.submitBtn removeTarget:nil
                                     action:NULL
                           forControlEvents:UIControlEventAllEvents];
    if ([_jumpFrom isEqualToString:@"home"] || [_jumpFrom isEqualToString:@"myZhuJiDiy"]) {
        //进行中
        if ([self.firstDateSource.status isEqualToString:@"diying"]) {
            _submitBtn.hidden = NO;
            _tableView.height = SCREEN_HEIGHT - TABBAR_HEIGHT;
            //没登录,绑定登录事件
            if (!GET_USER_TOKEN) {
                [_submitBtn addTarget:self action:@selector(jumpToPlanVC) forControlEvents:UIControlEventTouchUpInside];
                [_submitBtn setTitle:@"提交方案" forState:UIControlStateNormal];
            } else {
                //是自己发布就显示关闭
                if ([self.firstDateSource.isCharger isEqualToString:@"1"]) {
                    [_submitBtn addTarget:self action:@selector(askToClose) forControlEvents:UIControlEventTouchUpInside];
                    [_submitBtn setTitle:@"关闭定制" forState:UIControlStateNormal];
                }
                //不是自己发布的可以参与
                else {
                    [_submitBtn addTarget:self action:@selector(jumpToPlanVC) forControlEvents:UIControlEventTouchUpInside];
                    [_submitBtn setTitle:@"提交方案" forState:UIControlStateNormal];
                }
            }
        }
        //结束了
        else {
            _submitBtn.hidden = YES;
            _tableView.height = SCREEN_HEIGHT;
        }
    }
    //如果是从我的方案进入，则直接不显示
    else {
        _submitBtn.hidden = YES;
        _tableView.height = SCREEN_HEIGHT;
    }
}

//关闭之前询问
- (void)askToClose {
    NSString *title = @"确定要关闭当前定制吗?";
    DDWeakSelf;
    CddActionSheetView *sheetView = [[CddActionSheetView alloc] initWithSheetOKTitle:@"关闭定制" cancelTitle:@"取消" completion:^{
        [weakself closeThisZhuJiDiy];
    } cancel:nil];
    sheetView.title = title;
    [sheetView show];
}

//要是碰到是自己发布的助剂定制，调用此方法来关闭定制
- (void)closeThisZhuJiDiy {
    NSDictionary *dict = @{@"token":User_Token,
                           @"status":@"close",
                           @"id":_firstDateSource.zhujiDiyID,
                           };
    DDWeakSelf;
    [CddHUD showWithText:@"关闭中..." view:self.view];
    self.view.userInteractionEnabled = NO;
    [ClassTool postRequest:URLPost_Close_MyZhuJiDiy Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        weakself.view.userInteractionEnabled = YES;
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [weakself requestZhujiInfo];
            [CddHUD showTextOnlyDelay:@"定制已关闭" view:self.view];
        }
    } Failure:^(NSError *error) {
        weakself.view.userInteractionEnabled = YES;
    }];
}

//采纳解决方案
- (void)acceptPlanWithID:(NSString *)solutionID {
    NSDictionary *dict = @{@"token":User_Token,
                           @"id":solutionID,
                           };
    DDWeakSelf;
    [CddHUD showWithText:@"请求中..." view:self.view];
    self.view.userInteractionEnabled = NO;
    [ClassTool postRequest:URLPost_Accept_ZhuJiDiy Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        weakself.view.userInteractionEnabled = YES;
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [weakself requestZhujiInfo];
            [CddHUD showTextOnlyDelay:@"采纳成功" view:self.view];
        }
        
    } Failure:^(NSError *error) {
        weakself.view.userInteractionEnabled = YES;
    }];
}

//跳转到提交助剂定制解决方案页面
- (void)jumpToPlanVC {
    if (!GET_USER_TOKEN) {
        DDWeakSelf;
        [weakself jumpToLoginWithComplete:^{
            [weakself requestZhujiInfo];
        }];
        return ;
    }
    if (!isCompanyUser) {
        [CddHUD showTextOnlyDelay:@"只有企业用户才能提交助剂定制方案" view:self.view];
        return;
    }
    
    ZhuJiDiySubmitPlanVC *vc = [[ZhuJiDiySubmitPlanVC alloc] init];
    vc.zhuJiDiyID = _zhuJiDiyID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (ZhuJiDiyDetailHeaderView *)header {
    if (!_header) {
        _header = [[ZhuJiDiyDetailHeaderView alloc] init];
    }
    return _header;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView.backgroundColor = Main_BgColor;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, Bottom_Height_Dif, 0);
        _tableView.tableHeaderView = self.header;
        _tableView.hidden = YES;
        UIView *footer = [[UIView alloc] init];
        footer.backgroundColor = Main_BgColor;
        footer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
        _tableView.tableFooterView = footer;
        
    }
    return _tableView;
}

- (void)requestZhujiInfo {
    NSString *urlString = [NSString string];
    //首页进入详情
    if ([_jumpFrom isEqualToString:@"home"]) {
        urlString = [NSString stringWithFormat:URLGet_ZhuJiDiy_Detail,User_Token,_zhuJiDiyID];
    }
    //从我的助剂定制进入详情
    else if ([_jumpFrom isEqualToString:@"myZhuJiDiy"]) {
        urlString = [NSString stringWithFormat:URLGet_MyZhuJiDiy_DiyDetail,User_Token,_zhuJiDiyID];
    }
    //从我的解决方案进入详情
    else if ([_jumpFrom isEqualToString:@"myZhuJiSolution"]) {
        urlString = [NSString stringWithFormat:URLGet_MyZhuJiDiy_SolutionDetail,User_Token,_zhuJiDiyID];
    }
    
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
                    NSLog(@"---- %@",json);
        [weakself.infoDataSource removeAllObjects];
        weakself.infoDataSource = nil;
        if ([weakself.jumpFrom isEqualToString:@"home"]) {
            [weakself addInfo:json[@"data"]];
            weakself.firstDateSource = [ZhuJiDiyModel mj_objectWithKeyValues:json[@"data"]];
        } else if ([weakself.jumpFrom isEqualToString:@"myZhuJiDiy"]) {
            weakself.firstDateSource = [ZhuJiDiyModel mj_objectWithKeyValues:json[@"data"]];
            [weakself addInfo:json[@"data"]];
            if (weakself.firstDateSource.solutionList.count > 0) {
                weakself.firstDateSource.solutionList = [ZhuJiDiySolutionModel mj_objectArrayWithKeyValuesArray:weakself.firstDateSource.solutionList];
                [weakself.infoDataSource addObject:weakself.firstDateSource.solutionList];
            }
        } else if ([weakself.jumpFrom isEqualToString:@"myZhuJiSolution"]) {
            weakself.firstDateSource = [ZhuJiDiyModel mj_objectWithKeyValues:json[@"data"][@"zhujiDiy"]];
            [weakself addInfo:json[@"data"][@"zhujiDiy"]];
            ZhuJiDiySolutionModel *model = [ZhuJiDiySolutionModel mj_objectWithKeyValues:json[@"data"]];
            NSMutableArray *arr = [NSMutableArray arrayWithObject:model];
            weakself.firstDateSource.solutionList = arr;
            [weakself.infoDataSource addObject:weakself.firstDateSource.solutionList];
        }
        
        weakself.header.jumpFrom = weakself.jumpFrom;
        weakself.header.model = weakself.firstDateSource;
        weakself.tableView.hidden = NO;
        [weakself.tableView reloadData];
        [weakself setBtnState];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

#pragma mark - tableView代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.infoDataSource.count;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.infoDataSource[section] count];
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return [self.infoDataSource[indexPath.section][indexPath.row] cellHeight];
}

//给出cell的估计高度，主要目的是优化cell高度的计算次数
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 34;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001;
    } else if (section == 5) {
        return 40;
    } else {
        return 35;
    }
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 4) {
        return 10;
    } else {
        return 0.0001;
    }
}


//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else if (section == 5) {
        AskToBuySectionHeader *header = [AskToBuySectionHeader headerWithTableView:tableView];
        if ([_jumpFrom isEqualToString:@"myZhuJiDiy"]) {
            header.titleLabel.text = @"收到的解决方案";
        } else if ([_jumpFrom isEqualToString:@"myZhuJiSolution"]) {
            header.titleLabel.text = @"我的解决方案";
        }
        header.titleLabel.textColor = HEXColor(@"#F10215", 1);
        [HelperTool setRound:header.titleLabel corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:5];
        
        return header;
    } else {
        NSArray *titleArr = @[@"",@"纺织品属性",@"染整工艺要求",@"现用产品说明",@"助剂性能描述"];
        ZhuJiDiySectionHeader *header = [ZhuJiDiySectionHeader headerWithTableView:tableView];
        header.titleLab.text = titleArr[section];
        return header;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 4) {
        static NSString *identifier = @"footer";
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        if (header == nil) {
            header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
            view.backgroundColor = Main_BgColor;
            [header addSubview:view];
        }
        
        return header;
    }
    
    return nil;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        ZhuJiDiyFuncDesCell *cell = [ZhuJiDiyFuncDesCell cellWithTableView:tableView];
        cell.model = self.infoDataSource[indexPath.section][indexPath.row];
        return cell;
    } else if (indexPath.section == 5) {
        ZhuJiDiyReceiveSolutionCell *cell = [ZhuJiDiyReceiveSolutionCell cellWithTableView:tableView type:_jumpFrom];
        DDWeakSelf;
        cell.acceptBtnBlock = ^(NSString * _Nonnull solutionID) {
            [weakself acceptPlanWithID:solutionID];
        };
        cell.model = self.infoDataSource[indexPath.section][indexPath.row];
        return cell;
    } else {
        ZhuJiDiyInfoCell *cell = [ZhuJiDiyInfoCell cellWithTableView:tableView];
        cell.model = self.infoDataSource[indexPath.section][indexPath.row];
        if (indexPath.section == 0 && indexPath.row == 0) {
            [HelperTool setRound:cell.bgView corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:5.f];
        } else {
            [HelperTool setRound:cell.bgView corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:0.f];
        }
        return cell;
    }
}

//求购信息添加数组
- (void)addInfo:(id)json {
    NSArray *titleArr = [NSArray array];
    NSArray *infoArr = [NSArray array];
    titleArr = @[@"助剂定制分类:",@"定制助剂名称:"];
    infoArr = @[[self judgeStr:json[@"className"]],    //助剂定制分类
                [self judgeStr:json[@"zhujiName"]]     //助剂名称
                ];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        ZhuJiDiyDetailInfoModel *model = [[ZhuJiDiyDetailInfoModel alloc] init];
        model.leftText = titleArr[i];
        model.rightText = infoArr[i];
        [(NSMutableArray *)self.infoDataSource[0] addObject:model];
    }
    
    //纺织品属性
    titleArr = @[@"材质(基材):",@"成品用途:",@"环保要求:"];
    infoArr = @[[self judgeStr:json[@"material"]],    //材质
                [self judgeStr:json[@"purpose"]],      //用途
                [self judgeStr:json[@"requirement"]]   //环保要求
                ];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        ZhuJiDiyDetailInfoModel *model = [[ZhuJiDiyDetailInfoModel alloc] init];
        model.leftText = titleArr[i];
        model.rightText = infoArr[i];
        [(NSMutableArray *)self.infoDataSource[1] addObject:model];
    }


    //染整工艺要求
    titleArr = @[@"工作浴PH值:",@"处理工艺:",@"染色温度:"];
    infoArr = @[[self judgeStr:json[@"pH"]],    //ph值
                [self judgeStr:json[@"treatmentProcess"]],      //处理工艺
                [self judgeStr:json[@"temperature"]]   //温度
                ];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        ZhuJiDiyDetailInfoModel *model = [[ZhuJiDiyDetailInfoModel alloc] init];
        model.leftText = titleArr[i];
        model.rightText = infoArr[i];
        [(NSMutableArray *)self.infoDataSource[2] addObject:model];
    }

    //现用产品说明
    titleArr = @[@"现用产品说明:",@"生产厂家:",@"每月用量:",@"定制需求量:"];
    infoArr = @[[self judgeStr:json[@"productName"]],    //现用产品名称
                [self judgeStr:json[@"producer"]],      //产家
                [self judgeStr:json[@"useNumStr"]],   //月用量
                [self judgeStr:json[@"diyNumStr"]]   //定制需求量
                ];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        ZhuJiDiyDetailInfoModel *model = [[ZhuJiDiyDetailInfoModel alloc] init];
        model.leftText = titleArr[i];
        model.rightText = infoArr[i];
        [(NSMutableArray *)self.infoDataSource[3] addObject:model];
    }

    //助剂性能描述
    ZhuJiDiyDetailInfoModel *model = [[ZhuJiDiyDetailInfoModel alloc] init];
    model.leftText = @"";
    model.rightText = [self judgeStr:json[@"description"]];
    [(NSMutableArray *)self.infoDataSource[4] addObject:model];

}

- (NSString *)judgeStr:(NSString *)string {
    if (isRightData(To_String(string))) {
        return To_String(string);
    } else {
        return @"暂无信息";
    }
}
@end
