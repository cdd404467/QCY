//
//  MsgChildVC.m
//  QCY
//
//  Created by i7colors on 2018/11/14.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MsgChildVC.h"
#import <MJRefresh.h>
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "MessageModel.h"
#import "MessageCell.h"
#import "MsgDetaiiVC.h"
#import <UIScrollView+EmptyDataSet.h>
#import <JPUSHService.h>



#define Child_Height SCREEN_HEIGHT - NAV_HEIGHT - 80 - TABBAR_HEIGHT
@interface MsgChildVC ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation MsgChildVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    if (GET_USER_TOKEN)
        [self requestData];
    //子页面全部刷新
    NSString *nfcNameAll = @"refreshAllDataWithThis";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:nfcNameAll object:nil];
    
    //收到通知刷新列表
    NSString *refresh = @"app_msg_nfc_refresh";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:refresh object:nil];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Child_Height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        DDWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self refreshData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNumber - Page_Count * weakself.totalNumber > 0) {
                weakself.pageNumber++;
                weakself.isRefreshList = NO;
                [weakself requestData];
            } else {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
        // 忽略掉底部inset
        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = 40;
    }
    return _tableView;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无消息";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#708090", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

// 如果不实现此方法的话,无数据时下拉刷新不可用
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

//初始化数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _dataSource = mArr;
    }
    return _dataSource;
}

- (void)setMsgWithtype {
    if ([_userType isEqualToString:@"buyer"]) {
        NSInteger bCount = Msg_Buyer_Count_Get - 1 < 0 ? 0 : Msg_Buyer_Count_Get - 1;
        Msg_Buyer_Count_Set(bCount);
    } else if ([_userType isEqualToString:@"seller"]) {
        NSInteger sCount = Msg_Seller_Count_Get - 1 < 0 ? 0 : Msg_Seller_Count_Get - 1;
        Msg_Seller_Count_Set(sCount);
    }
    //消息的tabbar的本地存储
    Tabbar_Msg_Badge_Set(Msg_Buyer_Count_Get + Msg_Seller_Count_Get + Msg_Sys_Count_Get);
    //设置tabbar
    Tab_BadgeValue_2(Count_For_Tabbar(Tabbar_Msg_Badge_Get));
    //发通知改变按钮上的数量
    [[NSNotificationCenter defaultCenter] postNotificationName:App_Notification_Change_MsgCount object:nil];
}

#pragma mark - 请求列表
- (void)requestData {
    if (!GET_USER_TOKEN) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        return;
    }
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URLGet_Buyer_Message,User_Token,_userType,self.pageNumber,Page_Count];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//        NSLog(@"----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNumber = [json[@"totalCount"] intValue];
            if (weakself.isRefreshList == YES) {
                [weakself.dataSource removeAllObjects];
            }
            NSArray *tempArr = [MessageModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView reloadData];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

//刷新
- (void)refreshData {
    self.pageNumber = 1;
    self.isRefreshList = YES;
    [self requestData];
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
    
    return self.dataSource.count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 96;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgDetaiiVC *vc = [[MsgDetaiiVC alloc] init];
    MessageModel *model = self.dataSource[indexPath.row];
    vc.model = model;
    DDWeakSelf;
    vc.alreadyReadBlock = ^(NSString * _Nonnull dID) {
        for (MessageModel *model in weakself.dataSource) {
            if ([model.detailID isEqualToString:dID]) {
                //当这条消息为未读时，进行数量操作
                if ([model.isRead isEqualToString:@"0"]) {
                    [weakself setMsgWithtype];
                    model.isRead = @"1";
                }
                [weakself.tableView reloadData];
            }
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
