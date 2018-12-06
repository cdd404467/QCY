//
//  MyFriendCircleInfoVC.m
//  QCY
//
//  Created by i7colors on 2018/12/5.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyFriendCircleInfoVC.h"
#import "CommonNav.h"
#import <YNPageViewController.h>
#import "MacroHeader.h"
#import "FansVC.h"
#import "FriendCircleRecordVC.h"
#import "UIView+Geometry.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "CddHUD.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "FriendCricleModel.h"



@interface MyFriendCircleInfoVC ()<YNPageViewControllerDataSource, YNPageViewControllerDelegate>
@property (nonatomic, strong)CommonNav *nav;
@property (nonatomic, assign)int page;
@property (nonatomic, strong)YNPageViewController *ynVC;
@property (nonatomic, strong)FriendCricleInfoModel *headerDataSource;
@property (nonatomic, strong)NSMutableArray *dataSource;
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
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.nav];
    [self requestData];
}

- (CommonNav *)nav {
    if (!_nav) {
        CommonNav *nav = [[CommonNav alloc] init];
        nav.titleLabel.textColor = [UIColor whiteColor];
        nav.backgroundColor = HEXColor(@"#ffffff", 0);
        nav.bottomLine.hidden = YES;
        nav.leftBtnTintColor = [UIColor whiteColor];
        nav.titleLabel.text = @"朋友圈个人信息";
        [nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _nav = nav;
    }
    
    return _nav;
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
    //第一个线程获取列表
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_Friend_UserInfo,User_Token,weakself.userID];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                        NSLog(@"---- %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                weakself.headerDataSource = [FriendCricleInfoModel mj_objectWithKeyValues:json[@"data"]];
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            NSLog(@" Error : %@",error);
            dispatch_group_leave(group);
        }];
    });
    
    //第二个线程，获取详情
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        NSString *urlString = [NSString stringWithFormat:URL_User_Friend_InfoList,weakself.page,Page_Count,weakself.userID];
        [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                        NSLog(@"==== %@",json);
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                NSArray *tempArr = [FriendCricleModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [weakself.dataSource addObjectsFromArray:tempArr];
            }
            dispatch_group_leave(group);
        } Failure:^(NSError *error) {
            NSLog(@" Error : %@",error);
            dispatch_group_leave(group);
        }];
    });
    
    //全部任务完成后，就可以在这吊了
    dispatch_group_notify(group, globalQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself setupPageVC];
            [CddHUD hideHUD:weakself.view];
        });
    });
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
//    configration.headerViewCouldScale = YES;
//    configration.headerViewScaleMode = YNPageHeaderViewScaleModeTop;
    configration.bottomLineBgColor = HEXColor(@"#D3D3D3", 0.6);
    //    /// 设置悬浮停顿偏移量
    configration.suspenOffsetY = NAV_HEIGHT;
    //
    YNPageViewController *vc = [YNPageViewController pageViewControllerWithControllers:self.getArrayVCs
                                                                                titles:[self getArrayTitles]
                                                                                config:configration];
    vc.dataSource = self;
    vc.delegate = self;

    MyFriendCircleInfoView *header = [[MyFriendCircleInfoView alloc] init];
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 146 + NAV_HEIGHT);
    header.model = _headerDataSource;
    vc.headerView = header;
    //    /// 指定默认选择index 页面
    vc.pageIndex = 0;
    
    /// 作为自控制器加入到当前控制器
    [vc addSelfToParentViewController:self];
    _ynVC = vc;
    
    [_nav removeFromSuperview];
    [self.view addSubview:self.nav];
    
    /// 如果隐藏了导航条可以 适当改y值
    //    pageVC.view.yn_y = kYNPAGE_NAVHEIGHT;
    
}

- (NSArray *)getArrayVCs {
    
    FriendCircleRecordVC *vc_1 = [[FriendCircleRecordVC alloc] init];
    vc_1.dataSource = _dataSource;
//    vc_1.storeID = _storeID;
//    vc_1.tempArr = _tempArr;
    //
    FansVC *vc_2 = [[FansVC alloc] init];
    vc_2.userID = _userID;
    
    return @[vc_1, vc_2];
}

- (NSArray *)getArrayTitles {
    return @[@"朋友圈记录", @"粉丝"];
}

