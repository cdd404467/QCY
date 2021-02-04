//
//  LiveOnlineVC.m
//  QCY
//
//  Created by i7colors on 2020/3/27.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "LiveOnlineVC.h"
#import "LiveOnlineCell.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "LiveOnlineDetailVC.h"
#import "PromotionsHeaderView.h"
#import "PromotionsModel.h"
#import <MJRefresh.h>

@interface LiveOnlineVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)PromotionsHeaderView *header;
@property (nonatomic, copy)NSArray *bannerArr;
@property (nonatomic, strong)NSMutableArray *bannerDataSource;

@end

@implementation LiveOnlineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线直播";
    [self.view addSubview:self.tableView];
    [self requestHeader];
    [self requestData];
}

//初始化数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _dataSource = mArr;
    }
    return _dataSource;
}

- (NSMutableArray *)bannerDataSource {
    if (!_bannerDataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _bannerDataSource = mArr;
    }
    return _bannerDataSource;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

        _header = [[PromotionsHeaderView alloc] init];
//        _header.bannerArray = [_bannerDataSource copy];
        _header.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(144));
        _tableView.tableHeaderView = _header;

        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNumber - Page_Count * weakself.pageNumber > 0) {
                weakself.pageNumber++;
                [weakself requestData];
            } else {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
    return _tableView;
}

- (void)requestHeader {
    NSString *urlString = [NSString stringWithFormat:URL_Get_Banner,@"school_live_class_mobile_banner"];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//                 NSLog(@"---- %@",json);
            self.bannerArr = [PromotionsModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            for (PromotionsModel *model in self.bannerArr) {
                [self.bannerDataSource addObject:ImgUrl(model.ad_image)];
            }
            self.header.bannerArray = [self.bannerDataSource copy];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (void)requestData {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URLGet_Course_List,self.pageNumber,Page_Count];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {

//                        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNumber = [json[@"totalCount"] intValue];
            NSArray *tempArr = [LiveOnlineModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView reloadData];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

#pragma mark - tableView代理方法

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LiveOnlineDetailVC *vc = [[LiveOnlineDetailVC alloc] init];
    vc.courseID = [self.dataSource[indexPath.row] courseID];
    vc.channelId = [self.dataSource[indexPath.row] channelId];
    [self.navigationController pushViewController:vc animated:YES];
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

//自定义的section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *identifier = @"header";
    // 1.缓存中取
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    // 2.创建
    if (header == nil) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
        header.contentView.backgroundColor = UIColor.whiteColor;
    }
    return header;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LiveOnlineCell *cell = [LiveOnlineCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];

    return cell;
}

@end
