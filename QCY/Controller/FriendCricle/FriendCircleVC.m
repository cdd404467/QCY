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

@interface FriendCircleVC ()<UITableViewDelegate, UITableViewDataSource, FriendCellDelegate,UITextViewDelegate,TVDelegate>
@property (nonatomic, strong)WXKeyBoardView *kbView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, assign)int page;
@property (nonatomic, assign)NSInteger commentIndex;   //别人评论的ID
@property (nonatomic, assign)BOOL isCommentUser;    //是否是回复别人的评论
@property (nonatomic, assign)BOOL isRefresh;        //是否是刷新
@end

@implementation FriendCircleVC

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
    [self requestFriendList];
    [self.view addSubview:self.tableView];
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
    [self setupUI];
    
}

- (void)viewWillAppear: (BOOL)animated {
    [IQKeyboardManager sharedManager].enable = NO;
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
}

- (void)viewWillDisappear: (BOOL)animated {
    [IQKeyboardManager sharedManager].enable = YES;
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
    self.nav.backgroundColor = HEXColor(@"#D3D3D3", 0.6);
    self.nav.bottomLine.hidden = YES;

}

- (void)jumpToPublishVC {
    DDWeakSelf;
    PublishFriendCircleVC *vc = [[PublishFriendCircleVC alloc] init];
    vc.refreshFCBlock = ^{
        weakself.isRefresh = YES;
        [weakself requestFriendList];
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
        
        FriendHeaderView *headerView = [[FriendHeaderView alloc] init];
        _tableView.tableHeaderView = headerView;
        
    }
    return _tableView;
}

#pragma mark - 获取朋友圈列表
- (void)requestFriendList {
    NSString *urlString = [NSString stringWithFormat:URL_Friend_List,User_Token,_page,Page_Count];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            NSArray *tempArr = [FriendCricleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            if (weakself.isRefresh == YES) {
                [weakself.dataSource removeAllObjects];
            }
            [weakself.dataSource addObjectsFromArray:tempArr];
            for (FriendCricleModel *model in weakself.dataSource) {
                model.likeList = [LikeListModel mj_objectArrayWithKeyValuesArray:model.likeList];
                model.commentList = [CommentListModel mj_objectArrayWithKeyValuesArray:model.commentList];
            }
            
            [weakself.tableView reloadData];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

#pragma mark - cell点击的各种代理方法
// 查看全文/收起
- (void)didSelectFullText:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
//点赞
- (void)didZan:(NSIndexPath *)indexPath {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    NSLog(@"----zan");
}

//评论
- (void)didComment:(NSIndexPath *)indexPath {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    
    _kbView.textView.placeholder = @"评论:";
    _indexPath = indexPath;
    _isCommentUser = NO;
    [_kbView.textView becomeFirstResponder];
    
//    CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
//
//    CGRect r = [self.tableView convertRect:rect toView:[self.tableView superview]];
//    NSLog(@"---- %f",r.origin.y);
    
}

//回复别人的评论
- (void)commentUserComment:(NSIndexPath *)indexPath index:(NSInteger)index {
    if (!GET_USER_TOKEN) {
        [self jumpToLogin];
        return;
    }
    _indexPath = indexPath;
    _commentIndex = index;
    _isCommentUser = YES;
    FriendCricleModel *model = _dataSource[_indexPath.row];
    _kbView.textView.placeholder = [NSString stringWithFormat:@"回复%@:",[model.commentList[_commentIndex] commentUser]];
    [_kbView.textView becomeFirstResponder];
}

- (void)didClickHeaderImage:(NSString *)userID {
    MyFriendCircleInfoVC *vc = [[MyFriendCircleInfoVC alloc] init];
    vc.userID = userID;
    [self.navigationController pushViewController:vc animated:YES];
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
        [CddHUD showTextOnlyDelay:@"请填写您要发表的内容" view:self.view];
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
//            [model.commentList addObject:dict];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:model.commentList];
            [arr addObject:dict];
            model.commentList = arr;
            [weakself.dataSource replaceObjectAtIndex:weakself.indexPath.row withObject:model];
            [weakself.tableView reloadRowsAtIndexPaths:@[weakself.indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
    return 200;
}

//数据源
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCricleCell *cell = [FriendCricleCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
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
    void (^animation)(void) = ^void(void) {
        self.kbView.transform = CGAffineTransformMakeTranslation(0, -(keyBoardHeight + self.kbView.height));
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
    
    _kbView.textView.text = @"";
}
- (void)keyBoardWillHide:(NSNotification *)notificaiton
{
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notificaiton.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        self.kbView.transform = CGAffineTransformIdentity;
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}
@end
