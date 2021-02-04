//
//  FriendCircleVC.m
//  QCY
//
//  Created by i7colors on 2018/11/19.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FriendCircleVC.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "FriendHeaderView.h"
#import "FriendCricleCell.h"
#import "FriendCricleModel.h"
#import "WXKeyBoardView.h"
#import <IQKeyboardManager.h>
#import "CddHUD.h"
#import "PublishFriendCircleVC.h"
#import "MyFriendCircleInfoVC.h"
#import "TimeAbout.h"
#import <MJRefresh.h>
#import "Alert.h"
#import "HelperTool.h"
#import "FriendCircleDetailVC.h"
#import "FCMapVC.h"
#import "InfomationDetailVC.h"
#import "TopicVCHeaderView.h"
//#import "YBMulitiDelegateManager.h"


@interface FriendCircleVC ()<UITableViewDelegate, UITableViewDataSource, FriendCellDelegate,UITextViewDelegate,TVDelegate>
@property (nonatomic, strong)WXKeyBoardView *kbView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)FriendCricleInfoModel *myInfoDataSource;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, assign)int page;
@property (nonatomic, assign)int totalNum;
@property (nonatomic, assign)NSInteger commentIndex;   //别人评论的ID
@property (nonatomic, assign)BOOL isCommentUser;    //是否是回复别人的评论
@property (nonatomic, assign)BOOL isRefresh;        //是否是刷新
@property (nonatomic, strong)NSMutableArray *topicDataSource;
@property (nonatomic, strong)TopicVCHeaderView *headerView;
@property (nonatomic, assign)int pageCount;
@end

@implementation FriendCircleVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _isRefresh = YES;
        _pageCount = 20;
    }
    return self;
}

- (NSMutableArray *)topicDataSource {
    if (!_topicDataSource) {
        _topicDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _topicDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_type isEqualToString:@"noTopic"]) {
        self.title = _navTitle;
    }
    
    [self.view addSubview:self.tableView];
    [self requestList];
    //键盘将要显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //添加监听 键盘消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDown) name:UIKeyboardDidHideNotification object:nil];
    //刷新列表！！！！！！！
    NSString *nfcName = [NSString stringWithFormat:@"refreshAllDataWithThis%@",_firstTopicID];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:nfcName object:nil];
    //各个子页面全部刷新！！！！！！！
    NSString *nfcNameAll = @"refreshAllDataWithThis";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:nfcNameAll object:nil];
    
    
    NSString *hideKeyboard = @"hiddenKeyBoard";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenKeyBoard) name:hideKeyboard object:nil];
    
}


- (void)viewWillAppear: (BOOL)animated {
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear: (BOOL)animated {
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)hiddenKeyBoard {
    [_kbView.textView resignFirstResponder];
}

//初始化数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _dataSource = mArr;
    }
    return _dataSource;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:_tbFrame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.separatorColor = RGBA(233, 233, 233, 1);
        _tableView.separatorInset = UIEdgeInsetsZero;
        //取消垂直滚动条
        _tableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            //            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        DDWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakself.isRefresh = YES;
            weakself.page = 1;
            [weakself requestList];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakself.isRefresh = NO;
            if (weakself.totalNum - weakself.pageCount * weakself.page > 0) {
                weakself.page++;
                [weakself requestList];
            } else {
                [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
        
        if ([_firstType isEqualToString:@"find"] && [_firstTopicID isEqualToString:@"no"] && [_type isEqualToString:@"noTopic"]) {
            _headerView = [[TopicVCHeaderView alloc] init];
            
            _tableView.tableHeaderView = _headerView;
        }
    }
    return _tableView;
}

#pragma mark - 获取朋友圈列表
//刷新
- (void)refreshList {
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    self.isRefresh = YES;
    self.page = 1;
    [self requestList];
}

