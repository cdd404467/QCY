//
//  SelectedAddressVC.m
//  QCY
//
//  Created by i7colors on 2019/4/1.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "SelectedAddressVC.h"
#import "NavControllerSet.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
//搜索
#import <AMapSearchKit/AMapSearchKit.h>
//定位
#import <AMapLocationKit/AMapLocationKit.h>
#import "POIAnnotationModel.h"
#import <SDAutoLayout.h>
#import <MJRefresh.h>
#import "AddressSearchResultVC.h"

@interface SelectedAddressVC ()<UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate, AMapLocationManagerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray<NSMutableArray *> *dataSource;
@property (nonatomic, strong)AMapSearchAPI *search;  //周边检索对象
@property (nonatomic, strong)AMapLocationManager *locationManager;  //定位对象
@property (nonatomic, assign)CGFloat currentLat;    //当前定位的纬度
@property (nonatomic, assign)CGFloat currentLon;    //当前定位的经度
@property (nonatomic, strong)CLLocation *currentLocation;
@property (strong, nonatomic)UISearchController *searchController;
@property (nonatomic, strong)NSIndexPath *selectedPath;         //用于最终传过去的那个indexPath，只有三中情况
@property (nonatomic, assign)int page;
@end

@implementation SelectedAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    self.title = @"所在位置";
    //当前选中的indexPath
    self.selectedPath = _lastPath.row == -1 ? [NSIndexPath indexPathForRow:0 inSection:0] : _lastPath;
    [self.rightNavBtn addTarget:self action:@selector(completeSele) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    [self initAMap];
    [self getCurrentLocation];
}

//初始化数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray<NSString *> *arrA = [NSMutableArray arrayWithObject:@"不显示位置"];
        if (_city) {
            [arrA addObject:_city];
        }
        NSMutableArray<POIAnnotationModel *> *arrB = [NSMutableArray arrayWithCapacity:0];
        if (_selectedModel) {
            [arrB addObject:_selectedModel];
        }
        NSMutableArray<NSMutableArray *> *mArr = [NSMutableArray arrayWithObjects:arrA, arrB, nil];
        _dataSource = mArr;
    }
    return _dataSource;
}

- (void)initAMap {
    [AMapServices sharedServices].enableHTTPS = YES;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    self.locationManager = [[AMapLocationManager alloc]init];
    self.locationManager.delegate = self;
}

#pragma mark 获取定位位置
- (void)getCurrentLocation {
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =4;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 4;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    DDWeakSelf;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        //定位失败
        if (error) {
            NSLog(@"获取出错");
            if (error.code == AMapLocationErrorLocateFailed) {
                return;
            }
        }
        weakself.currentLat = location.coordinate.latitude;
        weakself.currentLon = location.coordinate.longitude;
        //定位成功
        if (regeocode) {
            if (weakself.dataSource[0].count < 2) {
                if isRightData(regeocode.city)
                    [weakself.dataSource[0] addObject:regeocode.city];
            } else {
                [weakself.dataSource[0] replaceObjectAtIndex:1 withObject:regeocode.city];
            }
            weakself.currentLocation = location;
            [weakself.tableView.mj_footer beginRefreshing];
            weakself.tableView.tableHeaderView = [self tbHeader];
        }
    }];
}

#pragma mark 搜索周边方法
-(void)searchAround {
    if (_page != 0) {
        if (self.totalNumber - 20 * _page <= 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
    }
    
    _page ++;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc]init];
    request.location = [AMapGeoPoint locationWithLatitude:self.currentLocation.coordinate.latitude longitude:self.currentLocation.coordinate.longitude];
    //    request.keywords = @"餐饮服务";
    request.sortrule = 0;
    request.radius = 1000;
    request.page = _page;  // 请求页码,默认为1
    request.offset = 20;  //每页返回的条数,默认为20
    request.requireExtension = YES; //设置为YES才会返回省市区等附加参数
    [self.search AMapPOIAroundSearch:request];
}

#pragma mark 请求检索周边的回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    //根据这个判断搜索类型
    self.totalNumber = @(response.count).intValue ;
    
    for (AMapPOI *p in response.pois) {
//        NSLog(@"uid-- %@\n  type-- %@\n  name-- %@\n  address--%@\n  province-- %@  city-- %@  area-- %@", p.uid, p.type, p.name, p.address, p.province, p.city, p.district);
        POIAnnotationModel *model = [POIAnnotationModel annWithPOI:p];
        if (self.dataSource[1].count > 0 && [[self.dataSource[1][0] title] isEqualToString:model.title])
            continue;
        [self.dataSource[1] addObject:model];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    });
}

