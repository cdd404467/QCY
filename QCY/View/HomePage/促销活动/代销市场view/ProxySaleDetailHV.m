//
//  ProxySaleDetailHV.m
//  QCY
//
//  Created by i7colors on 2020/3/24.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProxySaleDetailHV.h"
#import "ProxySaleModel.h"
#import <YYText.h>
#import "UIView+Border.h"
#import <UIImageView+WebCache.h>

@implementation ProxySaleDetailHV {
    UIImageView *_productImageView;
    YYLabel *_remainLab;
    YYLabel *_salePrice;
    UILabel *_nameLab;
    YYLabel *_saleLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    CGFloat perHeight = KFit_W(250) / 3;
    
    UIImageView *productImageView = [[UIImageView alloc] init];
    productImageView.frame = CGRectMake(0, 0, KFit_W(250), floor(KFit_W(250)));
    [self addSubview:productImageView];
    _productImageView = productImageView;
    
    //已销售量
    UIView *saleView = [[UIView alloc] init];
    saleView.backgroundColor = [UIColor whiteColor];
    saleView.frame = CGRectMake(productImageView.right, 0, SCREEN_WIDTH - productImageView.width, perHeight);
    [saleView addBorderView:LineColor width:1.0 direction:BorderDirectionBottom];
    [self addSubview:saleView];
    
    YYLabel *saleLab = [[YYLabel alloc] init];
    [saleView addSubview:saleLab];
    saleLab.numberOfLines = 2;
    saleLab.frame = CGRectMake(0, 5, saleView.width, saleView.height - 10);
    _saleLab = saleLab;
    
    
    //库存View
    UIView *remainView = [[UIView alloc] init];
    remainView.backgroundColor = [UIColor whiteColor];
    remainView.frame = CGRectMake(productImageView.right, perHeight, SCREEN_WIDTH - productImageView.width, perHeight);
    [remainView addBorderView:LineColor width:1.0 direction:BorderDirectionBottom];
    [self addSubview:remainView];
    
    YYLabel *remainLab = [[YYLabel alloc] init];
    [remainView addSubview:remainLab];
    remainLab.numberOfLines = 2;
    remainLab.frame = CGRectMake(0, 5, remainView.width, remainView.height - 10);
    _remainLab = remainLab;
    
    //优惠价
    UIImage *image = [UIImage imageNamed:@"price_bg"];
    UIImageView *priceView = [[UIImageView alloc] init];
    priceView.frame = CGRectMake(productImageView.frame.size.width - 10, remainView.bottom, remainView.width + 10, remainView.height);
    priceView.image = image;
    [self addSubview:priceView];
    
    
    YYLabel *salePrice = [[YYLabel alloc] init];
    salePrice.numberOfLines = 0;
    salePrice.frame = CGRectMake(10, 5, priceView.width, priceView.height - 10);
    [priceView addSubview:salePrice];
    _salePrice = salePrice;
    
    //产品名字
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(11, productImageView.bottom + 15, SCREEN_WIDTH - 10 * 2, 15)];
    _nameLab.numberOfLines = 0;
    _nameLab.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:_nameLab];
}


- (void)setDataSource:(ProxySaleModel *)dataSource {
    _dataSource = dataSource;
    [_productImageView sd_setImageWithURL:ImgUrl(dataSource.productPic) placeholderImage:PlaceHolderImg];
    
    //已销售总量
    NSString *saleTxt = @"已售量:";
    NSString *s_text = [NSString stringWithFormat:@"%@%@%@",saleTxt,dataSource.subscribedNum,dataSource.numUnit];
    NSMutableAttributedString *mutableText_sale = [[NSMutableAttributedString alloc] initWithString:s_text];
    mutableText_sale.yy_color = HEXColor(@"#868686", 1);
    mutableText_sale.yy_alignment = NSTextAlignmentCenter;
    mutableText_sale.yy_font = [UIFont systemFontOfSize:12];
    [mutableText_sale yy_setFont:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(saleTxt.length, dataSource.subscribedNum.length)];
    [mutableText_sale yy_setColor:HEXColor(@"#ED3851", 1) range:NSMakeRange(saleTxt.length, dataSource.subscribedNum.length)];
    _saleLab.attributedText = mutableText_sale;
    
    //库存量
    NSString *txt = @"库存量:";
    NSString *cText = [NSString stringWithFormat:@"%@%@%@",txt,dataSource.remainNum,dataSource.numUnit];
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:cText];
    mutableText.yy_color = HEXColor(@"#868686", 1);
    mutableText.yy_alignment = NSTextAlignmentCenter;
    mutableText.yy_font = [UIFont systemFontOfSize:12];
    [mutableText yy_setFont:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(txt.length, dataSource.remainNum.length)];
    _remainLab.attributedText = mutableText;
    
    //销售价
    NSString *salePrice = dataSource.price;
    NSString *saleText = [NSString stringWithFormat:@"销售价¥\n%@元/%@",salePrice,_dataSource.priceUnit];
    NSMutableAttributedString *mutableSale = [[NSMutableAttributedString alloc] initWithString:saleText];
    mutableSale.yy_color = [UIColor whiteColor];
    mutableSale.yy_alignment = NSTextAlignmentCenter;
    mutableSale.yy_font = [UIFont systemFontOfSize:14];
    [mutableSale yy_setFont:[UIFont boldSystemFontOfSize:22] range:NSMakeRange(5, salePrice.length)];
    _salePrice.attributedText = mutableSale;
    
    //产品名字
    CGFloat nameHeight = [dataSource.productName boundingRectWithSize:CGSizeMake(_nameLab.width, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName : _nameLab.font}
                                                  context:nil].size.height;
    
    _nameLab.height = nameHeight;
    _nameLab.text = dataSource.productName;
    _viewHeight = _nameLab.bottom + NAV_HEIGHT +15;
}

@end

