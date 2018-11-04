//
//  AskToBuyOfferCell.m
//  QCY
//
//  Created by i7colors on 2018/10/22.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuyOfferCell.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import <YYText.h>
#import "ClassTool.h"
#import "MinePageModel.h"
#import "TimeAbout.h"

@implementation AskToBuyOfferCell {
    UIImageView *_signImageView;
    UILabel *_signLabel;
    UILabel *_productName;
    UILabel *_offertTime;
    YYLabel *_countLabel;
    UILabel *_areaLabel;
    UILabel *_requireLabel;
    YYLabel *_priceLabel;
    UILabel *_freightLabel;
    UILabel *_bakLabel;
    UILabel *_firstLabel;
    UILabel *_secondtLabel;
    UILabel *_firstUnit;
    UILabel *_secondUnit;
    UILabel *_stateLabel;
    UIButton *_checkBtn;
    NSString *_pID;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView_1 = [[UIView alloc] init];
    bgView_1.backgroundColor = [UIColor whiteColor];
    bgView_1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    [self.contentView addSubview:bgView_1];
    
    //标志企业还是个人的图片
    UIImageView *signImageView = [[UIImageView alloc] init];
    [bgView_1 addSubview:signImageView];
    [signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(9));
        make.width.mas_equalTo(KFit_W(60));
        make.height.mas_equalTo(19);
        make.top.mas_equalTo(0);
    }];
    _signImageView = signImageView;
    
    //图片上面的文字
    UILabel *signLabel = [[UILabel alloc] init];
    signLabel.textColor = [UIColor whiteColor];
    signLabel.font = [UIFont systemFontOfSize:11];
    signLabel.textAlignment = NSTextAlignmentCenter;
    [signImageView addSubview:signLabel];
    [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _signLabel = signLabel;
    
    //产品名称
    UILabel *productName = [[UILabel alloc] init];
    productName.font = [UIFont boldSystemFontOfSize:16];
    productName.textColor = [UIColor blackColor];
    [bgView_1 addSubview:productName];
    [productName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(signImageView);
        make.top.mas_equalTo(signImageView.mas_bottom).offset(11);
        make.height.mas_equalTo(16);
        make.right.mas_equalTo(KFit_W(-130));
    }];
    _productName = productName;
    
    //时间
    UILabel *offertTime = [[UILabel alloc] init];
    offertTime.font = [UIFont systemFontOfSize:11];
    offertTime.textColor = HEXColor(@"#5F5F5F", 1);
    offertTime.textAlignment = NSTextAlignmentRight;
    [bgView_1 addSubview:offertTime];
    [offertTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(productName);
        make.height.mas_equalTo(11);
        make.right.mas_equalTo(KFit_W(-9));
    }];
    _offertTime = offertTime;
    
    CGFloat width = (SCREEN_WIDTH - KFit_W(9) * 2) / 3;
    //数量
    YYLabel *countLabel = [[YYLabel alloc] init];
    [bgView_1 addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(signImageView);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(width - 15);
        make.top.mas_equalTo(productName.mas_bottom).offset(7);
    }];
    _countLabel = countLabel;
    
    //地区
    UILabel *areaLabel = [[UILabel alloc] init];
    areaLabel.font = [UIFont systemFontOfSize:12];
    areaLabel.textColor = HEXColor(@"#868686", 1);
    [bgView_1 addSubview:areaLabel];
    [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(countLabel);
        make.width.mas_equalTo(width + 15);
        make.left.mas_equalTo(countLabel.mas_right);
    }];
    _areaLabel = areaLabel;
    
    //包装要求
    UILabel *requireLabel = [[UILabel alloc] init];
    requireLabel.font = [UIFont systemFontOfSize:12];
    requireLabel.textColor = HEXColor(@"#868686", 1);
    [bgView_1 addSubview:requireLabel];
    [requireLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(areaLabel);
        make.left.mas_equalTo(areaLabel.mas_right);
        make.right.mas_equalTo(offertTime);
    }];
    _requireLabel = requireLabel;
    
    //中间bgView
    UIView *bgView_2 = [[UIView alloc] init];
    bgView_2.layer.borderColor = HEXColor(@"#E3E4E5", 1).CGColor;
    bgView_2.layer.borderWidth = 1.f;
    bgView_2.backgroundColor = [UIColor whiteColor];
    bgView_2.frame = CGRectMake(0, 80, SCREEN_WIDTH, 80);
    [self.contentView addSubview:bgView_2];
    
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = [UIImage imageNamed:@"leftLine"];
    [bgView_2 addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(signImageView);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(6);
    }];
    
    UILabel *leftTitle = [[UILabel alloc] init];
    leftTitle.text = @"我的报价";
    leftTitle.font = [UIFont systemFontOfSize:13];
    leftTitle.textColor = [UIColor blackColor];
    [bgView_2 addSubview:leftTitle];
    [leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftImage.mas_right).offset(5);
        make.centerY.mas_equalTo(leftImage);
    }];

    UIImageView *leftImage_2 = [[UIImageView alloc] init];
    leftImage_2.image = [UIImage imageNamed:@"leftLine"];
    [bgView_2 addSubview:leftImage_2];
    [leftImage_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREEN_WIDTH / 2);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(6);
    }];

    UILabel *rightTitle = [[UILabel alloc] init];
    rightTitle.text = @"备注";
    rightTitle.font = [UIFont systemFontOfSize:13];
    rightTitle.textColor = [UIColor blackColor];
    [bgView_2 addSubview:rightTitle];
    [rightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftImage_2.mas_right).offset(5);
        make.centerY.mas_equalTo(leftImage_2);
    }];
    
    //价格
    YYLabel *priceLabel = [[YYLabel alloc] init];
    [bgView_2 addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(18));
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(KFit_W(90));
        make.bottom.mas_equalTo(-22);
    }];
    _priceLabel = priceLabel;
    
    //是否要运费
    UILabel *freightLabel = [[UILabel alloc] init];
    freightLabel.font = [UIFont systemFontOfSize:12];
    freightLabel.textColor = HEXColor(@"#868686", 1);
    [bgView_2 addSubview:freightLabel];
    [freightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(priceLabel);
        make.left.mas_equalTo(priceLabel.mas_right);
    }];
    _freightLabel = freightLabel;
    
    //备注
    UILabel *bakLabel = [[UILabel alloc] init];
    bakLabel.font = [UIFont systemFontOfSize:11];
    bakLabel.numberOfLines = 0;
    bakLabel.textColor = HEXColor(@"#868686", 1);
    [bgView_2 addSubview:bakLabel];
    [bakLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftImage_2);
        make.right.mas_equalTo(KFit_W(-9));
        make.top.mas_equalTo(leftImage_2.mas_bottom).offset(3);
        make.bottom.mas_equalTo(-5);
    }];
    _bakLabel = bakLabel;
    
    
    //下面bgView
    UIView *bgView_3 = [[UIView alloc] init];
    bgView_3.frame = CGRectMake(0, 160, SCREEN_WIDTH, 60);
    bgView_3.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView_3];
    
    //剩余时间
    UILabel *timeText = [[UILabel alloc] init];
    timeText.font = [UIFont systemFontOfSize:12];
    timeText.textColor = HEXColor(@"#333333", 1);
    timeText.text = @"剩余时间: ";
    [bgView_3 addSubview:timeText];
    [timeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(16));
        make.centerY.mas_equalTo(bgView_3);
    }];
    
    //第一个框
    UIImageView *firstTime = [[UIImageView alloc] init];
    firstTime.image = [UIImage imageNamed:@"time_bg"];
    [bgView_3 addSubview:firstTime];
    [firstTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.centerY.mas_equalTo(timeText);
        make.left.mas_equalTo(timeText.mas_right).offset(2);
    }];
    
    //第一个label
    UILabel *firstLabel = [[UILabel alloc] init];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.font = [UIFont systemFontOfSize:11];
    firstLabel.textColor = [UIColor whiteColor];
    [firstTime addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(firstTime);
    }];
    _firstLabel = firstLabel;
    
    //第一个单位
    UILabel *firstUnit = [[UILabel alloc] init];
    firstUnit.font = [UIFont systemFontOfSize:12];
    firstUnit.textColor = HEXColor(@"#333333", 1);
    [bgView_3 addSubview:firstUnit];
    [firstUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(firstTime.mas_right).offset(10);
        make.centerY.mas_equalTo(firstTime);
    }];
    _firstUnit = firstUnit;
    
    //第二个框
    UIImageView *secondTime = [[UIImageView alloc] init];
    secondTime.image = [UIImage imageNamed:@"time_bg"];
    [bgView_3 addSubview:secondTime];
    [secondTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.centerY.mas_equalTo(timeText);
        make.left.mas_equalTo(firstUnit.mas_right).offset(20);
    }];
    
    //第二个label
    UILabel *secondtLabel = [[UILabel alloc] init];
    secondtLabel.textAlignment = NSTextAlignmentCenter;
    secondtLabel.font = [UIFont systemFontOfSize:11];
    secondtLabel.textColor = [UIColor whiteColor];
    [secondTime addSubview:secondtLabel];
    [secondtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(secondTime);
    }];
    _secondtLabel = secondtLabel;
    
    //第二个单位
    UILabel *secondUnit = [[UILabel alloc] init];
    secondUnit.font = [UIFont systemFontOfSize:12];
    secondUnit.textColor = HEXColor(@"#333333", 1);
    [bgView_3 addSubview:secondUnit];
    [secondUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(secondTime.mas_right).offset(10);
        make.centerY.mas_equalTo(secondTime);
    }];
    _secondUnit = secondUnit;
    
    //若不是进行中，显示覆盖的label
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.backgroundColor = [UIColor whiteColor];
    stateLabel.textColor = HEXColor(@"#333333", 1);
    stateLabel.font = [UIFont systemFontOfSize:18];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH - KFit_W(90), 60);
    [bgView_3 addSubview:stateLabel];
    _stateLabel = stateLabel;
    
    //按钮
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(SCREEN_WIDTH - KFit_W(90), 0, KFit_W(90), 60);
    checkBtn.layer.borderWidth = 2.f;
    checkBtn.layer.borderColor = MainColor.CGColor;
    checkBtn.adjustsImageWhenHighlighted = NO;
    checkBtn.titleLabel.numberOfLines = 0;
    [checkBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [bgView_3 addSubview:checkBtn];
    _checkBtn = checkBtn;
    

    //最下面的黑色条
    CGRect rect = CGRectMake(0, 220, SCREEN_WIDTH, 10);
    [ClassTool addLayerVertical:self.contentView frame:rect startColor:RGBA(0, 0, 0, 0.15) endColor:RGBA(0, 0, 0, 0.08)];
}

