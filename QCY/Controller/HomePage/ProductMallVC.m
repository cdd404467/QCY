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
#import "WRNavigationBar.h"
#import "ProductDetailsVC.h"

@interface ProductMallVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ProductMallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品大厅";
    [self wr_setNavBarTintColor:[UIColor blackColor]];
    [self.view addSubview:self.tableView];
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
        //        _tableView.tableHeaderView = [self addHeaderView];
    }
    return _tableView;
}

#pragma mark - tableView代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 500;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailsVC *vc = [[ProductDetailsVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductMallVC_Cell *cell = [ProductMallVC_Cell cellWithTableView:tableView];
    return cell;
}


@end
