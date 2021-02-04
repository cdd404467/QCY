//
//  MyAskToBuyAllVC.m
//  QCY
//
//  Created by i7colors on 2018/10/23.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyAskToBuyAllVC.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "CddHUD.h"
#import <MJExtension.h>
#import "MinePageModel.h"
#import <MJRefresh.h>
#import "MyAskToBuyCell.h"
#import "AskToBuyDetailsVC.h"
#import "NoDataView.h"


@interface MyAskToBuyAllVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, copy)NSArray *tempArr;
@property (nonatomic, assign)BOOL isFirstLoad;
@property (nonatomic, assign)int totalNum;
@property (nonatomic, strong)NoDataView *noDataView;
@end

@implementation MyAskToBuyAllVC

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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 40) style:UITableViewStylePlain];
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
                weakself.page++;
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
    NSString *urlString = [NSString stringWithFormat:URL_MYASK_BUY,GET_USER_TOKEN,_buyType,_page,Page_Count];
    if (_isFirstLoad == YES) {
        [CddHUD show:self.view];
    }
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNum = [json[@"totalCount"] intValue];
            weakself.tempArr = [MyAskToBuyModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
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
                NSString *text = @"";
                if ([weakself.buyType isEqualToString:@""]) {
                    text = @"暂无求购数据";
                } else if ([weakself.buyType isEqualToString:@"1"]) {
                    text = @"暂无进行中的求购";
                } else if ([weakself.buyType isEqualToString:@"2"]) {
                    text = @"暂无已采纳的求购";
                } else if ([weakself.buyType isEqualToString:@"3"]) {
                    text = @"暂无已关闭的求购";
                }
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
    return 0.001;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}


//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    DDWeakSelf;
    MyAskToBuyCell *cell = [MyAskToBuyCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    cell.btnClickBlock = ^(NSString * _Nonnull pID) {
        AskToBuyDetailsVC *vc = [[AskToBuyDetailsVC alloc] init];
        vc.buyID = pID;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}


@end
