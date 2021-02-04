//
//  MsgSystemVC.m
//  QCY
//
//  Created by i7colors on 2018/11/15.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MsgSystemVC.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "UIDevice+UUID.h"
#import "SystemCell.h"
#import "MessageModel.h"
#import <MJRefresh.h>
#import "WebViewVC.h"
#import "VCJump.h"
#import <UIScrollView+EmptyDataSet.h>
#import <JPUSHService.h>

#define Child_Height SCREEN_HEIGHT - NAV_HEIGHT - 80 - TABBAR_HEIGHT
@interface MsgSystemVC ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation MsgSystemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self requestData];
    
    //子页面全部刷新,登录或退出登录刷新
    NSString *nfcNameAll = @"refreshAllDataWithThis";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:nfcNameAll object:nil];

    //收到通知刷新列表
    NSString *refresh = @"app_msg_nfc_refresh";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:refresh object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DDWeakSelf;
    if ([SingleShareManger shareInstance].msgIndex == 2) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself setMsg];
        });
    }
}

- (void)setMsg {
    Msg_Sys_Count_Set(0);
    //消息的tabbar的本地存储
    Tabbar_Msg_Badge_Set(Msg_Buyer_Count_Get + Msg_Seller_Count_Get + Msg_Sys_Count_Get);
    //设置tabbar
    Tab_BadgeValue_2(Count_For_Tabbar(Tabbar_Msg_Badge_Get));
    //发通知改变按钮上的数量
    [[NSNotificationCenter defaultCenter] postNotificationName:App_Notification_Change_MsgCount object:nil];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Child_Height) style:UITableViewStylePlain];
        _tableView.backgroundColor = View_Color;
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
            weakself.isRefreshList = YES;
            weakself.pageNumber = 1;
            [weakself requestData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNumber - Page_Count * weakself.pageNumber > 0) {
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
    NSString *title = @"暂无系统消息";
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

- (void)requestData {
    DDWeakSelf;
    //    [CddHUD show];
    NSString *deviceID = [UIDevice getDeviceID];
    NSString *urlString = [NSString stringWithFormat:URL_System_Msg_List,self.pageNumber,Page_Count,deviceID];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//        NSLog(@"---- %@",json);
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
//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

//估算高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = self.dataSource[indexPath.row];
    if ([model.type isEqualToString:@"inner"]) {
        [VCJump jumpToWithModel_SysMsgs:model];
    } else if ([model.type isEqualToString:@"html"]) {
        WebViewVC *vc = [[WebViewVC alloc] init];
        vc.needBottom = NO;
        vc.webUrl = model.url;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SystemCell *cell = [SystemCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
