//
//  ContestantsSearchVC.m
//  QCY
//
//  Created by i7colors on 2019/2/28.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ContestantsSearchVC.h"
#import <UIScrollView+EmptyDataSet.h>
#import "PYSearchConst.h"
#import "PYSearchSuggestionViewController.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import <MJRefresh.h>
#import "RankDetailVC.h"
#import "ContestantsCell.h"
#import "VoteModel.h"

@interface ContestantsSearchVC ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, assign)int page;
@property (nonatomic, assign)BOOL isClick;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, assign)int totalNum;
@property (nonatomic, assign)BOOL isFirstLoad;
@property (nonatomic, assign)int pageCount;
@end

@implementation ContestantsSearchVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _pageCount = Page_Count;
        _isClick = YES;
        _isFirstLoad = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @" ";
    [self.view addSubview:self.tableView];
    [self setupUI];
    [self requestData:NO];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
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
            if (weakself.totalNum - Page_Count * weakself.page > 0) {
                weakself.page++;
//                [weakself requestData];
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
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn sizeToFit];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    [btn addTarget:self action:@selector(cancelDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // 创建搜索框
    UIView *titleView = [[UIView alloc] init];
    titleView.py_x = PYMargin * 0.5;
    titleView.py_y = 7;
    titleView.py_width = self.view.py_width - 64 - titleView.py_x * 2;
    
    titleView.py_height = 30;
    titleView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    titleView.layer.cornerRadius = 13;
    titleView.clipsToBounds = YES;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    searchBar.py_width -= PYMargin * 1.5;
    searchBar.placeholder = @"输入关键词搜索";
    searchBar.text = _keyWord;
    //    searchBar.placeholder = PYSearchPlaceholderText;
    //iOS 10 searchBarBackground
    searchBar.backgroundImage = [UIImage imageNamed:@"PYSearch.bundle/clearImage"];
    searchBar.delegate = self;
    //    searchBar.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    //去掉searchBar的背景色
    //    for (UIView *view in searchBar.subviews) {
    //        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
    //            [[view.subviews objectAtIndex:0] removeFromSuperview];
    //            break;
    //        }
    //    }
    UITextField * searchTextField = [[[searchBar.subviews firstObject] subviews] lastObject];
    [searchTextField setClearButtonMode:UITextFieldViewModeNever];
    [searchTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    searchTextField.tintColor = [UIColor blackColor];
    //限制字数
    //    [searchTextField lengthLimit:^{
    //        if (searchTextField.text.length > 10) {
    //            searchTextField.text = [searchTextField.text substringToIndex:10];
    //        }
    //    }];
    [searchTextField setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1]];
    
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    self.navigationItem.titleView = titleView;
}

//监听键盘输入
-(void)textFieldChange:(UITextField *)textField{
    if (textField.markedTextRange == nil) {
        if (textField.text.length == 0) {
            //            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}

//searchBar 键盘搜索按钮的点击事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    _keyWord = _searchBar.text;
    _isClick = YES;
    _pageCount = Page_Count;
    _page = 1;
    [self requestData:NO];
}

/** 点击取消 */
- (void)cancelDidClick
{
    [self.searchBar resignFirstResponder];
    //    [self.navigationController popToRootViewControllerAnimated:NO];
    //    [self dismissViewControllerAnimated:NO completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
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

- (void)requestData:(BOOL)isRefresh {
    NSString *urlString = [NSString stringWithFormat:URL_Vote_Participant_List,User_Token,_voteID,_keyWord,_keyWord,_page,_pageCount];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"--=-=-====--= %@",urlString);
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
                        NSLog(@"----== %@",json);
        [weakself.tableView.mj_header endRefreshing];
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            if (isRefresh == YES)
                [weakself.dataSource removeAllObjects];
            weakself.totalNum = [json[@"totalCount"] intValue];
            NSArray *tempArr = [VoteUserModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            if (isRefresh == YES) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"vote_refresh" object:nil];
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


#pragma mark - UITableViews空数据代理
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"没有搜索结果，请换个关键词";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#708090", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark - UITableView代理
//section header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

//section footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
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


@end
