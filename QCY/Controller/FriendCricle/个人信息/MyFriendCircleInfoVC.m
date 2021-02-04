//
//  MyFriendCircleInfoVC.m
//  QCY
//
//  Created by i7colors on 2018/12/5.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyFriendCircleInfoVC.h"
#import <YNPageViewController.h>
#import "FansVC.h"
#import "FriendCircleRecordVC.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import <UIImageView+WebCache.h>
#import "FriendCricleModel.h"
#import <YYText.h>
#import "TimeAbout.h"
#import "BigVCertVC.h"
#import "ChangeHeaderVC.h"
#import "HelperTool.h"
#import "ChangeNickNameVC.h"
#import "NavControllerSet.h"
#import "MyFriendsVC.h"
#import "NewMsgListVC.h"
#import "Alert.h"

@interface MyFriendCircleInfoVC ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>
@property (nonatomic, assign)int page;
@property (nonatomic, strong)YNPageViewController *ynVC;
@property (nonatomic, strong)FriendCricleInfoModel *headerDataSource;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)MyFriendCircleInfoView *vcHeader;
@property (nonatomic, strong)UIButton *msgBtn;
@property (nonatomic, copy)NSString *msgBadgeValue;
@property (nonatomic, strong)UILabel *msgLabel;
@end

@implementation MyFriendCircleInfoVC {
    CGFloat pgOne;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar];
    [self requestData];
    //修改头像监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeInfo:) name:@"changeFCInfo" object:nil];
    
    if ([_ofType isEqualToString:@"mine"]) {
        [self setMsgView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMsgCount) name:NFT_FC_UnreadMessage_Refresh object:nil];
    }
}

- (void)setMsgBadgeValue:(NSString *)msgBadgeValue {
    _msgBadgeValue = msgBadgeValue;
    if ([msgBadgeValue integerValue] == 0) {
        _msgLabel.hidden = YES;
        return;
    }
    
    _msgLabel.hidden = NO;
    if ([msgBadgeValue integerValue] > 99)
        msgBadgeValue = @"99";
    _msgLabel.text = msgBadgeValue;
    CGFloat width = [msgBadgeValue boundingRectWithSize:CGSizeMake(30, 15)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:_msgLabel.font}
                                                context:nil].size.width;
    
    if (msgBadgeValue.length != 1) {
        _msgLabel.width = width + 4;
        _msgLabel.height = width + 4;
        _msgLabel.layer.cornerRadius = (width + 4) / 2;
        _msgLabel.clipsToBounds = YES;
    }
}

//刷新未读数量
- (void)refreshMsgCount {
    NSString *urlString = [NSString stringWithFormat:URL_Friend_MyInfo,User_Token];
    DDWeakSelf;
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        //                        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.headerDataSource = [FriendCricleInfoModel mj_objectWithKeyValues:json[@"data"]];
            if ([weakself.ofType isEqualToString:@"mine"]) {
                [weakself setMsgBadgeValue:weakself.headerDataSource.notReadMessageCount];
            }
            weakself.msgBadgeValue = weakself.headerDataSource.notReadMessageCount;
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}


- (void)setMsgView {
    _msgBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 2, 50, 44)];
    [_msgBtn setTitle:@"消息" forState:(UIControlStateNormal)];
    [_msgBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
    [_msgBtn addTarget:self action:@selector(goToReadMsg) forControlEvents:UIControlEventTouchUpInside];
    _msgBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, 15, 15)];
    _msgLabel.font = [UIFont systemFontOfSize:10];
    _msgLabel.textColor = MainColor;
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    _msgLabel.backgroundColor = UIColor.whiteColor;
    _msgLabel.layer.cornerRadius = 15 / 2;
    _msgLabel.clipsToBounds = YES;
    _msgLabel.hidden = YES;
    [self.msgBtn addSubview:_msgLabel];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.msgBtn];
}

