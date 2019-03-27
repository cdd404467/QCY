//
//  AskToBuyDetailsHeaderView.m
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuyDetailsHeaderView.h"
#import "MacroHeader.h"
#import <YYText.h>
#import "UIView+Border.h"
#import <Masonry.h>
#import "PaddingLabel.h"
#import "HomePageModel.h"
#import "ClassTool.h"

@interface AskToBuyDetailsHeaderView()
@property (nonatomic, strong) YYLabel *productName;
@property (nonatomic, strong) UIImageView *userType;
@property (nonatomic, strong) UILabel *signLabel;
@property (nonatomic, strong) PaddingLabel *historyBuy;
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) UIImageView *personImageView;
@property (nonatomic, strong) UILabel *personLabel;
@end

@implementation AskToBuyDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = Main_BgColor;
    }
    
    return self;
}

- (void)setupUIWithStarNumber:(NSInteger)number {
    //求购进度
    YYLabel *stateLabel = [[YYLabel alloc] init];
    stateLabel.numberOfLines = 2;
    stateLabel.frame = CGRectMake(0, 0, KFit_W(80), 50);
    stateLabel.backgroundColor = HEXColor(@"#F5F5F5", 1);
    [stateLabel addBorderView:HEXColor(@"#E5E5E5", 1) width:1 direction:BorderDirectionBottom];
    [self addSubview:stateLabel];
    _stateLabel = stateLabel;
    
    UILabel *sLabel = [[UILabel alloc] initWithFrame:_stateLabel.frame];
    [_stateLabel addSubview:sLabel];
    sLabel.font = [UIFont systemFontOfSize:15];
    sLabel.textColor = [UIColor whiteColor];
    sLabel.text = @"已完成";
    sLabel.textAlignment = NSTextAlignmentCenter;
    _sLabel = sLabel;
    
    //名称
    YYLabel *productName = [[YYLabel alloc] init];
    productName.font = [UIFont boldSystemFontOfSize:15];
    productName.backgroundColor = [UIColor whiteColor];
    [productName addBorderView:HEXColor(@"#E5E5E5", 1) width:1 direction:BorderDirectionBottom | BorderDirectionLeft];
    [self addSubview:productName];
    [productName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stateLabel.mas_right);
        make.height.mas_equalTo(50);
        make.right.top.mas_equalTo(0);
    }];
    _productName = productName;
    
//    if (!GET_USER_TOKEN) {
        //背景，用来投影
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 50);
        [self addSubview:bgView];
        
        //用户类型
        UIImageView *userType = [[UIImageView alloc] init];
        [bgView addSubview:userType];
        [userType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(stateLabel.mas_bottom);
            make.right.mas_equalTo(stateLabel);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(68 * Scale_W);
        }];
        _userType = userType;
        
        UILabel *signLabel = [[UILabel alloc] init];
        signLabel.textColor = [UIColor whiteColor];
        signLabel.font = [UIFont systemFontOfSize:11];
        signLabel.textAlignment = NSTextAlignmentCenter;
        [userType addSubview:signLabel];
        [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _signLabel = signLabel;
        
        //标志是否是自己发布
        UIImageView *personImageView = [[UIImageView alloc] init];
        [bgView addSubview:personImageView];
        [personImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(userType);
            make.left.mas_equalTo(userType.mas_right).offset(KFit_W(10));
            make.width.height.mas_equalTo(userType);
        }];
        _personImageView = personImageView;
        
        //图片上面的文字
        UILabel *personLabel = [[UILabel alloc] init];
        personLabel.font = [UIFont systemFontOfSize:11];
        personLabel.text = @"我的发布";
        personLabel.textAlignment = NSTextAlignmentCenter;
        [personImageView addSubview:personLabel];
        [personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _personLabel = personLabel;
        
        //历史求购
        PaddingLabel *historyBuy = [[PaddingLabel alloc] init];
        historyBuy.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        historyBuy.layer.borderWidth = 1.f;
        historyBuy.layer.cornerRadius = 6;
        historyBuy.font = [UIFont systemFontOfSize:9];
        historyBuy.textAlignment = NSTextAlignmentCenter;
        historyBuy.layer.borderColor = HEXColor(@"#ED3851", 1).CGColor;
        historyBuy.textColor = HEXColor(@"#F10215", 1);
        [bgView addSubview:historyBuy];
        [historyBuy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(userType.mas_bottom).offset(6);
            make.height.mas_equalTo(15);
            make.right.mas_equalTo(userType);
        }];
        _historyBuy = historyBuy;
        
        //公司名字
        UILabel *companyName = [[UILabel alloc] init];
        companyName.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:companyName];
        [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(userType.mas_right).offset(12);
            make.centerY.mas_equalTo(historyBuy);
            make.height.mas_equalTo(13);
            make.width.mas_equalTo(KFit_W(160));
        }];
        _companyName = companyName;
        
        //信用等级
        UILabel *cText = [[UILabel alloc] init];
        cText.font = [UIFont systemFontOfSize:9];
        cText.text = @"信用等级:";
        cText.textColor = HEXColor(@"#868686", 1);
        [bgView addSubview:cText];
        [cText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(companyName.mas_right).offset(KFit_W(5));
            make.centerY.mas_equalTo(companyName);
        }];
        
        //星星背景
        UIView *starView = [[UIView alloc] init];
        [bgView addSubview:starView];
        [starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cText.mas_right).offset(5);
            make.height.mas_equalTo(10);
            make.right.mas_equalTo(-5);
            make.centerY.mas_equalTo(cText);
        }];
        
        
        //几颗星星
        for (NSInteger i = 0;i < 5; i ++) {
            UIImageView *starImage = [[UIImageView alloc] init];
            starImage.frame = CGRectMake(12 * i, 0, 10, 10);
            [starView addSubview:starImage];
            if (i < number) {
                starImage.image = [UIImage imageNamed:@"star_selected"];
            } else {
                starImage.image = [UIImage imageNamed:@"star_unselected"];
            }
            
        }
