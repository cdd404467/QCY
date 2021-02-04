//
//  FansVC.m
//  QCY
//
//  Created by i7colors on 2018/12/5.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FansVC.h"
#import <YNPageTableView.h>
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import <MJRefresh.h>
#import "FansCell.h"
#import "FriendCricleModel.h"
#import <UIScrollView+EmptyDataSet.h>
#import "CddHUD.h"
#import "Alert.h"

@interface FansVC ()<UITableViewDataSource, UITableViewDelegate ,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation FansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyFans) name:@"fcMyFansListRefresh" object:nil];
    [self.view addSubview:self.tableView];
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = RGBA(225, 225, 225, 1);
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,14, 0, 0)];

        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        
        DDWeakSelf;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakself.pageNumber ++;
            if (weakself.totalNumber - Page_Count * weakself.pageNumber > 0) {
                weakself.pageNumber ++;
                weakself.isRefreshList = NO;
                [weakself requestData];
            } else {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
    return _tableView;
}

#pragma mark - w获取数据

- (void)refreshMyFans {
    self.pageNumber = 1;
    self.isRefreshList = YES;
    [self requestData];
}

- (void)requestData {
    DDWeakSelf;
    NSString *urlString = [NSString string];
    if ([self.ofType isEqualToString:@"mine"]) {
        urlString = [NSString stringWithFormat:URL_My_Fans_List,User_Token,self.pageNumber,Page_Count];
    } else {
        urlString = [NSString stringWithFormat:URL_Fans_List,User_Token,self.pageNumber,Page_Count,_userID];
    }
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                                                    NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNumber = [json[@"totalCount"] intValue];
            NSArray *tempArr = [FriendCricleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (weakself.isRefreshList == YES)
                [weakself.dataSource removeAllObjects];
            [weakself.dataSource addObjectsFromArray:tempArr];
            [weakself.tableView reloadData];
        }
        
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

//添加关注
- (void)addFocusWithUserID:(NSString *)userID {
    NSDictionary *dict = @{@"token":User_Token,
                           @"byUserId":userID
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Add_Focus Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                        NSLog(@"-----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fcMyFriendsListRefresh" object:nil userInfo:nil];
            for (FriendCricleModel *model in weakself.dataSource) {
                if ([model.userId isEqualToString:userID]) {
                    model.isFollow = 1;
                    break ;
                }
            }
            [weakself.tableView reloadData];
            [CddHUD showTextOnlyDelay:@"关注成功" view:weakself.view];
        }
    } Failure:^(NSError *error) {
        
    }];
}

//取消关注
- (void)cancelFocusWithUserID:(NSString *)userID {
    
    NSDictionary *dict = @{@"token":User_Token,
                           @"byUserId":userID
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Cancel_Focus Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        //                NSLog(@"-----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fcMyFansListRefresh" object:nil userInfo:nil];
            for (FriendCricleModel *model in weakself.dataSource) {
                if ([model.userId isEqualToString:userID]) {
                    model.isFollow = 0;
                    break ;
                }
            }
            [weakself.tableView reloadData];
            [CddHUD showTextOnlyDelay:@"取消关注成功" view:weakself.view];
        }
    } Failure:^(NSError *error) {
        
    }];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无粉丝";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#708090", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark - UITableView代理
//section header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

//section footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FansCell *cell = [FansCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    DDWeakSelf;
    cell.focusBlock = ^(NSString * _Nonnull userID) {
        [weakself addFocusWithUserID:userID];
    };
    
    cell.cancelFocusBlock = ^(NSString * _Nonnull userID, NSString * _Nonnull userName) {
        NSString *title = [NSString stringWithFormat:@"是否取消关注 “%@” ?",userName];
        [Alert alertTwo:title cancelBtn:@"再想想" okBtn:@"确定" OKCallBack:^{
            [weakself cancelFocusWithUserID:userID];
        }];
    };
    return cell;
}


- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
