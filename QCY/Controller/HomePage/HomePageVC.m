//
//  HomePageVC.m
//  QCY
//
//  Created by zz on 2018/9/4.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HomePageVC.h"
#import "HomePageHeaderView.h"
#import "HomePageSectionHeader.h"
#import "PromotionsCell.h"
#import "HomePageMapTBCell.h"
#import "AskToBuyCell.h"
#import "OpenMallVC_Cell.h"
#import "ClassTool.h"
#import "NSString+Class.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "HomePageModel.h"
#import "OpenMallModel.h"
#import "PYSearch.h"
#import <MJRefresh.h>
#import "OpenMallClassifyVC.h"
#import "ProductMallVC.h"
#import "AskToBuyVC.h"
#import "NetWorkingPort.h"
#import "IndustryInformationVC.h"
#import "AskToBuyDetailsVC.h"
#import "ShopMainPageVC.h"
#import "ZhuJiDiySpecialVC.h"
#import "HomePageSearchVC.h"
#import "WithoutNetView.h"
#import "GlobalFooterView.h"
#import "UpdateAppView.h"
#import "HelperTool.h"
#import "UIDevice+UUID.h"
#import "ADAlertView.h"
/*  活动页面 */
#import "GroupBuyingVC.h"
#import "DiscountSalesVC.h"
#import "PrchaseLeagueVC.h"
#import "VoteVC.h"
#import "AuctionVC.h"
#import "ProxySaleMarketVC.h"
#import "NavControllerSet.h"
#import "BaseNavigationController.h"
#import "WebViewVC.h"
#import "FCMapVC.h"
#import <JPUSHService.h>
#import <UMCommon/UMConfigure.h>
#import <UMAnalytics/MobClick.h>
#import "VCJump.h"
#import <SDWebImage.h>
#import "LiveOnlineVC.h"


@interface HomePageVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) HomePageModel *dataSource;
@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) HomePageHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *salesArray;
@property (nonatomic, strong) WithoutNetView *withoutView;
@property (nonatomic, assign)BOOL isFirstLoad;
@property (nonatomic, copy) NSArray<BannerModel *> *adArray;
@property (nonatomic, copy) NSArray<BannerModel *> *iconArray;
@property (nonatomic, strong) NSDictionary *homeDict;
//0 不更新,1 非强制更新，2强制更新
@property (nonatomic, assign) NSInteger updateType;
@end

@implementation HomePageVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isFirstLoad = YES;
        _updateType = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self requestMultiData];
    Tab_BadgeValue_1(Get_Badge_Fc);
    Icon_BadgeValue = 0;
    [JPUSHService setBadge:0];
    //各个子页面全部刷新！！！！！！！
    NSString *nfcNameAll = @"refreshAllDataWithThis";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestMultiData) name:nfcNameAll object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.navigationItem.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.navigationItem.title];
}



- (WithoutNetView *)withoutView {
    if (!_withoutView) {
        _withoutView = [[WithoutNetView alloc] init];
        _withoutView.top = SCREEN_HEIGHT / 2 - 100;
        [_withoutView.refreshBtn addTarget:self action:@selector(requestMultiData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _withoutView;
}


- (void)setNavBar {
    [self addRightBarButtonWithFirstImage:[UIImage imageNamed:@"search"] action:@selector(jumpToSearch)];
}

- (void)jumpToSearch {
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"输入关键词搜索" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        HomePageSearchVC *vc = [[HomePageSearchVC alloc]init];
        vc.searchKeyWord = searchText;
        [searchViewController.navigationController pushViewController:vc animated:NO];
    }];
    //历史搜索风格
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchViewController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav  animated:NO completion:nil];
}

//懒加载tableView
- (BaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = Like_Color;
        //取消垂直滚动条
        //_tableView.showsVerticalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, 0, 0);
//        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        DDWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakself.bannerArray removeAllObjects];
            [weakself requestMultiData];
        }];
        _tableView.tableHeaderView = self.headerView;
        self.headerView.iconArray = self.iconArray;
        GlobalFooterView *footer = [[GlobalFooterView alloc] init];
        _tableView.tableFooterView = footer;
    }
    return _tableView;
}

- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _bannerArray;
}

- (NSMutableArray *)salesArray {
    if (!_salesArray) {
        _salesArray = [NSMutableArray arrayWithCapacity:4];
    }
    return _salesArray;
}


