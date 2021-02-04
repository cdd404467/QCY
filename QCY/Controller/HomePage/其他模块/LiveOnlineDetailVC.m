//
//  LiveOnlineDetailVC.m
//  QCY
//
//  Created by i7colors on 2020/4/1.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "LiveOnlineDetailVC.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import "LiveOnlineModel.h"
#import <UIImageView+WebCache.h>
#import "CountDown.h"
#import "HelperTool.h"
#import "WebViewVC.h"
#import "CddHUD.h"
#import "WXApiManager.h"
#import "AlertInputView.h"
#import "PlayVideoVC.h"
#import "WXApiManager.h"



@interface LiveOnlineDetailVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LiveOnlineModel *dataSource;
@property (nonatomic, strong) UILabel *countDay;
@property (nonatomic, strong) UILabel *countHour;
@property (nonatomic, strong) UILabel *countMinute;
@property (nonatomic, strong) UILabel *countSecond;
@property (nonatomic, strong) CountDown *countDownTimer;
@property (nonatomic, strong) UIButton *watchBtn;
@property (nonatomic, strong) UIButton *yuYueBtn;
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, strong) AlertInputView *alertView;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, assign) BOOL isCheck;
@end

@implementation LiveOnlineDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"七彩云公开课";
    self.orderNum = @"0";
    self.phoneNumber = @"0";
    _isCheck = NO;
    [self requestData];
    [self getDefaultInfo];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkPayState) name:NotificationName_ApplicationDidBecomeActive object:nil];
}

//懒加载scrollview
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
        //150 + 680 + 6
//        sv.contentSize = CGSizeMake(SCREEN_WIDTH, 600);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.backgroundColor = HEXColor(@"#000000", 0.08);
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

- (void)requestData {
//    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URLGet_Course_Detail,User_Token,_courseID];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
                        NSLog(@"ggg---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            self.dataSource = [LiveOnlineModel mj_objectWithKeyValues:json[@"data"]];
            if (self.isFirstLoadData == YES) {
                [self setupUI];
            } else {
                [self changeBtnState];
            }
            self.isFirstLoadData = NO;
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (void)gointoLive {
    if (!GET_USER_TOKEN) {
        DDWeakSelf;
        [self jumpToLoginWithComplete:^{
            [weakself requestData];
        }];
        return;
    }
    
    if (_dataSource.isEnd.integerValue == 0) {
        //结束并且有回看视频
        if (isRightData(_dataSource.videoId) && isRightData(_dataSource.articleId)) {
            PlayVideoVC *vc = [[PlayVideoVC alloc] init];
            vc.dataSource = _dataSource;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //结束了没有回看视频
        else {
            [CddHUD showTextOnlyDelay:@"敬请期待" view:self.view];
            return;
        }
    }
    else {
        NSString *url = [NSString stringWithFormat:@"https://%@.i7colors.com/groupBuyMobile/courseLive/index.html?isLogin=1&token=%@&channelId=%@&id=%@&from=%@",ShareString,User_Token,_channelId,_courseID,@"app"];
        WebViewVC *vc = [[WebViewVC alloc] init];
        vc.webUrl = url;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)payMoney {
    if (!GET_USER_TOKEN) {
        DDWeakSelf;
        [self jumpToLoginWithComplete:^{
            [weakself requestData];
        }];
        return;
    }
    //判断用户是否已安装微信App
    if(![WXApi isWXAppInstalled]){
        [CddHUD showTextOnlyDelay:@"未安装微信" view:self.view];
        return;
    }
    
    
    NSDictionary *dict = [NSDictionary dictionary];
    //回看视频
    if (_dataSource.isEnd.integerValue == 0) {
        if (isNotRightData(_dataSource.articleId)) return;
        if (isNotRightData(_dataSource.videoId)) return;
        dict = @{@"token":User_Token,
                @"articleId":_dataSource.articleId,
                @"videoId":_dataSource.videoId,
                @"type":@"system_file",
                @"productType":@"video",
                @"tradeType":@"APP",
                @"price":_dataSource.price,
                };
    }
    //未结束的视频
    else {
        dict = @{@"token":User_Token,
               @"classId":_courseID,
               @"type":@"school_live",
               @"productType":@"school_live_class",
               @"price":_dataSource.price,
               @"tradeType":@"APP"
               };
    }

    NSMutableDictionary *mDict = [dict mutableCopy];
   
    DDWeakSelf;
    [CddHUD showWithText:@"支付中..." view:self.view];
    [ClassTool postRequest:URLPost_Weixin_Pay Params:mDict Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                NSLog(@"-----kkk %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            //用户信息存入字典
            PayReq *req = [[PayReq alloc] init];
            req.partnerId = [json[@"data"] objectForKey:@"partnerid"];
            req.prepayId = [json[@"data"] objectForKey:@"prepayid"];
            req.nonceStr = [json[@"data"] objectForKey:@"noncestr"];
            req.timeStamp = [[json[@"data"] objectForKey:@"timestamp"] intValue];
            req.package = [json[@"data"] objectForKey:@"package"];
            req.sign = [json[@"data"] objectForKey:@"sign"];
            self.orderNum = [json[@"data"] objectForKey:@"orderNum"];
            if ([WXApi sendReq:req]) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pay_success) name:@"weixinPayResultSuccess" object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pay_fail) name:@"weixinPayResultFailed" object:nil];
            }
        }
        
    } Failure:^(NSError *error) {
        
    }];
}