//    }
}

- (void)setModel:(AskToBuyDetailModel *)model {
    _model = model;
    [self configData:model];
    
//    if (!GET_USER_TOKEN) {
        [self configBottomData:model];
//    }
}

//倒计时和公司名字
- (void)configData:(AskToBuyDetailModel *)model {
    //剩余时间
    NSString *day = model.surplusDay;
    NSString *hour = model.surplusHour;
    NSString *min = model.surplusMin;
    NSString *sec = model.surplusSec;
    NSString *firstTime = [NSString string];
    NSString *secondTime = [NSString string];
    NSString *textTime = @"剩余时间";
    NSString *firstTimeUnit = [NSString string];
    NSString *secondTimeUnit = [NSString string];
    
    if (isNotRightData(day) && isNotRightData(hour) && isNotRightData(min) && isNotRightData(sec)) {
        [ClassTool addLayer:_stateLabel frame:_stateLabel.frame];
        _sLabel.hidden = NO;
    } else {
        _sLabel.hidden = YES;
        if (isRightData(day)){
            firstTimeUnit = @"天";
            secondTimeUnit = @"小时";
            firstTime = day;
            secondTime = hour;
        } else if (isNotRightData(day) && isRightData(hour)) {
            firstTimeUnit = @"小时";
            secondTimeUnit = @"分";
            firstTime = hour;
            secondTime = min;
        } else if (isNotRightData(day) && isNotRightData(hour)) {
            firstTimeUnit = @"分";
            secondTimeUnit = @"秒";
            if (isRightData(min) && isRightData(sec)) {
                firstTime = min;
                secondTime = sec;
            } else if (isNotRightData(min) && isRightData(sec)) {
                firstTime = @"0";
                secondTime = sec;
            }
        }
        _stateLabel.backgroundColor = [UIColor whiteColor];
        NSString *time = [NSString stringWithFormat:@"%@%@%@%@\n%@",firstTime,firstTimeUnit,secondTime,secondTimeUnit,textTime];
        NSMutableAttributedString *mutableTime = [[NSMutableAttributedString alloc] initWithString:time];
        mutableTime.yy_alignment = NSTextAlignmentCenter;
        mutableTime.yy_paragraphSpacing = 3;
        mutableTime.yy_font = [UIFont systemFontOfSize:12];
        mutableTime.yy_color = [UIColor colorWithHexString:@"#333333"];
        [mutableTime yy_setColor:MainColor range:NSMakeRange(0, firstTime.length)];
        [mutableTime yy_setColor:MainColor range:NSMakeRange(firstTime.length + firstTimeUnit.length , secondTime.length)];
        [mutableTime yy_setColor:HEXColor(@"#868686", 1) range:NSMakeRange(time.length - textTime.length, textTime.length)];
        [mutableTime yy_setFont:[UIFont systemFontOfSize:10] range:NSMakeRange(time.length - textTime.length, textTime.length)];
        _stateLabel.attributedText = mutableTime;
    }

    NSString *text = [NSString string];
    if isRightData(model.productName) {
        text = model.productName;
    } else {
        text = @"";
    }
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:text];
    mutableText.yy_font = [UIFont boldSystemFontOfSize:14];
    mutableText.yy_firstLineHeadIndent = 12.0;
    _productName.attributedText = mutableText;
}

//下半部分
- (void)configBottomData:(AskToBuyDetailModel *)model {
    //企业还是个人图片
    if ([model.publishType isEqualToString:@"企业发布"]) {
        _userType.image = [UIImage imageNamed:@"company_img"];
        _signLabel.text = @"企业用户";
        _companyName.textColor = HEXColor(@"#ED3851", 1);
    } else {
        _userType.image = [UIImage imageNamed:@"personal_img"];
        _signLabel.text = @"个人用户";
        _companyName.textColor = HEXColor(@"#386FED", 1);
    }
    
    //是否是我发布
    if ([model.isCharger isEqualToString:@"1"]) {
        _personImageView.hidden = NO;
        _companyName.text = model.companyName;
        if ([model.publishType isEqualToString:@"企业发布"]) {
            _personImageView.image = [UIImage imageNamed:@"person_red"];
            _personLabel.textColor = HEXColor(@"#F10215", 1);
        } else {
            _personImageView.image = [UIImage imageNamed:@"person_blue"];
            _personLabel.textColor = HEXColor(@"#386FED", 1);
        }
        
    } else {
        _personImageView.hidden = YES;
        _companyName.text = [NSString stringWithFormat:@"*****公司"];
    }
    
    //历史
    _historyBuy.text = [NSString stringWithFormat:@"历史求购 %@",model.enquiryTimes];
    
}

@end