//创建自定义的tableView headerView
- (HomePageHeaderView *)headerView {
     if (!_headerView) {
         CGFloat headerHeight = KFit_W(144) + 65 + 6;
         _headerView = [[HomePageHeaderView alloc] init];
         _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerHeight);
         DDWeakSelf;

         _headerView.clickBanerBlock = ^(BannerModel *model) {
             [VCJump jumpToWithModel_Ad:model];
         };
        
         _headerView.tapIconsBlock = ^(NSString *code) {
             if ([code isEqualToString:@"product"]) {
                 ProductMallVC *vc = [[ProductMallVC alloc] init];
                 [weakself.navigationController pushViewController:vc animated:YES];
             }
             else if ([code isEqualToString:@"market"]) {
                 OpenMallClassifyVC *vc = [[OpenMallClassifyVC alloc] init];
                 [weakself.navigationController pushViewController:vc animated:YES];
             }
             else if ([code isEqualToString:@"enquiry"]) {
                 AskToBuyVC *vc = [[AskToBuyVC alloc] init];
                 [weakself.navigationController pushViewController:vc animated:YES];
             }
             else if ([code isEqualToString:@"zhuji_diy"]) {
                 ZhuJiDiySpecialVC *vc = [[ZhuJiDiySpecialVC alloc] init];
                 [weakself.navigationController pushViewController:vc animated:YES];
             }
             else if ([code isEqualToString:@"information"]) {
                 IndustryInformationVC *vc = [[IndustryInformationVC alloc] init];
                 vc.fromPage = @"homePage";
                 [weakself.navigationController pushViewController:vc animated:YES];
             }
             else if ([code isEqualToString:@"school_live_class"]) {
                 LiveOnlineVC *vc = [[LiveOnlineVC alloc] init];
                 [weakself.navigationController pushViewController:vc animated:YES];
             }
         };
    }

    return _headerView;
}

#pragma mark - 获取列表数据
- (void)requestMultiData {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    //首页列表
    dispatch_group_enter(group);
    if (_isFirstLoad == YES) {
        [CddHUD show:self.view];
    }
    dispatch_group_async(group, globalQueue, ^{
        //获取当前app版本
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *current_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *jpushStr = [NSString string];
        //        NSLog(@"-- %@",JPushID);
        if (JPushID) {
            jpushStr = JPushID;
        } else {
            jpushStr = [JPUSHService registrationID];
        }
        NSString *urlString = [NSString stringWithFormat:URL_HomePage_List_CheckUpdate,User_Token, jpushStr ,current_Version,[UIDevice getDeviceID]];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//            NSLog(@"-----11   %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                self.homeDict = json;
                self.dataSource = [HomePageModel mj_objectWithKeyValues:json[@"data"]];
                
                BOOL isCom = self.dataSource.isCompany_User.boolValue;
                if (isCom != isCompanyUser) {
                    NSMutableDictionary *userDict = [User_Info mutableCopy];
                    [userDict setObject:isCom ? self.dataSource.companyName : @"" forKey:@"companyName"];
                    [userDict setObject:json[@"data"][@"isCompany"] forKey:@"isCompany"];
                    [UserDefault setObject:userDict forKey:@"userInfo"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAllDataWithThis" object:nil userInfo:nil];
                }
                
                [self setBadgeValuesWithWithDict:json[@"data"]];
                self.dataSource.enquiryList = [AskToBuyModel mj_objectArrayWithKeyValuesArray:self.dataSource.enquiryList];
                self.dataSource.marketList = [OpenMallModel mj_objectArrayWithKeyValuesArray:self.dataSource.marketList];
                for (OpenMallModel *model in self.dataSource.marketList) {
                    model.businessList = [BusinessList mj_objectArrayWithKeyValuesArray:model.businessList];
                }
                
                if ([self.dataSource.login_status isEqualToString:@" "]) {
                    [UserDefault removeObjectForKey:@"userInfo"];   //退出登陆操作
                    [self jumpToLogin];
                }
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            [self.view addSubview:self.withoutView];
//                        dispatch_group_leave(group);
        }];
        
    });
    
    //获取轮播图
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Get_Banner,@"APP_Index_Banner"];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//                                                 NSLog(@"----2 %@",json);
                self.bannerArray = [BannerModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            [self.view addSubview:self.withoutView];
            //            dispatch_group_leave(group);
        }];
    });
    
    //获取icon
    dispatch_group_enter(group);
        dispatch_group_async(group, globalQueue, ^{
            NSString *urlString = [NSString stringWithFormat:URL_Get_Banner,@"APP_Index_Plate"];
            [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                NSLog(@"icon--- %@",json);
                if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                    self.iconArray = [BannerModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                }
                dispatch_group_leave(group);
            } Failure:^(NSError *error) {
                [self.view addSubview:self.withoutView];
                //            dispatch_group_leave(group);
            }];
        });
    
    //获取活动
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Get_Banner,@"APP_Sales_Promotion"];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//                NSLog(@"----3 %@",json);
                self.salesArray = [BannerModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                //                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
                //                [weakself.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            [self.view addSubview:self.withoutView];
            //            dispatch_group_leave(group);
        }];
    });
    
    //获取活动弹窗
        dispatch_group_enter(group);
        dispatch_group_async(group, globalQueue, ^{
            NSString *urlString = [NSString stringWithFormat:URL_Get_Banner,@"APP_Index_Ad"];
            [ClassTool getRequest:urlString Params:nil Success:^(id json) {
                if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//                    NSLog(@"----4 %@",json);
                    self.adArray = [BannerModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                }
                dispatch_group_leave(group);
            } Failure:^(NSError *error) {
                [self.view addSubview:self.withoutView];
                //            dispatch_group_leave(group);
            }];
        });

    //全部任务完成后，就可以在这吊了
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.withoutView removeFromSuperview];
            self.withoutView = nil;
            [self.tableView.mj_header endRefreshing];
            if (self.isFirstLoad == YES) {
                [self.view addSubview:self.tableView];
                [self checkVersion:self.homeDict];
                if (self.updateType == 0) {
                    [self alertAD];
                }
                self.isFirstLoad = NO;
            } else {
                [self.tableView reloadData];
            }
            [self.tableView reloadData];
            self.headerView.bannerArray = [self.bannerArray copy];
            self.headerView.iconArray = self.iconArray;
            [CddHUD hideHUD:self.view];
        });
    });
}

