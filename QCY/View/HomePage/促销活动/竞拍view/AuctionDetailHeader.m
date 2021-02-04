//
//  AuctionDetailHeader.m
//  QCY
//
//  Created by i7colors on 2019/3/6.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AuctionDetailHeader.h"
#import "AuctionModel.h"
#import <UIImageView+WebCache.h>
#import <YYText.h>
#import "UIView+Border.h"
#import "CountDown.h"

@implementation AuctionDetailHeader {
    UIImageView *_productImageView;
    UIImageView *_stateImage;
//    YYLabel *_offerNumLab;
//    YYLabel *_startPriceLab;
//    YYLabel *_nowPrice;
    UIImageView *_nowPriceView;
    UILabel *_nameLab;
    UIView *_endTimeView;
    UILabel *_countDay;
    UILabel *_countHour;
    UILabel *_countMinute;
    UILabel *_countSecond;
    CountDown *_countDownTimer;
    UIView *_spView;
    UIView *_spView_1;
    UILabel *_addPriceLab;
    UILabel *_freightLab;
    UILabel *_producedCJLab;
    UILabel *_producedDateLab;
    UILabel *_areaLab;
    UILabel *_totalCountLab;
    UILabel *_phoneLab;
    UILabel *_companyNameLab;
    UILabel *_customLab_1;
    UILabel *_customLab_2;
    UIView *_topBgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    //产品图片
    UIImageView *productImageView = [[UIImageView alloc] init];
    productImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    [self addSubview:productImageView];
    _productImageView = productImageView;
    
    //开始结束的图片状态
    UIImageView *stateImage = [[UIImageView alloc] init];
    stateImage.frame = CGRectMake(0, 0, 55, 55);
    [productImageView addSubview:stateImage];
    _stateImage = stateImage;
    
//    CGFloat viewHeight = productImageView.frame.size.height / 3;
//    CGFloat viewWidth = SCREEN_WIDTH - productImageView.right;
    //出价次数
//    _offerNumLab = [[YYLabel alloc] initWithFrame:CGRectMake(productImageView.right, 0, viewWidth, viewHeight)];
//    _offerNumLab.backgroundColor = [UIColor whiteColor];
//    _offerNumLab.numberOfLines = 4;
//    [self addSubview:_offerNumLab];
//
//    //起拍
//    _startPriceLab = [[YYLabel alloc] initWithFrame:CGRectMake(_offerNumLab.left, _offerNumLab.bottom, viewWidth, viewHeight)];
//    _startPriceLab.backgroundColor = [UIColor whiteColor];
//    _startPriceLab.numberOfLines = 4;
//    [_startPriceLab addBorderView:LineColor width:0.5 direction:BorderDirectionTop | BorderDirectionBottom];
//    [self addSubview:_startPriceLab];
    
    //当前价格
//    _nowPriceView = [[UIImageView alloc] init];
//    _nowPriceView.frame = CGRectMake(_offerNumLab.left - 10, _startPriceLab.bottom, _startPriceLab.width + 10, _startPriceLab.height);
//    [self addSubview:_nowPriceView];
//
//    _nowPrice = [[YYLabel alloc] init];
//    _nowPrice.numberOfLines = 4;
//    _nowPrice.frame = CGRectMake(10, 0, _startPriceLab.width, _startPriceLab.height);
//    [_nowPriceView addSubview:_nowPrice];
    
    //发起人
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, productImageView.bottom, SCREEN_WIDTH, 40)];
    topBgView.backgroundColor = UIColor.whiteColor;
    topBgView.hidden = YES;
    [self addSubview:topBgView];
    [topBgView addBorderView:LineColor width:.5 direction:BorderDirectionBottom];
    _topBgView = topBgView;
    
    //发起人文字
    UILabel *initiatorLab = [[UILabel alloc] initWithFrame:CGRectMake(6, 10, 50, 20)];
    initiatorLab.textColor = HEXColor(@"#F10215", 1);
    initiatorLab.text = @"发起人";
    initiatorLab.layer.cornerRadius = 5.f;
    initiatorLab.layer.borderWidth = .6f;
    initiatorLab.layer.borderColor = initiatorLab.textColor.CGColor;
    initiatorLab.textAlignment = NSTextAlignmentCenter;
    initiatorLab.font = [UIFont systemFontOfSize:11.5];
    [topBgView addSubview:initiatorLab];
    
    //发起的公司名称
    _companyNameLab = [[UILabel alloc] initWithFrame:CGRectMake(initiatorLab.right + 5, 11, SCREEN_WIDTH - initiatorLab.right - 5, 15)];
    _companyNameLab.font = [UIFont systemFontOfSize:15];
    _companyNameLab.numberOfLines = 0;
    _companyNameLab.textColor = UIColor.blackColor;
    [topBgView addSubview:_companyNameLab];
    
    //产品名字
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(11, _companyNameLab.bottom + 10, SCREEN_WIDTH - 11 * 2, 15)];
    _nameLab.numberOfLines = 0;
    _nameLab.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_nameLab];
    
    //倒计时的view
    UIView *endTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, _nameLab.bottom, SCREEN_WIDTH, 40)];
    endTimeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:endTimeView];
    _endTimeView = endTimeView;
    
    //分割线
    _spView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    _spView.backgroundColor = LineColor;
    [self addSubview:_spView];
    
    UILabel *leftText = [[UILabel alloc] init];
    leftText.font = [UIFont systemFontOfSize:14];
    leftText.text = @"距离结束:";
    leftText.textColor = HEXColor(@"#868686", 1);
    [endTimeView addSubview:leftText];
    [leftText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
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
//        timeLabel.backgroundColor = [UIColor redColor];
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
//        timeUnit.backgroundColor = [UIColor blueColor];
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
    
    //加价幅度
    CGFloat labGap = 10;
    CGFloat labWidth = (SCREEN_WIDTH - _nameLab.left * 2 - labGap) * 0.5;
    CGFloat labHeight = 20;
    _addPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(_nameLab.left, _spView.bottom + 12, labWidth + 10, labHeight)];
    _addPriceLab.textColor = HEXColor(@"#ED3851", 1);
    _addPriceLab.font = [UIFont systemFontOfSize:13];
    [self addSubview:_addPriceLab];
    
    //总量
    _totalCountLab = [[UILabel alloc] initWithFrame:CGRectMake(_addPriceLab.right + 10, _addPriceLab.top, labWidth - 10, labHeight)];
    _totalCountLab.font = _addPriceLab.font;
    _totalCountLab.textColor = HEXColor(@"#868686", 1);
    [self addSubview:_totalCountLab];
    
    //运费
    _freightLab = [[UILabel alloc] initWithFrame:_addPriceLab.frame];
    _freightLab.textColor = HEXColor(@"#868686", 1);
    _freightLab.font = _addPriceLab.font;
    [self addSubview:_freightLab];
    
    //生产厂家
    _producedCJLab = [[UILabel alloc] initWithFrame:_totalCountLab.frame];
    _producedCJLab.textColor = _freightLab.textColor;
    _producedCJLab.font = _addPriceLab.font;
    [self addSubview:_producedCJLab];

    //生产日期
    _producedDateLab = [[UILabel alloc] initWithFrame:_addPriceLab.frame];
    _producedDateLab.textColor = _freightLab.textColor;
    _producedDateLab.font = _addPriceLab.font;
    [self addSubview:_producedDateLab];
    
    //地区
    _areaLab = [[UILabel alloc] initWithFrame:_totalCountLab.frame];
    _areaLab.textColor = _freightLab.textColor;
    _areaLab.font = _addPriceLab.font;
    [self addSubview:_areaLab];
    
    //电话
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:_addPriceLab.frame];
    phoneLab.font = _areaLab.font;
    phoneLab.textColor = _areaLab.textColor;
    [self addSubview:phoneLab];
    _phoneLab = phoneLab;
    
    //自定义
    _customLab_1 = [[UILabel alloc] initWithFrame:_addPriceLab.frame];
    _customLab_1.textColor = _freightLab.textColor;
    _customLab_1.font = _addPriceLab.font;
    [self addSubview:_customLab_1];
    
    _customLab_2 = [[UILabel alloc] initWithFrame:_addPriceLab.frame];
    _customLab_2.textColor = _freightLab.textColor;
    _customLab_2.font = _addPriceLab.font;
    [self addSubview:_customLab_2];
}




