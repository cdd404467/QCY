//
//  HomePageSearchVC.m
//  QCY
//
//  Created by i7colors on 2018/11/9.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HomePageSearchVC.h"
#import "MacroHeader.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "HomePageSectionHeader.h"
#import "OpenMallVC_Cell.h"
#import "AskToBuyCell.h"
#import "ProductMallVC_Cell.h"
#import "HomePageModel.h"
#import "OpenMallModel.h"
#import "PYSearchConst.h"
#import "PYSearchSuggestionViewController.h"
#import "ProductDetailsVC.h"
#import "AskToBuyDetailsVC.h"
#import "ShopMainPageVC.h"
#import "ProductMallVC.h"
#import "AskToBuyVC.h"
#import "OpenMallVC.h"
#import "NoDataView.h"
#import "UIView+Geometry.h"


@interface HomePageSearchVC ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)HomePageModel *dataSource;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, assign)BOOL isFirstLoad;
@property (nonatomic, strong)NoDataView *noDataView;
@end

@implementation HomePageSearchVC

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
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"搜索结果";
    
    [self keyWordSearch];
    [self setupUI];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
    searchBar.placeholder = @"搜索商品标题";
    searchBar.text = _searchKeyWord;
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
    searchTextField.tintColor = RGBA(84, 204, 84, 1);
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
    _searchKeyWord = _searchBar.text;
    [self keyWordSearch];
}

/** 点击取消 */
- (void)cancelDidClick
{
    [self.searchBar resignFirstResponder];
    //    [self.navigationController popToRootViewControllerAnimated:NO];
    //    [self dismissViewControllerAnimated:NO completion:nil];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
}

#pragma mark - 搜索
- (void)keyWordSearch {

    NSString *urlString = [NSString stringWithFormat:URL_HomePage_search,User_Token,_searchKeyWord,_page,Page_Count];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [CddHUD show:self.view];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.dataSource = [HomePageModel mj_objectWithKeyValues:json[@"data"]];
            
            if (weakself.dataSource.productList.count > 0) {
                weakself.dataSource.productList = [ProductInfoModel mj_objectArrayWithKeyValuesArray:weakself.dataSource.productList];
            }
            if (weakself.dataSource.enquiryList.count > 0) {
                weakself.dataSource.enquiryList = [AskToBuyModel mj_objectArrayWithKeyValuesArray:weakself.dataSource.enquiryList];
            }
            if (weakself.dataSource.marketList.count > 0) {
                weakself.dataSource.marketList = [OpenMallModel mj_objectArrayWithKeyValuesArray:weakself.dataSource.marketList];
                for (OpenMallModel *model in weakself.dataSource.marketList) {
                    model.businessList = [BusinessList mj_objectArrayWithKeyValuesArray:model.businessList];
                }
            }
            
            if (weakself.isFirstLoad == YES) {
                [weakself.view addSubview:weakself.tableView];
                weakself.isFirstLoad = NO;
            } else {
                [weakself.tableView reloadData];
            }
            
            //判断为空
            if (weakself.dataSource.productList.count == 0 && weakself.dataSource.enquiryList.count == 0 && weakself.dataSource.marketList.count == 0) {
                NSString *text = @"没有搜索结果，请换个关键词";
                weakself.noDataView = [[NoDataView alloc] init];
                weakself.noDataView.centerY = weakself.view.centerY;
                [weakself.view addSubview:weakself.noDataView];
                weakself.noDataView.noLabel.text = text;
            } else {
                [weakself.noDataView removeFromSuperview];
            }
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableView代理
//section header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (_dataSource.productList.count > 0) {
            return 36;
        } else {
            return 0.001;
        }
    } else if (section == 1) {
        if (_dataSource.enquiryList.count > 0) {
            return 36;
        } else {
            return 0.001;
        }
    } else {
        if (_dataSource.marketList.count > 0) {
            return 36;
        } else {
            return 0.001;
        }
    }
    
}

//section footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *titleArr = @[@"产品大厅",@"求购大厅",@"开放商城"];
    HomePageSectionHeader *header = [ HomePageSectionHeader headerWithTableView:tableView];
    header.titleLabel.text = titleArr[section];
    DDWeakSelf;
    if (section == 0) {
        if (_dataSource.productList.count > 0) {
            header.clickMoreBlock = ^{
                ProductMallVC *vc = [[ProductMallVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            };
            return header;
        } else {
            return nil;
        }
    } else if (section == 1) {
        if (_dataSource.enquiryList.count > 0) {
            header.clickMoreBlock = ^{
                AskToBuyVC *vc = [[AskToBuyVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            };
            return header;
        } else {
            return nil;
        }
    } else {
        if (_dataSource.marketList.count > 0) {
            header.clickMoreBlock = ^{
                OpenMallVC *vc = [[OpenMallVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            };
            return header;
        } else {
            return nil;
        }
    }
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (_dataSource.productList.count < 4) {
            return _dataSource.productList.count;
        } else {
            return 3;
        }
    } else if (section == 1) {
        if (_dataSource.enquiryList.count < 4) {
            return _dataSource.enquiryList.count;
        } else {
            return 3;
        }
    } else {
        if (_dataSource.marketList.count < 4) {
            return _dataSource.marketList.count;
        } else {
            return 3;
        }
    }
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_dataSource.productList.count > 0) {
            return 126;
        } else {
            return 0;
        }
    } else if (indexPath.section == 1) {
        if (_dataSource.enquiryList.count > 0) {
            return 126;
        } else {
            return 0;
        }
    } else {
        if (_dataSource.marketList.count > 0) {
            return 126;
        } else {
            return 0;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProductDetailsVC *vc = [[ProductDetailsVC alloc] init];
        ProductInfoModel *model = _dataSource.productList[indexPath.row];
        vc.productID = model.productID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        AskToBuyDetailsVC *vc = [[AskToBuyDetailsVC alloc] init];
        AskToBuyModel *model = _dataSource.enquiryList[indexPath.row];
        vc.buyID = model.buyID;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ShopMainPageVC *vc = [[ShopMainPageVC alloc] init];
        OpenMallModel *model = _dataSource.marketList[indexPath.row];
        vc.storeID = model.storeID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ProductMallVC_Cell *cell = [ProductMallVC_Cell cellWithTableView:tableView];
        cell.model = _dataSource.productList[indexPath.row];
        return cell;
    } else if (indexPath.section == 1) {
        AskToBuyCell *cell = [AskToBuyCell cellWithTableView:tableView];
        cell.model = _dataSource.enquiryList[indexPath.row];
        return cell;
    } else {
        OpenMallVC_Cell *cell = [OpenMallVC_Cell cellWithTableView:tableView];
        cell.model = _dataSource.marketList[indexPath.row];
        return cell;
    }
    
}


@end
