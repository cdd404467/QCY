//
//  OpenMallVC.m
//  QCY
//
//  Created by i7colors on 2018/9/17.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "OpenMallVC.h"
#import "MacroHeader.h"
#import "OpenMallVC_Cell.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "ClassTool.h"
#import "OpenMallModel.h"
#import <MJRefresh.h>
#import "ShopMainPageVC.h"


@interface OpenMallVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)int page;
@property (nonatomic, assign)BOOL isFirstLoad;
@property (nonatomic, copy)NSArray *tempArr;
@end

@implementation OpenMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirstLoad = YES;
    _page = 1;
    self.title = @"开放商城";
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消垂直滚动条
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakself.page++;
            if ( weakself.tempArr.count < Page_Count) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];

            } else {
                [weakself requestData];
            }
        }];
    }
    return _tableView;
}


#pragma mark - 获取列表
- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URL_Shop_List,_page,Page_Count];
    if (_isFirstLoad == YES) {
        [CddHUD show];
    }
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD];
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.tempArr  = [OpenMallModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            for (OpenMallModel *model in weakself.tempArr) {
                model.businessList = [BusinessList mj_objectArrayWithKeyValuesArray:model.businessList];
            }
            
            [weakself.dataSource addObjectsFromArray:weakself.tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            if (weakself.isFirstLoad == YES) {
                [weakself.view addSubview:weakself.tableView];
            } else {
                [weakself.tableView reloadData];
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
    return 125;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopMainPageVC *vc = [[ShopMainPageVC alloc] init];
    OpenMallModel *model = _dataSource[indexPath.row];
    vc.storeID = model.storeID;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OpenMallVC_Cell *cell = [OpenMallVC_Cell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