- (void)setModel:(AuctionModel *)model {
    _model = model;
    //记录高度
    [_productImageView sd_setImageWithURL:ImgUrl(model.productPic) placeholderImage:PlaceHolderImg];
    _stateImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"jp_state_%@",model.isType]];
    
    //竞拍次数
//    NSMutableAttributedString *mutableCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@次抢购",model.count]];
//    mutableCount.yy_color = HEXColor(@"#333333", 1);
//    mutableCount.yy_font = [UIFont systemFontOfSize:12];
//    mutableCount.yy_alignment = NSTextAlignmentCenter;
//    [mutableCount yy_setFont:[UIFont boldSystemFontOfSize:26] range:NSMakeRange(0, model.count.length)];
//    [mutableCount yy_setColor:HEXColor(@"#ED3851", 1) range:NSMakeRange(0, model.count.length)];
//    _offerNumLab.attributedText = mutableCount;
    
    //状态Label- 1未开始，2进行中，3成交，0已流拍
    //起拍价
//    NSString *sp = [NSString string];
//    if ([model.isType isEqualToString:@"1"]) {
//        sp = @"--";
//    } else {
//        sp = model.price;
//    }
//    NSString *spText = @"最低价:\n";
//    NSString *sString = [NSString stringWithFormat:@"%@¥%@%@",spText,sp,model.priceUnit];
//    NSMutableAttributedString *mutableStartPrice = [[NSMutableAttributedString alloc] initWithString:sString];
//    mutableStartPrice.yy_color = HEXColor(@"#868686", 1);
//    mutableStartPrice.yy_font = [UIFont systemFontOfSize:13];
//    mutableStartPrice.yy_alignment = NSTextAlignmentCenter;
//    [mutableStartPrice yy_setFont:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(spText.length + 1, sp.length)];
//    _startPriceLab.attributedText = mutableStartPrice;
    
    //当前价格