//话题上面的banner
- (void)requestBanner {
    NSString *urlString = [URL_Get_Topic_List stringByAppendingFormat:@"&id=%@",_secondTopicID];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.topicDataSource = [FriendTopicModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (weakself.topicDataSource.count == 0)
                return ;
            FriendTopicModel *model = weakself.topicDataSource[0];
            weakself.headerView.model = model;
            weakself.headerView.height = model.height;
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}


//获取列表
- (void)requestList {
    
    NSString *urlString = [NSString string];
    //热门
    if ([_firstType isEqualToString:@"hot"]) {
        urlString = [NSString stringWithFormat:URL_Friend_List_Hot,User_Token,_page,_pageCount];
    }
    //发现
    else if ([_firstType isEqualToString:@"find"]) {
        if ([_firstTopicID isEqualToString:@"no"]) {
            urlString = [NSString stringWithFormat:URL_Friend_List_Find1,User_Token,_secondTopicID,_page,_pageCount];
            if ([_type isEqualToString:@"noTopic"] && _isRefresh == YES) {
                [self requestBanner];
            }
            
        } else {
            urlString = [NSString stringWithFormat:URL_Friend_List_Find,User_Token,_firstTopicID,_secondTopicID,_page,_pageCount];
        }
    }
    //关注
    else if ([_firstType isEqualToString:@"focus"]) {
        urlString = [NSString stringWithFormat:URL_Friend_List_Focus,User_Token,_page,_pageCount];
    }
    
    if (self.isRefresh == YES && self.dataSource.count == 0) {
        [CddHUD show:self.view].centerY = self.tableView.centerY;
    }
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                            NSLog(@"---- %@",json);
        [CddHUD hideHUD:weakself.view];
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
                model.topic.topicList = [FriendTopicModel mj_objectArrayWithKeyValuesArray:model.topic.topicList];
            }
            [weakself.tableView reloadData];
        } else {
            [weakself.dataSource removeAllObjects];
            [CddHUD showTextOnlyDelay:json[@"msg"] view:weakself.view];
        }
        [weakself.tableView.mj_footer endRefreshing];
        [weakself.tableView.mj_header endRefreshing];
    } Failure:^(NSError *error) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@" Error : %@",error);
        
    }];
}

//获取个人详情
- (void)requestMyInfo:(dispatch_group_t)group {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_Friend_MyInfo,User_Token];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                        NSLog(@"---===- %@",json);
        weakself.myInfoDataSource = [FriendCricleInfoModel mj_objectWithKeyValues:json[@"data"]];
        
        dispatch_group_leave(group);
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
        dispatch_group_leave(group);
    }];
}

