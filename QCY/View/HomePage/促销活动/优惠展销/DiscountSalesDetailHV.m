//
//  DiscountSalesDetailHV.m
//  QCY
//
//  Created by i7colors on 2019/1/16.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "DiscountSalesDetailHV.h"
#import "UIView+Border.h"
#import <UIImageView+WebCache.h>
#import "DiscountSalesModel.h"
#import <YYText.h>
#import "HelperTool.h"

@implementation DiscountSalesDetailHV {
    UIImageView *_productImageView;
    YYLabel *_totalLabel;
    YYLabel *_originPrice;
    YYLabel *_salePrice;
    UILabel *_productName;
    UILabel *_saleAlready;
    UIView *_view_two;
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
    
    //已经销售的总量
    UIView *totalCountSale = [[UIView alloc] init];
    totalCountSale.backgroundColor = [UIColor whiteColor];
    totalCountSale.frame = CGRectMake(productImageView.right, 0, SCREEN_WIDTH - productImageView.width, perHeight);
    [totalCountSale addBorderView:LineColor width:1.0 direction:BorderDirectionBottom];
    [self addSubview:totalCountSale];
    
    YYLabel *totalLabel = [[YYLabel alloc] init];
    [totalCountSale addSubview:totalLabel];
    totalLabel.numberOfLines = 2;
    totalLabel.frame = CGRectMake(0, 5, totalCountSale.width, totalCountSale.height - 10);
    _totalLabel = totalLabel;
    
    //原价
    UIView *originView = [[UIView alloc] init];
    originView.backgroundColor = [UIColor whiteColor];
    originView.frame = CGRectMake(totalCountSale.left, totalCountSale.bottom, totalCountSale.width, totalCountSale.height);
    [self addSubview:originView];
    
    YYLabel *originPrice = [[YYLabel alloc] init];
    originPrice.frame = CGRectMake(0, 5, originView.width, originView.height - 10);
    [originView addSubview:originPrice];
    _originPrice = originPrice;
    
    //优惠价
    UIImage *image = [UIImage imageNamed:@"price_bg"];
    UIImageView *discountPriceView = [[UIImageView alloc] init];
    discountPriceView.frame = CGRectMake(productImageView.frame.size.width - 10, originView.bottom, originView.width + 10, originView.height);
    discountPriceView.image = image;
    [self addSubview:discountPriceView];
    
    YYLabel *salePrice = [[YYLabel alloc] init];
    salePrice.numberOfLines = 0;
    salePrice.frame = CGRectMake(10, 5, originView.width, discountPriceView.height - 10);
    [discountPriceView addSubview:salePrice];
    _salePrice = salePrice;
    
    //产品名字 + 销售总量
    UIView *view_one = [[UIView alloc] init];
    view_one.backgroundColor = [UIColor whiteColor];
    view_one.frame = CGRectMake(0, productImageView.bottom, SCREEN_WIDTH, 80);
    [view_one addBorderView:LineColor width:0.8f direction:BorderDirectionBottom];
    [self addSubview:view_one];
    
    UIView *view_two = [[UIView alloc] init];
    view_two.backgroundColor = [UIColor whiteColor];
    view_two.frame = CGRectMake(0, view_one.bottom, SCREEN_WIDTH, 70);
    [self addSubview:view_two];
    _view_two = view_two;
    
    //产品名字
    UILabel *productName = [[UILabel alloc] init];
    productName.frame = CGRectMake(15, 18, SCREEN_WIDTH - 20, 20);
    productName.textColor = [UIColor blackColor];
    productName.font = [UIFont boldSystemFontOfSize:18];
    [view_one addSubview:productName];
    _productName = productName;
    UILabel *saleAlready = [[UILabel alloc] init];
    saleAlready.frame = CGRectMake(productName.left, productName.bottom + 9, productName.width, 14);
    saleAlready.textColor = HEXColor(@"#868686", 1);
    saleAlready.font = [UIFont systemFontOfSize:13];
    [view_one addSubview:saleAlready];
    _saleAlready = saleAlready;
}