//广告弹窗
- (void)alertAD {
    if ([UserDefault objectForKey:@"isFirstLaunch"]) {
        if (self.adArray.count > 0) {
            BannerModel *model = self.adArray[0];
            if (isRightData(model.ad_image)) {
    //            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:ImgUrl(model.ad_image) completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
    //            }];
                [ADAlertView showWithURL:model.ad_image handler:^{
                    [VCJump jumpToWithModel_Ad:model];
                }];
            }
        }
    }
}

//版本更新
- (void)checkVersion:(id)json {
    NSString *isUpdate = To_String(json[@"data"][@"iosVersion"][@"hasUpdate"]);
    if ([isUpdate isEqualToString:@"1"]) {
        self.updateType = 1;
        //更新说明，描述
        NSString *updateText = To_String(json[@"data"][@"iosVersion"][@"description"]);
        //是否强制更新
        NSString *isMustUpdate = To_String(json[@"data"][@"iosVersion"][@"isForce"]);
        if (isMustUpdate.intValue == 1) {
            self.updateType = 2;
        }
        //更新的url
        NSString *updateUrl = To_String(json[@"data"][@"iosVersion"][@"url"]);
        //更新到的版本号
        NSString *online_Version = To_String(json[@"data"][@"iosVersion"][@"versionCode"]);
        //        NSString *updateUrl = @"https://itunes.apple.com/cn/app/id1329918420?mt=8";
        UpdateAppView *updateView = [[UpdateAppView alloc]init];
        if (self.updateType == 1) {
            DDWeakSelf;
            updateView.closeClickBlock = ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself alertAD];
                });
            };
        }
        updateView.updateUrl = updateUrl;
        updateView.version = online_Version;
        [UIApplication.sharedApplication.keyWindow addSubview:updateView];
        //        NSString *text = @"1、更新了我的页面\n2、更新了我的页面\n3、更新了我的页面\n4、更新了我的页面\n5、更新了我的页面\n6、更新了我的页面\n7、更新了我的页面\n8、更新了我的页面\n9、更新了我的页面\n10、更新了我的页面\n11、更新了我的页面\n";
        [updateView setupUIWithText:updateText isMustUpdate:isMustUpdate];
    }
}

