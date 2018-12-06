//
//  MineVC.m
//  QCY
//
//  Created by zz on 2018/9/4.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MineVC.h"
#import "MacroHeader.h"
#import "HelperTool.h"
#import <Masonry.h>
#import "BaseNavigationController.h"
#import <UIImageView+WebCache.h>
#import <YYText.h>
#import "PaddingLabel.h"
#import <SDAutoLayout.h>
#import "MineHeaderView.h"
#import "MineHeaderReusableView.h"
#import <UIImageView+WebCache.h>
#import "MineCollectionCell.h"
#import "MyOfferPriceVC.h"
#import "MyAskToBuyVC.h"
#import "CommonNav.h"
#import "SettingVC.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "MinePageModel.h"
#import <MJExtension.h>
//跳转的页面
#import "LoginVC.h"
#import "SwitchVC.h"
#import "MyAskBuyListVC.h"
#import "MyAcceptedOfferListVC.h"
#import "CddHUD.h"


@interface MineVC ()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)MineHeaderView *headerView;
@property (nonatomic, assign)NSInteger switchID;
@property (nonatomic, copy)NSArray *sectionOneData_buyArr;
@property (nonatomic, copy)NSArray *sectionOneData_sellerArr;
@end

@implementation MineVC
- (void)viewDidLoad {
    [super viewDidLoad];
    _switchID = 0;
    [self.view insertSubview:self.collectionView atIndex:0];
    [self getNumber];
    [self setupNav];
    [self registerNoti];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

//    UIImageView *lineImageView = [HelperTool findNavLine:self.navigationController.navigationBar];
//    lineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];

}

- (void)setupNav {
    //导航栏不透明时要不要延伸到bar的下面
//    self.extendedLayoutIncludesOpaqueBars = YES;
    //根视图延展
//    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.nav.titleLabel.text = @"我的";
    self.nav.backBtn.hidden = YES;
    self.nav.titleLabel.textColor = [UIColor whiteColor];
    self.nav.backgroundColor = [UIColor clearColor];
    self.nav.bottomLine.hidden = YES;
    [self.nav.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nav.rightBtn setTitle:@"设置" forState:UIControlStateNormal];
    [self.nav.rightBtn addTarget:self action:@selector(jumpToSeting) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)jumpToSeting {
    SettingVC *vc = [[SettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
//        _collectionView.scrollEnabled = NO; //禁止滚动
//        _collectionView.showsHorizontalScrollIndicator = NO;
//        _collectionView.showsVerticalScrollIndicator = NO;//垂直
        _collectionView.backgroundColor = HEXColor(@"#EDEDED", 1);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_collectionView addSubview:[self addHeaderView]];
        //设置滚动范围偏移200
//        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(NAV_HEIGHT + 106 + 35, 0, 0, 0);
        //设置内容范围偏移200
        _collectionView.contentInset = UIEdgeInsetsMake(NAV_HEIGHT + 106 + 35, 0, 0, 0);
        [_collectionView registerClass:[MineCollectionCell class] forCellWithReuseIdentifier:@"iconCell"];
        [_collectionView registerClass:[MineHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    
    return _collectionView;
}

//创建自定义的tableView headerView
- (MineHeaderView *)addHeaderView {
    CGFloat headerHeight = NAV_HEIGHT + 106 + 35;
    MineHeaderView *headerView = [[MineHeaderView alloc] init];
    headerView.frame = CGRectMake(0, -headerHeight, SCREEN_WIDTH, headerHeight);
    [headerView.switchBtn addTarget:self action:@selector(jumpToSwitchVC) forControlEvents:UIControlEventTouchUpInside];
    [HelperTool addTapGesture:headerView.userHeader withTarget:self andSEL:@selector(jumpToMyInfo)];
    _headerView = headerView;
    return headerView;
}

#pragma mark - 网络请求
//获取被采纳的数量
- (void)getNumber {
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_Get_Mine_Num,User_Token];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            MineNumberModel *model = [MineNumberModel mj_objectWithKeyValues:json[@"data"]];
//            NSLog(@"----  %@",json[@"data"]);
            //买家的数组
            if (isRightData(model.isEnquiryCount) && isRightData(model.waitSureCount) && isRightData(model.myExpireCount)) {
                weakself.sectionOneData_buyArr = @[model.isEnquiryCount,model.waitSureCount,model.myExpireCount];
            }
            //卖家的数组
            if isRightData(model.myAcceptOfferCount) {
                weakself.sectionOneData_sellerArr = @[model.myAcceptOfferCount];
            }
            //我的历史求购和历史报价的数目
            if (isRightData(model.enquiryTimes) && isRightData(model.offerTimes)) {
                [weakself.headerView configData:model.enquiryTimes offer:model.offerTimes];
            }
            
            
            [weakself.collectionView reloadData];
        }
    } Failure:^(NSError *error) {
        
    }];
}


