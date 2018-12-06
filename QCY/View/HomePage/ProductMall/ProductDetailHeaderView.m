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
#import "OpenMallModel.h"
#import <YYWebImage.h>

@implementation ProductDetailHeaderView {
    UIImageView *_headerImageView;
    YYLabel *_companyName;
    YYLabel *_priceLabel;
    YYLabel *_product_ch_name;
    YYLabel *_product_en_name;
    UIImageView *_productImage;
    ProductInfoModel *_dataSource;
    
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//
//        [self setupUI];
//        [self configData];
//    }
//
//    return self;
//}

- (instancetype)initWithDataSource:(ProductInfoModel *)dataSource {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _dataSource = dataSource;
        [self setupUI];
        [self configData:dataSource];
    }
    return self;
}


- (void)setupUI {
    
    //名字
    YYLabel *product_ch_name = [[YYLabel alloc] init];
    product_ch_name.backgroundColor = [UIColor whiteColor];
//    product_ch_name.frame = CGRectMake(0, 0, KFit_W(310), 40);
    product_ch_name.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    [product_ch_name addBorderLayer:LineColor width:1.f direction:BorderDirectionBottom];
    [self addSubview:product_ch_name];
    _product_ch_name = product_ch_name;
    
    //右边分享按钮
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareBtn.backgroundColor = [UIColor whiteColor];
//    shareBtn.frame = CGRectMake(product_ch_name.frame.size.width , 0, SCREEN_WIDTH - product_ch_name.frame.size.width, 40);
//    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
//    [shareBtn setTitleColor:HEXColor(@"#868686", 1) forState:UIControlStateNormal];
//    shareBtn.layer.shadowColor = RGBA(0, 0, 0, 0.1).CGColor;
//    shareBtn.layer.shadowOffset = CGSizeMake(0, 8);
//    shareBtn.layer.shadowOpacity = 1.0f;
//    shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [shareBtn addBorderLayer:LineColor width:1.f direction:BorderDirectionLeft];
//    [self addSubview:shareBtn];
//    _shareBtn = shareBtn;
    
    //图片
    UIImageView *productImage = [[UIImageView alloc] init];
    productImage.frame = CGRectMake(0, 40, KFit_W(250), KFit_H(210));
    [productImage addBorderLayer:LineColor width:1.f direction:BorderDirectionBottom];
    [self addSubview:productImage];
    _productImage = productImage;
    
    //收藏按钮
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
    YYLabel *companyName = [[YYLabel alloc] init];
    companyName.font = [UIFont boldSystemFontOfSize:16];
    companyName.textColor = [UIColor blackColor];
    [priceBg addSubview:companyName];
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(priceBg);
        make.right.mas_equalTo(-10);
        make.left.mas_equalTo(KFit_W(11));
    }];
    _companyName = companyName;
    //产品英文名称
//    YYLabel *product_en_name = [[YYLabel alloc] init];
//    product_en_name.font = [UIFont systemFontOfSize:12];
//    product_en_name.textColor = HEXColor(@"#868686", 1);
//    [priceBg addSubview:product_en_name];
//    [product_en_name mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(product_ch_name.mas_bottom);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(20);
//        make.left.equalTo(product_ch_name);
//    }];
//    _product_en_name = product_en_name;
    

}

- (void)configData:(ProductInfoModel *)model {
    NSString *text = model.productName;
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:text];
    mutableText.yy_font = [UIFont boldSystemFontOfSize:14];
    mutableText.yy_firstLineHeadIndent = 12.0;
    _product_ch_name.attributedText = mutableText;
    
    //产品图片
    [_productImage yy_setImageWithURL:[NSURL URLWithString:ImgStr(model.pic)] placeholder:PlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    
    
    //价格
    if isRightData(model.price) {
        NSString *price = model.price;
//        NSString *unit = [NSString stringWithFormat:@"/%@",model.unit];
        NSString *unit = [NSString stringWithFormat:@"/KG"];
        NSString *attPrice = [NSString stringWithFormat:@"¥%@%@",price,unit];
        NSMutableAttributedString *mutablePrice = [[NSMutableAttributedString alloc] initWithString:attPrice];
        mutablePrice.yy_color = [UIColor whiteColor];
        [mutablePrice yy_setFont:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 1)];
        [mutablePrice yy_setFont:[UIFont systemFontOfSize:27] range:NSMakeRange(1, price.length)];
        [mutablePrice yy_setFont:[UIFont systemFontOfSize:16] range:NSMakeRange(price.length + 1,unit.length)];
        mutablePrice.yy_alignment = NSTextAlignmentCenter;
        _priceLabel.attributedText = mutablePrice;
    }
    
    
    //产品名称
    if isRightData(model.companyName)
        _companyName.text = model.companyName;

}

@end
