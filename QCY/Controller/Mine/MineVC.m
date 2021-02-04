//
//  MineVC.m
//  QCY
//
//  Created by zz on 2018/9/4.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MineVC.h"
#import "HelperTool.h"
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
#import "SettingVC.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "MinePageModel.h"
//跳转的页面
#import "LoginVC.h"
#import "SwitchVC.h"
#import "MyAskBuyListVC.h"
#import "MyAcceptedOfferListVC.h"
#import "CddHUD.h"
#import "WXApiManager.h"
#import <UMAnalytics/MobClick.h>
#import "MyZhuJiDiyListVC.h"
#import "MyZhuJiDiySolveListVC.h"

@interface MineVC ()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)MineHeaderView *headerView;
@property (nonatomic, assign)NSInteger switchID;
@property (nonatomic, copy)NSArray *sectionOneData_buyArr;
@property (nonatomic, copy)NSArray *sectionOneData_sellerArr;

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *dataSource_buyer;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *dataSource_seller;
@property (nonatomic, strong) UIButton *selectedBtn; //选中按钮
@end

@implementation MineVC
- (void)viewDidLoad {
    [super viewDidLoad];
    _switchID = 0;
    [self.view insertSubview:self.collectionView atIndex:0];
    [self setupNav];
    [self registerNoti];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getNumber];
    [MobClick beginLogPageView:self.navigationItem.title];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.navigationItem.title];
}


- (NSMutableArray *)dataSource_buyer {
    if (!_dataSource_buyer) {
        NSArray *titleArr = [NSArray array];
        NSArray *imageArr = [NSArray array];
        _dataSource_buyer = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < 2; i++) {
            NSMutableArray<MineCellModel *> *mArr = [NSMutableArray arrayWithCapacity:0];
            if (i == 0) {
                titleArr = @[@"询盘中",@"待确认报价",@"即将过期"];
                imageArr = @[@"message_light",@"needOffer_light",@"willOutDate_light"];
                for (NSInteger j = 0; j < titleArr.count; j++) {
                    MineCellModel *model = [[MineCellModel alloc] init];
                    model.iconTitle = titleArr[j];
                    model.imageName = imageArr[j];
                    [mArr addObject:model];
                }
            } else {
                titleArr = @[@"试样中"];
                imageArr = @[@"mine_zhujidiy_try"];
                for (NSInteger j = 0; j < titleArr.count; j++) {
                    MineCellModel *model = [[MineCellModel alloc] init];
                    model.iconTitle = titleArr[j];
                    model.imageName = imageArr[j];
                    [mArr addObject:model];
                }
            }
            [_dataSource_buyer addObject:mArr];
        }
    }
    return _dataSource_buyer;
}

- (NSMutableArray *)dataSource_seller {
    if (!_dataSource_seller) {
        NSArray *titleArr = [NSArray array];
        NSArray *imageArr = [NSArray array];
        _dataSource_seller = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < 2; i++) {
            NSMutableArray<MineCellModel *> *mArr = [NSMutableArray arrayWithCapacity:0];
            if (i == 0) {
                titleArr = @[@"买家已接受"];
                imageArr = @[@"buyer_accept"];
                for (NSInteger j = 0; j < titleArr.count; j++) {
                    MineCellModel *model = [[MineCellModel alloc] init];
                    model.iconTitle = titleArr[j];
                    model.imageName = imageArr[j];
                    [mArr addObject:model];
                }
            } else {
                titleArr = @[@"买家已接受"];
                imageArr = @[@"buyer_accept"];
                for (NSInteger j = 0; j < titleArr.count; j++) {
                    MineCellModel *model = [[MineCellModel alloc] init];
                    model.iconTitle = titleArr[j];
                    model.imageName = imageArr[j];
                    [mArr addObject:model];
                }
            }
            [_dataSource_seller addObject:mArr];
        }
    }
    return _dataSource_seller;
}

