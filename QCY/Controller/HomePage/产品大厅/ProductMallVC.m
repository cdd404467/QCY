//
//  ProductMallVC.m
//  QCY
//
//  Created by i7colors on 2018/9/25.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProductMallVC.h"
#import "MacroHeader.h"
#import "ProductMallVC_Cell.h"
#import "ProductDetailsVC.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "OpenMallModel.h"
#import "CddHUD.h"

@interface ProductMallVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, copy)NSString *productName;
@property (nonatomic, assign)BOOL isFirstLoad;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, copy)NSArray *tempArr;
@end

@implementation ProductMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _productName = @"";
    _page = 1;
    _isFirstLoad = YES;
    self.title = @"产品大厅";
    
    [self requestData];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消垂直滚动条
        _tableView.showsVerticalScrollIndicator = NO;
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
                [weakself requestData];
            }
        }];
        
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

- (void)requestData {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mDict setObject:@"desc" forKey:@"is_display_price"];
    [mDict setObject:@"desc" forKey:@"price"];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *urlString = [NSString stringWithFormat:URL_Product_List,_page,Page_Count,_productName];
    NSString *parameter = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:mDict options:0 error:nil] encoding:NSUTF8StringEncoding];
    parameters[@"orderCond"] = parameter;
    [CddHUD show];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:[parameters copy] Success:^(id json) {
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.tempArr  = [ProductInfoModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:weakself.tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            if (weakself.isFirstLoad == YES) {
                [weakself.view addSubview:weakself.tableView];
            } else {
                [weakself.tableView reloadData];
            }
            
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
    return 126;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailsVC *vc = [[ProductDetailsVC alloc] init];
    ProductInfoModel *model = _dataSource[indexPath.row];
    vc.productID = model.productID;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductMallVC_Cell *cell = [ProductMallVC_Cell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    return cell;
}


@end
