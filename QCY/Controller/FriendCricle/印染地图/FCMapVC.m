//
//  FCMapVC.m
//  QCY
//
//  Created by i7colors on 2019/4/19.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCMapVC.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "NavControllerSet.h"
#import <YYText.h>
//定位
#import <AMapLocationKit/AMapLocationKit.h>
#import "FriendCricleModel.h"
#import <MapKit/MapKit.h>
#import <MJRefresh.h>
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "FriendCricleModel.h"
#import "FCMapRecommendShopCell.h"
#import "ShopMainPageVC.h"
#import "NonmemberCompanyInfoVC.h"
#import "EdgeButton.h"
#import "UIView+Border.h"
#import "AreaSelectView.h"
#import "CompanytypeSelectView.h"
#import "FCMapCustomAnnotationView.h"
#import "MAPointAnnotation_1.h"
#import "HelperTool.h"
#import "FCMapLeftNavView.h"
#import "MapNavigationClass.h"
#import "CddHUD.h"
#import "UITextField+Limit.h"
#import <UMAnalytics/MobClick.h>
#import "WebViewVC.h"


//拖拽超过这个距离就会响应动画
static const CGFloat responseMoveDistance = 15.f;

@interface FCMapVC ()<MAMapViewDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate>
//地图视图
@property (nonatomic, strong) MAMapView *mapView;
//搜索控件
@property (nonatomic, strong) UITextField *searchTF;
//搜索按钮
@property (nonatomic, strong) UIButton *joinBtn;
//遮罩
@property (nonatomic, strong) UIView *coverView;
//用户定位蓝点
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;
@property (nonatomic, strong) AMapLocationManager *locationManager;  //定位对象
@property (nonatomic, strong) AMapSearchAPI *searchLocation;
@property (nonatomic, assign) double targetLat;
@property (nonatomic, assign) double targetLon;
@property (nonatomic, assign) double currentLat;
@property (nonatomic, assign) double currentLon;
@property (nonatomic, assign) BOOL isTop;
//地图到上面的距离
@property (nonatomic, assign) CGFloat mapTopGap;
@property (nonatomic, assign) int pageCount;
@property (nonatomic, copy) NSString *from;
//后台返回的数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
//去除掉没有经纬度的数据后留下的数据源
@property (nonatomic, strong) NSMutableArray *validDataSource;
@property (nonatomic, strong) MapTBHeader *tbHeader;
@property (nonatomic, copy) NSString *currentKeyword;
@property (nonatomic, copy) NSString *currentArea;
@property (nonatomic, copy) NSString *currentCity;
@property (nonatomic, copy) NSString *currentProvince;
@property (nonatomic, copy) NSString *currentType;
//展示店铺的列表
@property (nonatomic, strong) UITableView *tableView;
//回到当前位置
@property (nonatomic, strong) UIButton *currentBtn;
//移动的View
@property (nonatomic, strong) UIView * bgMoveView;
//地区选择按钮
@property (nonatomic, strong) EdgeButton *areaBtn;
//企业类型选择按钮
@property (nonatomic, strong) EdgeButton *typeBtn;
//地区选择列表
@property (nonatomic, strong) AreaSelectView *areaView;
//企业类型选择视图
@property (nonatomic, strong) CompanytypeSelectView *companyTypeView;
//触摸视图的高度
@property (nonatomic, assign) CGFloat touchViewHeight;
//移动视图的最高位置
@property (nonatomic, assign) CGFloat moveViewTop;
//当前选中的点
@property (nonatomic, strong) FCMapRecommendShopCell *currentSelectView;
//地图b自定义标注点的数组
@property (nonatomic, strong) NSMutableArray<MAPointAnnotation_1 *> *annotationArr;
//左边弹出的View
@property (nonatomic, strong) FCMapLeftNavView *leftView;
@end

