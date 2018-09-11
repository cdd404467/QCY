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

@interface HomePageVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation HomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    HomePageHeaderView *headerView = [[HomePageHeaderView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 255 * Scale_H);
    
    
    return headerView;
}

//header不悬停
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.tableView) {
        CGFloat sectionHeaderHeight = 44 * Scale_H; //headerView高度
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
    if (section == 2) {
        return 10;
    } else if (section == 3) {
        return 20;
    }else {
        return 1;
    }
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return KFit_H(140);
    } else if (indexPath.section == 3){
        return KFit_H(120);
    } else {
        return KFit_H(100);
    }
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KFit_H(44.f);
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *titleArr = @[@"促销活动",@"今日头条",@"求购大厅",@"开放商城"];
    HomePageSectionHeader *header = [ HomePageSectionHeader headerWithTableView:tableView leftTitle:titleArr[section]];
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
