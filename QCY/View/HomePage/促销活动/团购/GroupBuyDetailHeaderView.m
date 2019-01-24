//
//  GroupBuyDetailHeaderView.m
//  QCY
//
//  Created by i7colors on 2018/11/2.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GroupBuyDetailHeaderView.h"
#import "MacroHeader.h"
#import "GroupBuyingModel.h"
#import <YYWebImage.h>
#import <YYText.h>
#import <Masonry.h>
#import "UIView+Border.h"
#import "CountDown.h"

@interface GroupBuyDetailHeaderView()

@property (nonatomic, strong)UILabel *countDay;
@property (nonatomic, strong)UILabel *countHour;
@property (nonatomic, strong)UILabel *countMinute;
@property (nonatomic, strong)UILabel *countSecond;
@end


@implementation GroupBuyDetailHeaderView {
    UIImageView *_productImageView;
    UIImageView *_stateImage;
    UILabel *_perText;
    YYLabel *_oriPrice;
    UIImageView *_groupPriceView;
    UILabel *_groupPrice;
    UILabel *_productName;
    UILabel *_totalWeight;
    UILabel *_alreadyGet;
    UIProgressView *_progressView;
    UILabel *_progressLabel;
}

- (instancetype)initWithDataSource:(GroupBuyingModel *)dataSource {
    self = [super init];
    if (self) {
        _dataSource = dataSource;
        [self setupUI];
        [self configData];
    }
    return self;
}

