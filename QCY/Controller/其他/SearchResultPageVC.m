//
//  SearchResultPageVC.m
//  QCY
//
//  Created by i7colors on 2018/12/19.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "SearchResultPageVC.h"
#import "MacroHeader.h"
#import <UIScrollView+EmptyDataSet.h>
#import "PYSearchConst.h"
#import "PYSearchSuggestionViewController.h"
#import "OpenMallVC_Cell.h"
#import "AskToBuyCell.h"
#import "ProductMallVC_Cell.h"
#import "OpenMallModel.h"
#import "HomePageModel.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import <MJRefresh.h>
#import "ProductDetailsVC.h"
#import "AskToBuyDetailsVC.h"
#import "ShopMainPageVC.h"

@interface SearchResultPageVC ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, assign)int page;
@property (nonatomic, assign)BOOL isClick;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, assign)int totalNum;
@property (nonatomic, assign)BOOL isFirstLoad;
@end

@implementation SearchResultPageVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _isClick = YES;
        _isFirstLoad = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @" ";
    [self setupUI];
    [self requestData];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelDidClick)];
    self.navigationItem.rightBarButtonItem.tintColor = RGBA(84, 204, 84, 1);
    
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
    [self requestData];
}

/** 点击取消 */
- (void)cancelDidClick
{
    [self.searchBar resignFirstResponder];
    //    [self.navigationController popToRootViewControllerAnimated:NO];
    //    [self dismissViewControllerAnimated:NO completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
}

////产品搜索
- (void)requestDataWithProduct {
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [mDict setObject:@"desc" forKey:@"is_display_price"];
    [mDict setObject:@"desc" forKey:@"price"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *urlString = [NSString stringWithFormat:URL_Product_List,_page,Page_Count,_keyWord];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *parameter = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:mDict options:0 error:nil] encoding:NSUTF8StringEncoding];
    parameters[@"orderCond"] = parameter;
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:[parameters copy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        //        NSLog(@"----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNum = [json[@"totalCount"] intValue];
            NSArray *tempArr = [ProductInfoModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (weakself.isClick == YES) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            if (weakself.isFirstLoad == YES) {
                [weakself.view addSubview:weakself.tableView];
                weakself.isFirstLoad = NO;
            } else {
                [weakself.tableView reloadData];
            }
            
            weakself.isClick = NO;
            
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        
    }];
}
//求购搜索
- (void)requestDataWithaskBuy {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_AskBuy_SearchList,_page,Page_Count,_keyWord];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        //        NSLog(@"--- %@",json);
        [CddHUD hideHUD:weakself.view];
        weakself.totalNum = [json[@"totalCount"] intValue];
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNum = [json[@"totalCount"] intValue];
            NSArray *tempArr = [AskToBuyModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (weakself.isClick == YES) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            if (weakself.isFirstLoad == YES) {
                [weakself.view addSubview:weakself.tableView];
                weakself.isFirstLoad = NO;
            } else {
                [weakself.tableView reloadData];
            }
            weakself.isClick = NO;
        }
        
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}
//店铺搜索
- (void)requestDataWithshop {
    DDWeakSelf;
    if (_isFirstLoad == YES) {
        [CddHUD show:self.view];
    }
    NSString *urlString = [NSString stringWithFormat:URL_Shop_List,_page,Page_Count,_keyWord];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        //        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNum = [json[@"totalCount"] intValue];
            NSArray *tempArr = [OpenMallModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            for (OpenMallModel *model in tempArr) {
                model.businessList = [BusinessList mj_objectArrayWithKeyValuesArray:model.businessList];
            }
            if (weakself.isClick == YES) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            if (weakself.isFirstLoad == YES) {
                [weakself.view addSubview:weakself.tableView];
                weakself.isFirstLoad = NO;
            } else {
                [weakself.tableView reloadData];
            }
            weakself.isClick = NO;
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
    
}

- (void)requestData {
    if (_isClick == YES) {
        [CddHUD show:self.view];
    }
    if ([_type isEqualToString:@"product"]) {
        [self requestDataWithProduct];
    } else if ([_type isEqualToString:@"askBuy"]) {
        [self requestDataWithaskBuy];
    } else {
        [self requestDataWithshop];
    }
    
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
    return 126;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_type isEqualToString:@"product"]) {
        ProductDetailsVC *vc = [[ProductDetailsVC alloc] init];
        ProductInfoModel *model = _dataSource[indexPath.row];
        vc.productID = model.productID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([_type isEqualToString:@"askBuy"]) {
        AskToBuyDetailsVC *vc = [[AskToBuyDetailsVC alloc] init];
        AskToBuyModel *model = _dataSource[indexPath.row];
        vc.buyID = model.buyID;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ShopMainPageVC *vc = [[ShopMainPageVC alloc] init];
        OpenMallModel *model = _dataSource[indexPath.row];
        vc.storeID = model.storeID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_type isEqualToString:@"product"]) {
        ProductMallVC_Cell *cell = [ProductMallVC_Cell cellWithTableView:tableView];
        cell.model = _dataSource[indexPath.row];
        return cell;
    } else if ([_type isEqualToString:@"askBuy"]) {
        AskToBuyCell *cell = [AskToBuyCell cellWithTableView:tableView];
        cell.model = _dataSource[indexPath.row];
        return cell;
    } else {
        OpenMallVC_Cell *cell = [OpenMallVC_Cell cellWithTableView:tableView];
        cell.model = _dataSource[indexPath.row];
        return cell;
    }
}


@end
