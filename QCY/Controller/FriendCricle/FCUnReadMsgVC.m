//
//  FCUnReadMsgVC.m
//  QCY
//
//  Created by i7colors on 2018/12/17.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCUnReadMsgVC.h"
#import "MacroHeader.h"
#import "FCUnReadMsgCell.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "FriendCricleModel.h"
#import "FriendCircleDetailVC.h"

@interface FCUnReadMsgVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)int page;
@end

@implementation FCUnReadMsgVC

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
    self.nav.titleLabel.text = @"未读消息";
    [self requestFriendList];
    [self.view addSubview:self.tableView];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.separatorColor = RGBA(204, 204, 204, 1);
        _tableView.separatorInset = UIEdgeInsetsZero;
        //取消垂直滚动条
        _tableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
//        DDWeakSelf;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            weakself.isRefresh = YES;
//            weakself.page = 1;
//            [weakself requestDataFirstIn];
//        }];
//
//        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            if (weakself.totalNum - Page_Count * weakself.page > 0) {
//                weakself.page++;
//                [weakself requestFriendList];
//            } else {
//                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }];
    }
    return _tableView;
}

- (void)requestFriendList {
    
    NSString *urlString = [NSString stringWithFormat:URL_UnRead_MsgList,User_Token,_page,Page_Count];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            NSArray *tempArr = [CommentListModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            if (weakself.removeUnreadViewBlock) {
                weakself.removeUnreadViewBlock();
            }
            [weakself.tableView reloadData];
        }
//        [weakself.tableView.mj_footer endRefreshing];
//        [weakself.tableView.mj_header endRefreshing];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

//section的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

//section的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCircleDetailVC *vc = [[FriendCircleDetailVC alloc] init];
    vc.tieziID = [_dataSource[indexPath.row] dyeId];
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCUnReadMsgCell *cell = [FCUnReadMsgCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

@end
