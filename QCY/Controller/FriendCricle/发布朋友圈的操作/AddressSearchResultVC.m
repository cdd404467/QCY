//
//  AddressSearchResultVC.m
//  QCY
//
//  Created by i7colors on 2019/4/2.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AddressSearchResultVC.h"
#import "NavControllerSet.h"
#import "BaseTableView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
//搜索
#import <AMapSearchKit/AMapSearchKit.h>
#import <MJRefresh.h>
#import "POIAnnotationModel.h"

@interface AddressSearchResultVC ()<UITableViewDelegate, UITableViewDataSource,AMapSearchDelegate,UITextFieldDelegate>
@property (nonatomic, strong)BaseTableView *tableView;
@property (nonatomic, strong)AMapSearchAPI *search;  //周边检索对象
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong)UILabel *noAddress;
@property (nonatomic, copy)NSString *keyWords;
@property (nonatomic, strong)UITextField *textField;
@end

@implementation AddressSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索地址";
    [self vhl_setNavBarBackgroundColor:Like_Color];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self initMapFunction];
    [self.view addSubview:self.tableView];
    [self setupUI];
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    [self.view addSubview:self.activityIndicator];
    //设置小菊花的frame
    self.activityIndicator.frame= CGRectMake(100, 100, 40, 40);
    self.activityIndicator.centerX = self.view.centerX;
    self.activityIndicator.centerY = self.view.centerY - 50;
    //设置小菊花颜色
    self.activityIndicator.color = MainColor;
    //设置背景颜色
    self.activityIndicator.backgroundColor = UIColor.clearColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.dataSource removeAllObjects];
}

- (UILabel *)noAddress {
    if (!_noAddress) {
        UILabel *label = [[UILabel alloc]init];
        label.textColor = UIColor.blackColor;
        label.text = @"暂无地址";
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        label.centerY = self.view.centerY - 50 - NAV_HEIGHT;
        _noAddress = label;
    }
    return _noAddress;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataSource;
}

//初始化地图需要的功能，设置代理
- (void)initMapFunction {
    //设置https
    [AMapServices sharedServices].enableHTTPS = YES;
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
}

//懒加载tableView
- (BaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //取消垂直滚动条
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT + 50, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        
        _tableView.tableFooterView = [[UIView alloc] init];
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNumber - 20 * weakself.pageNumber > 0) {
                weakself.pageNumber++;
                self.isRefreshList = NO;
                [weakself searchKeywords];
            } else {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
    return _tableView;
}

#pragma mark - 关键字检索方法
- (void)searchKeywords {
    if (self.isRefreshList == YES)
        self.pageNumber = 1;
    
    [self.activityIndicator startAnimating];
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = self.keyWords;
    request.city = _limitCity;
    request.cityLimit = YES;
    request.requireSubPOIs = YES;
    request.requireExtension = YES;
    request.sortrule = 0;
    request.offset = 20;
    request.page = self.pageNumber;
    [self.search AMapPOIKeywordsSearch:request];
}

#pragma mark - 请求检索的回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    self.totalNumber = @(response.count).intValue ;
    [self.noAddress removeFromSuperview];
    if (self.isRefreshList == YES)
        [self.dataSource removeAllObjects];
    for (AMapPOI *p in response.pois) {
        POIAnnotationModel *model = [POIAnnotationModel annWithPOI:p];
        [self.dataSource addObject:model];
        
//        for (AMapSubPOI *sp in p.subPOIs) {
//            NSLog(@"--- %@",sp.name);
//        }
    }
    DDWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.tableView.mj_footer endRefreshing];
        [weakself.tableView reloadData];
        if (weakself.isRefreshList == YES && weakself.dataSource.count > 0) {
            NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
            [weakself.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        [weakself.activityIndicator stopAnimating];
        if (weakself.dataSource.count == 0) {
            [weakself.tableView addSubview:self.noAddress];
        }
    });
}


- (void)popPage {
    [self.navigationController popViewControllerAnimated:NO];
}

//搜索虚拟键盘响应
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_textField resignFirstResponder];
    self.keyWords = self.textField.text;
    self.isRefreshList = YES;
    [self searchKeywords];
    
    return YES;
}

-(void)changedTextField:(UITextField *)textField {
    if (textField.markedTextRange == nil) {
        if (textField.text.length != 0) {
            self.keyWords = self.textField.text;
            self.isRefreshList = YES;
            [self searchKeywords];
        } else {
            [self.dataSource removeAllObjects];
            [self.tableView reloadData];
        }
    }
}

- (void)setupUI {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 50)];
    view.backgroundColor = Like_Color;
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftView.contentMode = UIViewContentModeCenter;
    leftView.image = [UIImage imageNamed:@"btn_search"];
    UITextField *textField = [[UITextField alloc] init];
    textField.frame = CGRectMake(9, 8, SCREEN_WIDTH - 9 - 50, 34);
    textField.leftView = leftView;
    textField.delegate = self;
    [textField becomeFirstResponder];
    textField.enablesReturnKeyAutomatically = YES;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder = @"搜索附近位置";
    textField.tintColor = MainColor;
    textField.font = [UIFont systemFontOfSize:16];
    textField.layer.cornerRadius = 8.f;
    textField.returnKeyType = UIReturnKeySearch;
    textField.backgroundColor = UIColor.whiteColor;
    [textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [view addSubview:textField];
    _textField = textField;
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(popPage) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.frame = CGRectMake(textField.right, textField.top, 50, textField.height);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [view addSubview:cancelBtn];
    
    [self.view addSubview:view];
}

#pragma mark - tableView代理方法
//每组的cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 52;
}


//点击cell选择地址
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    POIAnnotationModel *model = self.dataSource[indexPath.row];
    NSIndexPath *sPath = [NSIndexPath indexPathForRow:0 inSection:1];
    if (self.selectedAddressBlock) {
        self.selectedAddressBlock(model, @" ", sPath , @(0).doubleValue, @(0).doubleValue);
    }
    DDWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself popPage];
    });
    
}

//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    };
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = UIColor.blackColor;
    cell.detailTextLabel.textColor = RGBA(125, 125, 125, 1);
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    POIAnnotationModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@",model.city,model.area,model.subtitle];
    return cell;
}


@end
