//
//  BargainHeaderView.m
//  QCY
//
//  Created by i7colors on 2019/7/24.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BargainHeaderView.h"
#import "GroupBuyingModel.h"
#import <YYText.h>
#import "CountDown.h"
#import "MyGroupBuyingTBCell.h"
#import "ClassTool.h"


@interface BargainHeaderView()
//产品的cell
@property (nonatomic, strong) MyGroupBuyingTBCell *cellView;
//库存
@property (nonatomic, strong) YYLabel *inventoryLab;
//倒计时背景View
@property (nonatomic, strong) UIView *timeView;
//天
@property (nonatomic, strong) UILabel *dayLab;
//时
@property (nonatomic, strong) UILabel *hourLab;
//分
@property (nonatomic, strong) UILabel *minLab;
//秒
@property (nonatomic, strong) UILabel *secLab;
//倒计时
@property (nonatomic, strong) CountDown *countDownTimer;
//进度条
@property (nonatomic, strong) UIProgressView *progressView;
//已经砍价
@property (nonatomic, strong) YYLabel *hasCutLab;
//还可以砍价
@property (nonatomic, strong) YYLabel *leftCanCutLab;

@end


@implementation BargainHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    self.cellView = [[MyGroupBuyingTBCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    [self addSubview:self.cellView];
    
    //平台库存模块
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(9, 140, SCREEN_WIDTH - 18, 335)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 5.f;
    [self addSubview:bgView];
    
    //库存Label
    YYLabel *inventoryLab = [[YYLabel alloc] init];
    inventoryLab.frame = CGRectMake(0, 15, bgView.width, 30);
    [bgView addSubview:inventoryLab];
    _inventoryLab = inventoryLab;
    
    UIView *timeView = [[UIView alloc] init];
    timeView.backgroundColor = UIColor.whiteColor;
    [bgView addSubview:timeView];
    _timeView = timeView;
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(inventoryLab.mas_bottom).offset(15);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-18);
    }];
    
    //分割线
    UIImageView *spImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"groupBuy_sp_line"]];
    [bgView addSubview:spImageView];
    [spImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(timeView);
        make.height.height.mas_equalTo(5);
    }];
    
    //已砍价
    YYLabel *hasCutLab = [[YYLabel alloc] init];
    [bgView addSubview:hasCutLab];
    _hasCutLab = hasCutLab;
    [hasCutLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(spImageView.mas_bottom).offset(36);
        make.right.mas_equalTo(spImageView.mas_centerX);
    }];
    
    //剩余可以砍价
    YYLabel *leftCanCutLab = [[YYLabel alloc] init];
    [bgView addSubview:leftCanCutLab];
    _leftCanCutLab = leftCanCutLab;
    [leftCanCutLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.height.top.mas_equalTo(hasCutLab);
        make.left.mas_equalTo(spImageView.mas_centerX);
    }];
    
    //进度条
    UIProgressView *progressView = [[UIProgressView alloc] init];
    progressView.trackTintColor = HEXColor(@"#DAE1E8", 1);
    progressView.layer.cornerRadius = 7.f;
    progressView.clipsToBounds = YES;
    progressView.tintColor = HEXColor(@"#ED3851", 1);
    [bgView addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(hasCutLab.mas_bottom).offset(15);
        make.height.mas_equalTo(14);
    }];
    _progressView = progressView;
    
    //分享给好友砍价按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    shareBtn.layer.cornerRadius = 49.f / 2;
    shareBtn.clipsToBounds = YES;
    [bgView addSubview:shareBtn];
    _shareBtn = shareBtn;
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(49);
        make.top.mas_equalTo(progressView.mas_bottom).offset(50);
    }];
    [shareBtn layoutIfNeeded];
    [ClassTool addLayer:shareBtn frame:CGRectMake(0, 0, shareBtn.width, shareBtn.height)];
    
    //距离结束
    UILabel *endTextLab = [[UILabel alloc] init];
    endTextLab.text = @"距离结束: ";
    endTextLab.textColor = HEXColor(@"#868686", 1);
    endTextLab.font = [UIFont systemFontOfSize:13];
    [timeView addSubview:endTextLab];
    [endTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KFit_W(72));
    }];
    
    //时间和时间单位
    CGFloat width = KFit_W(42);
    CGFloat gap = KFit_W(63);
    NSArray *unitArr = @[@"天",@"时",@"分",@"秒"];
    for (NSInteger i = 0; i < 4; i++) {
        @autoreleasepool {
            UILabel *timeLab = [[UILabel alloc] init];
            timeLab.textAlignment = NSTextAlignmentCenter;
            timeLab.font = [UIFont boldSystemFontOfSize:23];
            timeLab.textColor = HEXColor(@"#F50000", 1);
            [timeView addSubview:timeLab];
            [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(endTextLab.mas_right).offset((i * gap));
                make.top.bottom.mas_equalTo(endTextLab);;
                make.width.mas_equalTo(width);
            }];
            
            UILabel *timeUnitLab = [[UILabel alloc] init];
            timeUnitLab.textAlignment = NSTextAlignmentCenter;
            timeUnitLab.font = [UIFont systemFontOfSize:17];
            timeUnitLab.textColor = HEXColor(@"#202020", 1);
            [timeView addSubview:timeUnitLab];
            [timeUnitLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(timeLab.mas_right).offset(0);
                make.top.bottom.mas_equalTo(timeLab);
                make.width.mas_equalTo(20);
            }];
            timeUnitLab.text = unitArr[i];
            if (i == 0) {
                _dayLab = timeLab;
            } else if (i == 1) {
                _hourLab = timeLab;
            } else if (i == 2) {
                _minLab = timeLab;
            } else if (i == 3) {
                _secLab = timeLab;
            }
        }
    }
}

