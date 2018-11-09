//
//  AskToBuyCell.m
//  QCY
//
//  Created by i7colors on 2018/9/7.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuyCell.h"
#import <Masonry.h>
#import "MacroHeader.h"
#import <YYText.h>
#import "HomePageModel.h"


@interface AskToBuyCell()
@property (nonatomic, strong)YYLabel *offerCount;

@end


@implementation AskToBuyCell {
    UILabel *_nameLabel;
    YYLabel *_leftTimeLabel;
    YYLabel *_countLabel;
    UIImageView *_signImageView;
    UILabel *_signLabel;
    UIImageView *_personImageView;
    UILabel *_personLabel;
    UILabel *_areaLabel;
    UIImageView *_labelImage;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Cell_BGColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(120);
    }];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 0, KFit_W(80), 120);
    leftView.layer.shadowColor = RGBA(0, 0, 0, 0.2).CGColor;
    leftView.layer.shadowOffset = CGSizeMake(2, 0);
    leftView.layer.shadowOpacity = 1.0f;
    leftView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:leftView];
    
    //剩余时间
    YYLabel *leftTimeLabel = [[YYLabel alloc] init];
    leftTimeLabel.numberOfLines = 0;
    [leftView addSubview:leftTimeLabel];
    [leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    _leftTimeLabel = leftTimeLabel;
    
    //数量
    YYLabel *countLabel = [[YYLabel alloc] init];
    [leftView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftTimeLabel.mas_bottom);
        make.left.bottom.mas_equalTo(0);
        make.width.equalTo(leftTimeLabel);
    }];
    _countLabel = countLabel;
    
    //分割线
    UIView *hLine = [[UIView alloc] init];
    hLine.backgroundColor = LineColor;
    [countLabel addSubview:hLine];
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    //标志企业还是个人的图片
    UIImageView *signImageView = [[UIImageView alloc] init];
    [bgView addSubview:signImageView];
    [signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(leftView.mas_right).offset(KFit_W(10));
        make.width.mas_equalTo(60 * Scale_W);
        make.height.mas_equalTo(18);
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
    
    //标志是否是自己发布
    UIImageView *personImageView = [[UIImageView alloc] init];
    [bgView addSubview:personImageView];
    [personImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(signImageView.mas_right).offset(KFit_W(10));
        make.width.height.mas_equalTo(signImageView);
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
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = RGBA(0, 0, 0, 1);
    nameLabel.numberOfLines = 0;
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(signImageView.mas_bottom).offset(24);
        make.left.mas_equalTo(signImageView);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(KFit_W(-140));
    }];
    _nameLabel = nameLabel;
    
    //地区
    UILabel *areaLabel = [[UILabel alloc] init];
    areaLabel.font = [UIFont systemFontOfSize:12];
    areaLabel.textColor = [UIColor colorWithHexString:@"#868686"];
    [bgView addSubview:areaLabel];
    [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.left.equalTo(nameLabel);
        make.height.mas_equalTo(12);
        make.right.mas_equalTo(nameLabel);
    }];
    _areaLabel = areaLabel;
    
    //一键呼叫按钮
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [callBtn setImage:[UIImage imageNamed:@"call_btn_110x25"] forState:UIControlStateNormal];
    [bgView addSubview:callBtn];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_top).offset(-5);
        make.right.mas_equalTo(-22 * Scale_W);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(110 * Scale_W);
    }];
    
    //多少人参与
    YYLabel *offerCount = [[YYLabel alloc] init];
    [bgView addSubview:offerCount];
    [offerCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(callBtn);
        make.top.mas_equalTo(areaLabel);
        make.height.mas_equalTo(12);
    }];
    _offerCount = offerCount;
    
    //标签
    UIImageView *labelImage = [[UIImageView alloc] init];
    [bgView insertSubview:labelImage belowSubview:callBtn];
    [labelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@42);
        make.height.mas_equalTo(@42);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    _labelImage = labelImage;
}

- (void)configMutableStrData:(AskToBuyModel *)model {
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
        _leftTimeLabel.backgroundColor = HEXColor(@"#E5E5E5", 1);
        _leftTimeLabel.font = [UIFont systemFontOfSize:15];
        _leftTimeLabel.textColor = HEXColor(@"#333333", 1);
        _leftTimeLabel.text = @"已完成";
        _leftTimeLabel.textAlignment = NSTextAlignmentCenter;
    } else {
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
        _leftTimeLabel.backgroundColor = [UIColor whiteColor];
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
        _leftTimeLabel.attributedText = mutableTime;
    }
    
    //数量
    NSString *count = model.num;
    NSString *unit = model.numUnit;
    NSString *countWithUnit = [NSString stringWithFormat:@"%@%@",count,unit];
    NSMutableAttributedString *mutableCount = [[NSMutableAttributedString alloc] initWithString:countWithUnit];
    [mutableCount yy_setFont:[UIFont systemFontOfSize:16] range:NSMakeRange(0, count.length)];
    mutableCount.yy_alignment = NSTextAlignmentCenter;
    [mutableCount yy_setFont:[UIFont systemFontOfSize:10] range:NSMakeRange(count.length , unit.length)];
    mutableCount.yy_color = HEXColor(@"#333333", 1);
    _countLabel.attributedText = mutableCount;
    //已有几家报价的数量
    NSString *number = model.offerNum;
    NSString *text = [NSString stringWithFormat:@"已有%@家参与报价",number];
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:text];
    mutableText.yy_font = [UIFont systemFontOfSize:12];
    mutableText.yy_color = [UIColor colorWithHexString:@"#5F5F5F"];
    [mutableText yy_setColor:[UIColor colorWithHexString:@"#FF7F00"] range:NSMakeRange(2, 1)];
    _offerCount.attributedText = mutableText;
}

- (void)setModel:(AskToBuyModel *)model {
    _model = model;
    [self configMutableStrData:model];
    //企业还是个人图片
    if ([model.publishType isEqualToString:@"企业发布"]) {
        _signImageView.image = [UIImage imageNamed:@"company_img"];
        _signLabel.text = @"企业用户";
    } else {
        _signImageView.image = [UIImage imageNamed:@"personal_img"];
        _signLabel.text = @"个人用户";
    }
    
    //是否是我发布
    if isRightData(model.isCharger) {
        if ([model.isCharger isEqualToString:@"1"]) {
            _personImageView.hidden = NO;
            _personLabel.hidden = NO;
            if ([model.publishType isEqualToString:@"企业发布"]) {
                _personImageView.image = [UIImage imageNamed:@"person_red"];
                _personLabel.textColor = HEXColor(@"#F10215", 1);
            } else {
                _personImageView.image = [UIImage imageNamed:@"person_blue"];
                _personLabel.textColor = HEXColor(@"#386FED", 1);
            }
            
        } else {
            _personImageView.hidden = YES;
            _personLabel.hidden = YES;
        }
    }
    
    //右上角标签
    if ([model.status isEqualToString:@"1"]) {
        _labelImage.image = [UIImage imageNamed:@"price_parity"];
    } else {
        _labelImage.image = [UIImage imageNamed:@"finish"];
    }
    //地区
    _areaLabel.text = [NSString stringWithFormat:@"地区: %@ %@",model.locationProvince,model.locationCity];
    //产品名称
    _nameLabel.text = model.productName;
}


- (void)callPhone {
    NSString *tel = [NSString stringWithFormat:@"tel://10086"];
    //开线程，解决ios10调用慢的问题
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:tel]];
        });
    });
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AskToBuyCell";
    AskToBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AskToBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
