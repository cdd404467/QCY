//
//  HomePageVC.m
//  QCY
//
//  Created by zz on 2018/9/4.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HomePageVC.h"
#import "MacroHeader.h"
#import "UIView+Geometry.h"
#import "HomePageHeaderView.h"
#import "HomePageSectionHeader.h"
#import "PromotionsCell.h"
#import "AskToBuyCell.h"
#import "OpenMallVC_Cell.h"
#import "ClassTool.h"
#import "UIDevice+UUID.h"
#import "NSString+Class.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "HomePageModel.h"
#import "OpenMallModel.h"
#import "PYSearch.h"
#import <MJRefresh.h>
#import "OpenMallVC.h"
#import "ProductMallVC.h"
#import "AskToBuyVC.h"
#import "NetWorkingPort.h"
#import "IndustryInformationVC.h"
#import "AskToBuyDetailsVC.h"
#import "ShopMainPageVC.h"
#import "HomePageSearchVC.h"
#import "WithoutNetView.h"
#import "UIView+Geometry.h"
#import "UIView+Geometry.h"
#import "GlobalFooterView.h"
#import "UpdateAppView.h"
#import "HelperTool.h"
/*  活动页面 */
#import "GroupBuyingVC.h"
#import "DiscountSalesVC.h"
#import "PrchaseLeagueVC.h"
#import "VoteVC.h"
#import "AuctionVC.h"
#import "NavControllerSet.h"
#import "BaseNavigationController.h"


@interface HomePageVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)HomePageModel *dataSource;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)HomePageHeaderView *headerView;
@property (nonatomic, strong)NSMutableArray *bannerArray;
@property (nonatomic, strong)NSMutableArray *salesArray;
@property (nonatomic, strong)WithoutNetView *withoutView;
@property (nonatomic, assign)BOOL isFirstLoad;
@end

@implementation HomePageVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isFirstLoad = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self requestMultiData];

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
//    NSArray *arr = @[@"阿伦",@"封金能"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"输入关键词搜索" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        HomePageSearchVC *vc = [[HomePageSearchVC alloc]init];
        vc.searchKeyWord = searchText;
        [searchViewController.navigationController pushViewController:vc animated:NO];
    }];
    //历史搜索风格
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}



//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:SCREEN_BOUNDS style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消垂直滚动条
//        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
//            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, TABBAR_HEIGHT, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        DDWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakself.bannerArray removeAllObjects];
            [weakself requestMultiData];
        }];
        
        _tableView.tableHeaderView = [self addHeaderView];
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
        _salesArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _salesArray;
}


//创建自定义的tableView headerView
- (HomePageHeaderView *)addHeaderView {
    CGFloat headerHeight = KFit_W(144) + 65 + 6;
    HomePageHeaderView *headerView = [[HomePageHeaderView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerHeight);
    DDWeakSelf;
    headerView.tapIconsBlock = ^(NSInteger tag) {
        switch (tag) {
            case 0: {
                OpenMallVC *vc = [[OpenMallVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1: {
                AskToBuyVC *vc = [[AskToBuyVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2: {
                ProductMallVC *vc = [[ProductMallVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3: {
                IndustryInformationVC *vc = [[IndustryInformationVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    };
    _headerView = headerView;
    return headerView;
}

#pragma mark - 获取列表数据
- (void)requestMultiData {
    DDWeakSelf;
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
//        NSString *urlString = [NSString stringWithFormat:URL_HomePage_List,User_Token];
        NSString *urlString = [NSString stringWithFormat:URL_HomePage_List_CheckUpdate,User_Token,current_Version];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//            NSLog(@"----1 %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                weakself.dataSource = [HomePageModel mj_objectWithKeyValues:json[@"data"]];
                [weakself checkVersion:json];
                weakself.dataSource.enquiryList = [AskToBuyModel mj_objectArrayWithKeyValuesArray:weakself.dataSource.enquiryList];
                weakself.dataSource.marketList = [OpenMallModel mj_objectArrayWithKeyValuesArray:weakself.dataSource.marketList];
                for (OpenMallModel *model in weakself.dataSource.marketList) {
                    model.businessList = [BusinessList mj_objectArrayWithKeyValuesArray:model.businessList];
                }
                
                if ([weakself.dataSource.login_status isEqualToString:@"NO_LOGIN"]) {
                    [UserDefault removeObjectForKey:@"userInfo"];   //退出登陆操作
                    [weakself jumpToLogin];
                }
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            [weakself.view addSubview:weakself.withoutView];
//            dispatch_group_leave(group);
        }];

    });
    
    //获取轮播图
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Get_Banner,@"APP_Index_Banner"];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//                                 NSLog(@"----2 %@",json);
                NSArray *bArray = [BannerModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                for (BannerModel *model in bArray) {
                    [weakself.bannerArray addObject:ImgUrl(model.ad_image)];
                }
//                weakself.headerView.bannerArray = [weakself.bannerArray copy];
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            [weakself.view addSubview:weakself.withoutView];
//            dispatch_group_leave(group);
        }];
    });
    
    //获取活动
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Get_Banner,@"APP_Sales_Promotion"];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//                                                 NSLog(@"----3 %@",json);
                weakself.salesArray = [BannerModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
//                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
//                [weakself.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            [weakself.view addSubview:weakself.withoutView];
//            dispatch_group_leave(group);
        }];
    });
    
    //全部任务完成后，就可以在这吊了
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.withoutView removeFromSuperview];
            weakself.withoutView = nil;
            [weakself.tableView.mj_header endRefreshing];
            if (weakself.isFirstLoad == YES) {
                [weakself.view addSubview:self.tableView];
                weakself.isFirstLoad = NO;
            } else {
                [weakself.tableView reloadData];
            }
            weakself.headerView.bannerArray = [weakself.bannerArray copy];
            [CddHUD hideHUD:weakself.view];
        });
    });
}

