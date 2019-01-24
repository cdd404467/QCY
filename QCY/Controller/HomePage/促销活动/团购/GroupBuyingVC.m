//
//  GroupBuyingVC.m
//  QCY
//
//  Created by i7colors on 2018/10/10.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GroupBuyingVC.h"
#import "CommonNav.h"
#import "MacroHeader.h"
#import "ClassTool.h"
#import "CddHUD.h"
#import <MJRefresh.h>
#import "NetWorkingPort.h"
#import "PromotionsHeaderView.h"
#import "GroupBuyingCell.h"
#import "GroupBuyingModel.h"
#import <MJExtension.h>
#import "GroupBuyingDetailVC.h"


@interface GroupBuyingVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NSMutableArray *bannerDataSource;
@property (nonatomic, copy)NSArray *bannerArr;
@property (nonatomic, copy)NSArray *tempArr;
@property (nonatomic, assign)BOOL isFirstLoad;
@property (nonatomic, assign)int totalNum;
@end

@implementation GroupBuyingVC

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
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self setNavBar];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setNavBar {
    CommonNav *nav = [[CommonNav alloc] init];
    nav.titleLabel.text = @"七彩云团购惠";
    [nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nav];
}


//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }

        PromotionsHeaderView *header = [[PromotionsHeaderView alloc] init];
        header.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(144));
        header.bannerArray = [_bannerDataSource copy];
        _tableView.tableHeaderView = header;
        
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

#pragma mark -  首次进入请求
- (void)loadData {
    DDWeakSelf;
    [CddHUD show:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    //第一个线程获取banner
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Get_Banner,@"XCX_Group_Buy"];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//                 NSLog(@"---- %@",json);
                weakself.bannerArr = [PromotionsModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                for (PromotionsModel *model in weakself.bannerArr) {
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
        NSString *urlString = [NSString stringWithFormat:URL_GroupBuying_List,weakself.page,Page_Count];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
            [CddHUD hideHUD:weakself.view];
//                            NSLog(@"---- %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                weakself.totalNum = [json[@"totalCount"] intValue];
                weakself.tempArr = [GroupBuyingModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [weakself.dataSource addObjectsFromArray:weakself.tempArr];

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

//加载更多
- (void)requestData {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_GroupBuying_List,_page,Page_Count];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {

//                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNum = [json[@"totalCount"] intValue];
            weakself.tempArr = [GroupBuyingModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:weakself.tempArr];
            [weakself.tableView.mj_footer endRefreshing];
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
    return 181;
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
    GroupBuyingDetailVC *vc = [[GroupBuyingDetailVC alloc] init];
    GroupBuyingModel *model = _dataSource[indexPath.row];
    vc.groupID = model.groupID;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupBuyingCell *cell = [GroupBuyingCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