- (void)pay_success {
    [self checkPayState];
}

- (void)pay_fail {
    NSLog(@"支付取消了哦");
}


//检测有无支付成功
- (void)checkPayState {
    if (!GET_USER_TOKEN) return;
    
    if (_orderNum.integerValue == 0 ) return;
    
    if (_isCheck) return;
    
    NSDictionary *dict = @{@"token":User_Token,
            @"classId":_courseID,
            @"type":@"school_live",
            @"productType":@"school_live_class",
            @"orderNum":_orderNum
            };
    [ClassTool postRequest:URLPost_CheckPay_State Params:[dict mutableCopy] Success:^(id json) {
//                NSLog(@"-----ppp %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            self.dataSource.loginUserIsBuy = @"1";
            self.isCheck = YES;
            [self changeBtnState];
        }
        
    } Failure:^(NSError *error) {
        
    }];
}


//预约课程
- (void)alertRemindView {
    _alertView = [[AlertInputView alloc] init];
    if (_phoneNumber.integerValue != 0) {
        _alertView.phoneNumberTF.text = _phoneNumber;
    }
    [_alertView.leftBtn addTarget:self action:@selector(orderRemind) forControlEvents:UIControlEventTouchUpInside];
    [_alertView show];
}

//自动填充
- (void)getDefaultInfo {
    NSString *urlString = [NSString stringWithFormat:URL_Default_Address,User_Token];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
//        NSLog(@"--- %@",json[@"data"]);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"] && isRightData(To_String(json[@"data"]))) {
            if isRightData(json[@"data"][@"phone"])
                self.phoneNumber = json[@"data"][@"phone"];
        } else {
            
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}


- (void)orderRemind {
    if (_alertView.phoneNumberTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入手机号码" view:self.alertView];
        return;
    } else if (_alertView.phoneNumberTF.text.length < 11) {
        [CddHUD showTextOnlyDelay:@"请输入正确的手机号码" view:self.alertView];
        return;
    }
    NSDictionary *dict = @{@"token":User_Token,
                            @"phone":_alertView.phoneNumberTF.text,
                            @"classId":_courseID,
                            };
    [CddHUD show:self.alertView];
    [ClassTool postRequest:URLPost_Order_Remind Params:[dict mutableCopy] Success:^(id json) {
//                NSLog(@"-----ppp %@",json);
        [CddHUD hideHUD:self.alertView];
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [self.alertView remove];
            [CddHUD showTextOnlyDelay:@"预约成功" view:UIApplication.sharedApplication.keyWindow];
            self.dataSource.loginUserIsReserve = @"1";
            [self changeBtnState];
        }
    } Failure:^(NSError *error) {
        
    }];
}

//取消预约
- (void)cancelRemind {
    NSDictionary *dict = @{@"token":User_Token,
                            @"classId":_courseID,
                            };
    [CddHUD show:self.view];
    [ClassTool postRequest:URLPost_Remind_Cancel Params:[dict mutableCopy] Success:^(id json) {
//                NSLog(@"-----ppp %@",json);
        [CddHUD hideHUD:self.view];
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [CddHUD showTextOnlyDelay:@"取消成功" view:self.view];
            self.dataSource.loginUserIsReserve = @"0";
            [self changeBtnState];
        }
    } Failure:^(NSError *error) {
        
    }];
}