@implementation FCMapVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapTopGap = NAV_HEIGHT + 40;
        self.isTop = NO;
        self.pageCount = 20;
        self.touchViewHeight = TABBAR_HEIGHT + 10;
        self.moveViewTop = NAV_HEIGHT + 140;
        self.currentKeyword = @"";
        self.currentArea = @"";
        self.currentCity = @"";
        self.currentProvince = @"";
        self.currentType = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_model) {
        self.from = @"fc";
    } else {
        self.from = @"home";
    }
    [self setNavBar];
    [self initMapView];
    if ([self.from isEqualToString:@"fc"]) {
        [self showTargetAddress];
    }
    [self getCurrentLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"印染地图"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"印染地图"];
}

- (void)setNavBar {
    [self vhl_setNavBarShadowImageHidden:YES];
    [self vhl_setNavigationSwitchStyle:VHLNavigationSwitchStyleFakeNavBar];
    
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 130, 30)];
    _searchTF.backgroundColor = UIColor.whiteColor;
    _searchTF.placeholder = @"请输入企业名称";
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    _searchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _searchTF.tintColor = MainColor;
    _searchTF.layer.cornerRadius = 15;
    _searchTF.returnKeyType = UIReturnKeySearch;
    //没文字时return不可点击
    _searchTF.enablesReturnKeyAutomatically = NO;
    _searchTF.delegate = self;
    _searchTF.font = [UIFont systemFontOfSize:15];
    _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    //限制字数
    DDWeakSelf;
    [_searchTF lengthLimit:^{
        if (weakself.searchTF.text.length > 20) {
            weakself.searchTF.text = [weakself.searchTF.text substringToIndex:20];
        }
    }];
    [_searchTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    self.navigationItem.titleView = _searchTF;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:weakself.joinBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (UIButton *)joinBtn {
    if (!_joinBtn) {
        _joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _joinBtn.frame = CGRectMake(0, 0, 70, 30);
        _joinBtn.backgroundColor = MainColor;
        _joinBtn.layer.cornerRadius = 15;
        [_joinBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _joinBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_joinBtn setTitle:@"加入" forState:UIControlStateNormal];
        [_joinBtn addTarget:self action:@selector(joinTehMap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinBtn;
}

- (void)joinTehMap {
    [self.searchTF resignFirstResponder];
    WebViewVC *vc = [[WebViewVC alloc] init];
    vc.webUrl = @"https://c.eqxiu.com/s/pJjgBfWy";
    vc.needBottom = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//取消搜索
- (void)cancelSearch {
    self.searchTF.text = nil;
    [self.searchTF resignFirstResponder];
}

//点击搜索
- (void)goSearch {
    self.currentKeyword = _searchTF.text;
    [self.searchTF resignFirstResponder];
    self.pageNumber = 1;
    [self requestDataWithIsLoadMore:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self goSearch];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
        _coverView.backgroundColor = RGBA(0, 0, 0, 0.0);
        [self.view addSubview:_coverView];
        [HelperTool addTapGesture:_coverView withTarget:self andSEL:@selector(cancelSearch)];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.backgroundColor = RGBA(0, 0, 0, .5);
    } completion:^(BOOL finished) {
    }];
}

//TF失去焦点，结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        self.coverView.backgroundColor = RGBA(0, 0, 0, 0.0);
    } completion:^(BOOL finished) {
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }];
}

//监听tf的输入变化
-(void)changedTextField:(UITextField *)textField {
    if (textField.markedTextRange == nil) {
        if (textField.text.length != 0) {
           
        } else {
            
        }
    }
}


