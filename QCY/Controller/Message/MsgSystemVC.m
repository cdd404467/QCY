//
//  MsgSystemVC.m
//  QCY
//
//  Created by i7colors on 2018/11/15.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MsgSystemVC.h"
#import "MacroHeader.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "UIDevice+UUID.h"
#import "SystemCell.h"
#import "MessageModel.h"
#import <MJRefresh.h>
#import <UITableView+FDTemplateLayoutCell.h>



#define Child_Height SCREEN_HEIGHT - NAV_HEIGHT - 86 - TABBAR_HEIGHT
@interface MsgSystemVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)int page;
@property (nonatomic, assign)int totalNum;
@end

@implementation MsgSystemVC

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Child_Height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
//            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SystemCell class] forCellReuseIdentifier:@"SystemCell"];
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

- (void)requestData {
    DDWeakSelf;
    //    [CddHUD show];
//    NSString *deviceID = [UIDevice getDeviceID];
    NSString *deviceID = @"E110C417-3C6B-49C4-B8F4-97ED1B3800EF";
    NSString *urlString = [NSString stringWithFormat:URL_System_Msg_List,_page,Page_Count,deviceID];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            NSArray *tempArr = [MessageModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
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

//估算高度
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return 200;
//}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"SystemCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        // 配置 cell 的数据源，和 "cellForRow" 干的事一致，比如：
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SystemCell *cell = [SystemCell cellWithTableView:tableView];
    [self configureCell:cell atIndexPath:indexPath];
//    cell.model = _dataSource[indexPath.row];
    return cell;
}

- (void)configureCell:(SystemCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
//    if (indexPath.row % 2 == 0) {
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    cell.entity = self.feedEntitySections[indexPath.section][indexPath.row];
    
    cell.model = _dataSource[indexPath.row];
}

@end
