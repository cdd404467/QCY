//
//  FriendCircleVC.m
//  QCY
//
//  Created by i7colors on 2018/11/19.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FriendCircleVC.h"
#import "MacroHeader.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "FriendHeaderView.h"
#import "FriendCricleCell.h"
#import "FriendCricleModel.h"
#import "WXKeyBoardView.h"
#import "UIView+Geometry.h"
#import <IQKeyboardManager.h>
#import "CddHUD.h"
#import "PublishFriendCircleVC.h"
#import <Masonry.h>
#import "MyFriendCircleInfoVC.h"
#import "TimeAbout.h"
#import <MJRefresh.h>
#import "Alert.h"
#import "HelperTool.h"
#import "FCUnReadMsgView.h"
#import "FriendCircleDetailVC.h"
#import "FCUnReadMsgVC.h"


@interface FriendCircleVC ()<UITableViewDelegate, UITableViewDataSource, FriendCellDelegate,UITextViewDelegate,TVDelegate>
@property (nonatomic, strong)WXKeyBoardView *kbView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)FriendHeaderView *headerView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)FriendCricleInfoModel *myInfoDataSource;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, assign)int page;
@property (nonatomic, assign)int totalNum;
@property (nonatomic, assign)NSInteger commentIndex;   //别人评论的ID
@property (nonatomic, assign)BOOL isCommentUser;    //是否是回复别人的评论
@property (nonatomic, assign)BOOL isRefresh;        //是否是刷新
@property (nonatomic, strong)FCUnReadMsgView *msgView;

@end

@implementation FriendCircleVC {
    dispatch_source_t _timer;
}

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
    [self setNavBar];
    
    [self requestDataFirstIn];
    //键盘将要显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //添加监听 键盘消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDown) name:UIKeyboardDidHideNotification object:nil];
    //修改头像或昵称监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo:) name:@"changeFCInfo" object:nil];
    //刷新列表！！！！！！！
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"refreshAllDataWithThis" object:nil];
}



- (void)viewWillAppear: (BOOL)animated {
    [IQKeyboardManager sharedManager].enable = NO;
    if (_timer) {
        dispatch_resume(_timer);
    }
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)viewWillDisappear: (BOOL)animated {
    [IQKeyboardManager sharedManager].enable = YES;
    if(_timer){
        dispatch_suspend(_timer);
    }
}

//改变头像的代理方法
- (void)changeInfo:(NSNotification *)notification {
    //头像
    if ([notification.object isEqualToString:@"header"]) {
        if isRightData(notification.userInfo[@"fcDict"]) {
            NSURL *header = notification.userInfo[@"fcDict"];
            _myInfoDataSource.communityPhoto = To_String(header);
        }
    } else if ([notification.object isEqualToString:@"nickName"]) {
        _myInfoDataSource.nickName = notification.userInfo[@"fcDict"];
    }
    
    _headerView.model = _myInfoDataSource;
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
    self.nav.titleLabel.text = @"朋友圈";
    self.nav.backBtn.hidden = YES;
    [self.nav.rightBtn setTitle:@"我要发布" forState:UIControlStateNormal];
    [self.nav.rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [self.nav.rightBtn addTarget:self action:@selector(jumpToPublishVC) forControlEvents:UIControlEventTouchUpInside];
    self.nav.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.nav.rightBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(90);
    }];
    self.nav.backgroundColor = HEXColor(@"#f3f3f3", 1);
    self.nav.bottomLine.hidden = YES;
}

- (void)jumpToPublishVC {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
    }
    DDWeakSelf;
    PublishFriendCircleVC *vc = [[PublishFriendCircleVC alloc] init];
    vc.refreshFCBlock = ^{
        weakself.isRefresh = YES;
        [weakself requestDataFirstIn];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setupUI {
    _kbView = [[WXKeyBoardView alloc] init];
    _kbView.top = SCREEN_HEIGHT;
    _kbView.tvDelegate = self;
    [self.view addSubview:_kbView];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.separatorColor = RGBA(204, 204, 204, 1);
        _tableView.separatorInset = UIEdgeInsetsZero;
        //取消垂直滚动条
        _tableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        DDWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.isRefresh = YES;
            weakself.page = 1;
            [weakself requestDataFirstIn];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakself.totalNum - Page_Count * weakself.page > 0) {
                weakself.page++;
                [weakself requestFriendList];
            } else {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        
        FriendHeaderView *headerView = [[FriendHeaderView alloc] init];
        if (GET_USER_TOKEN) {
            headerView.model = weakself.myInfoDataSource;
            headerView.noLoginLabel.hidden = YES;
        } else {
            headerView.noLoginLabel.hidden = NO;
        }
        [HelperTool addTapGesture:headerView withTarget:self andSEL:@selector(jumpToMyInfo)];
        _tableView.tableHeaderView = headerView;
        _headerView = headerView;
    }
    return _tableView;
}