#pragma mark - 地图相关
//设置中心点
- (void)initCenterLocation:(CLLocationCoordinate2D)coordinate {

    [self.mapView setCenterCoordinate:coordinate animated:YES];
    //self.mapView.userLocation.location.coordinate
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
- (NSMutableArray *)validDataSource {
    if (!_validDataSource) {
        _validDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _validDataSource;
}

- (NSMutableArray *)annotationArr {
    if (!_annotationArr) {
        _annotationArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _annotationArr;
}

- (MapTBHeader *)tbHeader {
    if (!_tbHeader) {
        _tbHeader = [[MapTBHeader alloc] init];
        _tbHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, TABBAR_HEIGHT + 10);
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        panGesture.delegate = self;
        [_tbHeader addGestureRecognizer:panGesture];
        [HelperTool addTapGesture:_tbHeader withTarget:self andSEL:@selector(clickMoveView)];
    }
    return _tbHeader;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 8);
        _tableView.separatorColor = RGBA(0, 0, 0, .1);
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
//        _tableView.scrollEnabled = NO;
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNumber - weakself.pageCount * weakself.pageNumber > 0) {
                weakself.pageNumber++;
                [weakself requestDataWithIsLoadMore:YES];
            } else {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}


#pragma mark - setUI
//地区和企业类型选择
- (void)setupUI {
    //地区
    EdgeButton *areaBtn = [EdgeButton buttonWithType:UIButtonTypeCustom];
    areaBtn.backgroundColor = UIColor.whiteColor;
    areaBtn.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH / 2, 40);
    [areaBtn setTitle:@"地区" forState:UIControlStateNormal];
    areaBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [areaBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [areaBtn setTitleColor:HEXColor(@"#000000", 0.1) forState:UIControlStateSelected];
    [areaBtn setImage:[UIImage imageNamed:@"selected_icon"] forState:UIControlStateNormal];
    areaBtn.imagePosition = SCCustomButtonImagePositionRight;
    [areaBtn addBorderView:Like_Color width:.6 direction:BorderDirectionTop];
    [areaBtn addTarget:self action:@selector(areaSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:areaBtn];
    _areaBtn = areaBtn;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.5 animations:^{
            areaBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, -50);
        }];
    });
    
    //企业类型
    EdgeButton *typeBtn = [EdgeButton buttonWithType:UIButtonTypeCustom];
    typeBtn.backgroundColor = areaBtn.backgroundColor;
    typeBtn.frame = CGRectMake(areaBtn.right, NAV_HEIGHT, SCREEN_WIDTH / 2, 40);
    [typeBtn setTitle:@"企业类型" forState:UIControlStateNormal];
    typeBtn.titleLabel.font = areaBtn.titleLabel.font;
    [typeBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [typeBtn setTitleColor:areaBtn.titleLabel.textColor forState:UIControlStateSelected];
    [typeBtn setImage:[UIImage imageNamed:@"selected_icon"] forState:UIControlStateNormal];
    typeBtn.imagePosition = SCCustomButtonImagePositionRight;
    [typeBtn addBorderView:Like_Color width:.6 direction:BorderDirectionTop];
    [typeBtn addTarget:self action:@selector(companyTypeSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:typeBtn];
    _typeBtn = typeBtn;
    
    UIView *line_1= [[UIView alloc] initWithFrame:CGRectMake(areaBtn.width - 1, 10, 1, 20)];
    line_1.backgroundColor = Like_Color;
    [areaBtn addSubview:line_1];
    
    UIView *line_2 = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 1, 20)];
    line_2.backgroundColor = line_1.backgroundColor;
    [typeBtn addSubview:line_2];
}

