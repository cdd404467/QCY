//
//  ZhuJiDiyDetailHeaderView.m
//  QCY
//
//  Created by i7colors on 2019/8/1.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ZhuJiDiyDetailHeaderView.h"
#import <YYText.h>
#import "UIView+Border.h"
#import "ZhuJiDiyModel.h"
#import "TimeAbout.h"

@interface ZhuJiDiyDetailHeaderView()
@property (nonatomic, strong) YYLabel *stateLabel;
@property (nonatomic, strong) UILabel *productNameLab;
@property (nonatomic, strong) UIView *botBgView;
@property (nonatomic, strong) UIImageView *userType;
@property (nonatomic, strong) UILabel *signLabel;
//@property (nonatomic, strong) UIImageView *personImageView;
//@property (nonatomic, strong) UILabel *personLabel;
@property (nonatomic, strong) UILabel *companyName;
@end

@implementation ZhuJiDiyDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = Main_BgColor;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        [self setupUI];
    }
    
    return  self;
}

- (void)setupUI {
    //进度
    YYLabel *stateLabel = [[YYLabel alloc] init];
    stateLabel.numberOfLines = 2;
    stateLabel.frame = CGRectMake(0, 0, KFit_W(80), 50);
    stateLabel.backgroundColor = HEXColor(@"#F5F5F5", 1);
    [stateLabel addBorderView:HEXColor(@"#E5E5E5", 1) width:1.0 direction:BorderDirectionBottom | BorderDirectionRight];
    [self addSubview:stateLabel];
    _stateLabel = stateLabel;
    
    //产品名字
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stateLabel.mas_right);
        make.top.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    UILabel *productNameLab = [[UILabel alloc] init];
    productNameLab.numberOfLines = 2;
    productNameLab.font = [UIFont boldSystemFontOfSize:15];
    [bgView addSubview:productNameLab];
    _productNameLab = productNameLab;
    [productNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(bgView);
        make.top.mas_equalTo(0);
    }];
    
    //下班部分信息，只有是看别人才显示
    UIView *botBgView = [[UIView alloc] init];
    botBgView.hidden = YES;
    botBgView.backgroundColor = [UIColor whiteColor];
    botBgView.frame = CGRectMake(0, 50, SCREEN_WIDTH, 50);
    [self addSubview:botBgView];
    _botBgView = botBgView;
    [botBgView addBorderView:HEXColor(@"#E5E5E5", 1) width:0.7 direction:BorderDirectionTop];
    
    //用户类型
    UIImageView *userType = [[UIImageView alloc] init];
    [botBgView addSubview:userType];
    [userType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(KFit_W(12));
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
    
    //公司名字
    UILabel *companyName = [[UILabel alloc] init];
    companyName.font = [UIFont systemFontOfSize:13];
    [botBgView addSubview:companyName];
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userType.mas_right).offset(12);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-10);
    }];
    _companyName = companyName;
    
}

- (void)setModel:(ZhuJiDiyModel *)model {
    _model = model;
    //剩余天数
    [self configMutableStrDate:model];
    
    //名称
    _productNameLab.text = model.zhujiName;
    
    //如果从首页进去
    if ([_jumpFrom isEqualToString:@"home"]) {
        self.height = 110;
        _botBgView.hidden = NO;
        
        //是否是我发布
        if ([model.isCharger isEqualToString:@"1"]) {
            _companyName.text = model.companyName;
        } else {
            _companyName.text = @"***************公司";
        }
        //企业还是个人图片
        if ([model.publishType isEqualToString:@"企业发布"]) {
            _userType.image = [UIImage imageNamed:@"company_img"];
            _signLabel.text = @"企业用户";
        } else {
            _userType.image = [UIImage imageNamed:@"personal_img"];
            _signLabel.text = @"个人用户";
        }
    }
}


//处理时间
- (void)configMutableStrDate:(ZhuJiDiyModel *)model {
    NSDate *datenow = [NSDate date];
    long long nowStamp = (long)[datenow timeIntervalSince1970] * 1000;
    NSArray *timeArr = [TimeAbout timeDiffWithStartTimeStamp:nowStamp finishTimeStamp:model.endTimeStamp];
    if ([model.status isEqualToString:@"diying"]) {
        NSString *day = [timeArr[0] stringValue];
        NSString *hour = [timeArr[1] stringValue];
        NSString *min = [timeArr[2] stringValue];
        NSString *sec = [timeArr[3] stringValue];
        NSString *firstTime = [NSString string];
        NSString *secondTime = [NSString string];
        NSString *textTime = @"剩余时间";
        NSString *firstTimeUnit = [NSString string];
        NSString *secondTimeUnit = [NSString string];
        if (day.integerValue != 0){
            firstTimeUnit = @"天";
            secondTimeUnit = @"小时";
            firstTime = day;
            if (hour.integerValue != 0) {
                secondTime = hour;
            } else {
                secondTime = @"0";
            }
        } else if (day.integerValue == 0 && hour.integerValue != 0) {
            firstTimeUnit = @"小时";
            secondTimeUnit = @"分";
            firstTime = hour;
            if (min.integerValue != 0) {
                secondTime = min;
            } else {
                secondTime = @"0";
            }
        } else if (day.integerValue == 0 && hour.integerValue == 0) {
            firstTimeUnit = @"分";
            secondTimeUnit = @"秒";
            if (min.integerValue != 0 && sec.integerValue != 0) {
                firstTime = min;
                secondTime = sec;
            } else if (min.integerValue == 0 && sec.integerValue != 0) {
                firstTime = @"0";
                secondTime = sec;
            }
        }
        firstTime = @"2";
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
    } else {
        _stateLabel.backgroundColor = HEXColor(@"#E5E5E5", 1);
        _stateLabel.font = [UIFont systemFontOfSize:15];
        _stateLabel.textColor = HEXColor(@"#333333", 1);
        _stateLabel.text = @"已完成";
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
}
@end