//版本更新
- (void)checkVersion:(id)json {
    NSString *isUpdate = To_String(json[@"data"][@"iosVersion"][@"hasUpdate"]);
    
    if ([isUpdate isEqualToString:@"1"]) {
        //更新说明，描述
        NSString *updateText = To_String(json[@"data"][@"iosVersion"][@"description"]);
        //是否强制更新
        NSString *isMustUpdate = To_String(json[@"data"][@"iosVersion"][@"isForce"]);
        //更新的url
        NSString *updateUrl = To_String(json[@"data"][@"iosVersion"][@"url"]);
        //更新到的版本号
        NSString *online_Version = To_String(json[@"data"][@"iosVersion"][@"versionCode"]);
//        NSString *updateUrl = @"https://itunes.apple.com/cn/app/id1329918420?mt=8";
        UpdateAppView *updateView = [[UpdateAppView alloc]init];
        updateView.updateUrl = updateUrl;
        updateView.version = online_Version;
        [UIApplication.sharedApplication.keyWindow addSubview:updateView];
//        NSString *text = @"1、更新了我的页面\n2、更新了我的页面\n3、更新了我的页面\n4、更新了我的页面\n5、更新了我的页面\n6、更新了我的页面\n7、更新了我的页面\n8、更新了我的页面\n9、更新了我的页面\n10、更新了我的页面\n11、更新了我的页面\n";
        [updateView setupUIWithText:updateText isMustUpdate:isMustUpdate];
    }
    
}

#pragma mark - tableView代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return _dataSource.enquiryList.count;
    } else {
        return _dataSource.marketList.count;
    }
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        int lineNum = (int)ceilf(_salesArray.count / 2.0);
        return KFit_W(75 * lineNum) + 6;
    } else {
        return 126;
    }
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
    NSArray *titleArr = @[@"促销活动",@"热门求购",@"推荐店铺"];
    HomePageSectionHeader *header = [ HomePageSectionHeader headerWithTableView:tableView];
    header.titleLabel.text = titleArr[section];
    DDWeakSelf;
    if (section == 0) {
        header.moreLabel.hidden = YES;
        return header;
    } else if (section == 1) {
        header.moreLabel.hidden = NO;
        header.clickMoreBlock = ^{
            AskToBuyVC *vc = [[AskToBuyVC alloc] init];
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        return header;
    } else {
        header.moreLabel.hidden = NO;
        header.clickMoreBlock = ^{
            OpenMallVC *vc = [[OpenMallVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        };
        return header;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        GroupBuyingVC *vc = [[GroupBuyingVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        AskToBuyDetailsVC *vc = [[AskToBuyDetailsVC alloc] init];
        AskToBuyModel *model = _dataSource.enquiryList[indexPath.row];
        vc.buyID = model.buyID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 2) {
        ShopMainPageVC *vc = [[ShopMainPageVC alloc] init];
        OpenMallModel *model = _dataSource.marketList[indexPath.row];
        vc.storeID = model.storeID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DDWeakSelf;
        PromotionsCell *cell = [PromotionsCell cellWithTableView:tableView];
//        cell.model = _salesArray[indexPath.row];
        cell.dataSource = _salesArray;
        cell.promotionsBlock = ^(NSInteger type) {
            [weakself jumpToPromotions:type];
        };
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
        default:
            break;
    }
}


#pragma mark 唤起App专用
-(void)urlAwake:(NSNotification *)notification {
    NSString *classString = notification.userInfo[@"className"];
//    Class JumpClass = NSClassFromString(classString);
    
    UIViewController *vc = [classString stringToClass:classString];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