#pragma mark - collectionView代理
//数据源
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //重用cell
    MineCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"iconCell" forIndexPath:indexPath];
    NSArray *titleArr = [NSArray array];
    NSArray *imageArr = [NSArray array];
    if (indexPath.section == 0) {
        if (_switchID == 0) {
            titleArr = @[@"询盘中",@"待确认报价",@"即将过期"];
            imageArr = @[@"message_light",@"needOffer_light",@"willOutDate_light"];
            [cell configData:_sectionOneData_buyArr[indexPath.row]];
        } else {
            titleArr = @[@"买家已接受"];
            imageArr = @[@"buyer_accept"];
            [cell configData:_sectionOneData_sellerArr[indexPath.row]];
        }
        
        [cell.iconBtn setTitle:titleArr[indexPath.row] forState:UIControlStateNormal];
        [cell.iconBtn setImage:[UIImage imageNamed:imageArr[indexPath.row]] forState:UIControlStateNormal];
    }
    
    return cell;
}


/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_switchID == 0) {
        return 3;
    } else {
        return 1;
    }
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_switchID == 0) {
        return CGSizeMake(SCREEN_WIDTH / 3, 60);
    } else {
        return CGSizeMake(SCREEN_WIDTH , 60);
    }
}

//cell行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

//cell列间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