- (void)setDataSource:(DiscountSalesModel *)dataSource {
    _dataSource = dataSource;
    [_productImageView sd_setImageWithURL:ImgUrl(dataSource.productPic) placeholderImage:PlaceHolderImg];
    //已销售总量
    NSString *cPrice = dataSource.subscribedNum;
    NSString *unit = dataSource.numUnit;
    NSString *cText = [NSString stringWithFormat:@"%@%@\n已销售总量",cPrice,unit];
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:cText];
    mutableText.yy_color = HEXColor(@"#ED3851", 1);
    mutableText.yy_alignment = NSTextAlignmentCenter;
    mutableText.yy_font = [UIFont systemFontOfSize:12];
    [mutableText yy_setFont:[UIFont boldSystemFontOfSize:28] range:NSMakeRange(0, cPrice.length)];
    [mutableText yy_setFont:[UIFont systemFontOfSize:16] range:NSMakeRange(cPrice.length, unit.length)];
    _totalLabel.attributedText = mutableText;
    
    //原价
    NSString *oPrice = _dataSource.oldPrice;
    NSString *oText = [NSString stringWithFormat:@"原价: ¥%@元/%@",oPrice,_dataSource.priceUnit];
    NSMutableAttributedString *mutableOriginal = [[NSMutableAttributedString alloc] initWithString:oText];
    mutableOriginal.yy_alignment = NSTextAlignmentCenter;
    mutableOriginal.yy_color = HEXColor(@"#868686", 1);
    mutableOriginal.yy_font = [UIFont systemFontOfSize:12];
    [mutableOriginal yy_setFont:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(5, oPrice.length)];
    NSRange range2 = [[mutableOriginal string] rangeOfString:oText options:NSCaseInsensitiveSearch];
    //下划线
    YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle
                                                                   width:@(1)
                                                                   color:RGBA(0, 0, 0, 0.5)];
    //删除样式
    [mutableOriginal yy_setTextStrikethrough:decoration range:range2];
    _originPrice.attributedText = mutableOriginal;
    
    //优惠价
    NSString *salePrice = dataSource.priceNew;
    NSString *saleText = [NSString stringWithFormat:@"优惠价¥\n%@元/%@",salePrice,_dataSource.priceUnit];
    NSMutableAttributedString *mutableSale = [[NSMutableAttributedString alloc] initWithString:saleText];
    mutableSale.yy_color = [UIColor whiteColor];
    mutableSale.yy_alignment = NSTextAlignmentCenter;
    mutableSale.yy_font = [UIFont systemFontOfSize:14];
    [mutableSale yy_setFont:[UIFont boldSystemFontOfSize:22] range:NSMakeRange(5, salePrice.length)];
    _salePrice.attributedText = mutableSale;
    
    //产品名字和销售量
    _productName.text = dataSource.productName;
    _saleAlready.text = [NSString stringWithFormat:@"已销售总量: %@%@",dataSource.subscribedNum,dataSource.numUnit];
    
    //优惠箭头
    NSInteger count = dataSource.listPrice.count;
    if (count == 0)
        return;
    CGFloat leftGap = 2.f;
    CGFloat overlap = 28.f;
    CGFloat width = (SCREEN_WIDTH - leftGap * 2 + overlap * 2) / 3;
    CGFloat labelLeft = 24.f;
    for (NSInteger i = 0; i < count; i ++) {
        ListPrice *model = dataSource.listPrice[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"ds_right_arrow"];
        imageView.frame = CGRectMake(leftGap + i * (width - overlap), 10, width, 50);
        [_view_two addSubview:imageView];
        
        UILabel *countLabel = [[UILabel alloc] init];
//        countLabel.numberOfLines = 2;
        countLabel.textAlignment = NSTextAlignmentCenter;
        countLabel.text = [NSString stringWithFormat:@"%@",model.salesNum];
        countLabel.frame = CGRectMake(labelLeft, 10, width - labelLeft * 2 + 7, 12);
        countLabel.font = [UIFont systemFontOfSize:9];
        countLabel.textColor = [UIColor blackColor];
        [imageView addSubview:countLabel];
        
        UILabel *priceLabel = [[UILabel alloc] init];
//        priceLabel.numberOfLines = 2;
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.text = [NSString stringWithFormat:@"优惠价:¥%@元/%@",[HelperTool getStringFrom:model.salesPrice],dataSource.priceUnit];
        priceLabel.frame = CGRectMake(countLabel.left, 50 - 10 - countLabel.height, countLabel.width, countLabel.height);
        priceLabel.font = countLabel.font;
        priceLabel.textColor = HEXColor(@"#F10215", 1);
        [imageView addSubview:priceLabel];
    }
    
}

@end