- (void)jumpToMyInfo {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    MyFriendCircleInfoVC *vc = [[MyFriendCircleInfoVC alloc] init];
    vc.ofType = @"mine";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 有消息提示
- (void)newMsgTip:(NSString *)tips {
    DDWeakSelf;
    
    NSString *tipText = [NSString stringWithFormat:@"更新%@条消息",tips];
    if ([self.view viewWithTag:444]) {
        _msgView.title = tipText;
//        NSLog(@"---");
    } else {
//        NSLog(@"===");
        [UIView animateWithDuration:0.3 animations:^{
            weakself.tableView.top = weakself.tableView.top + 30;
            weakself.tableView.height = weakself.tableView.height - 30;
        }];
        FCUnReadMsgView *msgView = [FCUnReadMsgView new];
        msgView.tag = 444;
        msgView.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, 30);
        msgView.title = tipText;
        [msgView.unReadBtn addTarget:self action:@selector(gotoUnReadVC) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:msgView atIndex:0];
        _msgView = msgView;
        
    }
}

- (void)gotoUnReadVC {
    FCUnReadMsgVC *vc = [[FCUnReadMsgVC alloc] init];
    DDWeakSelf;
    vc.removeUnreadViewBlock = ^{
        [weakself removeNewMsgTip];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//移除视图
- (void)removeNewMsgTip {
    [_msgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_msgView removeFromSuperview];
    DDWeakSelf;
    [UIView animateWithDuration:0.2 animations:^{
        weakself.tableView.top = weakself.tableView.top - 30;;
        weakself.tableView.height = weakself.tableView.height + 30;
    }];
}

#pragma mark 定时器请求消息
- (void)startTimer {
    //定义队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建定时器
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_time_t start = DISPATCH_TIME_NOW;        //当前时间
    dispatch_time_t interval = 45.0 * NSEC_PER_SEC;    //间隔时间
    //设置定时器
    dispatch_source_set_timer(_timer, start, interval, 0);
    //设置回调
    DDWeakSelf;
    dispatch_source_set_event_handler(_timer, ^{
        [weakself getUnReadMsg];
    });
    //启动定时器
    dispatch_resume(_timer);
}

#pragma mark - 获取朋友圈列表
- (void)requestFriendList {
    _isRefresh = NO;
    NSString *urlString = [NSString stringWithFormat:URL_Friend_List,User_Token,_page,Page_Count];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            NSArray *tempArr = [FriendCricleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            for (FriendCricleModel *model in weakself.dataSource) {
                model.likeList = [LikeListModel mj_objectArrayWithKeyValuesArray:model.likeList];
                model.commentList = [CommentListModel mj_objectArrayWithKeyValuesArray:model.commentList];
            }
            
            [weakself.tableView reloadData];
        }
        [weakself.tableView.mj_footer endRefreshing];
        [weakself.tableView.mj_header endRefreshing];
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (void)refreshList {
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    self.isRefresh = YES;
    self.page = 1;
    [self requestDataFirstIn];
}

//第一次进入页面以及刷新
- (void)requestDataFirstIn {
    DDWeakSelf;
    if (weakself.isRefresh == NO) {
        [CddHUD show:self.view];
    }
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    //第一个线程获取详情
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        if (GET_USER_TOKEN) {
            [weakself requestMyInfo:group];
        } else {
            dispatch_group_leave(group);
        }
    });
    
    //第二个线程，获取列表
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        [weakself requestList:group];
    });
    
    //全部任务完成后，就可以在这吊了
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView.mj_header endRefreshing];
            if (weakself.isRefresh == YES) {
                [weakself.tableView reloadData];
                if (GET_USER_TOKEN) {
                    weakself.headerView.model = weakself.myInfoDataSource;
                    weakself.headerView.noLoginLabel.hidden = YES;
                } else {
                    weakself.headerView.noLoginLabel.hidden = NO;
                }
            } else {
                [weakself.view addSubview:weakself.tableView];
                [weakself setupUI];
                [weakself startTimer];
            }
            [CddHUD hideHUD:weakself.view];
        });
    });
}