- (void)goToReadMsg {
    NewMsgListVC *vc = [[NewMsgListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//改变头像的代理方法
- (void)changeInfo:(NSNotification *)notification {
    //头像
    if ([notification.object isEqualToString:@"header"]) {
        if isRightData(notification.userInfo[@"fcDict"]) {
            NSURL *header = notification.userInfo[@"fcDict"];
            _headerDataSource.communityPhoto = To_String(header);
        }
    } else if ([notification.object isEqualToString:@"nickName"]) {
        _headerDataSource.nickName = notification.userInfo[@"fcDict"];
    }
    
    _vcHeader.model = _headerDataSource;
}

- (void)setNavBar {
    self.title = @"印染圈个人信息";
    self.backBtnTintColor = UIColor.whiteColor;
    [self vhl_setNavBarTitleColor:UIColor.whiteColor];
    [self vhl_setNavBarBackgroundAlpha:0.0];
    [self vhl_setNavBarShadowImageHidden:YES];
}


//初始化数据源
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
        _dataSource = mArr;
    }
    return _dataSource;
}

#pragma mark - 网络请求
- (void)requestData {
    DDWeakSelf;
    [CddHUD show:self.view];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    //第一个线程获取信息
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        //我的信息
        if ([weakself.ofType isEqualToString:@"mine"]) {
            NSString *urlString = [NSString stringWithFormat:URL_Friend_MyInfo,User_Token];
            [ClassTool getRequest:urlString Params:nil Success:^(id json) {
                //                NSLog(@"---- %@",json);
                if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                    weakself.headerDataSource = [FriendCricleInfoModel mj_objectWithKeyValues:json[@"data"]];
                    weakself.msgBadgeValue = weakself.headerDataSource.notReadMessageCount;
                }
                dispatch_group_leave(group);
            } Failure:^(NSError *error) {
                NSLog(@" Error : %@",error);
                dispatch_group_leave(group);
            }];
        } else {
            NSString *urlString = [NSString stringWithFormat:URL_Friend_UserInfo,User_Token,weakself.userID];
            if (weakself.messageType != nil)
                urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&&messageId=%@",weakself.messageId]];
            [ClassTool getRequest:urlString Params:nil Success:^(id json) {
                //                NSLog(@"----b %@",json);
                if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                    weakself.headerDataSource = [FriendCricleInfoModel mj_objectWithKeyValues:json[@"data"]];
                    if (weakself.messageType != nil) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NFT_FC_UnreadMessage_Refresh object:nil userInfo:nil];
                        if ([weakself.refreshDelegate respondsToSelector:@selector(fcMessageAlreadyRead:)]) {
                            [weakself.refreshDelegate fcMessageAlreadyRead:weakself.index];
                        }
                    }
                }
                dispatch_group_leave(group);
            } Failure:^(NSError *error) {
                NSLog(@" Error : %@",error);
                dispatch_group_leave(group);
            }];
        }
    });
    
    //第二个线程，获取列表
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        //获取我本人的信息
        if ([weakself.ofType isEqualToString:@"mine"]) {
            NSString *urlString = [NSString stringWithFormat:URL_My_Friend_InfoList,User_Token,weakself.page,Page_Count];
            [ClassTool getRequest:urlString Params:nil Success:^(id json) {
                //                                        NSLog(@"==== %@",json);
                if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                    NSArray *tempArr = [FriendCricleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                    [weakself.dataSource addObjectsFromArray:tempArr];
                }
                dispatch_group_leave(group);
            } Failure:^(NSError *error) {
                NSLog(@" Error : %@",error);
                dispatch_group_leave(group);
            }];
            //获取其他用户的信息
        } else {
            NSString *urlString = [NSString stringWithFormat:URL_User_Friend_InfoList,User_Token,weakself.page,Page_Count,weakself.userID];
            [ClassTool getRequest:urlString Params:nil Success:^(id json) {
                //                                        NSLog(@"==== %@",json);
                if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                    NSArray *tempArr = [FriendCricleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                    [weakself.dataSource addObjectsFromArray:tempArr];
                }
                dispatch_group_leave(group);
            } Failure:^(NSError *error) {
                NSLog(@" Error : %@",error);
                dispatch_group_leave(group);
            }];
        }
    });
    
    //全部任务完成后，就可以在这吊了
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself setupPageVC];
            [CddHUD hideHUD:weakself.view];
        });
    });
}

//关注
- (void)addFocus {
    NSDictionary *dict = @{@"token":User_Token,
                           @"byUserId":_userID
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Add_Focus Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        //                        NSLog(@"-----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.headerDataSource.isFollow = @"1";
            weakself.vcHeader.model = weakself.headerDataSource;
            if (weakself.clickFocusBlock) {
                weakself.clickFocusBlock(@"addFocus");
            }
            [CddHUD showTextOnlyDelay:@"关注成功" view:weakself.view];
        }
    } Failure:^(NSError *error) {
        
    }];
}