- (void)setupUI {
    [self.view addSubview:self.scrollView];
    UIImageView *bannerImg = [[UIImageView alloc] init];
    bannerImg.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(247));
    [bannerImg sd_setImageWithURL:ImgUrl(_dataSource.banner) placeholderImage:PlaceHolderImgBanner];
    [self.scrollView addSubview:bannerImg];
    
    UIImageView *stateImg = [[UIImageView alloc] init];
    [bannerImg addSubview:stateImg];
    [stateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(76);
        make.height.mas_equalTo(40);
    }];
    if (_dataSource.isEnd.integerValue == 0) {
        stateImg.image = [UIImage imageNamed:@"liveOnline_3"];
    } else if (_dataSource.isEnd.integerValue == 1) {
        stateImg.image = [UIImage imageNamed:@"liveOnline_2"];
    } else if (_dataSource.isEnd.integerValue ==2) {
        stateImg.image = [UIImage imageNamed:@"liveOnline_1"];
    }
    
    UIView *topBg = [[UIView alloc] init];
    topBg.backgroundColor = UIColor.whiteColor;
    topBg.frame = CGRectMake(0, bannerImg.bottom, SCREEN_WIDTH, 50);
    [self.scrollView addSubview:topBg];
    
    CGFloat height = 0.f;
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = _dataSource.title;
    nameLab.textColor = UIColor.blackColor;
    nameLab.font = [UIFont boldSystemFontOfSize:20];
    [topBg addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(15);
    }];
    
    [nameLab.superview layoutIfNeeded];
    height = nameLab.bottom + 11;
    
    UILabel *lookBackLab = [[UILabel alloc] init];
    lookBackLab.textAlignment = NSTextAlignmentCenter;
    lookBackLab.layer.cornerRadius = 10;
    lookBackLab.layer.borderWidth = 1.f;
        
    if (_dataSource.isEnd.integerValue == 0) {
        lookBackLab.text = @"回看课程";
        lookBackLab.textColor = HEXColor(@"#3BB142", 1);
    } else if (_dataSource.isEnd.integerValue == 1) {
        lookBackLab.text = @"正在直播中";
        lookBackLab.textColor = HEXColor(@"#F10215", 1);
    } else if (_dataSource.isEnd.integerValue == 2) {
        lookBackLab.text = [NSString stringWithFormat:@"直播开始时间:%@",_dataSource.startTime];
        lookBackLab.textColor = HEXColor(@"#868686", 1);
        
        //剩余时间
        UIView *leftTimeView = [[UIView alloc] init];
        leftTimeView.frame = CGRectMake(0, height, SCREEN_WIDTH, 34);
        [topBg addSubview:leftTimeView];
        height = leftTimeView.bottom + 12;
        
        UILabel *leftText = [[UILabel alloc] init];
        leftText.font = [UIFont systemFontOfSize:12];
        leftText.text = @"剩余时间:";
        leftText.textColor = HEXColor(@"#333333", 1);
        [leftTimeView addSubview:leftText];
        [leftText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(leftTimeView);
        }];
        
        //从秒开始
        CGFloat width = KFit_W(24);
        CGFloat gap = KFit_W(35);
        for (NSInteger i = 0; i < 4; i ++) {
            //倒计时背景
            UIImageView *timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_bg"]];
            [leftTimeView addSubview:timeImageView];
            [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(width);
                make.left.mas_equalTo(leftText.mas_right).offset(width * i + gap * (i + 1));
                make.centerY.mas_equalTo(leftTimeView);
            }];
            //倒计时label
            UILabel *timeLabel = [[UILabel alloc] init];
            timeLabel.font = [UIFont systemFontOfSize:12];
            timeLabel.textColor = [UIColor whiteColor];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            [timeImageView addSubview:timeLabel];
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];

            //时间单位
            UILabel *timeUnit = [[UILabel alloc] init];
            timeUnit.font = [UIFont systemFontOfSize:12];
            timeUnit.textColor = HEXColor(@"#333333", 1);
            timeUnit.textAlignment = NSTextAlignmentCenter;
            [leftTimeView addSubview:timeUnit];
            [timeUnit mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(timeImageView.mas_right).offset(0);
                make.width.mas_equalTo(gap);
                make.centerY.mas_equalTo(timeImageView);
            }];

            //判断添加
            if (i == 0) {
                _countDay = timeLabel;
                timeUnit.text = @"天";
            } else if (i == 1) {
                _countHour = timeLabel;
                timeUnit.text = @"小时";
            } else if (i == 2) {
                _countMinute = timeLabel;
                timeUnit.text = @"分";
            } else {
                _countSecond = timeLabel;
                timeUnit.text = @"秒";
            }
        }
        //倒计时
        NSDate *datenow = [NSDate date];
        long long nowStamp = (long)[datenow timeIntervalSince1970] * 1000;
        [self countDownWithBegin:nowStamp endTime:_dataSource.startTimeStamp];
    }
    
    lookBackLab.layer.borderColor = lookBackLab.textColor.CGColor;
    lookBackLab.font = [UIFont systemFontOfSize:12];
    [topBg addSubview:lookBackLab];
    CGSize labSize = [lookBackLab sizeThatFits:CGSizeMake(SCREEN_WIDTH, 20)];
    lookBackLab.frame = CGRectMake(10, height, labSize.width + 30, 20);
    height = lookBackLab.bottom + 12;
    
    UILabel *teacherLab = [[UILabel alloc] init];
    teacherLab.frame = CGRectMake(10, height, SCREEN_WIDTH - 20, 15);
    teacherLab.text = [NSString stringWithFormat:@"讲师: %@",_dataSource.teacher];
    teacherLab.textColor = HEXColor(@"#868686", 1);
    teacherLab.font = [UIFont systemFontOfSize:15];
    [topBg addSubview:teacherLab];
    height = teacherLab.bottom + 21;
    topBg.height = height;
    
    //详情介绍
    UILabel *detailTitle = [[UILabel alloc] init];
    detailTitle.backgroundColor = UIColor.whiteColor;
    detailTitle.frame = CGRectMake(10, topBg.bottom + 6, SCREEN_WIDTH - 20, 40);
    detailTitle.text = @"详情介绍";
    detailTitle.textAlignment = NSTextAlignmentCenter;
    detailTitle.font = [UIFont systemFontOfSize:16];
    [self.scrollView addSubview:detailTitle];
    [HelperTool setRound:detailTitle corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:5];
    
    UIView *bottomBg = [[UIView alloc] init];
    bottomBg.frame = CGRectMake(10, detailTitle.bottom, SCREEN_WIDTH - 20, 50);
    bottomBg.backgroundColor = HEXColor(@"#f6f6f6", 1);
    [self.scrollView addSubview:bottomBg];
    
    
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.textColor = HEXColor(@"#3C3C3C", 1);
    detailLab.font = [UIFont systemFontOfSize:12];
    detailLab.numberOfLines = 0;
    detailLab.text = _dataSource.descriptionStr;
    [bottomBg addSubview:detailLab];
    CGFloat maxWidth = SCREEN_WIDTH - 46;
    CGSize size = [detailLab sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    detailLab.frame = CGRectMake(13, 16, maxWidth, size.height);
    
    bottomBg.height = detailLab.bottom + 30;
    bottomBg.layer.shadowColor = RGBA(0, 0, 0, 0.1).CGColor;
    bottomBg.layer.shadowOffset = CGSizeMake(0, 0);
    bottomBg.layer.shadowOpacity = 1.0f;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, bottomBg.bottom + 10);
    
    //底部按钮
    UIButton *yuYueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yuYueBtn.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT, SCREEN_WIDTH, 49);
    yuYueBtn.backgroundColor = HEXColor(@"#FF771C", 1);
    [yuYueBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    yuYueBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:yuYueBtn];
    _yuYueBtn = yuYueBtn;
    
    UIButton *watchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    watchBtn.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT, SCREEN_WIDTH, 49);
    watchBtn.backgroundColor = HEXColor(@"#ED3851", 1);
    [watchBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    watchBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:watchBtn];
    _watchBtn = watchBtn;
    
    if (isSimuLator) {
        _yuYueBtn.hidden = YES;
        _watchBtn.hidden = YES;
    }
    
    [self changeBtnState];
}

