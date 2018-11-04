//
//  MyAskBuyListVC.m
//  QCY
//
//  Created by i7colors on 2018/10/25.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyAskBuyListVC.h"
#import <Masonry.h>
#import "NetWorkingPort.h"
#import "MacroHeader.h"
#import <MJRefresh.h>
#import "MyAskToBuyCell.h"
#import "CddHUD.h"
#import "ClassTool.h"
#import <MJExtension.h>
#import "MinePageModel.h"
#import "AskToBuyDetailsVC.h"

@interface MyAskBuyListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSArray *tempArr;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)NSInteger page;

@end

@implementation MyAskBuyListVC {
    NSString *_urlString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    if (_listType == 0) {
        self.nav.titleLabel.text = @"求购中";
        _urlString = URL_MyAsking_List;
    } else if (_listType == 1) {
        self.nav.titleLabel.text = @"待确认报价";
        _urlString = URL_NeedAffirmList;
    } else {
        self.nav.titleLabel.text = @"即将过期";
        _urlString = URL_WillPast_List;
    }
    
    [self requestList];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = View_Color;
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakself.page++;
            if ( weakself.tempArr.count < Page_Count) {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                
            } else {
                [weakself requestList];
            }
        }];
    } else {
        [_tableView reloadData];
    }
    return _tableView;
}

#pragma mark - 网络请求
- (void)requestList {
    NSString *urlString = [NSString stringWithFormat:_urlString,GET_USER_TOKEN,_page,Page_Count];
    DDWeakSelf;
    [CddHUD show];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.tempArr = [MyAskToBuyModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:weakself.tempArr];
            [weakself.view addSubview:weakself.tableView];
            [weakself.tableView.mj_footer endRefreshing];
        }
        [CddHUD hideHUD];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    DDWeakSelf;
    MyAskToBuyCell *cell = [MyAskToBuyCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    cell.btnClickBlock = ^(NSString * _Nonnull pID) {
        AskToBuyDetailsVC *vc = [[AskToBuyDetailsVC alloc] init];
        vc.buyID = pID;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}


@end
