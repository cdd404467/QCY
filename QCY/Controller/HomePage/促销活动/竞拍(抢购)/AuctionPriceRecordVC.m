//
//  AuctionPriceRecordVC.m
//  QCY
//
//  Created by i7colors on 2019/3/7.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AuctionPriceRecordVC.h"
#import <YNPageTableView.h>
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "AuctionModel.h"
#import "AuctionPriceRecordCell.h"
#import "UIView+Border.h"
#import <MJRefresh.h>

@interface AuctionPriceRecordVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)int totalNum;
@end

@implementation AuctionPriceRecordVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
//        _isFirstLoad = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"joinAuctionNFC" object:nil];
    [self.view addSubview:self.tableView];
    [self requestData];;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.separatorColor = LineColor;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 18, 0, 18);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            //            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
        
        _tableView.tableFooterView = [[UIView alloc] init];
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
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


#pragma mark - 网络请求
- (void)requestData {
    
    NSString *urlString = urlString = [NSString stringWithFormat:URL_Auction_PriceRecord,_jpID,_page,Page_Count];
    //    [CddHUD show];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNum = [json[@"totalCount"] intValue];
            NSArray *tempArr = [AuctionRecordModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
        }
//        [weakself.tableView reloadData];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
    
}

- (void)refreshData {
    _page = 1;
    NSString *urlString = urlString = [NSString stringWithFormat:URL_Auction_PriceRecord,_jpID,_page,Page_Count];
    //    [CddHUD show];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        //                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [weakself.dataSource removeAllObjects];
            weakself.totalNum = [json[@"totalCount"] intValue];
            NSArray *tempArr = [AuctionRecordModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
        }
        //        [weakself.tableView reloadData];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

#pragma mark - UITableView代理
//section header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 80;
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

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    header.backgroundColor = Cell_BGColor;

    UILabel *headerName = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 40)];
    NSString *text = @"抢购记录";
    headerName.text = text;
    headerName.textAlignment = NSTextAlignmentCenter;
    headerName.textColor = HEXColor(@"#818181", 1);
    headerName.font = [UIFont systemFontOfSize:14];
    headerName.backgroundColor = [UIColor whiteColor];
    [header addSubview:headerName];


    UIView *navBg = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 30)];
    navBg.backgroundColor = HEXColor(@"#F7F7F7", 1);
    [header addSubview:navBg];
    [navBg addBorderView:LineColor width:.5f direction:BorderDirectionTop];

    CGFloat width1 = SCREEN_WIDTH * 0.25;
    CGFloat width2 = SCREEN_WIDTH * 0.25;
    CGFloat width3 = SCREEN_WIDTH * 0.25;
    CGFloat width4 = SCREEN_WIDTH * 0.25;
    CGFloat height = 30;

    NSArray *titleArr = @[@"手机号",@"地区",@"价格",@"时间"];
    for (NSInteger i = 0; i < 4; i++) {
        UILabel *title = [[UILabel alloc] init];
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = HEXColor(@"#818181", 1);
        title.text = titleArr[i];
        title.font = [UIFont systemFontOfSize:13];
        [navBg addSubview:title];

        if (i == 0) {
            title.frame = CGRectMake(0, 0, width1, height);
        } else if (i == 1) {
            title.frame = CGRectMake(width1 , 0, width2, height);
        } else if (i == 2) {
            title.frame = CGRectMake(width1 + width2, 0, width3, height);
        } else {
            title.frame = CGRectMake(width1 + width2 + width3, 0, width4, height);
        }
    }

    return header;
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AuctionPriceRecordCell *cell = [AuctionPriceRecordCell cellWithTableView:tableView];
    cell.index = indexPath.row;
    cell.model = _dataSource[indexPath.row];
    return cell;
    
}


- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
