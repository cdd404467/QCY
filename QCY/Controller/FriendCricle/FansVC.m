//
//  FansVC.m
//  QCY
//
//  Created by i7colors on 2018/12/5.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FansVC.h"
#import "MacroHeader.h"
#import <YNPageTableView.h>
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "FansCell.h"
#import "FriendCricleModel.h"
#import <UIScrollView+EmptyDataSet.h>

@interface FansVC ()<UITableViewDataSource, UITableViewDelegate ,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)int page;
@end

@implementation FansVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
    }
    return self;
}

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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = RGBA(225, 225, 225, 1);
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,14, 0, 0)];

        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        
        
        //        DDWeakSelf;
        //        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //            weakself.page++;
        //            if ( weakself.tempArr.count < Page_Count) {
        //                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        //
        //            } else {
        //                [weakself requestData];
        //            }
        //        }];
    }
    return _tableView;
}

#pragma mark - w获取数据
- (void)requestData {
    DDWeakSelf;
    
    if ([weakself.ofType isEqualToString:@"mine"]) {
        NSString *urlString = [NSString stringWithFormat:URL_My_Fans_List,User_Token,_page,Page_Count];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                                            NSLog(@"---- %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                NSArray *tempArr = [FriendCricleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [weakself.dataSource addObjectsFromArray:tempArr];
                [weakself.tableView reloadData];
            }
            
        } Failure:^(NSError *error) {
            NSLog(@" Error : %@",error);
        }];
    } else {
        NSString *urlString = [NSString stringWithFormat:URL_Fans_List,_page,Page_Count,_userID];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
            //                                NSLog(@"---- %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                NSArray *tempArr = [FriendCricleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [weakself.dataSource addObjectsFromArray:tempArr];
                [weakself.tableView reloadData];
            }
            
        } Failure:^(NSError *error) {
            NSLog(@" Error : %@",error);
        }];
    }
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无粉丝";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#708090", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark - UITableView代理
//section header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

//section footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FansCell *cell = [FansCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}

@end