//buyer_accept
- (void)test {
    NSDictionary *dict = @{@"token":GET_USER_TOKEN,
                           @"workType":@"auciton",
                           @"body":@"七彩云电商-分散黄200%支付",
//                           @"from":@"app_ios"
                           };
    NSMutableDictionary *mDict = [dict mutableCopy];
   
    DDWeakSelf;
    [CddHUD showWithText:@"支付中..." view:self.view];
    [ClassTool postRequest:URL_WXPay_Auction Params:mDict Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        //        NSLog(@"-----ppp %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            //用户信息存入字典
//            NSLog(@"data---  %@",json[@"data"]);
//            NSLog(@"prepayid----- %@",[json[@"data"] objectForKey:@"prepayid"]);
            PayReq *req = [[PayReq alloc] init];
            req.partnerId = @"1532313091";
            req.prepayId = [json[@"data"] objectForKey:@"prepayid"];
            req.nonceStr = [json[@"data"] objectForKey:@"noncestr"];
            req.timeStamp = [[json[@"data"] objectForKey:@"timestamp"] intValue];
            req.package = @"Sign=WXPay";
            req.sign = [json[@"data"] objectForKey:@"sign"];
//
            if ([WXApi sendReq:req]) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suc) name:@"weixinPayResultSuccess" object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fail) name:@"weixinPayResultFailed" object:nil];
            }
        }
        
    } Failure:^(NSError *error) {
        
    }];
}


- (void)suc {
    NSLog(@"成功");
}

- (void)fail {
    NSLog(@"失败");
}

- (void)setupNav {
    [self addRightBarButtonItemWithTitle:@"设置" titleColor:UIColor.whiteColor action:@selector(jumpToSeting)];
    [self vhl_setNavBarTitleColor:UIColor.whiteColor];
    [self vhl_setNavBarBackgroundAlpha:0.0];
    [self vhl_setNavBarBackgroundColor:UIColor.clearColor];
    [self vhl_setNavBarShadowImageHidden:YES];
}

