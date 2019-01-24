//
//  AskToBuyVC.m
//  QCY
//
//  Created by i7colors on 2018/9/27.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuyVC.h"
#import "MacroHeader.h"
#import "AskToBuyCell.h"
#import <Masonry.h>
#import "PostBuyingVC.h"
#import "HelperTool.h"
#import "AskToBuyDetailsVC.h"
#import "NetWorkingPort.h"
#import "ClassTool.h"
#import <MJExtension.h>
#import "HomePageModel.h"
#import <MJRefresh.h>
#import "CddHUD.h"
#import "PYSearch.h"
#import "SearchResultPageVC.h"

@interface AskToBuyVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, copy)NSArray *tempArr;
@property (nonatomic, assign)int totalNum;
@property (nonatomic, assign)BOOL isFirstLoad;
@property (nonatomic, assign)int number;
@property (nonatomic, assign)int page;
@end

@implementation AskToBuyVC

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
    self.title = @"求购大厅";
    self.view.backgroundColor = View_Color;
    [self setRightItem];
    [self requestData];
}

- (void)setRightItem {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 14, 0, -14);
    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    
    //    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    UIBarButtonItem *rewardItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15;
    [btn addTarget:self action:@selector(jumpToSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[spaceItem,rewardItem];
}

- (void)jumpToSearch {
    //    NSArray *arr = @[@"阿伦",@"封金能"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"输入关键词搜索" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        SearchResultPageVC *vc = [[SearchResultPageVC alloc]init];
        vc.keyWord = searchText;
        vc.type = @"askBuy";
        [searchViewController.navigationController pushViewController:vc animated:NO];
    }];
    //历史搜索风格
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
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
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        self.edgesForExtendedLayout = UIRectEdgeNone;
        DDWeakSelf;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            weakself.page = 1;
//            [weakself.dataSource removeAllObjects];
//            [weakself requestData];
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

//初始化数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _dataSource = mArr;
    }
    return _dataSource;
}


- (void)setupUI {
    [self.view addSubview:self.tableView];
    UIImageView *issueImg = [[UIImageView alloc] init];
    issueImg.image = [UIImage imageNamed:@"issue_img"];
    issueImg.layer.shadowColor = RGBA(0, 0, 0, 0.5).CGColor;
    issueImg.layer.shadowOffset = CGSizeMake(0, 6);
    issueImg.layer.shadowOpacity = 1.0f;
    [HelperTool addTapGesture:issueImg withTarget:self andSEL:@selector(jumpToPostVC)];
    [self.view insertSubview:issueImg aboveSubview:_tableView];
    [self.view addSubview:issueImg];
    [issueImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(58);
        make.right.mas_equalTo(-9);
        make.bottom.mas_equalTo(-(58 + Bottom_Height_Dif));
    }];
    
    //文字
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 2;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.text = @"发布\n求购";
    textLabel.textAlignment = NSTextAlignmentCenter;
    [issueImg addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - 获取列表数据
- (void)requestData {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_ASKTOBUY_LIST,User_Token,_page,Page_Count];
    
    if (_isFirstLoad == YES) {
        [CddHUD show:self.view];
    }
    
    self.view.userInteractionEnabled = NO;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//        NSLog(@"--- %@",json);
        weakself.totalNum = [json[@"totalCount"] intValue];
        weakself.view.userInteractionEnabled = YES;
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.tempArr = [AskToBuyModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:weakself.tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            if (weakself.isFirstLoad == YES) {
                [weakself setupUI];
                weakself.isFirstLoad = NO;
            } else {
                [weakself.tableView reloadData];
            }
        } else {
            
        }
        
        [CddHUD hideHUD:weakself.view];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AskToBuyDetailsVC *vc = [[AskToBuyDetailsVC alloc] init];
    AskToBuyModel *model = _dataSource[indexPath.row];
    vc.buyID = model.buyID;
    [self.navigationController pushViewController:vc animated:YES];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AskToBuyCell *cell = [AskToBuyCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    return cell;
}

- (void)jumpToPostVC {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    DDWeakSelf;
    PostBuyingVC *vc = [[PostBuyingVC alloc] init];
    vc.refreshPostBuyBlock = ^{
        [weakself.dataSource removeAllObjects];
        [weakself requestData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

@end