//根据帖子ID拿到indexPath数组
- (NSMutableArray *)getIndexPath:(NSString *)tieziID {
    for (FriendCricleModel *model in _dataSource) {
        if ([model.tieziID isEqualToString:tieziID]) {
            NSInteger index =[_dataSource indexOfObject:model];
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
    [_kbView.textView resignFirstResponder];
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
    
//    _kbView.textView.placeholder = @"评论:";
    NSString *placeholder = @"评论:";
    _indexPath = [[self getIndexPath:tieziID] firstObject];
    _isCommentUser = NO;
//    [_kbView.textView becomeFirstResponder];
    [self setupUIWithPlaceholder:placeholder];
    
//    CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
//
//    CGRect r = [self.tableView convertRect:rect toView:[self.tableView superview]];
//    NSLog(@"---- %f",r.origin.y);
}

//回复别人的评论，或者有可能是删除自己的评论
- (void)commentUserComment:(NSString *)tieziID index:(NSInteger)index {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];
    [_kbView.textView resignFirstResponder];
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    _indexPath = [[self getIndexPath:tieziID] firstObject];
    FriendCricleModel *model = _dataSource[_indexPath.row];
    CommentListModel *commentModel = model.commentList[index];
    NSString *isSelf = commentModel.isCharger;
    //如果是自己的评论,就删除
    if ([isSelf isEqualToString:@"1"]) {
        NSString *commentID = [model.commentList[index] commentID];
        [self deleteMyComment:commentID];
    //如果是别人的评论,就回复
    } else {
        _commentIndex = index;
        _isCommentUser = YES;
        FriendCricleModel *model = _dataSource[_indexPath.row];
        NSString *placeholder = [NSString stringWithFormat:@"回复%@:",[model.commentList[_commentIndex] commentUser]];
//        _kbView.textView.placeholder = [NSString stringWithFormat:@"回复%@:",[model.commentList[_commentIndex] commentUser]];
//        [_kbView.textView becomeFirstResponder];
        [self setupUIWithPlaceholder:placeholder];
    }
}

//点击头像
- (void)didClickHeaderImage:(FriendCricleModel *)model{
    [_kbView.textView resignFirstResponder];
    [self jumpToUserDetailInfo:model.userId isSelf:@(model.isCharger).stringValue];
}

//点击名字
- (void)didClickUserName:(CommentListModel *)model userType:(NSString *)type {
    NSString *who = [type isEqualToString:@"name"] ? model.isCharger : model.byCommentIsCharger;
    [self jumpToUserDetailInfo:model.userId isSelf:who];
}

//点击点赞人头像
- (void)didClickZanUserHeader:(LikeListModel *)model {
    [_kbView.textView resignFirstResponder];
    [self jumpToUserDetailInfo:model.userId isSelf:model.isCharger];
}

//个人信息
- (void)jumpToUserDetailInfo:(NSString *)userID isSelf:(NSString *)isSelf {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];
    MyFriendCircleInfoVC *vc = [[MyFriendCircleInfoVC alloc] init];
    vc.userID = userID;
    //判断是否是自己
    vc.ofType = [isSelf integerValue] == 1 ? @"mine" : @"other";
    DDWeakSelf;
    vc.clickFocusBlock = ^(NSString * _Nonnull type) {
        for (FriendCricleModel *model in weakself.dataSource) {
            if ([model.userId isEqualToString:model.userId]) {
                if ([type isEqualToString:@"addFocus"]) {
                    model.isFollow = 1;
                    NSInteger newFansCount = [model.dyeFollowCount integerValue] + 1;
                    model.dyeFollowCount = @(newFansCount).stringValue;
                } else {
                    model.isFollow = 0;
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
    [_kbView.textView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];
    FriendCircleDetailVC *vc = [[FriendCircleDetailVC alloc] init];
    vc.tieziID = tieziID;
    [self.navigationController pushViewController:vc animated:YES];
}

//跳转地图
- (void)didGotoLocationMap:(FriendCricleModel *)model {
    [_kbView.textView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];
    FCMapVC *vc = [[FCMapVC alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

//跳转到资讯详情
- (void)didGotoZiXunDetail:(NSString *)zixunID {
    InfomationDetailVC *vc = [[InfomationDetailVC alloc] init];
    vc.infoID = zixunID;
    [self.navigationController pushViewController:vc animated:YES];
}

//跳转到话题
- (void)didGotoTopicList:(FriendTopicModel *)model {
    FriendCircleVC *vc = [[FriendCircleVC alloc] init];
    vc.type = @"noTopic";
    vc.firstTopicID = @"no";
    vc.firstType = @"find";
    vc.tbFrame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    vc.secondTopicID = model.secondTopicID;
    vc.navTitle = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

//关注或取消关注
- (void)focusOrCancel:(NSString *)tieziID {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:nil];
    NSIndexPath *indexPath = [[self getIndexPath:tieziID] firstObject];
    FriendCricleModel *model = _dataSource[indexPath.row];
    if (model.isFollow == 0) {
        [self addFocusWithUserID:model.userId];
    }
    //取消关注
    else {
        NSString *title = [NSString stringWithFormat:@"是否取消关注 “%@” ?",model.postUser];
        DDWeakSelf;
        [Alert alertTwo:title cancelBtn:@"再想想" okBtn:@"确定" OKCallBack:^{
            [weakself cancelFocusWithUserID:model.userId];
        }];
    }
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
                           @"parentId":commentID,
                           @"from":@"app_ios"
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
                    model.isFollow = 1;
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
                    model.isFollow = 0;
                    NSInteger newFansCount = [model.dyeFollowCount integerValue] - 1;
                    model.dyeFollowCount = @(newFansCount).stringValue;
                }
            }
            [weakself.tableView reloadData];
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
    cell.cellType = _type;
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

#pragma mark 按下return的代理方法
- (void)clickReturn {
    [_kbView.textView resignFirstResponder];
    [self publishComments];
}

- (void)setupUIWithPlaceholder:(NSString *)placeHolder {
    _kbView = [[WXKeyBoardView alloc] init];
    _kbView.top = SCREEN_HEIGHT;
    _kbView.tvDelegate = self;
    [_kbView.textView becomeFirstResponder];
    _kbView.textView.placeholder = placeHolder;
    //    [self.view addSubview:_kbView];
    [[UIApplication sharedApplication].keyWindow addSubview:_kbView];
}

#pragma mark -键盘监听方法
- (void)keyBoardWillShow:(NSNotification *)notification
{
//    NSLog(@"--- %@",[notification userInfo]);
    //     获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    DDWeakSelf;
    [UIView animateWithDuration:animationTime animations:^{
//        if (weakself.tbFrame.size.height == SCREEN_HEIGHT - NAV_HEIGHT) {
//            weakself.kbView.top = SCREEN_HEIGHT - keyBoardHeight - weakself.kbView.height;
//        } else {
//            weakself.kbView.top = SCREEN_HEIGHT - keyBoardHeight - weakself.kbView.height - (SCREEN_HEIGHT - weakself.tbFrame.size.height) + TABBAR_HEIGHT;
//        }
        weakself.kbView.top = SCREEN_HEIGHT - keyBoardHeight - weakself.kbView.height;
    }];
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
    } completion:^(BOOL finished) {
        [weakself.kbView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [weakself.kbView removeFromSuperview];
        weakself.kbView = nil;
    }];
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