- (void)setupUI {
    //产品图片
    UIImageView *productImageView = [[UIImageView alloc] init];
    productImageView.frame = CGRectMake(0, 0, KFit_W(250), floor(KFit_W(250)));
    [self addSubview:productImageView];
    _productImageView = productImageView;
    
    //开始结束的图片状态
    UIImageView *stateImage = [[UIImageView alloc] init];
    stateImage.frame = CGRectMake(0, 0, 85, 85);
    [productImageView addSubview:stateImage];
    _stateImage = stateImage;
    
    CGFloat viewHeight = productImageView.frame.size.height / 3;
    CGFloat viewWidth = SCREEN_WIDTH - productImageView.frame.size.width;
    //单个用户采购量
    UIView *perUserBuy = [[UIView alloc] init];
    perUserBuy.frame = CGRectMake(productImageView.frame.size.width, 0, viewWidth, viewHeight);
    [perUserBuy addBorderView:LineColor width:1.0 direction:BorderDirectionBottom];
    [self addSubview:perUserBuy];
    
    UIImageView *perIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"perUser_buy"]];
    [perUserBuy addSubview:perIcon];
    [perIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(27);
        make.centerX.mas_equalTo(perUserBuy);
        make.top.mas_equalTo(13);
    }];
    
    UILabel *perText = [[UILabel alloc] init];
    perText.textAlignment = NSTextAlignmentCenter;
    perText.numberOfLines = 0;
    perText.font = [UIFont systemFontOfSize:12];
    perText.textColor = HEXColor(@"#333333", 1);
    [perUserBuy addSubview:perText];
    [perText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(perIcon.mas_bottom).offset(5);
        make.left.right.mas_equalTo(0);
    }];
    _perText = perText;
    
    //原价
    UIView *oriPriceView = [[UIView alloc] init];
    oriPriceView.frame = CGRectMake(productImageView.frame.size.width, viewHeight, viewWidth, viewHeight);
    [oriPriceView addBorderView:LineColor width:1.0 direction:BorderDirectionBottom];
    [self addSubview:oriPriceView];
    
    YYLabel *oriPrice = [[YYLabel alloc] init];
    [oriPriceView addSubview:oriPrice];
    [oriPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(oriPriceView);
    }];
    _oriPrice = oriPrice;
    
    //团购价
    UIImage *image = [UIImage imageNamed:@"price_bg"];
    UIImageView *groupPriceView = [[UIImageView alloc] init];
    groupPriceView.frame = CGRectMake(productImageView.frame.size.width - KFit_W(10), viewHeight * 2, viewWidth + KFit_W(10), viewHeight);
    groupPriceView.image = image;
    [self addSubview:groupPriceView];
    _groupPriceView = groupPriceView;
    
    UILabel *groupText = [[UILabel alloc] init];
    groupText.text = @"团购价";
    groupText.textColor = [UIColor whiteColor];
    groupText.font = [UIFont boldSystemFontOfSize:12];
    [groupPriceView addSubview:groupText];
    [groupText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(groupPriceView.mas_centerX).offset(KFit_W(5));
    }];
    
    UILabel *groupPrice = [[UILabel alloc] init];
    [groupPriceView addSubview:groupPrice];
    [groupPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(groupPriceView);
        make.left.mas_equalTo(KFit_W(10));
        make.right.mas_equalTo(0);
    }];
    _groupPrice = groupPrice;
    
    //产品名字
    UILabel *productName = [[UILabel alloc] init];
    productName.font = [UIFont boldSystemFontOfSize:17];
    [self addSubview:productName];
    [productName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(10));
        make.top.mas_equalTo(productImageView.mas_bottom).offset(15);
        make.height.mas_equalTo(17);
        make.right.mas_equalTo(self.mas_centerX).offset(0);
        
    }];
    _productName = productName;
    
    //总量&剩余量
    UILabel *totalWeight = [[UILabel alloc] init];
    totalWeight.textAlignment = NSTextAlignmentRight;
    totalWeight.font = [UIFont systemFontOfSize:13];
    totalWeight.textColor = HEXColor(@"#868686", 1);
    [self addSubview:totalWeight];
    [totalWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX).offset(3);
        make.right.mas_equalTo(KFit_W(-10));
        make.centerY.mas_equalTo(productName);
    }];
    _totalWeight = totalWeight;
    
    //团购剩余时间
    UIView *leftTimeView = [[UIView alloc] init];
    [self addSubview:leftTimeView];
    [leftTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(productName);
        make.right.mas_equalTo(KFit_W(-5));
        make.height.mas_equalTo(34);
        make.top.mas_equalTo(productName.mas_bottom).offset(12);
    }];
    
    UILabel *leftText = [[UILabel alloc] init];
    leftText.font = [UIFont systemFontOfSize:12];
    leftText.text = @"团购剩余时间:";
    leftText.textColor = HEXColor(@"#333333", 1);
    [leftTimeView addSubview:leftText];
    [leftText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
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
            make.right.mas_equalTo(-(width * i + gap * (i + 1)));
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
            _countSecond = timeLabel;
            timeUnit.text = @"秒";
        } else if (i == 1) {
            _countMinute = timeLabel;
            timeUnit.text = @"分";
        } else if (i == 2) {
            _countHour = timeLabel;
            timeUnit.text = @"小时";
        } else {
            _countDay = timeLabel;
            timeUnit.text = @"天";
        }
    }
    
    //已经认领
    UILabel *alreadyGet = [[UILabel alloc] init];
    alreadyGet.font = [UIFont systemFontOfSize:12];
    alreadyGet.textColor = HEXColor(@"#868686", 1);
    [self addSubview:alreadyGet];
    [alreadyGet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftTimeView.mas_bottom).offset(8);
        make.left.mas_equalTo(productName);
    }];
    _alreadyGet = alreadyGet;
    
    //进度条
    UIProgressView *progressView = [[UIProgressView alloc] init];
    progressView.layer.cornerRadius = 2.5;
    progressView.clipsToBounds = YES;
    progressView.tintColor = MainColor;
    [self addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.countDay.mas_left);
        make.right.mas_equalTo(self.countSecond.mas_left).offset(-5);
        make.centerY.mas_equalTo(alreadyGet);
        make.height.mas_equalTo(5);
    }];
    _progressView = progressView;
    
    //进度label
    UILabel *progressLabel = [[UILabel alloc] init];
    progressLabel.font = [UIFont systemFontOfSize:11];
    progressLabel.textColor = HEXColor(@"#868686", 1);
    [self addSubview:progressLabel];
    [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(progressView.mas_right).offset(6);
        make.centerY.mas_equalTo(progressView);
        make.right.mas_equalTo(-2);
    }];
    _progressLabel = progressLabel;
}

