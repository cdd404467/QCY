



//
//  ProductMallVC.m
//  QCY
//
//  Created by i7colors on 2018/9/25.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProductMallVC.h"
#import "ProductMallVC_Cell.h"
#import "ProductDetailsVC.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "OpenMallModel.h"
#import "CddHUD.h"
#import "PYSearch.h"
#import "SearchResultPageVC.h"
#import "BaseNavigationController.h"
#import "UIViewController+BarButton.h"
#import <UMAnalytics/MobClick.h>
#import "UIView+Border.h"
#import "EdgeButton.h"
#import "ProductClassifyView.h"
#import <UIScrollView+EmptyDataSet.h>


@interface ProductMallVC ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, assign)BOOL isFirstLoad;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, copy)NSArray *tempArr;
@property (nonatomic, assign)int totalNum;
@property (nonatomic, strong)UIButton *leftBtn;
@property (nonatomic, strong)UIButton *rightBtn;
@property (nonatomic, strong)NSMutableArray *classifyDataSource;
@property (nonatomic, strong)NSString *eid;
//已经选择的分类
@property (nonatomic, strong)ProductClassifyModel *selectedModel;
@property (nonatomic, strong)NSIndexPath *selectIP;
@end

@implementation ProductMallVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _isFirstLoad = YES;
        _eid = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBar];
    [self requestFirstIn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.title];
}

- (void)setNavBar {
    self.title = @"产品大厅";
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"search"] action:@selector(jumpToSearch)];
}