//获取列表
- (void)requestList:(dispatch_group_t)group {
    NSString *urlString = [NSString stringWithFormat:URL_Friend_List,User_Token,_page,Page_Count];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                            NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.totalNum = [json[@"totalCount"] intValue];
            if (weakself.isRefresh == YES) {
                [weakself.dataSource removeAllObjects];
            }
            NSArray *tempArr = [FriendCricleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            [weakself.dataSource addObjectsFromArray:tempArr];
            for (FriendCricleModel *model in weakself.dataSource) {
                model.likeList = [LikeListModel mj_objectArrayWithKeyValuesArray:model.likeList];
                model.commentList = [CommentListModel mj_objectArrayWithKeyValuesArray:model.commentList];
            }
        }
        dispatch_group_leave(group);
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        dispatch_group_leave(group);
    }];
}

//获取个人详情
- (void)requestMyInfo:(dispatch_group_t)group {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_Friend_MyInfo,User_Token];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        //                NSLog(@"---- %@",json);
        weakself.myInfoDataSource = [FriendCricleInfoModel mj_objectWithKeyValues:json[@"data"]];
        dispatch_group_leave(group);
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        dispatch_group_leave(group);
    }];
}

- (void)getUnReadMsg {
    NSString *urlString = [NSString stringWithFormat:URL_Unread_MsgCounts,User_Token];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//            NSLog(@"---- %@",json);
            if (![To_String(json[@"data"]) isEqualToString:@"0"]) {
                [self newMsgTip:To_String(json[@"data"])];
            }
        }
        
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (NSMutableArray *)getIndexPath:(NSString *)tieziID {
    for (FriendCricleModel *model in _dataSource) {
        if ([model.tieziID isEqualToString:tieziID]) {
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

//根据userID拿indexPath数组
- (NSMutableArray *)getIndexPathWithUserID:(NSString *)userID {
    for (FriendCricleModel *model in _dataSource) {
        if ([model.userId isEqualToString:userID]) {
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

#pragma mark - cell点击的各种代理方法
- (void)didSelectFullText:(NSString *)tieziID {
    [self.tableView reloadRowsAtIndexPaths:[self getIndexPath:tieziID] withRowAnimation:UITableViewRowAnimationNone];
}

//点赞
- (void)didZan:(NSString *)tieziID {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];

    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    NSIndexPath *indexPath = [[self getIndexPath:tieziID] firstObject];
    [self giveYouZan:indexPath];
}

//评论
- (void)didComment:(NSString *)tieziID {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];

    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    
    _kbView.textView.placeholder = @"评论:";
    _indexPath = [[self getIndexPath:tieziID] firstObject];
    _isCommentUser = NO;
    [_kbView.textView becomeFirstResponder];
    
//    CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
//
//    CGRect r = [self.tableView convertRect:rect toView:[self.tableView superview]];
//    NSLog(@"---- %f",r.origin.y);
    
}

//回复别人的评论，或者有可能是删除自己的评论
- (void)commentUserComment:(NSString *)tieziID index:(NSInteger)index {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    _indexPath = [[self getIndexPath:tieziID] firstObject];
    FriendCricleModel *model = _dataSource[_indexPath.row];
    NSString *isSelf = [model.commentList[index] isCharger];
    //如果是自己的评论,就删除
    if ([isSelf isEqualToString:@"1"]) {
        NSString *commentID = [model.commentList[index] commentID];
        [self deleteMyComment:commentID];
    //如果是别人的评论,就回复
    } else {
        _commentIndex = index;
        _isCommentUser = YES;
        FriendCricleModel *model = _dataSource[_indexPath.row];
        _kbView.textView.placeholder = [NSString stringWithFormat:@"回复%@:",[model.commentList[_commentIndex] commentUser]];
        [_kbView.textView becomeFirstResponder];
    }
}
//点击头像
- (void)didClickHeaderImage:(NSString *)userID {
    [self jumpToUserDetailInfo:userID];
}

//点击名字
- (void)didClickUserName:(NSString *)userID {
    [self jumpToUserDetailInfo:userID];
}

//点击点赞人头像
- (void)didClickZanUserHeader:(NSString *)userID {
    [self jumpToUserDetailInfo:userID];
}

- (void)jumpToUserDetailInfo:(NSString *)userID {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];
    MyFriendCircleInfoVC *vc = [[MyFriendCircleInfoVC alloc] init];
    vc.userID = userID;
    vc.ofType = @"other";
    DDWeakSelf;
    vc.clickFocusBlock = ^(NSString * _Nonnull type) {
        for (FriendCricleModel *model in weakself.dataSource) {
            if ([model.userId isEqualToString:userID]) {
                if ([type isEqualToString:@"addFocus"]) {
                    model.isFollow = @"1";
                    NSInteger newFansCount = [model.dyeFollowCount integerValue] + 1;
                    model.dyeFollowCount = @(newFansCount).stringValue;
                } else {
                    model.isFollow = @"0";
                    NSInteger newFansCount = [model.dyeFollowCount integerValue] - 1;
                    model.dyeFollowCount = @(newFansCount).stringValue;
                }
            }
        }
        [weakself.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


//删除动态
- (void)didDeleteDynamic:(NSString *)tieziID {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];
    [self deleteMydynamic:[[self getIndexPath:tieziID] firstObject]];
}

//查看详情
- (void)didLookDetail:(NSString *)tieziID {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];
    FriendCircleDetailVC *vc = [[FriendCircleDetailVC alloc] init];
    vc.tieziID = tieziID;
    [self.navigationController pushViewController:vc animated:YES];
}

//关注或取消关注
- (void)focusOrCancel:(NSString *)tieziID {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];
    NSIndexPath *indexPath = [[self getIndexPath:tieziID] firstObject];
    FriendCricleModel *model = _dataSource[indexPath.row];
    if ([model.isFollow isEqualToString:@"0"]) {
        [self addFocusWithUserID:model.userId];
    } else {
        [self cancelFocusWithUserID:model.userId];
    }
}

#pragma mark 按下return的代理方法
- (void)clickReturn {
    [_kbView.textView resignFirstResponder];
    [self publishComments];
}

#pragma mark - 朋友圈的操作
/*** 发表评论 ***/
- (void)publishComments {
    
    if (_kbView.textView.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入您要发表的内容" view:self.view];
        return;
    }
  
    FriendCricleModel *model = _dataSource[_indexPath.row];
    NSString *tieziID = model.tieziID;
    NSString *commentID = [NSString string];
    if (_isCommentUser == YES) {
        commentID = [model.commentList[_commentIndex] commentID];
    } else {
        commentID = @"";
    }

    NSDictionary *dict = @{@"token":User_Token,
                           @"dyeId":tieziID,
                           @"content":_kbView.textView.text,
                           @"parentId":commentID
                           };
    [CddHUD show:self.view];
    DDWeakSelf;
    [ClassTool postRequest:URL_Publish_Comments Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            CommentListModel *dict = [CommentListModel mj_objectWithKeyValues:json[@"data"]];
            FriendCricleModel *model = weakself.dataSource[weakself.indexPath.row];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:model.commentList];
            [arr addObject:dict];
            model.commentList = arr;
            [weakself.dataSource replaceObjectAtIndex:weakself.indexPath.row withObject:model];
            [weakself.tableView reloadRowsAtIndexPaths:@[weakself.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } Failure:^(NSError *error) {
        
    }];
    
}

//添加关注
- (void)addFocusWithUserID:(NSString *)userID {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    NSDictionary *dict = @{@"token":User_Token,
                           @"byUserId":userID
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Add_Focus Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                NSLog(@"-----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            for (FriendCricleModel *model in weakself.dataSource) {
                if ([model.userId isEqualToString:userID]) {
                    model.isFollow = @"1";
                    NSInteger newFansCount = [model.dyeFollowCount integerValue] + 1;
                    model.dyeFollowCount = @(newFansCount).stringValue;
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
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    
    NSDictionary *dict = @{@"token":User_Token,
                           @"byUserId":userID
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Cancel_Focus Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        //                NSLog(@"-----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            for (FriendCricleModel *model in weakself.dataSource) {
                if ([model.userId isEqualToString:userID]) {
                    model.isFollow = @"0";
                    NSInteger newFansCount = [model.dyeFollowCount integerValue] - 1;
                    model.dyeFollowCount = @(newFansCount).stringValue;
                }
            }
            [weakself.tableView reloadData];
//            NSArray *cellArray = [weakself.tableView visibleCells];
//            NSMutableArray<NSIndexPath *> *ipArray = [NSMutableArray arrayWithCapacity:0];
//            for (FriendCricleCell *cell in cellArray) {
//                NSIndexPath *indexPath = [weakself.tableView indexPathForCell:cell];
//                [ipArray addObject:indexPath];
//            }
//            [weakself.tableView reloadRowsAtIndexPaths:ipArray withRowAnimation:UITableViewRowAnimationNone];
            [CddHUD showTextOnlyDelay:@"取消关注成功" view:weakself.view];
        }
    } Failure:^(NSError *error) {
        
    }];
}

//删除动态
- (void)deleteMydynamic:(NSIndexPath *)indexPath {
    DDWeakSelf;
    [Alert alertTwo:@"是否确定删除?" cancelBtn:@"取消" okBtn:@"确定" OKCallBack:^{
        NSString *tieziID = [weakself.dataSource[indexPath.row] tieziID];
        NSDictionary *dict = @{@"token":User_Token,
                               @"id":tieziID
                               };
        [CddHUD show:self.view];
        [ClassTool postRequest:URL_Delete_FriendCricle Params:[dict mutableCopy] Success:^(id json) {
            [CddHUD hideHUD:weakself.view];
//                                        NSLog(@"-----=== %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                [weakself.dataSource removeObjectAtIndex:indexPath.row];
                [weakself.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                [weakself.tableView reloadData];
            }
        } Failure:^(NSError *error) {
            
        }];
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
                FriendCricleModel *model = weakself.dataSource[weakself.indexPath.row];
                //保存临时的模型数组，用来查找在要删除的是第几个元素，拿到数组下标
                NSMutableArray *tempModelArr = [CommentListModel mj_objectArrayWithKeyValuesArray:model.commentList];
                NSMutableArray *arr = [NSMutableArray arrayWithArray:model.commentList];
                for (CommentListModel *dict in tempModelArr) {
                    if ([dict.commentID isEqualToString:commentID]) {
                        NSInteger index =[tempModelArr indexOfObject:dict] ;
                        [arr removeObjectAtIndex:index];
                    }
                }
                model.commentList = arr;
                [weakself.dataSource replaceObjectAtIndex:weakself.indexPath.row withObject:model];
                [weakself.tableView reloadRowsAtIndexPaths:@[weakself.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        } Failure:^(NSError *error) {
            
        }];
    }];
}

//点赞
- (void)giveYouZan:(NSIndexPath *)indexPath {
    FriendCricleModel *model = _dataSource[indexPath.row];
    NSDictionary *dict = @{@"token":User_Token,
                           @"dyeId":model.tieziID
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Click_Zan Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                        NSLog(@"-----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            model.isLike = @"1";
            LikeListModel *dict = [LikeListModel mj_objectWithKeyValues:json[@"data"]];
            FriendCricleModel *model = weakself.dataSource[indexPath.row];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:model.likeList];
            [arr addObject:dict];
            model.likeList = arr;
            [weakself.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [CddHUD showTextOnlyDelay:@"已点赞" view:weakself.view];
        }
    } Failure:^(NSError *error) {
        
    }];
}


#pragma mark - tableView代理方法
//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
//每组的cell个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCricleModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

//section的头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

//section的尾部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

//给出cell的估计高度，主要目的是优化cell高度的计算次数
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCricleModel *model = self.dataSource[indexPath.row];
    return model.cellHeight;
}

//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCricleCell *cell = [FriendCricleCell cellWithTableView:tableView];
//    cell.indexPath = indexPath;
    cell.model = self.dataSource[indexPath.row];
    cell.friendDelegate = self;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray *cellArray = [self.tableView visibleCells];
    for (FriendCricleCell *cell in cellArray) {
        cell.menuView.show = NO;
    }
}