//取消关注
- (void)cancelFocus {
    NSDictionary *dict = @{@"token":User_Token,
                           @"byUserId":_userID
                           };
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URL_Cancel_Focus Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        //                NSLog(@"-----=== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            weakself.headerDataSource.isFollow = @"0";
            weakself.vcHeader.model = weakself.headerDataSource;
            if (weakself.clickFocusBlock) {
                weakself.clickFocusBlock(@"cancelFocus");
            }
            [CddHUD showTextOnlyDelay:@"取消关注成功" view:weakself.view];
        }
    } Failure:^(NSError *error) {
        
    }];
}
//取消或关注
- (void)focusOrCancel {
    if ([self.headerDataSource.isFollow isEqualToString:@"0"]) {
        [self addFocus];
    }
    //取消关注
    else {
        NSString *title = @"是否取消关注?";
        DDWeakSelf;
        [Alert alertTwo:title cancelBtn:@"再想想" okBtn:@"确定" OKCallBack:^{
            [weakself cancelFocus];
        }];
    }
}

//修改昵称
- (void)gotoChangeNickName {
    ChangeNickNameVC *vc = [[ChangeNickNameVC alloc] init];
    vc.currentName = _headerDataSource.nickName;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setupPageVC {
    YNPageConfigration *configration = [YNPageConfigration defaultConfig];
    configration.pageStyle = YNPageStyleSuspensionTopPause;
    configration.headerViewCouldScale = YES;
    //    /// 控制tabbar 和 nav
    configration.showTabbar = NO;
    configration.showNavigation = NO;
    configration.scrollMenu = NO;
    configration.aligmentModeCenter = NO;
    configration.lineWidthEqualFontWidth = YES;
    configration.scrollViewBackgroundColor = [UIColor whiteColor];
    configration.normalItemColor = [UIColor blackColor];
    configration.selectedItemColor = MainColor;
    configration.lineColor = MainColor;
    configration.itemFont = [UIFont systemFontOfSize:15];
    configration.selectedItemFont = [UIFont boldSystemFontOfSize:15];
    configration.showBottomLine = YES;
    configration.bottomLineHeight = 0.6;
    configration.bottomLineBgColor = HEXColor(@"#D3D3D3", 0.6);
    //    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = NAV_HEIGHT;
    
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;
    DDWeakSelf;
    MyFriendCircleInfoView *header = [[MyFriendCircleInfoView alloc] init];
    header.ofType = _ofType;
    [header.focusBtn addTarget:self action:@selector(focusOrCancel) forControlEvents:UIControlEventTouchUpInside];
    [header.changeBtn addTarget:self action:@selector(gotoChangeNickName) forControlEvents:UIControlEventTouchUpInside];
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, floor(146 + NAV_HEIGHT));
    if ([_ofType isEqualToString:@"mine"]) {
        [HelperTool addTapGesture:header.headerImage withTarget:self andSEL:@selector(jumpToChangeHeader)];
    }
    header.model = _headerDataSource;
    __weak MyFriendCircleInfoView *weakHeader = header;
    header.certClickBlock = ^{
        BigVCertVC *vc = [[BigVCertVC alloc] init];
        vc.refreshMyInfoBlock = ^{
            weakHeader.isCert.text = @"审核中";
            weakHeader.isCert.font = [UIFont systemFontOfSize:13];
            weakHeader.isCert.textColor = HEXColor(@"#686D74", 1);
        };
        [weakself.navigationController pushViewController:vc animated:YES];
    };
    vc.headerView = header;
    _vcHeader = header;
    // 指定默认选择index 页面
    vc.pageIndex = 0;
    
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    _ynVC = vc;
}


- (NSArray *)getArrayVCs {
    //记录
    FriendCircleRecordVC *vc_1 = [[FriendCircleRecordVC alloc] init];
    vc_1.dataSource = _dataSource;
    vc_1.headerModel = self.headerDataSource;
    
    
    //粉丝
    FansVC *vc_2 = [[FansVC alloc] init];
    vc_2.userID = _userID;
    vc_2.ofType = _ofType;
    
    if ([_ofType isEqualToString:@"mine"]) {
        MyFriendsVC *fvc = [[MyFriendsVC alloc] init];
        return @[vc_1, fvc,vc_2];
    }
    
    return @[vc_1, vc_2];
}

- (NSArray *)getArrayTitles {
    if ([_ofType isEqualToString:@"mine"])
        return @[@"印染圈记录",@"好友" ,@"粉丝"];
    return @[@"印染圈记录", @"粉丝"];
}