- (void)initMapView {
    //设置https
    [AMapServices sharedServices].enableHTTPS = YES;
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, _mapTopGap, SCREEN_WIDTH, SCREEN_HEIGHT - _touchViewHeight - _mapTopGap)];
    self.mapView.delegate = self;
    self.locationManager = [[AMapLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    if (_model) {
        self.searchLocation = [[AMapSearchAPI alloc] init];
        self.searchLocation.delegate = self;
    }
    
    [self.view addSubview:self.mapView];
    [self setupUI];
    //定位，显示地图蓝点
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeNone;
    [self.mapView setZoomLevel:10.0 animated:YES];  //设置缩放等级 3-19
    self.mapView.showsCompass = NO; //关闭右上角指南针
    //self.mapView.showsScale = NO; //关闭比例尺
    
    //当前选中的点
    self.currentSelectView = [[FCMapRecommendShopCell alloc] init];
    self.currentSelectView.searchRouteBlock = ^(FCMapNavigationModel * _Nonnull model) {
        [MapNavigationClass showMapNavigationWithModel:model];
    };
    self.currentSelectView.hidden = YES;
    [HelperTool addTapGesture:self.currentSelectView withTarget:self andSEL:@selector(clickCell:)];
    [self.mapView addSubview:self.currentSelectView];
    [self.currentSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo (85);
        make.bottom.mas_equalTo(-10);
    }];
    
    //回到当前位置
    _currentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _currentBtn.frame = CGRectMake(_mapView.width - 40 - 10, _mapView.height - 40 - 10, 40, 40);
    _currentBtn.backgroundColor = RGBA(0, 0, 0, 0.4);
    _currentBtn.adjustsImageWhenHighlighted = NO;
    UIImage *image = [UIImage imageNamed:@"goCurrentLocation"];
    [_currentBtn setImage:[image imageWithTintColor_My:UIColor.whiteColor] forState:UIControlStateNormal];
    [_currentBtn addTarget:self action:@selector(goCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:_currentBtn];
    _currentBtn.layer.cornerRadius = 5;
    
    UIView *bgMoveView = [[UIView alloc] init];
    bgMoveView.backgroundColor = UIColor.whiteColor;
    bgMoveView.frame = CGRectMake(0, SCREEN_HEIGHT - _touchViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - _moveViewTop);
    [self.view insertSubview:bgMoveView belowSubview:_areaBtn];
    [bgMoveView addSubview:self.tbHeader];
    [bgMoveView addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, _tbHeader.bottom, _tbHeader.width, bgMoveView.height - _tbHeader.height);
    _bgMoveView = bgMoveView;
}

//如果是从印染圈点进地图，要显示目标地址并且导航
- (void)showTargetAddress {
    //设置目标地址为中心点
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_model.latitude, _model.longitude);
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
//    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_model.latitude, _targetLon);
//    pointAnnotation.title = @"target";
//    [self.mapView addAnnotation:pointAnnotation];
    
    FCMapLeftNavView *leftView = [[FCMapLeftNavView alloc] initWithFrame:CGRectMake(60 - SCREEN_WIDTH, self.mapView.height - 60, SCREEN_WIDTH, 60)];
    leftView.model = _model;
    [leftView.touchBtn addTarget:self action:@selector(touchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftView.navBtn addTarget:self action:@selector(mapNavigation) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:leftView];
    _leftView = leftView;
}

//伸缩按钮点击
- (void)touchBtnClick {
    DDWeakSelf;
    if (weakself.leftView.isLeft == NO)
        weakself.currentBtn.hidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        BOOL state = weakself.leftView.isLeft;
        weakself.leftView.left = state == YES ? 0 : 60 - SCREEN_WIDTH;
        weakself.leftView.backgroundColor = state == YES ? RGBA(0, 0, 0, 0.5) : RGBA(0, 0, 0, 0.0);
        weakself.leftView.touchBtn.backgroundColor = state == YES ? RGBA(0, 0, 0, 0.0) : RGBA(0, 0, 0, 0.4);
        weakself.currentBtn.alpha = state == YES ? 0.0 : 1.0;
        weakself.leftView.touchBtn.transform = state == YES ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0.0);
    } completion:^(BOOL finished) {
        weakself.leftView.isLeft = !weakself.leftView.isLeft;
        weakself.currentBtn.hidden = !weakself.leftView.isLeft;
    }];
}

//导航按钮点击
- (void)mapNavigation {
    FCMapNavigationModel *navModel = [[FCMapNavigationModel alloc] init];
    navModel.nowLat = self.currentLat;
    navModel.nowLon = self.currentLon;
    navModel.targetLat = _model.latitude;
    navModel.targetLon = _model.longitude;
    navModel.endLocationName = _model.locationTitle;
    [MapNavigationClass showMapNavigationWithModel:navModel];
}

