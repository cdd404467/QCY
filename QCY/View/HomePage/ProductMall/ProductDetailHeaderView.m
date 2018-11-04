//
//  ProductDetailHeaderView.m
//  QCY
//
//  Created by i7colors on 2018/10/31.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProductDetailHeaderView.h"
#import "MacroHeader.h"
#import <YYText.h>
#import <Masonry.h>
#import "HelperTool.h"
#import "HYBImageCliped.h"
#import "UIView+Border.h"

@implementation ProductDetailHeaderView {
    UIImageView *_headerImageView;
    YYLabel *_companyName;
    YYLabel *_priceLabel;
    YYLabel *_product_ch_name;
    YYLabel *_product_en_name;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self configData];
    }
    
    return self;
}

- (void)setupUI {
    
    //名字
    YYLabel *companyName = [[YYLabel alloc] init];
    companyName.backgroundColor = [UIColor whiteColor];
    companyName.frame = CGRectMake(0, 0, KFit_W(310), 40);
    [companyName addBorderLayer:LineColor width:1.f direction:BorderDirectionBottom];
    [self addSubview:companyName];
    _companyName = companyName;
    
//    //收藏按钮
//    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    collectBtn.frame = CGRectMake(companyName.frame.size.width, 0, width, 40);
//    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
//    [collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
//    [collectBtn setTitleColor:HEXColor(@"#868686", 1) forState:UIControlStateNormal];
//    [collectBtn setTitleColor:MainColor forState:UIControlStateSelected];
//    collectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [collectBtn addBorderLayer:LineColor width:1.f direction: BorderDirectionLeft | BorderDirectionBottom];
//    [self addSubview:collectBtn];
    
    //右边分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.backgroundColor = [UIColor whiteColor];
    shareBtn.frame = CGRectMake(companyName.frame.size.width , 0, SCREEN_WIDTH - companyName.frame.size.width, 40);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:HEXColor(@"#868686", 1) forState:UIControlStateNormal];
    shareBtn.layer.shadowColor = RGBA(0, 0, 0, 0.1).CGColor;
    shareBtn.layer.shadowOffset = CGSizeMake(0, 8);
    shareBtn.layer.shadowOpacity = 1.0f;
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [shareBtn addBorderLayer:LineColor width:1.f direction:BorderDirectionLeft];
    [self addSubview:shareBtn];
    
    //图片
    UIImageView *productImage = [[UIImageView alloc] init];
    productImage.image = [UIImage imageNamed:@"test1"];
    productImage.frame = CGRectMake(0, 40, KFit_W(250), KFit_H(210));
    [productImage addBorderLayer:LineColor width:1.f direction:BorderDirectionBottom];
    [self addSubview:productImage];
    
    //加入购物车按钮
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    collectBtn.backgroundColor = [UIColor whiteColor];
    collectBtn.frame = CGRectMake(productImage.frame.size.width, 40, SCREEN_WIDTH - productImage.frame.size.width, productImage.frame.size.height / 2);
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setTitleColor:HEXColor(@"#333333", 1) forState:UIControlStateNormal];
    [collectBtn addBorderLayer:LineColor width:1.f direction:BorderDirectionLeft];
    collectBtn.titleEdgeInsets = UIEdgeInsetsMake(collectBtn.imageView.frame.size.height, -collectBtn.imageView.frame.size.width, 0, 0);
    collectBtn.imageEdgeInsets = UIEdgeInsetsMake(-collectBtn.imageView.frame.size.height, 0, 0, -collectBtn.titleLabel.bounds.size.width);
    [self addSubview:collectBtn];
    
    //价格 - view
    UIView *priceView = [[UIView alloc] init];
    priceView.frame = CGRectMake(SCREEN_WIDTH - KFit_W(134), 40 + collectBtn.frame.size.height, KFit_W(134), collectBtn.frame.size.height);
    //推荐这种方式设置背景，减少内存占用
    UIImage *image = [UIImage imageNamed:@"price_bg"];
    priceView.layer.contents = (id)image.CGImage;
    [self addSubview:priceView];
    
    //价格 - label
    YYLabel *priceLabel = [[YYLabel alloc] init];
    [priceView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(9);
    }];
    _priceLabel = priceLabel;
    
    //产品描述
    UIView *priceBg = [[UIView alloc] init];
    priceBg.backgroundColor = [UIColor whiteColor];
    priceBg.layer.shadowColor = RGBA(0, 0, 0, 0.1).CGColor;
    priceBg.layer.shadowOffset = CGSizeMake(0, 8);
    priceBg.layer.shadowOpacity = 1.0f;
    priceBg.frame = CGRectMake(0, 40 + productImage.frame.size.height, SCREEN_WIDTH, 60);
    [self addSubview:priceBg];
    
    //产品中文名称
    YYLabel *product_ch_name = [[YYLabel alloc] init];
    product_ch_name.font = [UIFont boldSystemFontOfSize:14];
    product_ch_name.textColor = [UIColor blackColor];
    [priceBg addSubview:product_ch_name];
    [product_ch_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(KFit_W(11));
    }];
    _product_ch_name = product_ch_name;
    //产品英文名称
    YYLabel *product_en_name = [[YYLabel alloc] init];
    product_en_name.font = [UIFont systemFontOfSize:12];
    product_en_name.textColor = HEXColor(@"#868686", 1);
    [priceBg addSubview:product_en_name];
    [product_en_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(product_ch_name.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.left.equalTo(product_ch_name);
    }];
    _product_en_name = product_en_name;
    

}

- (void)configData {
    NSString *text = @"盐城东吴化工有限公司";
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:text];
    mutableText.yy_font = [UIFont boldSystemFontOfSize:14];
    mutableText.yy_firstLineHeadIndent = 12.0;
    _companyName.attributedText = mutableText;
    
    //价格
    NSString *price = @"34.5";
    NSString *unit = @"/公斤";
    NSString *attPrice = [NSString stringWithFormat:@"¥%@%@",price,unit];
    NSMutableAttributedString *mutablePrice = [[NSMutableAttributedString alloc] initWithString:attPrice];
    mutablePrice.yy_color = [UIColor whiteColor];
    [mutablePrice yy_setFont:[UIFont systemFontOfSize:18] range:NSMakeRange(0, 1)];
    [mutablePrice yy_setFont:[UIFont systemFontOfSize:30] range:NSMakeRange(1, price.length)];
    [mutablePrice yy_setFont:[UIFont systemFontOfSize:15] range:NSMakeRange(price.length + 1,unit.length)];
    mutablePrice.yy_alignment = NSTextAlignmentCenter;
    _priceLabel.attributedText = mutablePrice;
    
    //产品名称
    NSString *chineseName = @"阳离子染料 苏州东吴 分散阳离子红SD-GRL 100%";
    NSString *englishName = @"CTC DONGWU Disperse-Cationic Red SD-GRL 100%";
    _product_ch_name.text = chineseName;
    _product_en_name.text = englishName;
}

@end
