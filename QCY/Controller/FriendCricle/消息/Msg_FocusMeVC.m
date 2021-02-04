//
//  Msg_FocusMeVC.m
//  QCY
//
//  Created by i7colors on 2019/4/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "Msg_FocusMeVC.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import <MJRefresh.h>
#import "FriendCricleModel.h"
#import "MyFriendCircleInfoVC.h"
#import "FriendCircleDelegate.h"
#import "CddHUD.h"


#import "Msg_FocusMeCell.h"

@interface Msg_FocusMeVC ()<UITableViewDataSource, UITableViewDelegate,FriendCircleDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)UIButton *rightbBarButton;
@end

@implementation Msg_FocusMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友粉丝";
    [self setNavBar];
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

- (void)setNavBar {
    NSString *title = @"全部标记已读";
    CGFloat width = [title boundingRectWithSize:CGSizeMake(200, 44)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                        context:nil].size.width;
    self.rightbBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width + 5, 44)];
    [self.rightbBarButton setTitle:title forState:UIControlStateNormal];
    [self.rightbBarButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.rightbBarButton setTitleColor:RGBA(0, 0, 0, 0.4) forState:UIControlStateDisabled];
    self.rightbBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightbBarButton addTarget:self action:@selector(targetAlready) forControlEvents:(UIControlEventTouchUpInside)];
    //    rightbBarButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    [rightbBarButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5 * kScreenWidth/375.0)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightbBarButton];
    self.rightbBarButton.enabled = NO;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = RGBA(225, 225, 225, 1);
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,14, 0, 0)];
        _tableView.backgroundColor = HEXColor(@"#F5F6F7", 1);
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        DDWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.isRefreshList = YES;
            weakself.pageNumber = 1;
            [weakself requestData];
        }];
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

//代理刷新
- (void)fcMessageAlreadyRead:(NSInteger)index {
    FCMsgModel *model = self.dataSource[index];
    model.isRead = 1;
    [self.tableView reloadData];
}

- (void)requestData {
    NSString *urlString = [NSString stringWithFormat:URL_FC_FriendsFans_List,User_Token,self.pageNumber,Page_Count];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                                                         NSLog(@"---- %@",json);
        [CddHUD hideHUD:weakself.view];
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNumber = [json[@"totalCount"] intValue];
            NSArray *tempArr = [FCMsgModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (weakself.isRefreshList == YES)
                [weakself.dataSource removeAllObjects];
            
            [weakself.dataSource addObjectsFromArray:tempArr];
            for (FCMsgModel *model in weakself.dataSource) {
                if (model.isRead == 0) {
                    weakself.rightbBarButton.enabled = YES;
                    break;
                }
            }
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView.mj_header endRefreshing];
            [weakself.tableView reloadData];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}


//全部标记已读
- (void)targetAlready {
    NSDictionary *dict = @{@"token":GET_USER_TOKEN,
                           @"type":_messageType
                           };
    DDWeakSelf;
    [ClassTool postRequest:URL_FCMSG_AlreadyRead Params:[dict mutableCopy] Success:^(id json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            weakself.rightbBarButton.enabled = NO;
            for (FCMsgModel *model in weakself.dataSource) {
                if (model.isRead == 0)
                    model.isRead = 1;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NFT_FC_UnreadMessage_Refresh object:nil userInfo:nil];
            [weakself.tableView reloadData];
        }
    } Failure:^(NSError *error) {
        weakself.rightbBarButton.enabled = YES;
    }];
}

//添加关注
- (void)addFocusWithUserID:(FCMsgModel *)model {
    NSDictionary *dict = @{@"token":User_Token,
                           @"byUserId":model.postUserId
                           };
    NSMutableDictionary *mDict = [dict mutableCopy];
    
    if (model.isRead == 0)
        [mDict setObject:model.messageID forKey:@"messageId"];
    
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Add_Focus Params:mDict Success:^(id json) {
        //                NSLog(@"-----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.isRefreshList = YES;
            weakself.pageNumber = 1;
            [[NSNotificationCenter defaultCenter] postNotificationName:NFT_FC_UnreadMessage_Refresh object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fcMyFriendsListRefresh" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fcMyFansListRefresh" object:nil userInfo:nil];
            [weakself requestData];
        }
    } Failure:^(NSError *error) {
        
    }];
}

//删除msg
- (void)deleteMsg:(NSInteger)index {
    NSDictionary *dict = @{@"token":GET_USER_TOKEN,
                           @"id":[self.dataSource[index] messageID]
                           };
    self.rightbBarButton.enabled = NO;
    DDWeakSelf;
    [ClassTool postRequest:URL_DeleteMSG_FriendsFans Params:[dict mutableCopy] Success:^(id json) {
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            weakself.rightbBarButton.enabled = YES;
            if ([weakself.dataSource[index] isRead] == 0)
                [[NSNotificationCenter defaultCenter] postNotificationName:NFT_FC_UnreadMessage_Refresh object:nil userInfo:nil];
            [weakself.dataSource removeObjectAtIndex:index];
            for (FCMsgModel *model in weakself.dataSource) {
                if (model.isRead == 0) {
                    weakself.rightbBarButton.enabled = YES;
                    break;
                }
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [weakself.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } Failure:^(NSError *error) {
        weakself.rightbBarButton.enabled = YES;
    }];
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

//cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MyFriendCircleInfoVC *vc = [[MyFriendCircleInfoVC alloc] init];
    FCMsgModel *model = self.dataSource[indexPath.row];
    vc.ofType = @"other";
    vc.userID = model.postUserId;
    vc.refreshDelegate = self;
    if (model.isRead == 0) {
        vc.messageType = _messageType;
        vc.messageId = model.messageID;
        vc.index = indexPath.row;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

// 设置 cell 是否允许左滑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

// 设置默认的左滑按钮的title
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

// 点击左滑出现的删除按钮触发
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteMsg:indexPath.row];
    }
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Msg_FocusMeCell *cell = [Msg_FocusMeCell cellWithTableView:tableView];
    cell.model = self.dataSource[indexPath.row];
    DDWeakSelf;
    cell.addFriendsBlock = ^(FCMsgModel * _Nonnull model) {
        [weakself addFocusWithUserID:model];
    };
    return cell;
}


@end
