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
/** 跳转的页面 **/
#import "OpenMallVC.h"
#import "ProductMallVC.h"
#import "AskToBuyVC.h"
#import "NetWorkingPort.h"
#import "IndustryInformationVC.h"
#import "GroupBuyingVC.h"



@interface HomePageVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(urlAwake:) name:@"urlJump" object:nil];
    
    
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.tableView];
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
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        _tableView.tableHeaderView = [self addHeaderView];
    }
    return _tableView;
}

//创建自定义的tableView headerView
- (HomePageHeaderView *)addHeaderView {
    CGFloat headerHeight = 8 + 144 + 67;
    HomePageHeaderView *headerView = [[HomePageHeaderView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerHeight * Scale_H);
    DDWeakSelf;
    headerView.tapIconsBlock = ^(NSInteger tag) {
        switch (tag) {
            case 0: {
                ProductMallVC *vc = [[ProductMallVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1: {
                AskToBuyVC *vc = [[AskToBuyVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2: {
                OpenMallVC *vc = [[OpenMallVC alloc] init];
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
    
    return headerView;
}

//header不悬停
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.tableView) {
        CGFloat sectionHeaderHeight = 36; //header高度
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } else if (scrollView.contentOffset.y>sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }else if (scrollView.contentOffset.y<=sectionHeaderHeight){
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
        return 1;
    } else if (section == 1) {
        return 8;
    } else {
        return 8;
    }
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return KFit_H(110) + 30 + 6;
    } else if (indexPath.section == 1){
        return 86;
    } else {
        return 125;
    }
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *titleArr = @[@"促销活动",@"求购大厅",@"开放商城"];
    HomePageSectionHeader *header = [ HomePageSectionHeader headerWithTableView:tableView];
    header.titleLabel.text = titleArr[section];
    if (section == 0) {
        header.clickMoreBlock = ^{
//            NSLog(@"促销活动");
        };
        return header;
    } else if (section == 1) {
        header.clickMoreBlock = ^{
            NSLog(@"求购大厅");
        };
        return header;
    } else {
        header.clickMoreBlock = ^{
            NSLog(@"开放商城");
        };
        return header;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GroupBuyingVC *vc = [[GroupBuyingVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PromotionsCell *cell = [PromotionsCell cellWithTableView:tableView];
        return cell;
    } else if (indexPath.section == 1) {
        AskToBuyCell *cell = [AskToBuyCell cellWithTableView:tableView];
        return cell;
    } else {
        OpenMallVC_Cell *cell = [OpenMallVC_Cell cellWithTableView:tableView];
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
