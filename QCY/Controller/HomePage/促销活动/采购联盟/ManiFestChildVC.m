//
//  ManiFestChildVC.m
//  QCY
//
//  Created by i7colors on 2019/1/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ManiFestChildVC.h"
#import "MacroHeader.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "CddHUD.h"
#import <MJRefresh.h>
#import "PrchaseLeagueModel.h"
#import "ManifestScetionHeader.h"
#import "ManifestScetionFooter.h"
#import "ManifestCell.h"
#import "ManifestSupplyCell.h"

@interface ManiFestChildVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)BOOL isFirstLoad;
@property (nonatomic, assign)int totalNum;
@end

@implementation ManiFestChildVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        
        _isFirstLoad = YES;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - 40 - Bottom_Height_Dif) style:UITableViewStylePlain];
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
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
//        DDWeakSelf;
//        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            if (weakself.totalNum - Page_Count * weakself.page > 0) {
//                weakself.page++;
////                [weakself requestData];
//            } else {
//                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }];
    }
    return _tableView;
}

- (void)requestData {
    DDWeakSelf;
    NSString *urlString = [NSString string];
    if ([_listType isEqualToString:@"cg"]) {
        urlString = [NSString stringWithFormat:URL_My_Ordergoods_list,@"0",_phoneNumber,_page,Page_Count];
    } else {
        urlString = [NSString stringWithFormat:URL_My_Ordergoods_list,@"1",_phoneNumber,_page,Page_Count];
    }
    if (_isFirstLoad == YES) {
        [CddHUD show:self.view];
    }
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNum = [json[@"totalCount"] intValue];
            NSArray *tempArr = [PrchaseLeagueModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            for (PrchaseLeagueModel *model in tempArr) {
                model.meetingShopList = [MeetingShopListModel mj_objectArrayWithKeyValuesArray:model.meetingShopList];
                for (MeetingShopListModel *sModel in model.meetingShopList) {
                    sModel.meetingTypeList = [MeetingTypeListModel mj_objectArrayWithKeyValuesArray:sModel.meetingTypeList];
                }
            }
            
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.view addSubview:weakself.tableView];
            
//            [weakself.tableView.mj_footer endRefreshing];

//            if (weakself.isFirstLoad == YES) {
//                [weakself.view addSubview:weakself.tableView];
//                weakself.isFirstLoad = NO;
//                if (weakself.dataSource.count <= weakself.totalNum) {
//                    [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
//                }
//            } else {
//                [weakself.tableView reloadData];
//            }
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

#pragma mark - tableView代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_dataSource[section] isOpen]) {
        return [[_dataSource[section] meetingShopList] count];
    } else {
        return 0;
    }
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrchaseLeagueModel *ds= self.dataSource[indexPath.section];
    MeetingShopListModel *model = ds.meetingShopList[indexPath.row];
    return model.cellHeight;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ManifestScetionHeader *header = [ManifestScetionHeader headerWithTableView:tableView];
    DDWeakSelf;
    header.rightBtnClick = ^(BOOL isOpen) {
        [weakself.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    header.model = _dataSource[section];
    return header;
}

//自定义的section footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ManifestScetionFooter *footer = [ManifestScetionFooter footerWithTableView:tableView];
    footer.model = _dataSource[section];
    
    return footer;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrchaseLeagueModel *model = _dataSource[indexPath.section];
    if ([_listType isEqualToString:@"cg"]) {
        ManifestCell *cell = [ManifestCell cellWithTableView:tableView];
        cell.model = model.meetingShopList[indexPath.row];
        
        return cell;
    } else {
        ManifestSupplyCell *cell = [ManifestSupplyCell cellWithTableView:tableView];
        cell.model = model.meetingShopList[indexPath.row];
        
        return cell;
    }
}

@end
