//
//  supplierQuotationCell.m
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "supplierQuotationCell.h"
#import "HomePageModel.h"

@interface supplierQuotationCell ()
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *contactLabel;
@property (nonatomic, strong) UILabel *yfLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIButton *cBtn;
@property (nonatomic, strong) UIView *infoView;
@end

@implementation supplierQuotationCell {
    UIImageView *_signImageView;
    UILabel *_signLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = Main_BgColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *companyView = [[UIView alloc] init];
    companyView.frame = CGRectMake(13, 5, SCREEN_WIDTH - 13 * 2, 40);
    companyView.layer.shadowColor = RGBA(0, 0, 0, 0.1).CGColor;
    companyView.layer.shadowOffset = CGSizeMake(0, 2);
    companyView.layer.shadowOpacity = 1.0f;
    companyView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:companyView];
    
    //标志企业还是个人的图片
    UIImageView *signImageView = [[UIImageView alloc] init];
    [companyView addSubview:signImageView];
    [signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(60);
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
    
    //公司名字
    UILabel *companyName = [[UILabel alloc] init];
    companyName.font = [UIFont systemFontOfSize:12];
    companyName.textColor = HEXColor(@"#818181", 1);
    companyName.textAlignment = NSTextAlignmentCenter;
    companyName.numberOfLines = 2;
    [companyView addSubview:companyName];
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.height.mas_equalTo(companyView);
        make.width.mas_equalTo(SCREEN_WIDTH - 95 * 2);
    }];
    _companyName = companyName;
    
    //采纳和未采纳按钮
    UIButton *cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    cBtn.layer.borderWidth = 1.f;
    cBtn.layer.cornerRadius = 11;
    [cBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [companyView addSubview:cBtn];
    [cBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(52);
        make.centerY.mas_equalTo(companyView);
    }];
    _cBtn = cBtn;
    
    UIView *infoView = [[UIView alloc] init];
    infoView.frame = CGRectMake(companyView.left, companyView.bottom, companyView.width, 60);
    infoView.backgroundColor = [UIColor whiteColor];
    [self.contentView insertSubview:infoView belowSubview:companyView];
    _infoView = infoView;
    
    //价格
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.frame = CGRectMake(27, 8, infoView.width - 30, 11);
    priceLabel.font = [UIFont systemFontOfSize:11];
    priceLabel.textColor = HEXColor(@"#505050", 1);
    [infoView addSubview:priceLabel];
    _priceLabel = priceLabel;
    
    //联系方式
    UILabel *contactLabel = [[UILabel alloc] init];
    contactLabel.frame = CGRectMake(priceLabel.left, priceLabel.bottom + 5, infoView.width - 30, priceLabel.height);
    contactLabel.font = priceLabel.font;
    contactLabel.textColor = priceLabel.textColor;
    [infoView addSubview:contactLabel];
    _contactLabel = contactLabel;
    
    //报价时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.frame = CGRectMake(priceLabel.left, contactLabel.bottom + 5, infoView.width - 30, priceLabel.height);
    timeLabel.font = priceLabel.font;
    timeLabel.textColor = priceLabel.textColor;
    [infoView addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    //运费
    UILabel *yfLabel = [[UILabel alloc] init];
    yfLabel.frame = CGRectMake(priceLabel.left, timeLabel.bottom + 5, infoView.width - 30, priceLabel.height);
    yfLabel.font = priceLabel.font;
    yfLabel.textColor = priceLabel.textColor;
    [infoView addSubview:yfLabel];
    _yfLabel = yfLabel;
    
    //报价说明
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.frame = CGRectMake(priceLabel.left, yfLabel.bottom + 5, infoView.width - 30, priceLabel.height);
    desLabel.font = priceLabel.font;
    desLabel.textColor = priceLabel.textColor;
    [infoView addSubview:desLabel];
    _desLabel = desLabel;
    
    //没有报价的时候
    UILabel *noneLabel = [[UILabel alloc] init];
    noneLabel.hidden = YES;
    noneLabel.textAlignment = NSTextAlignmentCenter;
    noneLabel.backgroundColor = [UIColor whiteColor];
    noneLabel.font = [UIFont systemFontOfSize:14];
    noneLabel.text = @"暂无供应商报价";
    [self.contentView addSubview:noneLabel];
    [noneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(companyView);
        make.top.bottom.mas_equalTo(0);
    }];
    _noneLabel = noneLabel;
    
}

- (void)setModel:(AskToBuyModel *)model {
    _model = model;
}