- (void)jumpToSearch {
    //    NSArray *arr = @[@"阿伦",@"封金能"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"输入关键词搜索" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        SearchResultPageVC *vc = [[SearchResultPageVC alloc]init];
        vc.keyWord = searchText;
        vc.type = @"product";
        [searchViewController.navigationController pushViewController:vc animated:NO];
    }];
    //历史搜索风格
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchViewController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav  animated:NO completion:nil];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = Cell_BGColor;
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
        _tableView.contentInset = UIEdgeInsetsMake(40, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNum - Page_Count * weakself.page > 0) {
                weakself.page ++;
                weakself.isRefreshList = NO;
                [weakself requestData:nil];
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

- (NSMutableArray *)classifyDataSource {
    if (!_classifyDataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _classifyDataSource = mArr;
    }
    return _classifyDataSource;
}


- (void)setupUI {
    [self.view addSubview:self.tableView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 40);
    [self.view addSubview:effectView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"全部产品" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [leftBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [leftBtn setTitleColor:HEXColor(@"#F10215", 1) forState:UIControlStateDisabled];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.backgroundColor = Like_Color;
    leftBtn.alpha = .8;
    leftBtn.enabled = NO;
    leftBtn.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH / 2, 40);
    [self.view addSubview:leftBtn];
    _leftBtn = leftBtn;

    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.backgroundColor = Like_Color;
    rightBtn.alpha = .8;
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    rightBtn.frame = CGRectMake(leftBtn.width, leftBtn.top, leftBtn.width, leftBtn.height);
    [rightBtn setTitle:@"筛选" forState:UIControlStateNormal];
    rightBtn.adjustsImageWhenHighlighted = NO;
    [rightBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [rightBtn setTitleColor:HEXColor(@"#F10215", 1) forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(showRightMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    _rightBtn = rightBtn;
}

//全部按钮点击事件
- (void)leftBtnClick {
    _rightBtn.selected = NO;
    [_rightBtn setTitle:@"筛选" forState:UIControlStateNormal];
    _selectIP = nil;
    _selectedModel = nil;
    
    if (_leftBtn.enabled) {
        _page = 1;
        _eid = @"";
        self.isRefreshList = YES;
        [self requestData:nil];
    }
    _leftBtn.enabled = NO;
}


- (void)showRightMenu {
    ProductClassifyView *view = [[ProductClassifyView alloc] init];
    if (_selectIP)
        view.selectIP = _selectIP;
    
    view.selectModel = _selectedModel;
    view.dataSource = [self.classifyDataSource copy];
    DDWeakSelf;
    view.selectedBlock = ^(ProductClassifyModel * _Nonnull model, NSIndexPath * _Nonnull selectIP) {
        weakself.selectedModel = model;
        //如果选择了筛选条件
        if (model) {
            ProductClassifyModel *secondModel = model.propList[selectIP.row];
            [weakself.rightBtn setTitle:[NSString stringWithFormat:@"%@ · %@",model.typeText,secondModel.value] forState:UIControlStateNormal];
            weakself.rightBtn.selected = YES;
            //如果选择的和上次选择的是一样的，不再重新网络请求
            if (weakself.selectIP != selectIP) {
                weakself.page = 1;
                weakself.eid = secondModel.classifyID;
                weakself.isRefreshList = YES;
                weakself.leftBtn.enabled = YES;
                [weakself requestData:nil];
            }
        } else {
            [weakself.rightBtn setTitle:@"筛选" forState:UIControlStateNormal];
            weakself.leftBtn.enabled = NO;
            weakself.rightBtn.selected = NO;
            weakself.page = 1;
            weakself.eid = @"";
            weakself.isRefreshList = YES;
            [weakself requestData:nil];
            weakself.leftBtn.enabled = NO;
        }
        weakself.selectIP = selectIP;
        
    };
    [view show];
}



- (void)requestData:(dispatch_group_t)group {
    if (self.isRefreshList == YES) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mDict setObject:@"desc" forKey:@"is_display_price"];
    [mDict setObject:@"desc" forKey:@"price"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *urlString = [NSString stringWithFormat:URL_Product_List,_page,Page_Count,@""];
    NSString *parameter = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:mDict options:0 error:nil] encoding:NSUTF8StringEncoding];
    parameters[@"orderCond"] = parameter;
    if (_eid.length != 0) {
        parameters[@"classCondJson"] = [ClassTool arrayToJSONString:@[_eid]];
    }
    
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:[parameters copy] Success:^(id json) {
//                NSLog(@"----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            if (weakself.isRefreshList == YES) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.tableView.mj_footer endRefreshing];
            weakself.totalNum = [json[@"totalCount"] intValue];
            weakself.tempArr  = [ProductInfoModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:weakself.tempArr];
            
            [weakself.tableView reloadData];
        }
        
        if (group)
            dispatch_group_leave(group);
        
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        if (group)
            dispatch_group_leave(group);
    }];
}

//第一次进入页面的请求
- (void)requestFirstIn {
    if (_isFirstLoad == YES) {
        [CddHUD show:self.view];
    }
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    //获取一级和二级分类
    dispatch_group_enter(group);
    DDWeakSelf;
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Product_Classify,@""];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                            NSLog(@"----=== %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                weakself.classifyDataSource = [ProductClassifyModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                for (ProductClassifyModel *model in weakself.classifyDataSource) {
                    model.propList = [ProductClassifyModel mj_objectArrayWithKeyValuesArray:model.propList];
                    NSMutableArray *mProList = [model.propList mutableCopy];
                    ProductClassifyModel *allModel = [[ProductClassifyModel alloc] init];
                    allModel.value = @"全部";
                    allModel.classifyID = model.classifyID;
                    [mProList insertObject:allModel atIndex:0];
                    model.propList = [mProList copy];
                }
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            NSLog(@" Error : %@",error);
            dispatch_group_leave(group);
        }];
    });
    
    //获取列表
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        [weakself requestData:group];
    });
    
    //全部任务完成后，就可以在这吊了
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [CddHUD hideHUD:weakself.view];
            if (weakself.isFirstLoad == YES) {
                [weakself setupUI];
                weakself.isFirstLoad = NO;
            } else {
                [weakself.tableView reloadData];
            }
        });
    });
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无产品";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#708090", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

// 如果不实现此方法的话,无数据时下拉刷新不可用
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
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
