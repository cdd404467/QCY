//
//  MyFriendsVC.m
//  QCY
//
//  Created by i7colors on 2019/4/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyFriendsVC.h"
#import <YNPageTableView.h>
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import <MJRefresh.h>
#import "FriendCricleModel.h"
#import <UIScrollView+EmptyDataSet.h>
#import "MyFriendsCell.h"
#import "CddHUD.h"
#import "Alert.h"

@interface MyFriendsVC ()<UITableViewDataSource, UITableViewDelegate ,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)int page;
@end

@implementation MyFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"fcMyFriendsListRefresh" object:nil];
    _page = 1;
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

- (void)refresh {
    self.pageNumber = 1;
    self.isRefreshList = YES;
    [self requestData];
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URL_My_Friends_List,User_Token,_page,Page_Count];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                                 NSLog(@"---- %@",json);
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

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无好友";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName:HEXColor(@"#708090", 1)
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
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
                    [weakself.dataSource removeObject:model];
                    break ;
                }
            }
            [weakself.tableView reloadData];
            [CddHUD showTextOnlyDelay:@"取消关注成功" view:weakself.view];
        }
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableView代理
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
    MyFriendsCell *cell = [MyFriendsCell cellWithTableView:tableView];
    cell.model = _dataSource[indexPath.row];
    DDWeakSelf;
    cell.cancelFriendsBlock = ^(NSString * _Nonnull userID, NSString * _Nonnull userName) {
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
