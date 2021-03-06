//
//  InformationChildVC.m
//  QCY
//
//  Created by i7colors on 2018/11/1.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "InformationChildVC.h"
#import "CommonNav.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "CddHUD.h"
#import <MJRefresh.h>
#import "InformationChildCell.h"
#import "InfomationModel.h"
#import "InfomationDetailVC.h"

@interface InformationChildVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, copy)NSArray *tempArr;
@property (nonatomic, assign)BOOL isFirstLoad;
@end

@implementation InformationChildVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isFirstLoad = YES;
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 40) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            //            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
       
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

#pragma mark -  网络请求
//全部：0  行业资讯：66  人物访谈：89  政策法规：90  展会/会议：91  人才招聘:11
- (void)requestData {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_Infomation_List,_page,Page_Count,_typeID];
    [CddHUD show:self.view];
    
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.tempArr = [InfomationModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:weakself.tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            if (weakself.isFirstLoad == YES) {
                [weakself.view addSubview:weakself.tableView];
                weakself.isFirstLoad = NO;
            } else {
                [weakself.tableView reloadData];
            }
        }
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
    return 116;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    InfomationModel *model = _dataSource[indexPath.row];
    if ([_fromPage isEqualToString:@"pfPage"]) {
        if (self.selectedZXBlock) {
            self.selectedZXBlock(model);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        InfomationDetailVC *vc = [[InfomationDetailVC alloc] init];
        vc.infoID = model.infoID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InformationChildCell *cell = [InformationChildCell cellWithTableView:tableView];
    cell.cellType = _fromPage;
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}

@end
