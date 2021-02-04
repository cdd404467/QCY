//
//  ProxySaleMarketCell.m
//  QCY
//
//  Created by i7colors on 2020/3/24.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProxySaleMarketCell.h"
#import <UIImageView+WebCache.h>
#import "ProxySaleModel.h"
#import <YYText.h>

@implementation ProxySaleMarketCell {
    UIImageView *_productImg;
    UILabel *_productName;
    UILabel *_inventoryLab;
    YYLabel *_nowPriceLab;
    UILabel *_packLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    productName.font = [UIFont boldSystemFontOfSize:15];
    productName.frame = CGRectMake(productImg.right + 16, 10, SCREEN_WIDTH - productImg.width - 20, 20);
    [self.contentView addSubview:productName];
    _productName = productName;
    
    //库存量
    UILabel *inventoryLab = [[UILabel alloc] init];
    inventoryLab.textColor = HEXColor(@"#868686", 1);
    inventoryLab.font = [UIFont systemFontOfSize:12];
    inventoryLab.frame = CGRectMake(productName.left, productName.bottom + 8, KFit_W(95), 14);
    [self.contentView addSubview:inventoryLab];
    _inventoryLab = inventoryLab;
    
    //包装
    UILabel *packLab = [[UILabel alloc] init];
    packLab.textColor = HEXColor(@"#868686", 1);
    packLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:packLab];
    [packLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inventoryLab.mas_right).offset(15);
        make.right.mas_equalTo(productName);
        make.height.centerY.mas_equalTo(inventoryLab);
    }];
    _packLab = packLab;
    
    //现价
    YYLabel *nowPriceLab = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 23)];
    nowPriceLab.layer.borderColor = HEXColor(@"#ED3851", 1).CGColor;
    nowPriceLab.layer.borderWidth = 1.f;
    nowPriceLab.layer.cornerRadius = 23 / 2;
    nowPriceLab.bottom = productImg.bottom - 6;
    [self.contentView addSubview:nowPriceLab];
    _nowPriceLab = nowPriceLab;
    
    //灰色间隔
    UIView *bottomGap = [[UIView alloc] init];
    bottomGap.backgroundColor = HEXColor(@"#010101", 0.15);
    bottomGap.frame = CGRectMake(0, 120, SCREEN_WIDTH, 10);
    [self.contentView addSubview:bottomGap];
}

- (void)setModel:(ProxySaleModel *)model {
    _model = model;
    [_productImg sd_setImageWithURL:ImgUrl(model.productPic) placeholderImage:PlaceHolderImg];

    _productName.text = model.productName;
    
    _inventoryLab.text = [NSString stringWithFormat:@"库存量: %@%@",model.remainNum,model.numUnit];
    
    _packLab.text = [NSString stringWithFormat:@"包装:%@",_model.pack];
    
    //现价
    NSString *nowPrice = [NSString stringWithFormat:@"     现价: ¥ %@%@     ",model.price,model.priceUnit];
    NSMutableAttributedString *mutableNowPrice = [[NSMutableAttributedString alloc] initWithString:nowPrice];
    mutableNowPrice.yy_font = [UIFont systemFontOfSize:11];
    mutableNowPrice.yy_color = HEXColor(@"#F10215", 1);
    [mutableNowPrice yy_setFont:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(11, model.price.length)];
    _nowPriceLab.attributedText = mutableNowPrice;
    CGSize introSize = CGSizeMake(CGFLOAT_MAX, _nowPriceLab.height);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:mutableNowPrice];
    _nowPriceLab.textLayout = layout;
    CGFloat width1 = layout.textBoundingSize.width;
    _nowPriceLab.width = width1;
    _nowPriceLab.left = SCREEN_WIDTH - width1 - 8;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ProxySaleMarketCell";
    ProxySaleMarketCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ProxySaleMarketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