#pragma mark - 代理方法
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[FriendCircleRecordVC class]]) {
        return [(FriendCircleRecordVC *)vc tableView];
    } else if ([vc isKindOfClass:[FansVC class]]) {
        return [(FansVC *)vc tableView];
    } else {
        return [(MyFriendsVC *)vc tableView];
    }
}

- (void)jumpToChangeHeader {
    ChangeHeaderVC *vc = [[ChangeHeaderVC alloc] init];
    vc.changeType = @"fc";
    vc.fcHeaderUrl = _headerDataSource.communityPhoto;
    [self.navigationController pushViewController:vc animated:YES];
}


//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (pgOne < 0.2) {
        return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
    } else {
        return UIStatusBarStyleDefault;
    }
}

//滚动监听
- (void)pageViewController:(YNPageViewController *)pageViewController
            contentOffsetY:(CGFloat)contentOffset
                  progress:(CGFloat)progress {
    //    NSLog(@"--- contentOffset = %f, progress = %f", contentOffset, progress);
    pgOne = progress;
    [self vhl_setNavBarBackgroundAlpha:progress];
    
    [self setNeedsStatusBarAppearanceUpdate];
    if (progress < 0.2) {
        self.backBtnTintColor = UIColor.whiteColor;
        [self vhl_setNavBarTitleColor:UIColor.whiteColor];
        _msgLabel.backgroundColor = UIColor.whiteColor;
        _msgLabel.textColor = MainColor;
        [_msgBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    } else {
        self.backBtnTintColor = UIColor.blackColor;
        [self vhl_setNavBarTitleColor:UIColor.blackColor];
        _msgLabel.backgroundColor = MainColor;
        _msgLabel.textColor = UIColor.whiteColor;
        [_msgBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    }
    
    if (progress == 1.0) {
        [self vhl_setNavBarShadowImageHidden:NO];
    } else {
        [self vhl_setNavBarShadowImageHidden:YES];
    }
    
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end



/******************************************* 自定义的headerView *******************************************/
@interface MyFriendCircleInfoView()
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)YYLabel *nickName;
@property (nonatomic, strong)UIImageView *bigVImage;
@end

@implementation MyFriendCircleInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 102 + NAV_HEIGHT);
    bgView.image = [UIImage imageNamed:@"friend_myinfo_bg"];
    [self addSubview:bgView];
    
    UIImageView *infoBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"info_bgView"]];
    infoBg.userInteractionEnabled = YES;
    infoBg.frame = CGRectMake(15, NAV_HEIGHT + 16, SCREEN_WIDTH - 30, 112);
    [self addSubview:infoBg];
    
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.contentMode = UIViewContentModeScaleAspectFill;
    headerImage.layer.cornerRadius = 32;
    headerImage.clipsToBounds = YES;
    [self addSubview:headerImage];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.width.height.mas_equalTo(65);
        make.top.mas_equalTo(infoBg.mas_top).offset(-15);
    }];
    _headerImage = headerImage;
    
    UIImageView *bigVImage = [[UIImageView alloc] init];
    bigVImage.layer.cornerRadius = 9;
    bigVImage.clipsToBounds = YES;
    bigVImage.image = [UIImage imageNamed:@"bigV_img"];
    bigVImage.hidden = YES;
    [self addSubview:bigVImage];
    [bigVImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(18);
        make.right.bottom.mas_equalTo(headerImage);
    }];
    _bigVImage = bigVImage;
    
    //修改昵称
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setTitle:@"修改\n昵称" forState:UIControlStateNormal];
    changeBtn.titleLabel.numberOfLines = 2;
    [changeBtn setTitleColor:HEXColor(@"#1E90FF", 1) forState:UIControlStateNormal];
    [changeBtn setTitleColor:HEXColor(@"#1E90FF", 0.7) forState:UIControlStateHighlighted];
    changeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    changeBtn.hidden = YES;
    [infoBg addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(45);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(10);
    }];
    _changeBtn = changeBtn;
    
    //关注按钮
    UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    focusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    focusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    focusBtn.layer.cornerRadius = 5;
    focusBtn.clipsToBounds = YES;
    focusBtn.hidden = YES;
    [infoBg addSubview:focusBtn];
    [focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(headerImage);
        make.width.mas_equalTo(changeBtn);
        make.height.mas_equalTo(25);
        make.bottom.mas_equalTo(-20);
    }];
    _focusBtn = focusBtn;
    
    //昵称
    YYLabel *nickName = [[YYLabel alloc] init];
    nickName.textColor = HEXColor(@"#292B32", 1);
    nickName.font = [UIFont boldSystemFontOfSize:15];
    nickName.numberOfLines = 2;
    nickName.frame = CGRectMake(90, 8, infoBg.width - 90 - 50 - 5, 0);
    [infoBg addSubview:nickName];
    _nickName = nickName;
    
    //是否认证
    YYLabel *isCert = [[YYLabel alloc] init];
    isCert.font = [UIFont systemFontOfSize:13];
    isCert.textColor = HEXColor(@"#686D74", 1);
    isCert.frame = CGRectMake(_nickName.left, _nickName.bottom + 4, _nickName.width, 15);
    [infoBg addSubview:isCert];
    _isCert = isCert;
    
    //认证名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = HEXColor(@"#686D74", 1);
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.numberOfLines = 2;
    nameLabel.frame = CGRectMake(_isCert.left, _isCert.bottom + 5, _nickName.width + 55, 0);
    [infoBg addSubview:nameLabel];
    _nameLabel = nameLabel;
}

