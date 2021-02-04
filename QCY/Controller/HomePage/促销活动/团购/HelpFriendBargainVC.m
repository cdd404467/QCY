//
//  HelpFriendBargainVC.m
//  QCY
//
//  Created by i7colors on 2019/7/24.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HelpFriendBargainVC.h"
#import "BargainHeaderView.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "GroupBuyingModel.h"
#import "CddHUD.h"
#import <WXApi.h>
#import "BargainAlertView.h"
#import "HelperTool.h"
#import "GroupBuyingDetailVC.h"

@interface HelpFriendBargainVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) BargainHeaderView *bargainView;
@property (nonatomic, strong) GroupBuyingModel *dataSource;
@property (nonatomic, strong) UIButton *bargainBtn;
@end

@implementation HelpFriendBargainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友帮砍价";
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.bargainBtn];
    [self requestData:YES];
}

- (UIButton *)bargainBtn {
    if (!_bargainBtn) {
        _bargainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bargainBtn.frame = CGRectMake(0, SCREEN_HEIGHT - 49 - Bottom_Height_Dif, SCREEN_WIDTH, 49);
        [_bargainBtn setTitle:@"我也要参与" forState:UIControlStateNormal];
        [_bargainBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _bargainBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_bargainBtn addTarget:self action:@selector(iWantToJoin) forControlEvents:UIControlEventTouchUpInside];
        [ClassTool addLayer:_bargainBtn];
    }
    
    return _bargainBtn;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        //是否可以滚动
        _scrollView.scrollEnabled = YES;
        //禁止水平滚动
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 500);
        //允许垂直滚动
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = Like_Color;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (BargainHeaderView *)bargainView {
    if (!_bargainView) {
        _bargainView = [[BargainHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 490)];
        _bargainView.backgroundColor = Like_Color;
        if([WXApi isWXAppInstalled]) {//判断用户是否已安装微信App
            [self addRightBarButtonItemWithTitle:@"分享" action:@selector(share)];
        }
    }
    
    return _bargainView;
}

//我也要参与，跳团购详情
- (void)iWantToJoin {
    GroupBuyingDetailVC *vc = [[GroupBuyingDetailVC alloc] init];
    vc.groupID = _dataSource.groupID;
    vc.productName = _dataSource.productName;
    [self.navigationController pushViewController:vc animated:YES];
}

//分享
- (void)share {
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    [imageArray addObject:ImgStr(_dataSource.productPic)];
    NSString *shareStr = [NSString stringWithFormat:@"http://%@.i7colors.com/groupBuyMobile/openApp/cut.html?mainId=%@&buyerId=%@",ShareString,_groupID,_barganID];
    
    NSString *text = [NSString stringWithFormat:@"亲们帮帮忙,我正在参与七彩云电商\"%@\"砍价活动",_dataSource.productName];
    [ClassTool shareSomething:imageArray urlStr:shareStr title:@"【团购砍价】" text:text];
}

//获取砍价数据
- (void)requestData:(BOOL)isHUD {
    if (_bargainView) {
        _bargainView.shareBtn.enabled = NO;
    }
    
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URL_Groupbuy_BarganInfo,User_Token,_groupID,_barganID];
    if (isHUD) {
        [CddHUD show:self.view];
    }
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//                                NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [CddHUD hideHUD:weakself.view];
            weakself.dataSource = [GroupBuyingModel mj_objectWithKeyValues:json[@"data"]];
            [weakself setBtnState];
            [weakself.scrollView addSubview:weakself.bargainView];
            weakself.bargainView.model = weakself.dataSource;
            weakself.bargainView.shareBtn.enabled = YES;
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (void)loginNow {
    if (!GET_USER_TOKEN) {
        DDWeakSelf;
        [weakself jumpToLoginWithComplete:^{
            [weakself requestData:YES];
        }];
    }
}

- (void)setBtnState {
    [self.bargainView.shareBtn removeTarget:nil
                                         action:NULL
                               forControlEvents:UIControlEventAllEvents];
    NSString *title = [NSString string];
    
    //团购还没结束，进行正常操作
    if ([_dataSource.endCode isEqualToString:@"10"]) {
        self.bargainBtn.hidden = NO;
        self.scrollView.height = SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT;
        
        if (!GET_USER_TOKEN) {
            title = @"点我登录,帮好友砍价";
            [_bargainView.shareBtn addTarget:self action:@selector(loginNow) forControlEvents:UIControlEventTouchUpInside];
            
        } else {
            //已经帮好友砍价
            if ([_dataSource.loginUserHasCut integerValue] == 1) {
                title = @"已砍价,帮好友分享";
                [_bargainView.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
            }
            //没帮好友砍价
            else {
                //已经砍完,不能再砍价了
                if ([_dataSource.remainCutPrice doubleValue] == 0.00) {
                    title = @"已砍完,帮好友分享";
                    [_bargainView.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
                }
                //没砍完,还能再砍价
                else {
                    title = @"点击帮好友砍价";
                    [_bargainView.shareBtn addTarget:self action:@selector(helpToBargain) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
    //团购已经结束，直接显示分享
    else {
        title = @"团购已结束,点击分享";
        [_bargainView.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        self.bargainBtn.hidden = YES;
        self.scrollView.height = SCREEN_HEIGHT - NAV_HEIGHT;
    }
    
    
    [_bargainView.shareBtn setTitle:title forState:UIControlStateNormal];
}
//To_String(json[@"data"])
//点击提交
- (void)helpToBargain {
    _bargainView.shareBtn.enabled = NO;
    NSDictionary *dict = @{@"token":User_Token,
                           @"mainId":_groupID,
                           @"buyerId":_barganID,
                           @"from":@"app_ios"
                           };
    DDWeakSelf;
    [CddHUD showWithText:@"参与中..." view:self.view];
    [ClassTool postRequest:URL_Help_Bargain Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                        NSLog(@"----- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [weakself requestData:NO];
            [CddHUD hideHUD:weakself.view];
            weakself.bargainView.shareBtn.enabled = YES;
            BargainAlertView *alert = [[BargainAlertView alloc] initWithPrice:To_String(json[@"data"]) unit:self.dataSource.priceUnit];
            [[[UIApplication sharedApplication] keyWindow] addSubview:alert];
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

@end
