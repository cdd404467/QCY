//
//  SettingVC.m
//  QCY
//
//  Created by i7colors on 2018/10/24.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "SettingVC.h"
#import "Alert.h"
#import <YYWebImage.h>
#import "Alert.h"
#import <UIImageView+WebCache.h>
#import "CddHUD.h"
#import "AboutQCY.h"
#import "MyInfoCenterVC.h"
#import "NavControllerSet.h"
#import "CddActionSheetView.h"
#import <JPUSHService.h>


@interface SettingVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *titleArray;
@property (nonatomic, strong)NSMutableArray *subTitleArray;
@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = Like_Color;
    [self vhl_setNavBarBackgroundColor:Like_Color];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self setupUI];
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        NSArray *arr = @[@[@"关于七彩云",@"版本信息",@"清除缓存"],@[@"账号中心"],@[@"退出登录"]];
        _titleArray = [NSMutableArray arrayWithArray:arr];
    }
    
    return _titleArray;
}

- (NSMutableArray *)subTitleArray {
    if (!_subTitleArray) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *current_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *version = [NSString stringWithFormat:@"版本%@",current_Version];
        NSArray *arr = @[@[@"",version,@""],@[@""],@[@""]];
        _subTitleArray = [NSMutableArray arrayWithArray:arr];
    }
    return _subTitleArray;
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, self.tableView.width, 80)];
    copyrightLabel.numberOfLines = 2;
    copyrightLabel.text = @"Copyright © 2019\ni7colors.com  版权所有";
    copyrightLabel.font = [UIFont systemFontOfSize:15];
    copyrightLabel.textColor = HEXColor(@"#868686", 1);
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:copyrightLabel];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT - 50) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = Like_Color;
        [_tableView setSeparatorColor : HEXColor(@"#ebebeb", 1)];
        _tableView.bounces = NO;
        //取消垂直滚动条
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (void)clearCache {
    DDWeakSelf;
    [Alert alertTwo:@"是否确定清除缓存?" cancelBtn:@"取消" okBtn:@"确定" OKCallBack:^{
        __block MBProgressHUD *hud;
        dispatch_async(dispatch_get_main_queue(), ^{
            hud = [CddHUD showWithText:@"清理中..." view:weakself.view];
        });
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
        //SDWebimage
        dispatch_group_enter(group);
        dispatch_group_async(group, globalQueue, ^{
            [[[SDWebImageManager sharedManager] imageCache] clearWithCacheType:SDImageCacheTypeDisk completion:^{
                dispatch_group_leave(group);
            }];
        });

        //YYwebimage
        dispatch_group_enter(group);
        dispatch_group_async(group, globalQueue, ^{
            YYImageCache *cache = [YYWebImageManager sharedManager].cache;
            [cache.diskCache removeAllObjectsWithBlock:^{
                dispatch_group_leave(group);
            }];
        });

        //全部任务完成后操作
        dispatch_group_notify(group, globalQueue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [CddHUD showSwitchText:hud text:@"清理完成!"];
            });
        });

        
    }];
}

#pragma mark - tableView代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [self.titleArray[section] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AboutQCY *vc = [[AboutQCY alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
            [self clearCache];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            MyInfoCenterVC *vc = [[MyInfoCenterVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        [self exitLogin];
    }
}

//cell的高度
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 70;
//}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        if (indexPath.section == 2) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
    }
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.text = self.subTitleArray[indexPath.section][indexPath.row];
    //控制显示箭头和文字位置
    if (indexPath.section == 2) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        if (indexPath.section == 0 && indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

- (void)exitLogin {
    NSString *title = @"确定要退出登录吗?";
    DDWeakSelf;
    CddActionSheetView *sheetView = [[CddActionSheetView alloc] initWithSheetOKTitle:@"退出登录" cancelTitle:@"取消" completion:^{
        if (GET_USER_TOKEN) {
            [UserDefault removeObjectForKey:@"userInfo"];
            Tabbar_Msg_Badge_Set(Msg_Sys_Count_Get);
            [weakself.tabBarController.viewControllers[2].tabBarItem setBadgeValue:Count_For_Tabbar(Tabbar_Msg_Badge_Get)];
            [UserDefault removeObjectForKey:@"msgBuyerCount"];
            [UserDefault removeObjectForKey:@"msgSellerCount"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAllDataWithThis" object:@"loginRefresh" userInfo:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakself.tabBarController.selectedIndex = 0;
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }
    } cancel:nil];
    sheetView.title = title;
    [sheetView show];
}

@end