- (AreaSelectView *)areaView {
    if (!_areaView) {
        _areaView = [[AreaSelectView alloc] init];
        _areaView.frame = CGRectMake(0, _areaBtn.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - _areaBtn.bottom);
        DDWeakSelf;
        _areaView.allAreaClickBlock = ^(NSString * _Nonnull area, NSInteger type) {
            //全国
            if (type == 10000) {
                area = @"全国";
                weakself.currentProvince = @"";
                weakself.currentCity = @"";
                weakself.currentArea = @"";
            }
            //全省
            else if (type == 10001) {
                weakself.currentProvince = area;
                weakself.currentCity = @"";
                weakself.currentArea = @"";
            }
            //全市
            else if (type == 10002) {
                weakself.currentProvince = @"";
                weakself.currentCity = area;
                weakself.currentArea = @"";
            }
            //某个区
            else if (type == 10003) {
                weakself.currentProvince = @"";
                weakself.currentCity = @"";
                weakself.currentArea = area;
            }
            NSMutableArray *historyArr = [NSMutableArray arrayWithArray:(NSArray *)FCMap_History_Area];
            //存储的是title + type
            NSString *saveStr = [NSString stringWithFormat:@"%@-%@",area,@(type).stringValue];
            //如果有历史记录
            if (historyArr.count > 0) {
                //历史记录已经包含当前选择的地区,查找出来这个记录并删除
                if ([historyArr containsObject:saveStr]) {
                    NSInteger index = [historyArr indexOfObject:saveStr];
                    [historyArr removeObjectAtIndex:index];
                }
                //如果没有这条记录
                else {
                    if (historyArr.count >= 6) {
                        [historyArr removeLastObject];
                    }
                }
            }
            [historyArr insertObject:saveStr atIndex:0];
            [UserDefault setObject:[historyArr copy] forKey:@"fcMapHistoryAreaArray"];
            [weakself.areaBtn setTitle:area forState:UIControlStateNormal];
            weakself.pageNumber = 1;
            [weakself requestDataWithIsLoadMore:NO];
        };
    }
    return _areaView;
}


- (CompanytypeSelectView *)companyTypeView {
    if (!_companyTypeView) {
        _companyTypeView = [[CompanytypeSelectView alloc] initWithFrame:CGRectMake(0, _areaBtn.bottom, SCREEN_WIDTH, SCREEN_HEIGHT)];
        DDWeakSelf;
        _companyTypeView.typeSelectBlock = ^(NSString * _Nonnull type) {
            if (![weakself.currentType isEqualToString:type]) {
                weakself.currentType = type;
                weakself.pageNumber = 1;
                [weakself requestDataWithIsLoadMore:NO];
            }
            type = type.length == 0 ? @"全部" : type;
            [weakself.typeBtn setTitle:type forState:UIControlStateNormal];
        };
    }
    
    return _companyTypeView;
}


//区域选择
- (void)areaSelect {
    if (_companyTypeView && _companyTypeView.hidden == NO) {
        [_companyTypeView hide];
    }
    if (_areaView) {
        if (_areaView.hidden) {
            [_areaView show];
        } else {
            [_areaView hide];
        }
    } else {
        [self.view insertSubview:self.areaView belowSubview:_areaBtn];
        [self.areaView show];
    }
}

//企业类型选择
- (void)companyTypeSelect {
    if (_areaView && _areaView.hidden == NO) {
        [_areaView hide];
    }
    if (_companyTypeView) {
        if (_companyTypeView.hidden) {
            [_companyTypeView show];
        } else {
            [_companyTypeView hide];
        }
    }
    //没有的就创建
    else {
        [self.view insertSubview:self.companyTypeView belowSubview:_areaBtn];
        [self.companyTypeView show];
    }
    
}

