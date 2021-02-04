//
//  FriendCircleRecordVC.m
//  QCY
//
//  Created by i7colors on 2018/12/5.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FriendCircleRecordVC.h"
#import <YNPageTableView.h>
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "FCRecordCell.h"
#import "FriendCircleDetailVC.h"
#import "FriendCricleModel.h"
#import <UIScrollView+EmptyDataSet.h>
#import <MJRefresh.h>
#import "InfomationDetailVC.h"


@interface FriendCircleRecordVC ()<UITableViewDataSource, UITableViewDelegate ,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, assign)int totalNum;
@end

@implementation FriendCircleRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        DDWeakSelf;
        //        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //            if (weakself.totalNum - Page_Count * weakself.page > 0) {
        //                weakself.page++;
        //                [weakself requestData];
        //            } else {
        //                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        //            }
        //        }];
    }
    return _tableView;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无印染圈记录";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#708090", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark - UITableView代理

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCricleModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCircleDetailVC *vc = [[FriendCircleDetailVC alloc] init];
    FriendCricleModel *model = _dataSource[indexPath.row];
    vc.tieziID = model.tieziID;
    [self.navigationController pushViewController:vc animated:YES];
}

//给出cell的估计高度，主要目的是优化cell高度的计算次数
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCricleModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCRecordCell *cell = [FCRecordCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}


@end
