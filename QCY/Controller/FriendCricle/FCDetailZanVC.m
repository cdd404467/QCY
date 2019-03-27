//
//  FCDetailZanVC.m
//  QCY
//
//  Created by i7colors on 2018/12/11.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCDetailZanVC.h"
#import "MacroHeader.h"
#import <YNPageTableView.h>
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "FCDetailZanCell.h"
#import "FriendCricleModel.h"
#import <UIScrollView+EmptyDataSet.h>

@interface FCDetailZanVC ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, assign) int page;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)BOOL isRefresh;
@end

@implementation FCDetailZanVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _isRefresh = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addZan:) name:@"zanChange" object:nil];
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

- (void)addZan:(NSNotification *)notification {
    _isRefresh = YES;
    _page = 1;
    [self requestData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,14, 0, 0)];
        _tableView.separatorColor = RGBA(225, 225, 225, 1);
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
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
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TABBAR_HEIGHT)];
        footer.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = footer;
    }
    return _tableView;
}

#pragma mark - 网络请求
- (void)requestData {
    DDWeakSelf;
    //    [CddHUD show:self.view];
    NSString *urlString = [NSString stringWithFormat:URL_Zan_List,_tieziID,_page,Page_Count];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                        NSLog(@"----== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            NSArray *tempArr = [LikeListModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (weakself.isRefresh == YES) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:tempArr];
        }
        
        [weakself.tableView reloadData];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无用户点赞";
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
    
    return 70;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCDetailZanCell *cell = [FCDetailZanCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