#pragma mark - 数据请求
- (void)requestDataWithIsLoadMore:(BOOL)isLoadMore {
    NSString *urlString = [NSString stringWithFormat:URL_FCMap_Stores,self.currentKeyword,self.currentProvince,self.currentCity,self.currentArea,self.currentType,self.pageNumber,_pageCount];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                    NSLog(@"----1 %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNumber = [json[@"totalCount"] intValue];
            if (weakself.totalNumber < 1) {
                [CddHUD showTextOnlyDelay:@"暂无搜索结果" view:weakself.view];
            }
            //如果不是加载更多
            if (isLoadMore == NO) {
                [weakself.mapView removeAnnotations:[weakself.annotationArr copy]];
                [weakself.annotationArr removeAllObjects];
                [weakself.dataSource removeAllObjects];
            }
            NSArray<FCMapModel *> *tempArr = [FCMapModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            for (FCMapModel *model in tempArr) {
                if (model.latitude != 0.0 && model.longitude != 0.0) {
                    [weakself.validDataSource addObject:model];
                    [weakself addCustomAnnotation:model];
                }
                model.nowLatitude = weakself.currentLat;
                model.nowLongitude = weakself.currentLon;
                if (model.latitude != 0.0 && model.longitude != 0.0) {
                    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(model.latitude, model.longitude));
                    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(weakself.currentLat,weakself.currentLon));
                    NSInteger distance = MAMetersBetweenMapPoints(point1,point2);
                    if (distance < 1000) {
                        model.distance = [NSString stringWithFormat:@"%ldm",(long)distance];
                    } else {
                        model.distance = [NSString stringWithFormat:@"%ldkm",(long)distance / 1000];
                    }
                } else {
                    model.distance = @"未知";
                }
            }
            [weakself.dataSource addObjectsFromArray:tempArr];
            
            if (weakself.annotationArr.count > 0 && isLoadMore == NO) {
                if (isLoadMore == NO) {
                    MAPointAnnotation_1 *ann = weakself.annotationArr[0];
                    FCMapModel *m = weakself.dataSource[0];
                    if ([ann.model.companyName isEqualToString:m.companyName]) {
                        [weakself.mapView selectAnnotation:weakself.annotationArr[0] animated:YES];
                    }
                }
            }
            
            if (weakself.dataSource.count > 0) {
                weakself.currentSelectView.model = weakself.dataSource[0];
                weakself.currentSelectView.hidden = NO;
                [UIView animateWithDuration:0.2 animations:^{
                    weakself.currentBtn.top = weakself.mapView.height - 145;
                    weakself.leftView.top = weakself.mapView.height - 155;
                }];
            } else {
                weakself.currentSelectView.hidden = YES;
                [UIView animateWithDuration:0.2 animations:^{
                    weakself.currentBtn.top = weakself.mapView.height - 50;
                    weakself.leftView.top = weakself.mapView.height - 60;
                }];
            }
            
            weakself.tbHeader.countArr = @[@(weakself.dataSource.count),json[@"totalCount"]];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
        }
    } Failure:^(NSError *error) {
    
    }];
}

//添加自定义点标记
-(void)addCustomAnnotation:(FCMapModel *)model {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
    MAPointAnnotation_1 *annotation = [[MAPointAnnotation_1 alloc] init];
    annotation.model = model;
    annotation.coordinate = coordinate;
    annotation.title    = model.companyName;
//    annotation.subtitle = @"CustomAnnotationView";
    [self.annotationArr addObject:annotation];
    [self.mapView addAnnotation:annotation];

}


- (void)panAction:(UIPanGestureRecognizer *)pan {
    if (pan.enabled == NO) return;
    
    CGPoint point = [pan locationInView:self.bgMoveView.superview];
    
    CGFloat maxY = SCREEN_HEIGHT - _touchViewHeight;
    CGFloat minY = _moveViewTop;
    
    //拖拽开始
    if (pan.state == UIGestureRecognizerStateBegan) {
        
//        NSLog(@"aaa------ %f ",point.y);
    }
    
    //正在拖拽中
    else if (pan.state == UIGestureRecognizerStateChanged) {
//        NSLog(@"bbb------ %f ",point.y);
        if (point.y > maxY || point.y < minY)
            return;
        
        self.bgMoveView.top = point.y;
    }
    
    //拖拽结束
    else if (pan.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"ccc------ %f ",point.y);
        if (point.y > maxY || point.y < minY)
            return;
        
        [self autoBackLocation:point.y];
    }
    
}