#pragma mark -键盘监听方法
- (void)keyBoardWillShow:(NSNotification *)notification
{
    //     获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    // 定义好动作
//    void (^animation)(void) = ^void(void) {
//
//        self.kbView.transform = CGAffineTransformMakeTranslation(0, -(keyBoardHeight + self.kbView.height));
//    };
    DDWeakSelf;
    [UIView animateWithDuration:animationTime animations:^{
        weakself.kbView.top = SCREEN_HEIGHT - keyBoardHeight - weakself.kbView.height;
    }];
    
    
//    if (animationTime > 0) {
//        [UIView animateWithDuration:animationTime animations:animation];
//    } else {
//        animation();
//    }
//    NSLog(@"---- %f",keyBoardHeight + self.kbView.height);
}

- (void)keyBoardWillHide:(NSNotification *)notificaiton
{
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notificaiton.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    DDWeakSelf;
    [UIView animateWithDuration:animationTime animations:^{
        weakself.kbView.top = SCREEN_HEIGHT;
    }];
    // 定义好动作
//    void (^animation)(void) = ^void(void) {
//        self.kbView.transform = CGAffineTransformIdentity;
//    };
//
//    if (animationTime > 0) {
//        [UIView animateWithDuration:animationTime animations:animation];
//    } else {
//        animation();
//    }
}

//键盘消失
- (void)keyboardDown {
    _kbView.textView.text = @"";
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
