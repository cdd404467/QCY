//
//  AuctionVC.m
//  QCY
//
//  Created by i7colors on 2019/3/4.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AuctionVC.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import <MJRefresh.h>
#import "CddHUD.h"
#import "AuctionTBCell.h"
#import "AuctionModel.h"
#import "PromotionsHeaderView.h"
#import "AuctionDetailVC.h"


@interface AuctionVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, assign)int totalNum;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NSMutableArray *bannerDataSource;
@end

@implementation AuctionVC

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
    
    self.title = @"抢购";
    [self loadData];
}

//初始化数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _dataSource = mArr;
    }
    return _dataSource;
}

- (NSMutableArray *)bannerDataSource {
    if (!_bannerDataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _bannerDataSource = mArr;
    }
    return _bannerDataSource;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = HEXColor(@"#e5e5e5", 1);
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, Bottom_Height_Dif, 0);
//        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        
        PromotionsHeaderView *header = [[PromotionsHeaderView alloc] init];
        header.bannerArray = [_bannerDataSource copy];
        header.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(144));
        _tableView.tableHeaderView = header;
        DDWeakSelf;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            weakself.page = 1;
//
//        }];
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

#pragma mark -  首次进入请求
- (void)loadData {
    DDWeakSelf;
    [CddHUD show:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    //第一个线程获取banner
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Get_Banner,@"App_Auction_Info"];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//                NSLog(@"---- %@",json);
                NSArray *bannerArr = [PromotionsModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                for (PromotionsModel *model in bannerArr) {
                    [weakself.bannerDataSource addObject:ImgUrl(model.ad_image)];
                }
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            NSLog(@" Error : %@",error);
            dispatch_group_leave(group);
        }];
    });
    
    //第二个线程，获取列表
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Auction_List,weakself.page,Page_Count];
        DDWeakSelf;
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
            //        [CddHUD hideHUD:weakself.view];
            [weakself.tableView.mj_footer endRefreshing];
//            NSLog(@"----== %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                weakself.totalNum = [json[@"totalCount"] intValue];
                NSArray *tempArr = [AuctionModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [weakself.dataSource addObjectsFromArray:tempArr];
                [weakself.tableView reloadData];
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            dispatch_group_leave(group);
            NSLog(@" Error : %@",error);
        }];
    });
    
    //全部任务完成后，就可以在这吊了
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.view addSubview:weakself.tableView];
            [CddHUD hideHUD:weakself.view];
        });
    });
    
}

//获取数据
- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URL_Auction_List,_page,Page_Count];
    DDWeakSelf;
//    [CddHUD show:self.view];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                [CddHUD hideHUD:weakself.view];
        [weakself.tableView.mj_footer endRefreshing];
//        NSLog(@"----== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNum = [json[@"totalCount"] intValue];
            NSArray *tempArr = [AuctionModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView reloadData];
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
    return [(AuctionModel *)self.dataSource[indexPath.row] cellHeight];
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AuctionDetailVC *vc = [[AuctionDetailVC alloc] init];
    vc.jpID = [_dataSource[indexPath.row] jpID];
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AuctionTBCell *cell = [AuctionTBCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    return cell;
}


@end
