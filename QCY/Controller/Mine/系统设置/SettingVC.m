//
//  SettingVC.m
//  QCY
//
//  Created by i7colors on 2018/10/24.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "SettingVC.h"
#import "MacroHeader.h"
#import "Alert.h"
#import <YYWebImage.h>
#import "Alert.h"
#import <UIImageView+WebCache.h>
#import "CddHUD.h"
#import "AboutQCY.h"

@interface SettingVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *titleArray;
@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        NSArray *arr = @[@[@"关于七彩云",@"清除缓存"],@[@"退出登录"]];
        _titleArray = [NSMutableArray arrayWithArray:arr];
    }
    
    return _titleArray;
}

- (void)setupNav {
    self.nav.titleLabel.text = @"设置";
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXColor(@"#f5f5f5", 1);
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
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AboutQCY *vc = [[AboutQCY alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
            [self clearCache];
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
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 51;
//}

//section footer的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01;
//}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (indexPath.section == 1) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

- (void)exitLogin {
    [Alert alertTwo:@"确定要退出登录吗?" cancelBtn:@"取消" okBtn:@"确定" OKCallBack:^{
        if (GET_USER_TOKEN) {
            [UserDefault removeObjectForKey:@"userInfo"];
            self.tabBarController.selectedIndex = 0;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
