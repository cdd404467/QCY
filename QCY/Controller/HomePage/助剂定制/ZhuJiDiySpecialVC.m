//
//  ZhuJiDiySpecialVC.m
//  QCY
//
//  Created by i7colors on 2019/10/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ZhuJiDiySpecialVC.h"
#import <MJRefresh.h>
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "CddHUD.h"
#import "ZhuJiDiyModel.h"
#import "HelperTool.h"
#import "ZhuJiDiySpecialCell.h"
#import "ZhuJiDiyVC.h"


@interface ZhuJiDiySpecialVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)BaseTableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation ZhuJiDiySpecialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"助剂定制专场";
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

//懒加载tableView
- (BaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = Cell_BGColor;
        //取消垂直滚动条
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, Bottom_Height_Dif, 0);
//        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNumber - Page_Count * weakself.pageNumber > 0) {
                weakself.pageNumber++;
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
    NSString *urlString = [NSString stringWithFormat:URL_Get_ZhuJiDiySpecialList,User_Token,self.pageNumber,Page_Count];
    if (self.pageNumber == 1) {
        [CddHUD show:self.view];
    }
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD:self.view];
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//                        NSLog(@"--- %@",json);
            weakself.totalNumber = [json[@"totalCount"] intValue];
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                if (weakself.pageNumber == 1) {
                    [weakself.dataSource removeAllObjects];
                }
                NSArray *tempArr = [ZhuJiDiySpecialModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [weakself.dataSource addObjectsFromArray:tempArr];
                [weakself.tableView.mj_footer endRefreshing];
                [weakself.tableView reloadData];
            }
        }
        [CddHUD hideHUD:weakself.view];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

#pragma mark - tableView代理方法
//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

//cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZhuJiDiyVC *vc = [[ZhuJiDiyVC alloc] init];
    ZhuJiDiySpecialModel *model = _dataSource[indexPath.row];
    vc.specialID = model.specialID;
    vc.bannerURL = model.mobileBanner;
    vc.specialCompanyName = model.name;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZhuJiDiySpecialCell *cell = [ZhuJiDiySpecialCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    return cell;
}

@end