- (void)configData:(AskToBuyOfferModel *)model {
    
    NSString *count = model.enquiryDomain.num;
    NSString *text = [NSString stringWithFormat:@"数量: %@ KG",count];
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:text];
    mutableText.yy_font = [UIFont systemFontOfSize:12];
    mutableText.yy_color = HEXColor(@"#868686", 1);
    [mutableText yy_setColor:HEXColor(@"#F04C55", 1) range:NSMakeRange(4, count.length)];
    _countLabel.attributedText = mutableText;
    
    //价格
    NSString *price = model.price;
    NSString *textPrice = [NSString stringWithFormat:@"¥ %@ /KG",price];
    NSMutableAttributedString *mutableTextPrice = [[NSMutableAttributedString alloc] initWithString:textPrice];
    mutableTextPrice.yy_font = [UIFont systemFontOfSize:12];
    mutableTextPrice.yy_color = [UIColor blackColor];
    [mutableTextPrice yy_setColor:HEXColor(@"#F10215", 1) range:NSMakeRange(0, price.length + 2)];
    [mutableTextPrice yy_setFont:[UIFont systemFontOfSize:18] range:NSMakeRange(2, price.length)];
    _priceLabel.attributedText = mutableTextPrice;
    
    //剩余时间
    if ([model.status isEqualToString:@"0"]) {
        _stateLabel.hidden = YES;
        NSString *day = model.enquiryDomain.surplusDay;
        NSString *hour = model.enquiryDomain.surplusHour;
        NSString *min = model.enquiryDomain.surplusMin;
        NSString *sec = model.enquiryDomain.surplusSec;
        NSString *firstTime = [NSString string];
        NSString *secondTime = [NSString string];
        NSString *firstTimeUnit = [NSString string];
        NSString *secondTimeUnit = [NSString string];
        
        if (isRightData(day)) {
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
        _firstLabel.text = firstTime;
        _secondtLabel.text = secondTime;
        _firstUnit.text = firstTimeUnit;
        _secondUnit.text = secondTimeUnit;
        
    } else {
        _stateLabel.hidden = NO;
        if ([model.status isEqualToString:@"1"]) {
            _stateLabel.text = @"已采纳";
        } else if ([model.status isEqualToString:@"2"]) {
            _stateLabel.text = @"已关闭";
        } else {
            _stateLabel.text = @"";
        }
    }
    
    //右侧Btn
    NSString *offerCount = model.enquiryDomain.offerNum;
    NSString *btnTitle = [NSString stringWithFormat:@"查看\n已有%@家报价",offerCount];
    NSMutableAttributedString *mutableTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",btnTitle]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为4
    [paragraphStyle  setLineSpacing:2];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [mutableTitle addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, btnTitle.length)];
    mutableTitle.yy_color = HEXColor(@"#5F5F5F", 1);
    [mutableTitle yy_setFont:[UIFont systemFontOfSize:15] range:NSMakeRange(0,2)];
    [mutableTitle yy_setFont:[UIFont systemFontOfSize:11] range:NSMakeRange(2,btnTitle.length - 2)];
    [mutableTitle yy_setColor:MainColor range:NSMakeRange(0,2)];
    [mutableTitle yy_setColor:HEXColor(@"#EE2E7E", 1) range:NSMakeRange(5,offerCount.length)];
    [_checkBtn setAttributedTitle:mutableTitle forState:UIControlStateNormal];
}