//按钮状态
- (void)changeBtnState {
    NSString *btnTitle = [NSString string];
    if (_dataSource.isEnd.integerValue == 0) {
        _yuYueBtn.hidden = YES;
        btnTitle = @"观看回放";
    } else if (_dataSource.isEnd.integerValue == 1) {
        _yuYueBtn.hidden = YES;
        btnTitle = @"观看直播";
    } else if (_dataSource.isEnd.integerValue == 2) {
        _yuYueBtn.width = SCREEN_WIDTH / 2;
        _watchBtn.left = _yuYueBtn.right;
        _watchBtn.width = _yuYueBtn.width;
        btnTitle = @"观看直播";
    }
    [_watchBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [_yuYueBtn removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    //预约按钮
    if (_dataSource.loginUserIsReserve.integerValue == 0) {
        [_yuYueBtn setTitle:@"预约提醒" forState:UIControlStateNormal];
        [_yuYueBtn addTarget:self action:@selector(alertRemindView) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_yuYueBtn setTitle:@"取消预约" forState:UIControlStateNormal];
        [_yuYueBtn addTarget:self action:@selector(cancelRemind) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //需要购买观看
    if (_dataSource.price.floatValue > 0) {
        //未购买
        if (_dataSource.loginUserIsBuy.integerValue == 0) {
            //已结束
            if (_dataSource.isEnd.integerValue == 0) {
                //并且可以观看
                if (isRightData(_dataSource.videoId) && isRightData(_dataSource.articleId)) {
                    btnTitle = [NSString stringWithFormat:@"¥%@ 支付观看",_dataSource.price];
                }
                //结束了视频还没弄好
                else {
                    btnTitle = @"观看回放";
                }
                [_watchBtn addTarget:self action:@selector(gointoLive) forControlEvents:UIControlEventTouchUpInside];
            }
            //没结束的
            else {
                btnTitle = [NSString stringWithFormat:@"¥%@ 支付观看",_dataSource.price];
            }
            [_watchBtn addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
        }
        //已购买
        else {
            [_watchBtn addTarget:self action:@selector(gointoLive) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    //不需要购买观看
    else {
        [_watchBtn addTarget:self action:@selector(gointoLive) forControlEvents:UIControlEventTouchUpInside];
    }
    [_watchBtn setTitle:btnTitle forState:UIControlStateNormal];
}


//倒计时
- (void)countDownWithBegin:(long long)beginTime endTime:(long long)endTime {
    DDWeakSelf;
    _countDownTimer = [[CountDown alloc]init];
    long long startTime = beginTime;
    long long finishTime = endTime;
    [_countDownTimer countDownWithStratTimeStamp:startTime finishTimeStamp:finishTime completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        [weakself refreshTimeWithDay:day hour:hour min:minute sec:second];
    }];
}

- (void)refreshTimeWithDay:(NSInteger)day hour:(NSInteger)hour min:(NSInteger)min sec:(NSInteger)sec {
    NSString *dayStr = [NSString string];
    NSString *hourStr = [NSString string];
    NSString *minStr = [NSString string];
    NSString *secStr = [NSString string];
    
    if (day < 10) {
        dayStr = [NSString stringWithFormat:@"0%ld",(long)day];
    }else {
        dayStr = [NSString stringWithFormat:@"%ld",(long)day];
    }
    if (hour < 10) {
        hourStr = [NSString stringWithFormat:@"0%ld",(long)hour];
    }else {
        hourStr = [NSString stringWithFormat:@"%ld",(long)hour];
    }
    if (min < 10) {
        minStr = [NSString stringWithFormat:@"0%ld",(long)min];
    }else {
        minStr = [NSString stringWithFormat:@"%ld",(long)min];
    }
    if (sec < 10) {
        secStr = [NSString stringWithFormat:@"0%ld",(long)sec];
    }else {
        secStr = [NSString stringWithFormat:@"%ld",(long)sec];
    }
    
    _countDay.text = dayStr;
    _countHour.text = hourStr;
    _countMinute.text = minStr;
    _countSecond.text = secStr;
}


@end