//    if ([model.isType isEqualToString:@"0"]) {
//        NSMutableAttributedString *mutableNowPrice = [[NSMutableAttributedString alloc] initWithString:@"无人抢购！"];
//        mutableNowPrice.yy_color = [UIColor whiteColor];
//        mutableNowPrice.yy_font = [UIFont systemFontOfSize:15];
//        mutableNowPrice.yy_alignment = NSTextAlignmentCenter;
//        _nowPrice.attributedText = mutableNowPrice;
//    } else {
//        NSString *np = [NSString string];
//        if ([model.isType isEqualToString:@"1"]) {
//            np = @"--";
//        } else {
//            np = model.maxPrice;
//        }
//        NSString *npText = @"现价:\n";
//        NSString *nString = [NSString stringWithFormat:@"%@¥%@%@",npText,np,model.priceUnit];
//        NSMutableAttributedString *mutableNowPrice = [[NSMutableAttributedString alloc] initWithString:nString];
//        mutableNowPrice.yy_color = [UIColor whiteColor];
//        mutableNowPrice.yy_font = [UIFont systemFontOfSize:13];
//        mutableNowPrice.yy_alignment = NSTextAlignmentCenter;
//        [mutableNowPrice yy_setFont:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(npText.length + 1, model.maxPrice.length)];
//        _nowPrice.attributedText = mutableNowPrice;
//    }
    
    //背景图片和是否显示时间
    NSString *imgName = [NSString string];
    switch ([model.isType integerValue]) {
        case 0: //0已流拍
            imgName = @"jp_price_bg2";
            _endTimeView.hidden = YES;
            break;
        case 1: //1未开始
            imgName = @"jp_price_bg2";
            _endTimeView.hidden = NO;
            break;
        case 2: //2进行中
            imgName = @"price_bg";
            _endTimeView.hidden = NO;
            break;
        case 3: //3成交
            imgName = @"jp_price_bg1";
            _endTimeView.hidden = YES;
            break;
        default:
            break;
    }
    _nowPriceView.image = [UIImage imageNamed:imgName];
    
    //发起人
    if ([model.from isEqualToString:@"pc"] && isRightData(model.from)) {
        _companyNameLab.text = model.companyName;
        CGFloat cpHeight = [_companyNameLab.text boundingRectWithSize:CGSizeMake(_companyNameLab.width, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName : _companyNameLab.font}
                                                          context:nil].size.height;
        _companyNameLab.height = cpHeight;
        _topBgView.height = _companyNameLab.bottom + 10;
        _topBgView.hidden = NO;
    } else {
        _topBgView.hidden = YES;
        _topBgView.height = 0;
    }
    
    //产品名字
    CGFloat nameHeight = [model.shopName boundingRectWithSize:CGSizeMake(_nameLab.width, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName : _nameLab.font}
                                                  context:nil].size.height;
    
    _nameLab.height = nameHeight;
    _nameLab.text = model.shopName;
    _nameLab.top = _topBgView.bottom + 10;
    
    //倒计时
    if (_endTimeView.hidden == NO) {
        _endTimeView.top = _nameLab.bottom + 2;
        NSDate *datenow = [NSDate date];
        long long nowStamp = (long)[datenow timeIntervalSince1970] * 1000;
        [self countDownWithBegin:nowStamp endTime:model.overTime];
        _spView.top = _endTimeView.bottom;
    } else {
        _spView.top = _nameLab.bottom + 10;
    }
    
    //加价幅度(改成现价)
    _addPriceLab.top = _spView.bottom + 12;
    _addPriceLab.text = [NSString stringWithFormat:@"现价: %@%@",model.maxPrice,model.priceUnit];
    
    //总量
    _totalCountLab.top = _addPriceLab.top;
    if (isRightData(model.num)) {
        _totalCountLab.hidden = NO;
        _totalCountLab.text = [NSString stringWithFormat:@"总量: %@%@",model.num, model.numUnit];
    } else {
        _totalCountLab.hidden = YES;
    }
    
    //运费
    _freightLab.top = _totalCountLab.hidden == YES ? _addPriceLab.top : _addPriceLab.bottom + 5;
    _freightLab.left = _totalCountLab.hidden == YES ? _addPriceLab.right + 10 : _addPriceLab.left;
    NSString *freight = [NSString string];
    if (isRightData(model.isFreight)) {
        if ([model.isFreight isEqualToString:@"1"]) {
            freight = @"是否包含运费: 是";
        } else {
            freight = @"是否包含运费: 否";
        }
    } else {
        freight = @"是否包含运费: 暂无信息";
    }
    _freightLab.text = freight;
    
    //生产厂家
    _producedCJLab.top = _addPriceLab.bottom + 5;
    _producedCJLab.left = _totalCountLab.hidden == YES ? _addPriceLab.left : _totalCountLab.left;
    _producedCJLab.text = [NSString stringWithFormat:@"生产厂家: %@",model.manufacturer];
    
    //生产日期
    _producedDateLab.top = _totalCountLab.hidden == YES ? _producedCJLab.top : _producedCJLab.bottom + 5;
    _producedDateLab.left = _totalCountLab.hidden == YES ? _freightLab.left : _addPriceLab.left;
    _producedDateLab.text = [NSString stringWithFormat:@"生产日期: %@",model.dateOfProduction];
    
    //地区
    _areaLab.top = _producedCJLab.bottom + 5;
    _areaLab.left = _totalCountLab.hidden == YES ? _producedCJLab.left : _totalCountLab.left;
    NSString *address = [NSString string];
    if (isRightData(model.address)) {
        address = model.address;
    } else if (isRightData(model.sourceOfSupply)) {
        address = model.sourceOfSupply;
    } else {
        address = @"暂无";
    }
    _areaLab.text = [NSString stringWithFormat:@"货源地: %@",address];
    
    //电话
    _phoneLab.top = _totalCountLab.hidden == YES ? _areaLab.top : _areaLab.bottom + 5;
    _phoneLab.left = _totalCountLab.hidden == YES ? _freightLab.left : _addPriceLab.left;
    NSString *phone = [NSString string];
    if ([model.from isEqualToString:@"pc"] && isRightData(model.phone)) {
        phone = [NSString stringWithFormat:@"电话: %@",model.phone];
    } else {
        phone = @"电话: 暂无";
    }
    _phoneLab.text = phone;
    _viewHeight = _phoneLab.bottom + 10;
    
    //自定义
    if (model.auctionDetails.length != 0 && model.auctionDetails1.length != 0) {
        _customLab_1.top = _phoneLab.bottom + 5;
        _customLab_1.text = [NSString stringWithFormat:@"%@: %@",model.auctionDetails,model.detailsValue];
        _customLab_2.top = _customLab_1.bottom + 5;
        _customLab_2.text = [NSString stringWithFormat:@"%@: %@",model.auctionDetails1,model.detailsValue1];
        _viewHeight = _customLab_2.bottom + 10;
    } else if (model.auctionDetails.length != 0 && model.auctionDetails1.length == 0) {
        _customLab_1.top = _phoneLab.bottom + 5;
        _customLab_1.text = [NSString stringWithFormat:@"%@: %@",model.auctionDetails,model.detailsValue];
        _customLab_2.hidden = YES;
        _viewHeight = _customLab_1.bottom + 10;
    } else if (model.auctionDetails.length == 0 && model.auctionDetails1.length != 0) {
        _customLab_2.top = _phoneLab.bottom + 5;
        _customLab_2.text = [NSString stringWithFormat:@"%@: %@",model.auctionDetails1,model.detailsValue1];
        _customLab_1.hidden = YES;
        _viewHeight = _customLab_2.bottom + 10;
    } else {
        _customLab_1.hidden = YES;
        _customLab_2.hidden = YES;
    }
    
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
   
    if (dayStr.length > 2) {
        CGFloat nameWidth = [dayStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24]}
                                                 context:nil].size.width;
        [_countDay mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(nameWidth + 2);
        }];
    }
    _countDay.text = dayStr;
    _countHour.text = hourStr;
    _countMinute.text = minStr;
    _countSecond.text = secStr;
}
@end

