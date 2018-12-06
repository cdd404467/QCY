//
//  MyAcceptedOfferListVC.m
//  QCY
//
//  Created by i7colors on 2018/10/26.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyAcceptedOfferListVC.h"
#import "MacroHeader.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "CddHUD.h"
#import <MJExtension.h>
#import "MinePageModel.h"
#import <MJRefresh.h>
#import "AskToBuyOfferCell.h"
#import "AskToBuyDetailsVC.h"
#import "NoDataView.h"
#import "UIView+Geometry.h"


@interface MyAcceptedOfferListVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, copy)NSArray *tempArr;
@property (nonatomic, strong)NoDataView *noDataView;
@property (nonatomic, assign)BOOL isFirstLoad;
@property (nonatomic, assign)int totalNum;
@end

@implementation MyAcceptedOfferListVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _isFirstLoad = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav.titleLabel.text = @"买家已接受";
    [self requestData];
}

//初始化数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _dataSource = mArr;
    }
    return _dataSource;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        UIView *headerView = [[UIView alloc] init];
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 6);
        headerView.backgroundColor = View_Color;
        _tableView.tableHeaderView = headerView;
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNum - Page_Count * weakself.page > 0) {
                weakself.page ++;
                [weakself requestData];
            } else {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
    return _tableView;
}

#pragma mark -  网络请求
- (void)requestData {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_MyAccepted_List,User_Token,_page,Page_Count];
    [CddHUD show:self.view];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNum = [json[@"totalCount"] intValue];
            weakself.tempArr = [AskToBuyOfferModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:weakself.tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            
            if (weakself.isFirstLoad == YES) {
                [weakself.view addSubview:weakself.tableView];
                weakself.isFirstLoad = NO;
                if (weakself.dataSource.count <= weakself.totalNum) {
                    [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [weakself.tableView reloadData];
            }
            
            //判断为空
            if (weakself.dataSource.count == 0) {
                NSString *text = @"暂无已接受买家";
                weakself.noDataView = [[NoDataView alloc] init];
                weakself.noDataView.centerY = weakself.view.centerY;
                [weakself.view addSubview:weakself.noDataView];
                weakself.noDataView.noLabel.text = text;
            } else {
                [weakself.noDataView removeFromSuperview];
            }
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

#pragma mark - tableView代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    DDWeakSelf;
    AskToBuyOfferCell *cell = [AskToBuyOfferCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    cell.btnClickBlock = ^(NSString * _Nonnull pID) {
        AskToBuyDetailsVC *vc = [[AskToBuyDetailsVC alloc] init];
        vc.buyID = pID;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}


@end