//拖拽停止时
- (void)autoBackLocation:(CGFloat)currentY {
    DDWeakSelf;
//    CGFloat centerY = SCREEN_HEIGHT / 2;
    CGFloat maxBottomY = SCREEN_HEIGHT - _touchViewHeight;
    CGFloat maxTopY = _moveViewTop;
    [UIView animateWithDuration:.3 animations:^{
        //顶部手势滑动
        if (weakself.isTop == YES) {
            //向下滑动
            if (currentY - maxTopY > responseMoveDistance) {
                weakself.bgMoveView.top = maxBottomY;
            }
            //向上滑动
            else {
                weakself.bgMoveView.top = maxTopY;
            }
        }
        //底部手势滑动
        else {
            //向上滑动
            if (maxBottomY - currentY > responseMoveDistance) {
                weakself.bgMoveView.top = maxTopY;
            }
            //向下滑动
            else {
                weakself.bgMoveView.top = maxBottomY;
            }
        }
    } completion:^(BOOL finished) {
        if (weakself.bgMoveView.top == maxTopY) {
            weakself.isTop = YES;
//            weakself.tableView.scrollEnabled = YES;
        } else {
            weakself.isTop = NO;
//            weakself.tableView.scrollEnabled = NO;
        }
    }];
}

//点击响应移动动画
- (void)clickMoveView {
    if (self.isTop == YES) {
        [self autoBackLocation:self.moveViewTop + responseMoveDistance + 10];
    } else {
        [self autoBackLocation:responseMoveDistance + 10];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat currentOffsetY = scrollView.contentOffset.y;
    
//    NSLog(@"----%f ",currentOffsetY);
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    
    return NO;
}


//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FCMapModel *model = _dataSource[indexPath.row];
    FCMapNavigationModel *navModel = [[FCMapNavigationModel alloc] init];
    navModel.nowLat = model.nowLatitude;
    navModel.nowLon = model.nowLongitude;
    navModel.targetLat = model.latitude;
    navModel.targetLon = model.longitude;
    navModel.endLocationName = model.address;
    if ([model.from compare:@"market"] == NSOrderedSame) {
        ShopMainPageVC *vc = [[ShopMainPageVC alloc] init];
        vc.storeID = model.marketId;
        vc.navModel = navModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.from compare:@"archive"] == NSOrderedSame) {
        NonmemberCompanyInfoVC *vc = [[NonmemberCompanyInfoVC alloc] init];
        vc.model = model;
        vc.navModel = navModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//单独取出来的那个cell点击事件
- (void)clickCell:(UITapGestureRecognizer *)tap {
    FCMapRecommendShopCell *cell = (FCMapRecommendShopCell *)tap.view;
    FCMapModel *model = cell.model;
    FCMapNavigationModel *navModel = [[FCMapNavigationModel alloc] init];
    navModel.nowLat = model.nowLatitude;
    navModel.nowLon = model.nowLongitude;
    navModel.targetLat = model.latitude;
    navModel.targetLon = model.longitude;
    navModel.endLocationName = model.address;
    if ([model.from compare:@"market"] == NSOrderedSame) {
        ShopMainPageVC *vc = [[ShopMainPageVC alloc] init];
        vc.storeID = model.marketId;
        vc.navModel = navModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.from compare:@"archive"] == NSOrderedSame) {
        NonmemberCompanyInfoVC *vc = [[NonmemberCompanyInfoVC alloc] init];
        vc.model = model;
        vc.navModel = navModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCMapRecommendShopCell *cell = [FCMapRecommendShopCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    cell.searchRouteBlock = ^(FCMapNavigationModel * _Nonnull model) {
        [MapNavigationClass showMapNavigationWithModel:model];
    };
    return cell;
}


//回到当前位置的方法
- (void)goCurrentLocation {
    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    }
}


//获取当前位置
- (void)getCurrentLocation {
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    DDWeakSelf;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            NSLog(@"获取出错");
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //定位成功
        if (regeocode) {
            weakself.currentLat = location.coordinate.latitude;
            weakself.currentLon = location.coordinate.longitude;
            
            if ([weakself.from isEqualToString:@"home"]) {
                [weakself goCurrentLocation];
                weakself.currentArea = regeocode.district;
                if (weakself.currentArea.length > 0)
                    [weakself.areaBtn setTitle:weakself.currentArea forState:UIControlStateNormal];
                
                [weakself requestDataWithIsLoadMore:NO];
            } else {
                [weakself getFCLocation];
            }
        } else {
            weakself.currentLat = @(0).doubleValue;
            weakself.currentLon = @(0).doubleValue;
        }
    }];
}

