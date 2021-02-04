//
//  MyZhuJiDiyChildVC.m
//  QCY
//
//  Created by i7colors on 2019/8/7.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyZhuJiDiyChildVC.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "CddHUD.h"
#import <MJRefresh.h>
#import "ZhuJiDiyModel.h"
#import "ZhuJiDiyCell.h"
#import "ZhuJiDiyDetailVC.h"
#import <UIScrollView+EmptyDataSet.h>

@interface MyZhuJiDiyChildVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation MyZhuJiDiyChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
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
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNumber - Page_Count * weakself.pageNumber > 0) {
                weakself.pageNumber++;
                [weakself requestData];
            } else {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
    return _tableView;
}

- (void)requestData {
    DDWeakSelf;
    NSString *urlString = [NSString string];
    if (_type.integerValue == 0) {
        urlString = [NSString stringWithFormat:URLGet_MyZhuJiDiy_List,User_Token,_status,self.pageNumber,Page_Count];
    } else if (_type.integerValue == 1) {
        urlString = [NSString stringWithFormat:URLGet_MyZhuJiDiy_SolutionList,User_Token,_status,self.pageNumber,Page_Count];
    }
    
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            //            NSLog(@"--- %@",json);
            weakself.totalNumber = [json[@"totalCount"] intValue];
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                NSArray *tempArr = [ZhuJiDiyModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [weakself.dataSource addObjectsFromArray:tempArr];
                [weakself.tableView.mj_footer endRefreshing];
                [weakself.tableView reloadData];
            }
        }
        [CddHUD hideHUD:weakself.view];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无数据";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#708090", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark - tableView代理方法
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZhuJiDiyDetailVC *vc = [[ZhuJiDiyDetailVC alloc] init];
    ZhuJiDiyModel *model = _dataSource[indexPath.row];
    vc.zhuJiDiyID = model.zhujiDiyID;
    if (_type.integerValue == 0) {
        vc.jumpFrom = @"myZhuJiDiy";
    } else {
        vc.jumpFrom = @"myZhuJiSolution";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZhuJiDiyCell *cell = [ZhuJiDiyCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    return cell;
}

@end