//加载数据
- (void)configData {
    //图片
    [_productImageView yy_setImageWithURL:ImgUrl(_dataSource.productPic) placeholder:PlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    
    //左上角图片
    //未开始
    if ([_dataSource.endCode isEqualToString:@"00"]) {
        _stateImage.image = [UIImage imageNamed:@"groupBuy_notStart_85"];
        //已开始
    } else if ([_dataSource.endCode isEqualToString:@"10"]) {
        _stateImage.image = [UIImage imageNamed:@"groupBuy_start_85"];
        //已结束
    } else {
        _stateImage.image = [UIImage imageNamed:@"groupBuy_end_85"];
    }
    
    //最小认购量 - 最大认购量
    if (isRightData(_dataSource.minNum) && isRightData(_dataSource.maxNum) && isRightData(_dataSource.numUnit)) {
        _perText.text = [NSString stringWithFormat:@"单个用户采购量\n%@-%@%@",_dataSource.minNum,_dataSource.maxNum,_dataSource.numUnit];
    }
    
    //原价
    NSString *oPrice = _dataSource.oldPrice;
    NSString *oText = [NSString stringWithFormat:@"原价: ¥%@元/%@",oPrice,_dataSource.priceUnit];
    NSMutableAttributedString *mutableOriginal = [[NSMutableAttributedString alloc] initWithString:oText];
    mutableOriginal.yy_color = HEXColor(@"#868686", 1);
    mutableOriginal.yy_font = [UIFont systemFontOfSize:12];
    [mutableOriginal yy_setFont:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(5, oPrice.length)];
    NSRange range2 = [[mutableOriginal string] rangeOfString:oText options:NSCaseInsensitiveSearch];
    //下划线
    YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle
                                                                   width:@(1)
                                                                   color:RGBA(0, 0, 0, 0.5)];
    //删除样式
    [mutableOriginal yy_setTextStrikethrough:decoration range:range2];
    _oriPrice.attributedText = mutableOriginal;
    
    //团购价
    NSString *cPrice = _dataSource.priceNew;
    NSString *cText = [NSString stringWithFormat:@"¥%@元/%@",cPrice,_dataSource.priceUnit];
    NSMutableAttributedString *mutablecurrent = [[NSMutableAttributedString alloc] initWithString:cText];
    mutablecurrent.yy_color = [UIColor whiteColor];
    mutablecurrent.yy_alignment = NSTextAlignmentCenter;
    mutablecurrent.yy_font = [UIFont systemFontOfSize:14];
    [mutablecurrent yy_setFont:[UIFont boldSystemFontOfSize:26] range:NSMakeRange(1, cPrice.length)];
    _groupPrice.attributedText = mutablecurrent;
    
    //产品名字
    if isRightData(_dataSource.productName)
        _productName.text = _dataSource.productName;
    
    //总量和剩余量
    if isRightData(_dataSource.totalNum) {
        NSString *total = [NSString stringWithFormat:@"总量 :%@%@ ",_dataSource.totalNum,_dataSource.numUnit];
        _totalWeight.text = total;
        if isRightData(_dataSource.remainNum) {
            NSString *rest = [NSString stringWithFormat:@"   剩余量 :%@%@",_dataSource.remainNum,_dataSource.numUnit];
            _totalWeight.text = [NSString stringWithFormat:@"%@%@",total,rest];
        }
    }
    
    //倒计时
    NSDate *datenow = [NSDate date];
    long long nowStamp = (long)[datenow timeIntervalSince1970] * 1000;
    [self countDownWithBegin:nowStamp endTime:_dataSource.endTimeStamp];
    
    //已经认领
    if isRightData(_dataSource.subscribedNum)
        _alreadyGet.text = [NSString stringWithFormat:@"已认领量:  %@%@",_dataSource.subscribedNum,_dataSource.numUnit];
    
    //进度条
    if (isRightData(_dataSource.numPercent)) {
        NSString *percentStr = [_dataSource.numPercent substringToIndex:_dataSource.numPercent.length - 1];
        CGFloat percent = [percentStr floatValue] / 100;
        _progressView.progress = percent;
        _progressLabel.text = [NSString stringWithFormat:@"达成%@",_dataSource.numPercent];
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
    
    _countDay.text = dayStr;
    _countHour.text = hourStr;
    _countMinute.text = minStr;
    _countSecond.text = secStr;
}

@end