//朋友圈点进来就直接拿朋友圈定位坐标
- (void)getFCLocation {
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:_model.latitude longitude:_model.longitude];
    regeo.requireExtension = YES;
    [self.searchLocation AMapReGoecodeSearch:regeo];
}


- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(_model.latitude, _model.longitude) animated:YES];
        self.currentArea = response.regeocode.addressComponent.district;
        if (self.currentArea.length > 0)
            [self.areaBtn setTitle:self.currentArea forState:UIControlStateNormal];
        
        [self requestDataWithIsLoadMore:NO];
    } else {
        self.currentLat = @(0).doubleValue;
        self.currentLon = @(0).doubleValue;
    }
}


#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (!annotationView)
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationStyleReuseIndetifier];

        annotationView.image = [UIImage imageNamed:@"userPosition"];
        self.userLocationAnnotationView = annotationView;
        return annotationView;
    }
    else if ([annotation isKindOfClass:[MAPointAnnotation_1 class]] && ![annotation.title isEqualToString:@"target"])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";

        FCMapCustomAnnotationView *annotationView = (FCMapCustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];

        if (annotationView == nil)
        {
            annotationView = [[FCMapCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        }
                annotationView.name = annotation.title;

        return annotationView;
    }
    return nil;
}

//点击标记点代理方法
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    MAPointAnnotation_1 *mview = (MAPointAnnotation_1 *)view.annotation;
    FCMapModel *model = mview.model;
    self.currentSelectView.model = model;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
    [self.mapView setCenterCoordinate:coordinate animated:YES];
}


- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (!updatingLocation && self.userLocationAnnotationView != nil) {
        [UIView animateWithDuration:0.1 animations:^{
            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
        }];
    }
}


@end


@implementation MapTBHeader {
    YYLabel *_countLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"fc_map_pullMore"];
    imageView.image = [image imageWithTintColor_My:UIColor.grayColor];
    imageView.frame = CGRectMake((SCREEN_WIDTH - 32) / 2, 10, 32, 3);
    [self addSubview:imageView];
    
    _countLab = [[YYLabel alloc] init];
    _countLab.frame = CGRectMake(0, imageView.bottom + 8, SCREEN_WIDTH, 25);
    _countLab.font = [UIFont systemFontOfSize:15];
    _countLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_countLab];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGBA(0, 0, 0, .1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
    }];
}


- (void)setCountArr:(NSArray *)countArr {
    _countArr = countArr;
    
    NSInteger alreadyShowCount = [countArr[0] integerValue];
    NSInteger totalCount = [countArr[1] integerValue];
    
    if (totalCount == 0) {
        _countLab.text = @"暂未找到公司";
    } else {
        NSString *ftext = [NSString stringWithFormat:@"已展示%ld条结果",(long)alreadyShowCount];
        NSString *btext = [NSString stringWithFormat:@"(共%ld条)",(long)totalCount];
        
        NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:[ftext stringByAppendingString:btext]];
        mText.yy_alignment = NSTextAlignmentCenter;
        mText.yy_font = [UIFont systemFontOfSize:16];
        [mText yy_setFont:[UIFont boldSystemFontOfSize:23] range:NSMakeRange(3,@(alreadyShowCount).stringValue.length)];
        [mText yy_setColor:HEXColor(@"#ED3851", 1) range:NSMakeRange(3,@(alreadyShowCount).stringValue.length)];
        [mText yy_setFont:[UIFont systemFontOfSize:13] range:NSMakeRange(ftext.length,btext.length)];
        [mText yy_setColor:HEXColor(@"#333333", 1) range:NSMakeRange(ftext.length,btext.length)];
        
        _countLab.attributedText = mText;
    }
}

@end