//设置bagdevalue
- (void)setBadgeValuesWithWithDict:(NSDictionary *)dict {
//    NSLog(@"home---    %@",dict);
    if (isRightData(To_String(dict[@"buyer_not_read_count"])) && isRightData(To_String(dict[@"seller_not_read_count"]))) {
        //设置买家和卖家的本地存储数量
        Msg_Buyer_Count_Set([dict[@"buyer_not_read_count"] integerValue]);
        Msg_Seller_Count_Set([dict[@"seller_not_read_count"] integerValue]);
         
        //消息的tabbar的本地存储
        Tabbar_Msg_Badge_Set(Msg_Buyer_Count_Get + Msg_Seller_Count_Get + Msg_Sys_Count_Get);
        //设置tabbar
        Tab_BadgeValue_2(Count_For_Tabbar(Tabbar_Msg_Badge_Get));
        
        [[NSNotificationCenter defaultCenter] postNotificationName:App_Notification_Change_MsgCount object:nil];
    }
}


#pragma mark - tableView代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    } else if (section == 2) {
        return _dataSource.enquiryList.count;
    } else {
        return _dataSource.marketList.count;
    }
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return KFit_W(75) + 6;
    } else if (indexPath.section == 1) {
        int lineNum = (int)ceilf(self.salesArray.count / 2.0);
        return KFit_W(75 * lineNum) + 6;
    } else {
        return 126;
    }
}

//给出cell的估计高度，主要目的是优化cell高度的计算次数
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? KFit_W(75 * 2) : 126;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *titleArr = @[@"印染地图",@"促销活动",@"热门求购",@"推荐店铺"];
    HomePageSectionHeader *header = [ HomePageSectionHeader headerWithTableView:tableView];
    header.titleLabel.text = titleArr[section];
    DDWeakSelf;
    switch (section) {
        case 0:
        case 1:
            header.moreLabel.hidden = YES;
            break;
        case 2:
        {
            header.moreLabel.hidden = NO;
            header.clickMoreBlock = ^{
                AskToBuyVC *vc = [[AskToBuyVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            };
        }
            break;
        case 3:
        {
            header.moreLabel.hidden = NO;
            header.clickMoreBlock = ^{
                OpenMallClassifyVC *vc = [[OpenMallClassifyVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            };
        }
            break;
        default:
            break;
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            FCMapVC *vc = [[FCMapVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            AskToBuyDetailsVC *vc = [[AskToBuyDetailsVC alloc] init];
            AskToBuyModel *model = _dataSource.enquiryList[indexPath.row];
            vc.buyID = model.buyID;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            ShopMainPageVC *vc = [[ShopMainPageVC alloc] init];
            OpenMallModel *model = _dataSource.marketList[indexPath.row];
            vc.storeID = model.storeID;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomePageMapTBCell *cell = [HomePageMapTBCell cellWithTableView:tableView];
        return cell;
    } else if (indexPath.section == 1) {
        DDWeakSelf;
        PromotionsCell *cell = [PromotionsCell cellWithTableView:tableView];
        cell.dataSource = self.salesArray;
        cell.promotionsBlock = ^(NSInteger type) {
            [weakself jumpToPromotions:type];
        };
        return cell;
    } else if (indexPath.section == 2) {
        AskToBuyCell *cell = [AskToBuyCell cellWithTableView:tableView];
        cell.model = _dataSource.enquiryList[indexPath.row];
        return cell;
    } else {
        OpenMallVC_Cell *cell = [OpenMallVC_Cell cellWithTableView:tableView];
        cell.model = _dataSource.marketList[indexPath.row];
        return cell;
    }
}



#pragma mark - 点击icon跳转
//首页活动模块跳转到各个活动页面
- (void)jumpToPromotions:(NSInteger)type {
    switch (type) {
        case 0:
        {
            GroupBuyingVC *vc = [[GroupBuyingVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            DiscountSalesVC *vc = [[DiscountSalesVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            PrchaseLeagueVC *vc = [[PrchaseLeagueVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            VoteVC *vc = [[VoteVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            AuctionVC *vc = [[AuctionVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            ProxySaleMarketVC *vc = [[ProxySaleMarketVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
