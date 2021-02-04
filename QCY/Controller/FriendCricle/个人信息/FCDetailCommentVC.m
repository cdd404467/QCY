//
//  FCDetailCommentVC.m
//  QCY
//
//  Created by i7colors on 2018/12/11.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCDetailCommentVC.h"
#import <YNPageTableView.h>
#import "FCDetailCell.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import "FriendCricleModel.h"
#import "Alert.h"
#import <UIScrollView+EmptyDataSet.h>


@interface FCDetailCommentVC ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, assign) int page;
@property (nonatomic, assign)BOOL isRefresh;
@end

@implementation FCDetailCommentVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _isRefresh = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addComment:) name:@"commentChange" object:nil];
    [self requestData];
}

- (void)addComment:(NSNotification *)notification {
    _isRefresh = YES;
    _page = 1;
    [self requestData];
    
//    if ([notification.object isEqualToString:@"add"]) {
//        [_dataSource addObject:notification.userInfo[@"oneComment"]];
//        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
//        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//
//        NSIndexPath *ip = [NSIndexPath indexPathForRow:_dataSource.count - 1 inSection:0];
//        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO]; //滚动到最后一行
//    } else if ([notification.object isEqualToString:@"jian"]) {
////        [weakself.dataSource removeObjectAtIndex:indexPath.row];
////        [weakself.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
}



- (NSMutableArray *)getIndexPath:(NSString *)commentID {
    for (CommentListModel *model in _dataSource) {
        if ([model.commentID isEqualToString:commentID]) {
            NSInteger index =[_dataSource indexOfObject:model] ;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
            NSMutableArray<NSIndexPath *> *array = [NSMutableArray arrayWithCapacity:0];
            [array addObject:indexPath];
            //            NSLog(@"-    %ld",indexPath.row);
            return array;
        }
    }
    
    return nil;
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
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,14, 0, 0)];
        _tableView.separatorColor = RGBA(225, 225, 225, 1);
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
        
        //        DDWeakSelf;
        //        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //            weakself.page++;
        //            if ( weakself.tempArr.count < Page_Count) {
        //                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        //
        //            } else {
        //                [weakself requestData];
        //            }
        //        }];
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TABBAR_HEIGHT)];
        footer.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = footer;
        
    }
    return _tableView;
}

#pragma mark - 网络请求
- (void)requestData {
    DDWeakSelf;
//    [CddHUD show:self.view];
    NSString *urlString = [NSString stringWithFormat:URL_Comment_List,User_Token,_tieziID,_page,Page_Count];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            NSArray *tempArr = [CommentListModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (weakself.isRefresh == YES) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:tempArr];
        }
        
        [weakself.tableView reloadData];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

//删除自己评论
- (void)deleteMyComment:(NSString *)commentID {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    
    [Alert alertTwo:@"是否确定删除评论?" cancelBtn:@"取消" okBtn:@"确定" OKCallBack:^{
        NSDictionary *dict = @{@"token":User_Token,
                               @"id":commentID
                               };
        DDWeakSelf;
        [CddHUD show:self.view];
        [ClassTool postRequest:URL_Delete_MyComment Params:[dict mutableCopy] Success:^(id json) {
            [CddHUD hideHUD:weakself.view];
            //                            NSLog(@"-----=== %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                weakself.isRefresh = YES;
                weakself.page = 1;
                [weakself requestData];
            }
        } Failure:^(NSError *error) {
            
        }];
    }];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无评论";
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
    
    CommentListModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FCDetailCell *cell = [FCDetailCell cellWithTableView:tableView];
    DDWeakSelf;
    cell.clickPLBlock = ^(NSString *commentID, NSString *isSelf, NSString *user) {
        if ([isSelf isEqualToString:@"1"]) {
            [weakself deleteMyComment:commentID];
        }
        if (weakself.clickCellPLBlock) {
            weakself.clickCellPLBlock(commentID, isSelf, user);
        }
    };
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
