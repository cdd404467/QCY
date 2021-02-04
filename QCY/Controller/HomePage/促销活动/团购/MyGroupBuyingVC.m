//
//  MyGroupBuyingVC.m
//  QCY
//
//  Created by i7colors on 2019/7/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyGroupBuyingVC.h"
#import "ClassTool.h"
#import "CddHUD.h"
#import <MJRefresh.h>
#import "NetWorkingPort.h"
#import "GroupBuyingModel.h"
#import "MyGroupBuyingTBCell.h"
#import "GroupBuyBargainVC.h"
#import "GroupBuyingDetailVC.h"
#import <UIScrollView+EmptyDataSet.h>

@interface MyGroupBuyingVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation MyGroupBuyingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我参与的团购";
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = Like_Color;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, Bottom_Height_Dif, 0);
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

//加载更多
- (void)requestData {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_MyGroupBuying_List,User_Token,self.pageNumber,Page_Count];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNumber = [json[@"totalCount"] intValue];
            NSArray *tempArr = [GroupBuyingModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无记录";
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupBuyingModel *model = self.dataSource[indexPath.row];
    //可以砍价
    if ([model.isCutPrice integerValue] == 1) {
        GroupBuyBargainVC *vc = [[GroupBuyBargainVC alloc] init];
        vc.infoDataSource = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //不可以砍价，去团购详情
    else {
        GroupBuyingDetailVC *vc = [[GroupBuyingDetailVC alloc] init];
        vc.groupID = model.groupID;
        vc.productName = model.productName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyGroupBuyingTBCell *cell = [MyGroupBuyingTBCell cellWithTableView:tableView];
    cell.style = @"group";
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}

@end