- (void)setModel:(FriendCricleInfoModel *)model {
    _model = model;
    if isRightData(model.communityPhoto) {
        if ([[model.communityPhoto substringToIndex:4] isEqualToString:@"http"]) {
            [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.communityPhoto] placeholderImage:PlaceHolderImg];
        } else {
            [_headerImage sd_setImageWithURL:ImgUrl(model.communityPhoto) placeholderImage:PlaceHolderImg];
        }
    } else {
        _headerImage.image = DefaultImage;
    }
    
    //昵称
    if isRightData(model.nickName) {
        _nickName.text = model.nickName;
        //是自己,有修改按钮
        if (![_ofType isEqualToString:@"mine"]) {
            if (GET_USER_TOKEN) {
                //如果进入看的不是自己，显示关注按钮
                if (model.isCharger == 0) {
                    _nickName.width = _nickName.width + 55;
                    _nickName.numberOfLines = 2;
                }
            } else {
                _nickName.width = _nickName.width + 55;
                _nickName.numberOfLines = 2;
            }
        }
            
        NSMutableAttributedString *mtitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",model.nickName]];
        mtitle.yy_color = _nickName.textColor;
        mtitle.yy_font = _nickName.font;
        if (isRightData(model.bossLevel)) {
            UIImageView *levelImageView = [[UIImageView alloc] init];
            levelImageView.frame = CGRectMake(0, 0, 15, 15);
            NSString *imageStr = [NSString string];
            if ([model.bossLevel isEqualToString:@"1"]) {
                imageStr = @"level_1";
            } else if ([model.bossLevel isEqualToString:@"2"]) {
                imageStr = @"level_2";
            } else if ([model.bossLevel isEqualToString:@"3"]) {
                imageStr = @"level_3";
            }
            levelImageView.image = [UIImage imageNamed:imageStr];
            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:levelImageView contentMode:UIViewContentModeCenter attachmentSize:levelImageView.size alignToFont:_nickName.font alignment:YYTextVerticalAlignmentCenter];
            [mtitle appendAttributedString:attachText];
        }
        
        //YYLabel计算高度
        _nickName.attributedText = mtitle;
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(_nickName.width, MAXFLOAT) text:mtitle];
        _nickName.textLayout = layout;
        CGFloat nameHeight = layout.textBoundingSize.height + 2;
        _nickName.height = nameHeight;
        _isCert.width = _nickName.width;
        _isCert.top = _nickName.bottom + 4;
    } else {
        _nickName.height = 20;
        _isCert.top = _nickName.bottom + 4;
        _nickName.text = @"未设置昵称";
    }
    
    //认证名字
    if isRightData(model.dyeVName) {
        _nameLabel.text = model.dyeVName;
    } else if isRightData(model.companyName) {
        _nameLabel.text = model.companyName;
    }
    CGFloat nameLabHeight = [_nameLabel.text boundingRectWithSize:CGSizeMake(_nameLabel.width, CGFLOAT_MAX)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:_nameLabel.font}
                                                      context:nil].size.height + 1;
    _nameLabel.height = nameLabHeight;
    _nameLabel.top = _isCert.bottom + 5;
    
    
    if ([_ofType isEqualToString:@"mine"]) {
        _focusBtn.hidden = YES;
        _changeBtn.hidden = NO;
    } else {
        if (GET_USER_TOKEN) {
            //如果进入看的不是自己，显示关注按钮
            if (model.isCharger.integerValue == 0) {
                _focusBtn.hidden = NO;
                _changeBtn.hidden = YES;
                if ([model.isFollow isEqualToString:@"0"]) {
                    [_focusBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
                    [_focusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    _focusBtn.layer.borderWidth = 1.f;
                    _focusBtn.layer.borderColor = [UIColor blackColor].CGColor;
                    [_focusBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
                } else {
                    [_focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
                    [_focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    _focusBtn.layer.borderWidth = 0.f;
                    _focusBtn.layer.borderColor = [UIColor clearColor].CGColor;
                    [_focusBtn setBackgroundImage:[UIImage imageNamed:@"friend_btn_bg"] forState:UIControlStateNormal];
                }
            } else {
                _focusBtn.hidden = YES;
                _changeBtn.hidden = NO;
            }
        } else {
            _focusBtn.hidden = YES;
            _changeBtn.hidden = YES;
        }
    }
    
    //是否大V认证
    //如果是企业就是代表已经认证
    if ([model.isCompanyType isEqualToString:@"1"]) {
        _isCert.text = @"已认证";
        _bigVImage.hidden = NO;
        //如果不是企业类型
    } else {
        //先判断是否是自己，是的话会有去认证按钮
        if ([_ofType isEqualToString:@"mine"]) {
            //是自己，而且是已经认证
            if ([model.isDyeV isEqualToString:@"1"]) {
                if isRightData(model.dyeVCreatedAtStamp) {
                    _bigVImage.hidden = NO;
                    _isCert.text = [NSString stringWithFormat:@"大V认证时间: %@",[TimeAbout timestampToString:[model.dyeVCreatedAtStamp longLongValue] isSecondMin:NO]];
                } else {
                    _isCert.text = @" ";
                }
                //是自己，而且是审核中
            } else if ([model.isDyeV isEqualToString:@"2"]) {
                _isCert.text = @"审核中";
                //是自己，而且是未认证
            } else if ([model.isDyeV isEqualToString:@"-1"]) {
                NSString *certText = @"未认证,现在去认证";
                NSMutableAttributedString *mtitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",certText]];
                UIFont *font = [UIFont systemFontOfSize:13];
                mtitle.yy_font = font;
                mtitle.yy_color = HEXColor(@"#686D74", 1);
                UIImageView *uncert = [[UIImageView alloc] init];
                uncert.frame = CGRectMake(0, 0, 13, 13);
                uncert.image = [UIImage imageNamed:@"friend_un_cert"];
                NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:uncert contentMode:UIViewContentModeScaleAspectFill attachmentSize:uncert.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
                [mtitle insertAttributedString:attachText atIndex:0];
                [mtitle yy_setFont:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(6, 5)];
                //点击事件
                [mtitle yy_setTextHighlightRange:NSMakeRange(6, 5) color:HEXColor(@"#1E90FF", 1) backgroundColor:HEXColor(@"#000000", 0.3) tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    if (self.certClickBlock) {
                        self.certClickBlock();
                    }
                }];
                _isCert.attributedText = mtitle;
                //是自己，认证失败
            } else if ([model.isDyeV isEqualToString:@"0"]) {
                NSString *certText = @"认证失败,去重新认证";
                NSMutableAttributedString *mtitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",certText]];
                UIFont *font = [UIFont systemFontOfSize:13];
                mtitle.yy_font = font;
                mtitle.yy_color = HEXColor(@"#686D74", 1);
                //点击事件
                [mtitle yy_setTextHighlightRange:NSMakeRange(6, 5) color:HEXColor(@"#1E90FF", 1) backgroundColor:HEXColor(@"#000000", 0.3) tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    if (self.certClickBlock) {
                        self.certClickBlock();
                    }
                }];
                _isCert.attributedText = mtitle;
            }
            
        }
        //不是自己的页面
        else {
            //如果不是自己，而且是已经认证的
            if ([model.isDyeV isEqualToString:@"1"]) {
                if isRightData(model.dyeVCreatedAtStamp) {
                    _bigVImage.hidden = NO;
                    _isCert.text = [NSString stringWithFormat:@"大V认证时间: %@",[TimeAbout timestampToString:[model.dyeVCreatedAtStamp longLongValue] isSecondMin:NO]];
                } else {
                    _isCert.text = @" ";
                }
                //不是自己，未认证
            } else {
                _isCert.text = @"未认证";
            }
        }
    }
}

@end