- (void)jumpToSeting {
    SettingVC *vc = [[SettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//注册通知
-(void)registerNoti {
    NSString *notiName = @"refreshAllDataWithThis";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:notiName object:nil];
    
    //修改头像监听
    NSString *notiName1 = @"changeHeader";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeader:) name:notiName1 object:nil];
    
    //修改密码后重新登录
    NSString *notiName2 = @"notifiReLogin";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLogin) name:notiName2 object:@"login"];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = HEXColor(@"#EDEDED", 1);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } 
        [_collectionView addSubview:self.headerView];
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
- (MineHeaderView *)headerView {
    if (!_headerView) {
        CGFloat headerHeight = NAV_HEIGHT + 106 + 35;
        _headerView = [[MineHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, -headerHeight, SCREEN_WIDTH, headerHeight);
        [_headerView.buyerBtn addTarget:self action:@selector(switchIdentity:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.sellerBtn addTarget:self action:@selector(switchIdentity:) forControlEvents:UIControlEventTouchUpInside];
        [HelperTool addTapGesture:_headerView.userHeader withTarget:self andSEL:@selector(jumpToMyInfo)];
        self.selectedBtn = _headerView.buyerBtn;
    }
    
    return _headerView;
}

//判断选择的按钮
- (void)btnClickSelected:(UIButton *)sender {
    //如果按下的按钮是之前已经按下的
    if (sender == self.selectedBtn ) {
        sender.selected = YES;
    } else {
        sender.selected = !sender.selected;
        self.selectedBtn.selected = NO;
    }
    self.selectedBtn = sender;
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
                NSMutableArray *mArr = weakself.dataSource_buyer[0];
                NSArray *array = @[model.isEnquiryCount,model.waitSureCount,model.myExpireCount];
                for (NSInteger i = 0; i < mArr.count; i++) {
                    MineCellModel *m = mArr[i];
                    m.iconNum = array[i];
                }
            }
            if (isRightData(model.zhujiDiyingCount)) {
                NSMutableArray *mArr_1 = weakself.dataSource_buyer[1];
                NSArray *array = @[model.zhujiDiyingCount];
                for (NSInteger i = 0; i < mArr_1.count; i++) {
                    MineCellModel *m = mArr_1[i];
                    m.iconNum = array[i];
                }
            }
            
            //卖家的数组
            if isRightData(model.myAcceptOfferCount) {
                NSMutableArray *mArr = weakself.dataSource_seller[0];
                NSArray *array = @[model.myAcceptOfferCount];
                for (NSInteger i = 0; i < mArr.count; i++) {
                    MineCellModel *m = mArr[i];
                    m.iconNum = array[i];
                }
            }
            if (isRightData(model.zhujiDiyingCount)) {
                NSMutableArray *mArr_1 = weakself.dataSource_seller[1];
                NSArray *array = @[model.zhujiSolutionAcceptCount];
                for (NSInteger i = 0; i < mArr_1.count; i++) {
                    MineCellModel *m = mArr_1[i];
                    m.iconNum = array[i];
                }
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
    //买家
    if (_switchID == 0) {
        cell.model = self.dataSource_buyer[indexPath.section][indexPath.row];
    }
    //卖家
    else {
        cell.model = self.dataSource_seller[indexPath.section][indexPath.row];
    }
    
    return cell;
}


/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
/** 每组几个cell*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_switchID == 0) {
        if (section == 0) {
            return 3;
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_switchID == 0) {
        if (indexPath.section == 0) {
            return CGSizeMake(SCREEN_WIDTH / 3, 60);
        } else {
            return CGSizeMake(SCREEN_WIDTH, 60);
        }
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
    } else if (indexPath.section == 1) {
        if (_switchID == 0) {
            MyZhuJiDiyListVC *vc = [[MyZhuJiDiyListVC alloc] init];
            vc.selectedIndex = 1;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            MyZhuJiDiySolveListVC *vc = [[MyZhuJiDiySolveListVC alloc] init];
            vc.selectedIndex = 2;
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
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *reusableView = nil;
    //header
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSArray *imageArr_buyer = @[@"my_ask_buy",@"section_ZhujiDiy"];
        NSArray *imageArr_seller = @[@"ask_buy_price_icon",@"section_ZhujiDiy"];
        NSArray *titleArr_buyer = @[@"我的求购",@"助剂定制"];
        NSArray *titleArr_seller = @[@"我的报价",@"助剂定制方案"];
        
        MineHeaderReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        [header.rightBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [header.rightBtn setImage:[UIImage imageNamed:@"btn_right"] forState:UIControlStateNormal];
        DDWeakSelf;
        //买家中心
        if (_switchID == 0) {
            header.leftImageView.image = [UIImage imageNamed:imageArr_buyer[indexPath.section]];
            header.leftLabel.text = titleArr_buyer[indexPath.section];
            if (indexPath.section == 0) {
                //我的求购
                header.rightBtnClickBlock = ^{
                    [weakself jumpToAskAll];
                };
            } else if (indexPath.section == 1) {
                header.rightBtnClickBlock = ^{
                    MyZhuJiDiyListVC *vc = [[MyZhuJiDiyListVC alloc] init];
                    vc.selectedIndex = 0;
                    [weakself.navigationController pushViewController:vc animated:YES];
                };
            }
        }
        //卖家中心
        else {
            header.leftImageView.image = [UIImage imageNamed:imageArr_seller[indexPath.section]];
            header.leftLabel.text = titleArr_seller[indexPath.section];
            if (indexPath.section == 0) {
                //我的报价
                header.rightBtnClickBlock = ^{
                    [weakself jumpToOfferAll];
                };
            } else if (indexPath.section == 1) {
                header.rightBtnClickBlock = ^{
                    MyZhuJiDiySolveListVC *vc = [[MyZhuJiDiySolveListVC alloc] init];
                    vc.selectedIndex = 0;
                    [weakself.navigationController pushViewController:vc animated:YES];
                };
            }
        }
        
        return header;
    }

    return nil;
}


- (void)jumpTo {
    MyAskToBuyVC *vc = [[MyAskToBuyVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)switchIdentity:(UIButton *)sender {
    if (sender.tag == 100) {    //买家
        _switchID = 0;
    } else {    //卖家
        _switchID = 1;
    }
    [self getNumber];
    [self.collectionView reloadData];
    [self btnClickSelected:sender];
}

//获取全部求购列表
- (void)jumpToAskAll {
    MyAskToBuyVC *vc = [[MyAskToBuyVC alloc] init];
    vc.selectedIndex = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

//获取全部报价列表
- (void)jumpToOfferAll {
    MyOfferPriceVC *vc = [[MyOfferPriceVC alloc] init];
    vc.selectedIndex = 0;
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)jumpToMyInfo {
    MyInfoCenterVC *vc = [[MyInfoCenterVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//改变整个页面的数据显示
- (void)refreshData {
    [self getNumber];
    //头像
    if (Get_Header) {
        NSURL *headerUrl = Get_Header;
        [_headerView.userHeader sd_setImageWithURL:headerUrl placeholderImage:nil];
    } else {
        _headerView.userHeader.image = DefaultImage;
    }
    
    //名字和用户类型
    NSString *name = [[UserDefault objectForKey:@"userInfo"] objectForKey:@"userName"];
    NSString *userType = [NSString string];
    if (isCompanyUser) {
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
