//
//  HomePageVC.m
//  QCY
//
//  Created by zz on 2018/9/4.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HomePageVC.h"
#import "MacroHeader.h"
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
/** 跳转的页面 **/
#import "OpenMallVC.h"
#import "ProductMallVC.h"
#import "AskToBuyVC.h"
#import "NetWorkingPort.h"
#import "IndustryInformationVC.h"
#import "GroupBuyingVC.h"
#import "AskToBuyDetailsVC.h"
#import "ShopMainPageVC.h"
#import "HomePageSearchVC.h"
#import "WithoutNetView.h"
#import "UIView+Geometry.h"
#import "UIView+Geometry.h"
#import "GlobalFooterView.h"
#import "UpdateAppView.h"
#import "HelperTool.h"

#define sectionHeaderHeight 40
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
//    [self registerNotifi];
    self.navigationController.navigationBar.translucent = NO;

    [self setRightItem];
    [self requestMultiData];

}

//- (void)registerNotifi {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(urlAwake:) name:@"urlJump" object:nil];
//}



- (WithoutNetView *)withoutView {
    if (!_withoutView) {
        _withoutView = [[WithoutNetView alloc] init];
        _withoutView.top = SCREEN_HEIGHT / 2 - 100;
        [_withoutView.refreshBtn addTarget:self action:@selector(requestMultiData) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _withoutView;
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
        HomePageSearchVC *vc = [[HomePageSearchVC alloc]init];
        vc.searchKeyWord = searchText;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //取消垂直滚动条
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
//            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
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
    CGFloat headerHeight = 8 + KFit_W(144) + 65 + 6;
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
        NSString *urlString = [NSString stringWithFormat:URL_HomePage_List,User_Token];
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
                    [UserDefault removeObjectForKey:@"userInfo"];   //推出登陆操作
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
    
    //活动
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Get_Banner,@"APP_Group_Buy"];
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
    //当前版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *current_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //线上版本
    NSString *online_Version = To_String(json[@"data"][@"iosVersion"][@"versionCode"]);
    NSInteger result = [HelperTool compareVersionWithOnline:online_Version oldVersion:current_Version];
    
    if (result == 1) {
        //更新说明，描述
        NSString *updateText = To_String(json[@"data"][@"iosVersion"][@"description"]);
        //是否强制更新
        NSString *isMustUpdate = To_String(json[@"data"][@"iosVersion"][@"isForce"]);
        //更新的url
        NSString *updateUrl = To_String(json[@"data"][@"iosVersion"][@"url"]);
//        NSString *updateUrl = @"https://itunes.apple.com/cn/app/id1329918420?mt=8";
        UpdateAppView *updateView = [[UpdateAppView alloc]init];
        updateView.updateUrl = updateUrl;
        updateView.version = online_Version;
        [UIApplication.sharedApplication.keyWindow addSubview:updateView];
//        NSString *text = @"1、更新了我的页面\n2、更新了我的页面\n3、更新了我的页面\n4、更新了我的页面\n5、更新了我的页面\n6、更新了我的页面\n7、更新了我的页面\n8、更新了我的页面\n9、更新了我的页面\n10、更新了我的页面\n11、更新了我的页面\n";
        [updateView setupUIWithText:updateText isMustUpdate:isMustUpdate];
    }
    
}



//header不悬停
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.tableView) {
        if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } else if (scrollView.contentOffset.y > sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }else if (scrollView.contentOffset.y <= sectionHeaderHeight){
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
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
        return _salesArray.count;
    } else if (section == 1) {
        return _dataSource.enquiryList.count;
    } else {
        return _dataSource.marketList.count;
    }
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return KFit_H(110) + 6;
    } else {
        return 126;
    }
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return sectionHeaderHeight;
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
            [weakself.navigationController pushViewController:vc animated:YES];
        };
        return header;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GroupBuyingVC *vc = [[GroupBuyingVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
        PromotionsCell *cell = [PromotionsCell cellWithTableView:tableView];
        cell.model = _salesArray[indexPath.row];
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
