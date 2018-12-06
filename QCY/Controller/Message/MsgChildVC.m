//
//  MsgChildVC.m
//  QCY
//
//  Created by i7colors on 2018/11/14.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MsgChildVC.h"
#import "MacroHeader.h"
#import <MJRefresh.h>
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "MessageModel.h"
#import "MessageCell.h"
#import "MsgDetaiiVC.h"
#import "NoDataView.h"
#import "UIView+Geometry.h"

#define Child_Height SCREEN_HEIGHT - NAV_HEIGHT - 86 - TABBAR_HEIGHT
@interface MsgChildVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, assign)int totalNum;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NoDataView *noDataView;
@end

@implementation MsgChildVC

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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Child_Height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNum - Page_Count * weakself.page > 0) {
                weakself.page++;
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

//初始化数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _dataSource = mArr;
    }
    return _dataSource;
}

#pragma mark - 请求列表
- (void)requestData {
    DDWeakSelf;
//    [CddHUD show];
    NSString *urlString = [NSString stringWithFormat:URL_AskBuy_Msg_List,User_Token,_type,_page,Page_Count];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            NSArray *tempArr = [MessageModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
        }
        
        
        //判断为空
        if (weakself.dataSource.count == 0) {
            NSString *text = @"暂无消息";
            weakself.noDataView = [[NoDataView alloc] init];
            weakself.noDataView.centerY = weakself.view.centerY;
            [weakself.view addSubview:weakself.noDataView];
            weakself.noDataView.noLabel.text = text;
            
        } else {
            [weakself.noDataView removeFromSuperview];
        }
        
        
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
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
    
    return 86;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgDetaiiVC *vc = [[MsgDetaiiVC alloc] init];
    MessageModel *model = _dataSource[indexPath.row];
    vc.msgID = model.detailID;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}

@end
