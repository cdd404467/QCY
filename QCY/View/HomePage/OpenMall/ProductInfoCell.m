//
//  ProductInfoCell.m
//  QCY
//
//  Created by i7colors on 2018/10/30.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProductInfoCell.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "HelperTool.h"
#import <YYText.h>
#import "OpenMallModel.h"
#import <YYWebImage.h>

@implementation ProductInfoCell {
    UIImageView *_productImageView;
    UILabel *_productName;
    UILabel *_areaLabel;
    UILabel *_logisticsLabel;
    UILabel *_countLabel;
    UILabel *_specLabel;
    YYLabel *_priceLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBA(0, 0, 0, 0.1);
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 6.f;
    bgView.frame = CGRectMake(KFit_W(9), 5, SCREEN_WIDTH - KFit_W(18), 120);
    [self.contentView addSubview:bgView];
    
    //产品图片
    UIImageView *productImageView = [[UIImageView alloc] init];
    productImageView.frame = CGRectMake(0, 0, 120, 120);
    [HelperTool setRound:productImageView corner:UIRectCornerTopLeft | UIRectCornerBottomLeft radiu:6];
    [bgView addSubview:productImageView];
    _productImageView = productImageView;

    //产品名称
    UILabel *productName = [[UILabel alloc] init];
    productName.font = [UIFont boldSystemFontOfSize:12];
    productName.numberOfLines = 2;
    [bgView addSubview:productName];
    [productName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.left.mas_equalTo(productImageView.mas_right).offset(10);
        make.right.mas_equalTo(-5);
//        make.height.mas_equalTo(38);
    }];
    _productName = productName;

    //地区
    UILabel *areaLabel = [[UILabel alloc] init];
    areaLabel.font = [UIFont boldSystemFontOfSize:10];
    areaLabel.textColor = HEXColor(@"#868686", 1);
    [bgView addSubview:areaLabel];
    [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(productName);
        make.height.mas_equalTo(12);
        make.width.mas_equalTo(KFit_W(90));
        make.top.mas_equalTo(46);
    }];
    _areaLabel = areaLabel;

    //物流
    UILabel *logisticsLabel = [[UILabel alloc] init];
    logisticsLabel.font = [UIFont boldSystemFontOfSize:10];
    logisticsLabel.textColor = HEXColor(@"#868686", 1);
    [bgView addSubview:logisticsLabel];
    [logisticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(areaLabel.mas_right).offset(5);
        make.height.top.mas_equalTo(areaLabel);
        make.right.mas_equalTo(productName);
    }];
    _logisticsLabel = logisticsLabel;

    //起卖数量
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.font = [UIFont boldSystemFontOfSize:10];
    countLabel.textColor = HEXColor(@"#868686", 1);
    [bgView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(areaLabel);
        make.top.mas_equalTo(areaLabel.mas_bottom).offset(5);
    }];
    _countLabel = countLabel;

    //规格
    UILabel *specLabel = [[UILabel alloc] init];
    specLabel.font = [UIFont boldSystemFontOfSize:10];
    specLabel.textColor = HEXColor(@"#868686", 1);
    [bgView addSubview:specLabel];
    [specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(logisticsLabel);
        make.top.mas_equalTo(countLabel);
    }];
    _specLabel = specLabel;

    //价格
    YYLabel *priceLabel = [[YYLabel alloc] init];
    [bgView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-18);
        make.left.right.mas_equalTo(productName);
        make.height.mas_equalTo(16);
    }];
    _priceLabel = priceLabel;
    
}

- (void)setModel:(ProductInfoModel *)model {
    _model = model;
    
    //公司头像
    if isRightData(model.pic) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic]];
        [_productImageView yy_setImageWithURL:url options:YYWebImageOptionSetImageWithFadeAnimation];
    }
    
    //产品名称
    if isRightData(model.productName)
        _productName.text = model.productName;
    
    
    //规格
    if isRightData(model.pack)
        _specLabel.text = [NSString stringWithFormat:@"包装规格: %@",model.pack];
    
    //价格
    if (isRightData(@(model.price).stringValue) && [model.displayPrice isEqualToString:@"1"]){
        NSString *price = [self getStringFrom:model.price];
        
        NSString *text = [NSString stringWithFormat:@"¥ %@/KG",price];
        NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:text];
        mutableText.yy_color = HEXColor(@"#F10215", 1);
        mutableText.yy_font = [UIFont systemFontOfSize:12];
        [mutableText yy_setFont:[UIFont systemFontOfSize:18] range:NSMakeRange(2, price.length)];
        _priceLabel.attributedText = mutableText;
    } else {
        NSString *text = @"议价";
        NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:text];
        mutableText.yy_color = HEXColor(@"#F10215", 1);
        mutableText.yy_font = [UIFont systemFontOfSize:14];
        _priceLabel.attributedText = mutableText;
    }
   
}

-(NSString*)getStringFrom:(double)doubleVal {
    NSString* stringValue = @"0.00";
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.usesSignificantDigits = true;
    formatter.maximumSignificantDigits = 100;
    formatter.groupingSeparator = @"";
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    stringValue = [formatter stringFromNumber:@(doubleVal)];
    
    return stringValue;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ProductInfoCell";
    ProductInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ProductInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