- (void)setModel:(AskToBuyOfferModel *)model {
    _model = model;
    [self configData:model];
    //企业还是个人图片
    if ([model.enquiryDomain.publishType isEqualToString:@"企业发布"]) {
        _signImageView.image = [UIImage imageNamed:@"company_img"];
        _signLabel.text = @"企业用户";
    } else {
        _signImageView.image = [UIImage imageNamed:@"personal_img"];
        _signLabel.text = @"个人用户";
    }
    //企业名字
    if isRightData(model.enquiryDomain.productName) {
        _productName.text = model.enquiryDomain.productName;
    } else {
        _productName.text = @"";
    }
    //报价时间
    _offertTime.text = [TimeAbout timestampToString:model.offerTime];

    //地区
    _areaLabel.text = [NSString stringWithFormat:@"地区: %@ %@",model.enquiryDomain.locationProvince,model.enquiryDomain.locationCity];
    //包装要求
    _requireLabel.text = [NSString stringWithFormat:@"包装要求: %@",model.enquiryDomain.pack];
    //是否包含运费
    if ([model.isIncludeTrans isEqualToString:@"1"]) {
        _freightLabel.text = @"(包含运费)";
    } else {
        _freightLabel.text = @"(不包含运费)";
    }

    //备注
    if isRightData(model.enquiryDomain.descriptionStr) {
        _bakLabel.text = model.enquiryDomain.descriptionStr;
    } else {
        _bakLabel.text = @"暂无";
    }

    _pID = model.enquiryId;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AskToBuyOfferCell";
    AskToBuyOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AskToBuyOfferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)btnClick {
    if (self.btnClickBlock) {
        self.btnClickBlock(_pID);
    }
}

@end