#pragma mark - 代理方法
- (UIScrollView *)pageViewController:(YNPageViewController *)pageViewController pageForIndex:(NSInteger)index {
    UIViewController *vc = pageViewController.controllersM[index];
    if ([vc isKindOfClass:[FriendCircleRecordVC class]]) {
        return [(FriendCircleRecordVC *)vc tableView];
    } else {
        return [(FansVC *)vc tableView];
    }
    
}

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (pgOne < 0.5) {
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
    _nav.backgroundColor = HEXColor(@"#ffffff", progress);
    [self setNeedsStatusBarAppearanceUpdate];
    if (progress < 0.5) {
        _nav.titleLabel.textColor = RGBA(255, 255, 255,1 - progress);
    } else {
        _nav.titleLabel.textColor = RGBA(0, 0, 0,progress);
    }
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end



/************************************************ 自定义的view ************************************************/
@interface MyFriendCircleInfoView()
@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *isCert;
@property (nonatomic, strong)UILabel *nickName;
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
    infoBg.frame = CGRectMake(KFit_W(15), NAV_HEIGHT + 16, SCREEN_WIDTH - KFit_W(30), 112);
    [self addSubview:infoBg];

    UIImageView *headerImage = [[UIImageView alloc] init];
    [headerImage sd_setImageWithURL:ImgUrl(@"ffff") placeholderImage:DefaultImage];
    headerImage.layer.cornerRadius = 32;
    headerImage.clipsToBounds = YES;
    [self addSubview:headerImage];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(30));
        make.width.height.mas_equalTo(64);
        make.top.mas_equalTo(infoBg.mas_top).offset(-15);
    }];
    _headerImage = headerImage;
    
    //关注按钮
    UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    focusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    focusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    focusBtn.layer.cornerRadius = 6;
    focusBtn.clipsToBounds = YES;
    [infoBg addSubview:focusBtn];
    [focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(45);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
    }];
    _focusBtn = focusBtn;
    
    //名字/昵称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = HEXColor(@"#292B32", 1);
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [infoBg addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerImage.mas_right).offset(10);
        make.right.mas_equalTo(focusBtn.mas_left).offset(-5);
        make.centerY.mas_equalTo(focusBtn);
    }];
    _nameLabel = nameLabel;
    
    //是否认证
    UILabel *isCert = [[UILabel alloc] init];
    isCert.font = [UIFont systemFontOfSize:12];
    isCert.textColor = HEXColor(@"#686D74", 1);
    [infoBg addSubview:isCert];
    [isCert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(nameLabel);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(7);
    }];
    _isCert = isCert;
    
    //昵称
    UILabel *nickName = [[UILabel alloc] init];
    nickName.textColor = HEXColor(@"#686D74", 1);
    nickName.font = [UIFont systemFontOfSize:14];
    [infoBg addSubview:nickName];
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel);
        make.right.mas_equalTo(focusBtn.mas_left).offset(20);
        make.top.mas_equalTo(isCert.mas_bottom).offset(19);
    }];
    _nickName = nickName;
    
    
    //修改昵称
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setTitle:@"点击修改" forState:UIControlStateNormal];
    [changeBtn setTitleColor:HEXColor(@"#686D74", 1) forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [infoBg addSubview:changeBtn];
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.mas_equalTo(focusBtn);
        make.width.mas_equalTo(60);
        make.centerY.mas_equalTo(nickName);
    }];
    
//    [self test];
}

- (void)setModel:(FriendCricleInfoModel *)model {
    _model = model;
    
    if ([model.isFollow isEqualToString:@"0"]) {
        [_focusBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_focusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _focusBtn.layer.borderWidth = 1.f;
        _focusBtn.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
        [_focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [_focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_focusBtn setImage:[UIImage imageNamed:@"friend_btn_bg"] forState:UIControlStateNormal];
    }
    
    //称号
    _nameLabel.text = @"中国印染行业协会会长 陈志华";
    _isCert.text = @"大V认证时间：2018-10-17";
    _nickName.text = @"昵称：陈志华";
    
}

- (void)test {
    
    _nameLabel.text = @"中国印染行业协会会长 陈志华";
    _isCert.text = @"大V认证时间：2018-10-17";
    _nickName.text = @"昵称：陈志华";
}

@end
