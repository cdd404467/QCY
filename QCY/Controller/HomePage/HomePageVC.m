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
#import "OpenMallCell.h"
#import "TodaysNewsCell.h"
/** 跳转的页面 **/
#import "OpenMallVC.h"
#import "ProductMallVC.h"

@interface HomePageVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
//    UIImage *navLine = [UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(SCREEN_WIDTH, 1)];
//    [self.navigationController.navigationBar setShadowImage:navLine];
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
    CGFloat headerHeight = 8 + 144 + 90;
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
            case 1:
                NSLog(@"1");
                break;
            case 2: {
                OpenMallVC *vc = [[OpenMallVC alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
                NSLog(@"3");
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
        CGFloat sectionHeaderHeight = 41 * Scale_H; //header高度
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
    return 4;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 10;
    } else if (section == 2) {
        return 8;
    } else {
        return 1;
    }
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return KFit_H(140);
    } else if (indexPath.section == 1){
        return KFit_H(40);
    } else if (indexPath.section == 2){
        return 88;
    } else {
        return KFit_H(125);
    }
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KFit_H(42.f);
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *titleArr = @[@"促销活动",@"今日头条",@"求购大厅",@"开放商城"];
    HomePageSectionHeader *header = [ HomePageSectionHeader headerWithTableView:tableView];
    header.titleLabel.text = titleArr[section];
    if (section == 0) {
        header.clickMoreBlock = ^{
            NSLog(@"促销活动");
        };
        return header;
    } else if (section == 1) {
        header.clickMoreBlock = ^{
            NSLog(@"今日头条");
        };
        return header;
    } else if (section == 2) {
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

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PromotionsCell *cell = [PromotionsCell cellWithTableView:tableView];
        return cell;
    } else if (indexPath.section == 1) {
        TodaysNewsCell *cell = [TodaysNewsCell cellWithTableView:tableView];
        cell.countLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
        return cell;
    } else if (indexPath.section == 2) {
        AskToBuyCell *cell = [AskToBuyCell cellWithTableView:tableView];
        return cell;
    } else if (indexPath.section == 3) {
        OpenMallCell *cell = [OpenMallCell cellWithTableView:tableView];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        return cell;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
