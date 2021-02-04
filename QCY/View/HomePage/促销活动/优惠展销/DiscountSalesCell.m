//
//  DiscountSalesCell.m
//  QCY
//
//  Created by i7colors on 2019/1/14.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "DiscountSalesCell.h"
#import "DiscountSalesModel.h"
#import <UIImageView+WebCache.h>
#import <YYText.h>

@interface DiscountSalesCell()

@end

@implementation DiscountSalesCell {
    UIImageView *_productImg;
    UILabel *_productName;
    UILabel *_saleCount;
    YYLabel *_originPrice;
    YYLabel *_discountPrice;
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
        //        self.contentView.backgroundColor = RGBA(0, 0, 0, 0.1);
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    //图片
    UIImageView *productImg = [[UIImageView alloc] init];
    productImg.frame = CGRectMake(0, 0, 120, 120);
    [self.contentView addSubview:productImg];
    _productImg = productImg;
    
    //产品名字
    UILabel *productName = [[UILabel alloc] init];
    productName.font = [UIFont boldSystemFontOfSize:18];
    productName.frame = CGRectMake(productImg.right + 16, 10, SCREEN_WIDTH - productImg.width - 20, 20);
    [self.contentView addSubview:productName];
    _productName = productName;
    
    //销售数量
    UILabel *saleCount = [[UILabel alloc] init];
    saleCount.textColor = HEXColor(@"#868686", 1);
    saleCount.font = [UIFont systemFontOfSize:12];
    saleCount.frame = CGRectMake(productName.left, productName.bottom + 6, productName.width, 14);
    [self.contentView addSubview:saleCount];
    _saleCount = saleCount;
    
    //原价
    YYLabel *originPrice = [[YYLabel alloc] init];
    originPrice.frame = CGRectMake(productName.left, productImg.centerY + 5, productName.width, 16);
    [self.contentView addSubview:originPrice];
    _originPrice = originPrice;
    
    //现价
    YYLabel *discountPrice = [[YYLabel alloc] init];
    discountPrice.frame = CGRectMake(productName.left,originPrice.bottom + 7, productName.width, 20);
    [self.contentView addSubview:discountPrice];
    _discountPrice = discountPrice;
    
    //灰色间隔
    UIView *bottomGap = [[UIView alloc] init];
    bottomGap.backgroundColor = HEXColor(@"#010101", 0.15);
    bottomGap.frame = CGRectMake(0, 120, SCREEN_WIDTH, 10);
    [self.contentView addSubview:bottomGap];
}

- (void)setModel:(DiscountSalesModel *)model {
    _model = model;
    [_productImg sd_setImageWithURL:ImgUrl(model.productPic) placeholderImage:PlaceHolderImg];
    
    _productName.text = model.productName;
    
    _saleCount.text = [NSString stringWithFormat:@"已销售总量: %@吨",model.subscribedNum];
    
    //原价
    NSString *oPrice = model.oldPrice;
    NSString *oText = [NSString stringWithFormat:@"原价: ¥%@元/%@",oPrice,model.priceUnit];
    NSMutableAttributedString *mutableOriginal = [[NSMutableAttributedString alloc] initWithString:oText];
    mutableOriginal.yy_color = HEXColor(@"#868686", 1);
    mutableOriginal.yy_font = [UIFont systemFontOfSize:12];
    [mutableOriginal yy_setFont:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(5, oPrice.length)];
    NSRange range2 = [[mutableOriginal string] rangeOfString:oText options:NSCaseInsensitiveSearch];
    //下划线
    YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle
                                                                   width:@(1)
                                                                   color:HEXColor(@"#868686", 1)];
    //删除样式
    [mutableOriginal yy_setTextStrikethrough:decoration range:range2];
    _originPrice.attributedText = mutableOriginal;
    
    //现价
    NSString *cPrice = model.priceNew;
    NSString *cText = [NSString stringWithFormat:@"优惠价: ¥%@元/%@",cPrice,model.priceUnit];
    NSMutableAttributedString *mutablecurrent = [[NSMutableAttributedString alloc] initWithString:cText];
    mutablecurrent.yy_color = HEXColor(@"#F10215", 1);
    mutablecurrent.yy_font = [UIFont systemFontOfSize:12];
    [mutablecurrent yy_setFont:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(6, cPrice.length)];
    _discountPrice.attributedText = mutablecurrent;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"DiscountSalesCell";
    DiscountSalesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DiscountSalesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