- (void)setModel:(GroupBuyingModel *)model {
    _model = model;
    self.cellView.style = @"nowPrice";
    self.cellView.model = model;
    
    //团购价
    NSString *dtext = @"平台库存量: ";
    NSString *text = [NSString stringWithFormat:@"%@%@ %@",dtext,model.remainNum,model.numUnit];
    NSMutableAttributedString *mCount = [[NSMutableAttributedString alloc] initWithString:text];
    mCount.yy_alignment = NSTextAlignmentCenter;
    mCount.yy_color = HEXColor(@"#333333", 1);
    mCount.yy_font = [UIFont systemFontOfSize:15];
    [mCount yy_setFont:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(dtext.length, model.remainNum.length)];
    _inventoryLab.attributedText = mCount;
    
    //倒计时
    if ([model.endCode isEqualToString:@"10"]) {
        NSDate *datenow = [NSDate date];
        long long nowStamp = (long)[datenow timeIntervalSince1970] * 1000;
        [self countDownWithBegin:nowStamp endTime:model.endTimeStamp];
    } else {
        _dayLab.text = @"00";
        _hourLab.text = @"00";
        _minLab.text = @"00";
        _secLab.text = @"00";
    }
    
    //已砍价
    NSString *hasCutText = [NSString stringWithFormat:@"已砍:%@元/%@",model.hasCutPrice,model.priceUnit];
    NSMutableAttributedString *mHasCutText = [[NSMutableAttributedString alloc] initWithString:hasCutText];
    mHasCutText.yy_color = HEXColor(@"#333333", 1);
    mHasCutText.yy_font = [UIFont systemFontOfSize:12];
    [mHasCutText yy_setFont:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(3, model.hasCutPrice.length)];
    [mHasCutText yy_setColor:HEXColor(@"#ED3851", 1) range:NSMakeRange(3, model.hasCutPrice.length)];
    _hasCutLab.attributedText = mHasCutText;
    
    //剩余砍价
    NSString *canCutText = [NSString stringWithFormat:@"还可以砍:%@元/%@",model.remainCutPrice,model.priceUnit];
    NSMutableAttributedString *mCanCutText = [[NSMutableAttributedString alloc] initWithString:canCutText];
    mCanCutText.yy_color = HEXColor(@"#333333", 1);
    mCanCutText.yy_alignment = NSTextAlignmentRight;
    mCanCutText.yy_font = [UIFont systemFontOfSize:12];
    [mCanCutText yy_setFont:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(5, model.remainCutPrice.length)];
    [mCanCutText yy_setColor:HEXColor(@"#ED3851", 1) range:NSMakeRange(5, model.remainCutPrice.length)];
    _leftCanCutLab.attributedText = mCanCutText;
    
    //进度条
    if (isRightData(model.numPercent)) {
        NSString *percentStr = [model.cutPricePercent substringToIndex:model.cutPricePercent.length - 1];
        CGFloat percent = [percentStr floatValue] / 100;
        _progressView.progress = percent;
    }
    
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
    
    _dayLab.text = dayStr;
    _hourLab.text = hourStr;
    _minLab.text = minStr;
    _secLab.text = secStr;
}
@end