//四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 选中cell后操作
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_switchID == 0) {
            MyAskBuyListVC *vc = [[MyAskBuyListVC alloc] init];
            vc.listType = indexPath.row;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            MyAcceptedOfferListVC *vc = [[MyAcceptedOfferListVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//设置footer尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//
//}

//设置header尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 51);
}

//设置头部
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {  //header
        MineHeaderReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        [header.rightBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [header.rightBtn setImage:[UIImage imageNamed:@"btn_right"] forState:UIControlStateNormal];
        [self refreshSection:header];
        reusableView = header;
        
        return reusableView;
    }
//    else if([kind isEqualToString:UICollectionElementKindSectionFooter]){  //footer
//        TYHeaderFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
//        footer.backgroundColor = [UIColor blueColor];
//        return footer;
//    }
    return reusableView;
}


- (void)jumpTo {
    
    MyAskToBuyVC *vc = [[MyAskToBuyVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//弹出切换身份的页面
- (void)jumpToSwitchVC {
    SwitchVC *vc = [[SwitchVC alloc] init];
    vc.sID = _switchID;
    DDWeakSelf;
    vc.switchBlock = ^(NSInteger tag) {
        weakself.switchID = tag;
        [weakself getNumber];
        [weakself refreshType];
        [weakself.collectionView reloadData];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

//获取全部报价列表
- (void)jumpToOfferAll {
    MyOfferPriceVC *vc = [[MyOfferPriceVC alloc] init];
    vc.selectedIndex = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

//获取全部求购列表
- (void)jumpToAskAll {
    MyAskToBuyVC *vc = [[MyAskToBuyVC alloc] init];
    vc.selectedIndex = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToMyInfo {
    MyInfoCenterVC *vc = [[MyInfoCenterVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//切换身份，刷新按钮状态,用全局变量实现
- (void)refreshType {
    if (_switchID == 0) {
        [_headerView.idBtn setTitle:@"买家中心" forState:UIControlStateNormal];
        [_headerView.idBtn setImage:[UIImage imageNamed:@"buyer_icon"] forState:UIControlStateNormal];
    } else {
        [_headerView.idBtn setTitle:@"卖家中心" forState:UIControlStateNormal];
        [_headerView.idBtn setImage:[UIImage imageNamed:@"seller_icon"] forState:UIControlStateNormal];
    }
}

//刷新section
- (void)refreshSection:(MineHeaderReusableView *)header {
    
    NSString *sectionTitleOne = [NSString string];
    NSString *secctionImageOne = [NSString string];
    
    if (_switchID == 0) {
        sectionTitleOne = @"我的求购";
        secctionImageOne = @"my_ask_buy";
        [header.rightBtn removeTarget:self action:@selector(jumpToOfferAll) forControlEvents:UIControlEventTouchUpInside];
        [header.rightBtn addTarget:self action:@selector(jumpToAskAll) forControlEvents:UIControlEventTouchUpInside];
    } else {
        sectionTitleOne = @"我的报价";
        secctionImageOne = @"ask_buy_price_icon";
        [header.rightBtn removeTarget:self action:@selector(jumpToAskAll) forControlEvents:UIControlEventTouchUpInside];
        [header.rightBtn addTarget:self action:@selector(jumpToOfferAll) forControlEvents:UIControlEventTouchUpInside];
    }
    header.leftImageView.image = [UIImage imageNamed:secctionImageOne];
    header.leftLabel.text = sectionTitleOne;
}


//注册通知
-(void)registerNoti {
    NSString *notiName = @"refreshMainData";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:notiName object:nil];
    
    //修改头像监听
    NSString *notiName1 = @"changeHeader";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeader:) name:notiName1 object:nil];
    
    //修改密码后重新登录
    NSString *notiName2 = @"notifiReLogin";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLogin) name:notiName2 object:nil];
}

//改变整个页面的数据显示
- (void)refreshData {
    
    [self getNumber];
    //头像
    if (Get_Header) {
        NSURL *headerUrl = Get_Header;
        [_headerView.userHeader sd_setImageWithURL:headerUrl placeholderImage:nil];
    }
    
    //名字和用户类型
    NSString *name = [[UserDefault objectForKey:@"userInfo"] objectForKey:@"userName"];
    NSString *userType = [NSString string];
    if ([isCompany boolValue] == YES) {
        userType = @"企业用户";
    } else {
        userType = @"个人用户";
    }
    NSString *nameText = [NSString stringWithFormat:@"%@ | %@",name,userType];
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:nameText];
    mutableText.yy_color = [UIColor whiteColor];
    [mutableText yy_setFont:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, name.length + 2)];
    [mutableText yy_setFont:[UIFont systemFontOfSize:12] range:NSMakeRange(name.length + 2, userType.length)];
    _headerView.userName.attributedText = mutableText;
}

//通知到这里时只改变头像
- (void)changeHeader:(NSNotification *)notification {
    NSURL *header = notification.userInfo[@"cHeader"];
    //头像
    if (header) {
//        NSURL *headerUrl = header;
        [_headerView.userHeader sd_setImageWithURL:header placeholderImage:nil];
    }
}

- (void)reLogin {
    LoginVC *vc = [[LoginVC alloc] init];
    BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
    UITabBarController *tb = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    vc.isJump = YES;
    vc.jumpIndex = tb.tabBar.items.count - 1;
    [self presentViewController:navVC animated:YES completion:nil];
}

//修改statesBar 颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;  //白色，默认的值是黑色的
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