- (UIView *)tbHeader {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    header.backgroundColor = Like_Color;
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(9, 8, SCREEN_WIDTH - 9 * 2, 34);
    searchBtn.backgroundColor = UIColor.whiteColor;
    [searchBtn setTitle:@"搜索附近位置" forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    searchBtn.layer.cornerRadius = 8.f;
    [searchBtn setTitleColor:HEXColor(@"#A6A6A6", 1) forState:UIControlStateNormal];
    searchBtn.adjustsImageWhenHighlighted = NO;
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [searchBtn addTarget:self action:@selector(jumpToSearch) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.imageView.sd_layout
    .leftSpaceToView(searchBtn, 12)
    .centerYEqualToView(searchBtn)
    .widthIs(16)
    .heightIs(16);
    
    searchBtn.titleLabel.sd_layout
    .centerYEqualToView(searchBtn)
    .leftSpaceToView(searchBtn, 40)
    .heightIs(12);
    [header addSubview:searchBtn];
    
    return header;
}

- (void)jumpToSearch {
    AddressSearchResultVC *vc = [[AddressSearchResultVC alloc] init];
    if (self.dataSource[0].count > 1) {
        vc.limitCity = self.dataSource[0][1];
    }
    DDWeakSelf;
    vc.selectedAddressBlock = ^(POIAnnotationModel * _Nonnull model, NSString * _Nonnull city, NSIndexPath * _Nonnull indexPath, double lon, double lat) {
        if (weakself.selectedAddressBlock) {
            NSString *s_city = city;
            if (weakself.dataSource[0].count > 1) {
                s_city = weakself.dataSource[0][1];
            }
            weakself.selectedAddressBlock(model, s_city, indexPath, weakself.currentLon, weakself.currentLat);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself dismissViewControllerAnimated:YES completion:nil];
            });
        }
    };
    [self.navigationController pushViewController:vc animated:NO];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:SCREEN_BOUNDS style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.separatorColor = RGBA(233, 233, 233, 1);
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view.backgroundColor = Like_Color;
        _tableView.tableHeaderView = view;
        _tableView.tableFooterView = [[UIView alloc] init];
        MJRefreshAutoNormalFooter *mjfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(searchAround)];
        [mjfooter setTitle:@"正在拼命搜索附近位置" forState:MJRefreshStateRefreshing];
        mjfooter.stateLabel.textColor = MainColor;
        mjfooter.stateLabel.font = [UIFont systemFontOfSize:16];
        _tableView.mj_footer = mjfooter;
        
        
    }
    return _tableView;
}


//选择地址完成
- (void)completeSele {
    if (self.selectedAddressBlock) {
        NSString *city = nil;
        if (self.dataSource[0].count > 1) {
            city = _dataSource[0][1];
        }
        self.selectedAddressBlock(_selectedModel, city, _selectedPath, _currentLon, _currentLat);
    }
}



//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataSource[0].count;
    } else {
        return self.dataSource[1].count;
    }
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

//点击cell选择地址
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath != _lastPath) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        _lastPath = indexPath;
    }
    
    if (indexPath.section == 0) {
        _selectedModel = nil;
        self.selectedPath = indexPath;
    } else {
        _selectedModel = self.dataSource[1][indexPath.row];
        self.selectedPath = [NSIndexPath indexPathForRow:0 inSection:1];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *ID = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        };
        cell.textLabel.text = self.dataSource[0][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = indexPath.row == 0 ? [UIColor colorWithRed:0.28 green:0.35 blue:0.54 alpha:1.0] : UIColor.blackColor;
        cell.accessoryType = indexPath == _lastPath ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
     
        return cell;
    } else {
        static NSString *ID = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        };
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = UIColor.blackColor;
        cell.detailTextLabel.textColor = RGBA(125, 125, 125, 1);
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        POIAnnotationModel *model = self.dataSource[1][indexPath.row];
        cell.textLabel.text = model.title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@",model.city,model.area,model.subtitle];
        cell.accessoryType = indexPath == _lastPath ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        return cell;
    }
}

@end


