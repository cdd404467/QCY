//
//  ContestantsVC.m
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ContestantsVC.h"
#import <YNPageTableView.h>
#import "MacroHeader.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import "VoteModel.h"
#import "ContestantsCell.h"
#import <MJRefresh.h>
#import "CddHUD.h"
#import "RankDetailVC.h"
#import "PYSearch.h"
#import <SDAutoLayout.h>
#import "ContestantsSearchVC.h"
#import "BaseNavigationController.h"

@interface ContestantsVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign)int page;
@property (nonatomic, assign)int totalNum;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)int pageCount;
@end

@implementation ContestantsVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _pageCount = Page_Count;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"vote_refresh" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshAllDataWithThis" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataWithFirst) name:@"vote_refresh_first" object:nil];
    [self.view addSubview:self.tableView];
    [self requestData:NO];
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
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        //        _tableView.backgroundColor = [UIColor redColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            //            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNum - Page_Count * weakself.page > 0) {
                weakself.page++;
                [weakself requestData:NO];
            } else {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
    return _tableView;
}


- (void)requestData:(BOOL)isRefresh {
    NSString *urlString = [NSString stringWithFormat:URL_Vote_Participant_List,User_Token,_voteID,@"",@"",_page,_pageCount];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                NSLog(@"----== %@",json);
        [weakself.tableView.mj_header endRefreshing];
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            if (isRefresh == YES)
                [weakself.dataSource removeAllObjects];
            weakself.totalNum = [json[@"totalCount"] intValue];
            NSArray *tempArr = [VoteUserModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            if (isRefresh == YES) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"vote_home_add" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"vote_header_add" object:nil];
            }
            
            [weakself.tableView reloadData];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

//刷新数据
- (void)refreshData {
    [self requestData:YES];
}

- (void)refreshDataWithFirst {
    _page = 1;
    _pageCount = Page_Count;
    [self requestData:NO];
}

- (void)startVote:(NSString *)voteID {
    _pageCount = Page_Count * _page;
    
    NSDictionary *dict = @{@"token":User_Token,
                           @"mainId":_voteID,
                           @"applicationId":voteID,
                           @"from":@"app_ios"
                           };
    DDWeakSelf;
    [ClassTool postRequest:URL_Vote_Start Params:[dict mutableCopy] Success:^(id json) {
//               NSLog(@"-----== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [weakself requestData:YES];
        } else {
            [CddHUD showTextOnlyDelay:json[@"msg"] view:[[UIApplication sharedApplication].windows lastObject]];
        }
    } Failure:^(NSError *error) {

    }];
}

- (void)jumpToSearch {
    //    NSArray *arr = @[@"阿伦",@"封金能"];
    DDWeakSelf;
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"输入关键词搜索" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        ContestantsSearchVC *vc = [[ContestantsSearchVC alloc]init];
        vc.keyWord = searchText;
        vc.voteID = weakself.voteID;
        [searchViewController.navigationController pushViewController:vc animated:NO];
    }];
    //历史搜索风格
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}

#pragma mark - UITableView代理
//section header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

//section footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    header.backgroundColor = [UIColor whiteColor];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(9, 6, SCREEN_WIDTH - 9 * 2, 28);
    searchBtn.backgroundColor = HEXColor(@"#F5F5F5", 1);
    [searchBtn setTitle:@"请输入参赛选手名称" forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    searchBtn.layer.cornerRadius = 14.f;
    [searchBtn setTitleColor:HEXColor(@"#A6A6A6", 1) forState:UIControlStateNormal];
    searchBtn.adjustsImageWhenHighlighted = NO;
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [searchBtn addTarget:self action:@selector(jumpToSearch) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.imageView.sd_layout
    .leftSpaceToView(searchBtn, 12)
    .centerYEqualToView(searchBtn)
    .widthIs(16)
    .heightIs(16);
    
    searchBtn.titleLabel.sd_layout
    .centerYEqualToView(searchBtn)
    .leftSpaceToView(searchBtn, 37)
    .heightIs(12);
    [header addSubview:searchBtn];
    

    return header;
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 145;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RankDetailVC *vc = [[RankDetailVC alloc] init];
    vc.pageTitle = [_dataSource[indexPath.row] name];
    vc.joinerID = [_dataSource[indexPath.row] voteUserID];
    vc.voteID = _voteID;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContestantsCell *cell = [ContestantsCell cellWithTableView:tableView];
    DDWeakSelf;
    cell.voteClickBlock = ^(NSString * _Nonnull voteUserID) {
        if (!GET_USER_TOKEN) {
            [self jumpToLogin];
            return;
        }
        [weakself startVote:voteUserID];
    };
    cell.model = _dataSource[indexPath.row];
    return cell;
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