- (void)setModel_sup:(supOrrerModel *)model_sup {
    _model_sup = model_sup;
    /*** 供应商报价列表 ***/
    /*** 求购ststus 1 2 3，报价0 1 2 ***/
    //价格
    if isRightData(model_sup.price) {
        _priceLabel.text = [NSString stringWithFormat:@"价格: %@/KG",model_sup.price];
    } else {
        _priceLabel.text = @"价格: 保密";
    }
    
    //判断报价供应商企业还是个人
    if ([model_sup.publishType isEqualToString:@"企业发布"]) {
        //        area = model.companyDomain.provinceName;
        _companyName.text = model_sup.companyDomain.companyName;
        _signImageView.image = [UIImage imageNamed:@"company_img"];
        _signLabel.text = @"企业用户";
    } else {
        //        area = @"***";
        _companyName.text = model_sup.companyName2;
        _signImageView.image = [UIImage imageNamed:@"personal_img"];
        _signLabel.text = @"个人用户";
    }
    
    //联系方式
    _contactLabel.text = [NSString stringWithFormat:@"联系方式: %@",model_sup.phone];
    //报价时间
    _timeLabel.text = [NSString stringWithFormat:@"报价时间: %@",model_sup.createdAtString];
    //运费
    NSString *str = [model_sup.isIncludeTrans isEqualToString:@"1"] ? @"包含运费" : @"不包含运费";
    _yfLabel.text = [@"运费: " stringByAppendingString:str];
    //报价说明
    NSString *desText = isRightData(model_sup.descriptionStr) == YES ? model_sup.descriptionStr : @"暂无说明";
    _desLabel.text = [@"报价说明: " stringByAppendingString:desText];
    
    if ([_model.isCharger isEqualToString:@"1"]) {
        _yfLabel.hidden = NO;
        _desLabel.hidden = NO;
        CGFloat height = [_timeLabel.text boundingRectWithSize:CGSizeMake(_desLabel.width, MAXFLOAT)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:_desLabel.font}
                                                          context:nil].size.height;
        _desLabel.height = height;
        _infoView.height = _desLabel.bottom + 8;
    } else {
        _yfLabel.hidden = YES;
        _desLabel.hidden = YES;
        _infoView.height = _timeLabel.bottom + 8;
    }
    model_sup.cellHeight = _infoView.bottom;
    
    //判断按钮状态
    //如果登录
    if (GET_USER_TOKEN) {
        _cBtn.hidden = NO;
        //是我自己发布的求购
        if ([_model.isCharger isEqualToString:@"1"]) {
            //我的求购在进行中
            if ([_model.status isEqualToString:@"1"]) {
                //报价进行中
                if ([model_sup.status isEqualToString:@"0"]) {
                    [_cBtn setTitle:@"采纳" forState:UIControlStateNormal];
                    [_cBtn setTitleColor:HEXColor(@"#ED3851", 1) forState:UIControlStateNormal];
                    _cBtn.layer.borderColor = HEXColor(@"#ED3851", 1).CGColor;
                    _cBtn.enabled = YES;
                } else if ([model_sup.status isEqualToString:@"1"]) {
                    [_cBtn setTitle:@"已采纳" forState:UIControlStateNormal];
                    [_cBtn setTitleColor:RGBA(0, 0, 0, 0.2) forState:UIControlStateNormal];
                    _cBtn.layer.borderColor = RGBA(0, 0, 0, 0.2).CGColor;
                    _cBtn.enabled = NO;
                } else {
                    [_cBtn setTitle:@"已关闭" forState:UIControlStateNormal];
                    [_cBtn setTitleColor:RGBA(0, 0, 0, 0.2) forState:UIControlStateNormal];
                    _cBtn.layer.borderColor = RGBA(0, 0, 0, 0.2).CGColor;
                    _cBtn.enabled = NO;
                }
            }
            //我的求购已经关闭了
            else {
                if ([model_sup.status isEqualToString:@"1"]) {
                    [_cBtn setTitle:@"已采纳" forState:UIControlStateNormal];
                    [_cBtn setTitleColor:RGBA(0, 0, 0, 0.2) forState:UIControlStateNormal];
                    _cBtn.layer.borderColor = RGBA(0, 0, 0, 0.2).CGColor;
                    _cBtn.enabled = NO;
                } else {
                    [_cBtn setTitle:@"未采纳" forState:UIControlStateNormal];
                    [_cBtn setTitleColor:RGBA(0, 0, 0, 0.2) forState:UIControlStateNormal];
                    _cBtn.layer.borderColor = RGBA(0, 0, 0, 0.2).CGColor;
                    _cBtn.enabled = NO;
                }
            }
        }
        //不是个人
        else {
            _cBtn.hidden = YES;
        }
    }
    //如果未登录
    else {
        _cBtn.hidden = YES;
    }
    
}

- (void)btnClick {
    if (self.cbtnClickBlock) {
        self.cbtnClickBlock(_model_sup.offerID);
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"supplierQuotationCell";
    supplierQuotationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[supplierQuotationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
