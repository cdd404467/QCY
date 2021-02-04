//
//  VoteDetailHeaderView.m
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "VoteDetailHeaderView.h"
#import "HelperTool.h"
#import "VoteModel.h"
#import <UIImageView+WebCache.h>
#import "CountDown.h"

@implementation VoteDetailHeaderView {
    UIImageView *_posterImageView;
    UILabel *_competitorLab;
    UILabel *_visitLab;
    CountDown *_countDownTimer;
    UILabel *_countDay;
    UILabel *_countHour;
    UILabel *_countMinute;
    UILabel *_countSecond;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXColor(@"#f3f3f3", 1);
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    //图片
    _posterImageView = [[UIImageView alloc] init];
    _posterImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 144);
    [self addSubview:_posterImageView];
    
    CGFloat gap = 8;
    CGFloat width = (SCREEN_WIDTH - 8 * 4) / 3;
    NSArray *title = @[@"参赛者",@"投票数",@"访问量"];
    for (NSInteger i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(gap + i * (width + gap), 0, width, 60);
        view.layer.cornerRadius = 3.f;
        view.centerY = _posterImageView.bottom;
        [self addSubview:view];
        
        //显示数字
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 12, width, 22);
        label.font = [UIFont boldSystemFontOfSize:22];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        //显示文本
        UILabel *txtLabel = [[UILabel alloc] init];
        txtLabel.frame = CGRectMake(0, label.bottom + 2, width, 12);
        txtLabel.font = [UIFont systemFontOfSize:12];
        txtLabel.textAlignment = NSTextAlignmentCenter;
        txtLabel.text = title[i];
        [view addSubview:txtLabel];
        
        if (i == 0) {
            _competitorLab = label;
            [HelperTool textGradientview:label bgVIew:view gradientColors:@[(id)HEXColor(@"#55B5FF", 1).CGColor,(id)HEXColor(@"#8CCFFF", 1).CGColor] gradientStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
        } else if (i == 1) {
            _voteLab = label;
            [HelperTool textGradientview:label bgVIew:view gradientColors:@[(id)HEXColor(@"#FF5153", 1).CGColor,(id)HEXColor(@"#FF6B6E", 1).CGColor] gradientStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
        } else {
            _visitLab = label;
            [HelperTool textGradientview:label bgVIew:view gradientColors:@[(id)HEXColor(@"#FF8803", 1).CGColor,(id)HEXColor(@"#FFAD4F", 1).CGColor] gradientStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
        }
    }
    
    //投票截止的view
    UIView *endTimeView = [[UIView alloc] init];
    endTimeView.backgroundColor = [UIColor whiteColor];
//    endTimeView.frame = CGRectMake(0, _posterImageView.bottom + 40, SCREEN_WIDTH, 40);
    [self addSubview:endTimeView];
    [endTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(0);
    }];
    
    UILabel *leftText = [[UILabel alloc] init];
    leftText.font = [UIFont systemFontOfSize:14];
    leftText.text = @"投票截止:";
    leftText.textColor = HEXColor(@"#868686", 1);
    [endTimeView addSubview:leftText];
    [leftText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.centerY.mas_equalTo(endTimeView);
    }];
    [leftText sizeToFit];
    
    //从秒开始
    CGFloat timeWidth = KFit_W(35);
    CGFloat timeGap = KFit_W(10);
    CGFloat unitWidth = 20;
    for (NSInteger i = 0; i < 4; i ++) {
        //倒计时label
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = [UIFont boldSystemFontOfSize:24];
        timeLabel.textColor = HEXColor(@"#F50000", 1);
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [endTimeView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftText.mas_right).offset(timeGap + (unitWidth + timeWidth + timeGap) * i);
            make.centerY.mas_equalTo(leftText);
            make.width.height.mas_equalTo(timeWidth);
        }];
        [timeLabel sizeToFit];
        //时间单位
        UILabel *timeUnit = [[UILabel alloc] init];
        timeUnit.font = [UIFont systemFontOfSize:17];
        timeUnit.textColor = HEXColor(@"#202020", 1);
        timeUnit.textAlignment = NSTextAlignmentCenter;
        [endTimeView addSubview:timeUnit];
        [timeUnit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(timeLabel.mas_right).offset(0);
            make.centerY.mas_equalTo(timeLabel);
        }];
        
        //判断添加
        if (i == 0) {
            _countDay = timeLabel;
            timeUnit.text = @"天";
        } else if (i == 1) {
            _countHour = timeLabel;
            timeUnit.text = @"时";
        } else if (i == 2) {
            _countMinute = timeLabel;
            timeUnit.text = @"分";
        } else {
            _countSecond = timeLabel;
            timeUnit.text = @"秒";
        }
    }
    
    
}

- (void)setModel:(VoteModel *)model {
    _model = model;
    
    [_posterImageView sd_setImageWithURL:ImgUrl(model.banner) placeholderImage:PlaceHolderImgBanner];
    _competitorLab.text = model.applicationNum;
    _voteLab.text = model.joinNum;
    _visitLab.text = model.clickNum;
    
    //倒计时
    NSDate *datenow = [NSDate date];
    long long nowStamp = (long)[datenow timeIntervalSince1970] * 1000;
    [self countDownWithBegin:nowStamp endTime:model.endTimeStamp];
}

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
