//
//  ProductDetailsView.m
//  QCY
//
//  Created by i7colors on 2018/9/25.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProductDetailsView.h"
#import "MacroHeader.h"
#import <YYText.h>
#import <Masonry.h>
#import "HelperTool.h"
#import "HYBImageCliped.h"

@implementation ProductDetailsView {
    UIImageView *_headerImageView;
    YYLabel *_companyName;
    YYLabel *_priceLabel;
    YYLabel *_product_ch_name;
    YYLabel *_product_en_name;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self configData];
    }
    
    return self;
}

- (void)setupUI {
    //左边image的宽度，和右边的按钮均分
    CGFloat width = (SCREEN_WIDTH - KFit_W(250)) / 2;
    //左边图片
    UIView *imageBg = [[UIView alloc] init];
    imageBg.frame = CGRectMake(0, 0, width, 40);
    [self addSubview:imageBg];
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.image = [UIImage imageNamed:@"test1"];
    headerImageView.frame = CGRectMake(0, 0, 40, imageBg.frame.size.height);
    headerImageView.center = imageBg.center;
    [imageBg addSubview:headerImageView];
    _headerImageView = headerImageView;
    
    //左边竖线
    UIView *leftLine = [[UIView alloc] init];
    leftLine.frame = CGRectMake(imageBg.frame.size.width - 1, 0, 1, 40);
    leftLine.backgroundColor = LineColor;
    [imageBg addSubview:leftLine];
    
    //名字
    YYLabel *companyName = [[YYLabel alloc] init];
    companyName.frame = CGRectMake(imageBg.frame.size.width, 0, KFit_W(250), 40);
    [self addSubview:companyName];
    _companyName = companyName;
    
    //右边分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.backgroundColor = [UIColor whiteColor];
    shareBtn.frame = CGRectMake(imageBg.frame.size.width + KFit_W(250), 0, width, 40);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:HEXColor(@"#868686", 1) forState:UIControlStateNormal];
    shareBtn.layer.shadowColor = RGBA(0, 0, 0, 0.1).CGColor;
    shareBtn.layer.shadowOffset = CGSizeMake(0, 8);
    shareBtn.layer.shadowOpacity = 1.0f;
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:shareBtn];
    
    //右边竖线
    UIView *rightLine = [[UIView alloc] init];
    rightLine.frame = CGRectMake(0, 0, 1, 40);
    rightLine.backgroundColor = LineColor;
    [shareBtn addSubview:rightLine];
    
    //下边横线
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = LineColor;
    bottomLine.frame = CGRectMake(0, 39, imageBg.frame.size.width + companyName.frame.size.width, 1);
    [self addSubview:bottomLine];
    
    //图片
    UIImageView *productImage = [[UIImageView alloc] init];
    productImage.image = [UIImage imageNamed:@"test1"];
    productImage.frame = CGRectMake(0, 40, KFit_W(250), KFit_H(210));
    [self addSubview:productImage];
    
    //收藏按钮
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(productImage.frame.size.width, 40, SCREEN_WIDTH - productImage.frame.size.width, productImage.frame.size.height / 2);
    collectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [collectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"collect_selected"] forState:UIControlStateSelected];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
    [collectBtn setTitleColor:HEXColor(@"#868686", 1) forState:UIControlStateNormal];
    [collectBtn setTitleColor:MainColor forState:UIControlStateSelected];
    collectBtn.titleEdgeInsets = UIEdgeInsetsMake(collectBtn.imageView.frame.size.height, -collectBtn.imageView.frame.size.width, 0, 0);
    collectBtn.imageEdgeInsets = UIEdgeInsetsMake(-collectBtn.imageView.frame.size.height, 0, 0, -collectBtn.titleLabel.bounds.size.width);
    [self addSubview:collectBtn];
    
    //收藏按钮的横线
    UIView *collectBtnLine = [[UIView alloc] init];
    collectBtnLine.backgroundColor = LineColor;
    collectBtnLine.frame = CGRectMake(0, 0, 1, collectBtn.frame.size.height);
    [collectBtn addSubview:collectBtnLine];
    
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
    
    //价格的背景
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
    
    //下半部分
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = RGBA(0, 0, 0, 0.1);
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceBg.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(417);
    }];
    
    //下半部分一整块
    UIView *bottomBg = [[UIView alloc] init];
    bottomBg.backgroundColor = [UIColor whiteColor];
    bottomBg.layer.cornerRadius = 5;
    bottomBg.layer.shadowColor = RGBA(0, 0, 0, 0.1).CGColor;
    bottomBg.layer.shadowOffset = CGSizeMake(0, 10);
    bottomBg.layer.shadowOpacity = 1.0f;
    bottomBg.frame = CGRectMake(KFit_W(13), 11, SCREEN_WIDTH - KFit_W(13) * 2, 364);
    [bottomView addSubview:bottomBg];
    
    //基本参数label
    UILabel *title = [[UILabel alloc] init];
    title.text = @"基本参数";
    title.font = [UIFont systemFontOfSize:12];
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 5, bottomBg.frame.size.width, 30);
    [bottomBg addSubview:title];
    
    //左边的view
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, 40, KFit_W(120), 364 - 40);
    leftView.backgroundColor = HEXColor(@"#F5F5F5", 1);
    [bottomBg addSubview:leftView];
    
    //右边的view
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(leftView.frame.size.width, 40, bottomBg.frame.size.width - leftView.frame.size.width, 364 - 40);
    rightView.backgroundColor = HEXColor(@"#F5F5F5", 1);
    [HelperTool setRound:leftView corner:UIRectCornerBottomRight radiu:5];
    [bottomBg addSubview:rightView];
    
    //竖线
    UIView *vLine = [[UIView alloc] init];
    vLine.frame = CGRectMake(leftView.frame.size.width - 1, 40, 1, leftView.frame.size.height);
    vLine.backgroundColor = LineColor;
    [bottomBg addSubview:vLine];
    
    
    NSArray *leftArr = @[@"印染工艺",@"包装形式",@"规格型号",@"颜色",@"适用纤维",@"浸染温度",@"适用基材"];
    NSArray *rightArr = @[@"浸染 印花",@"25KG/箱",@"分散型阳离子染料",@"红色",@"梭织 针织 筒纱 绞纱",@"100",@" 腈纶   改性涤纶   涤纶    阳离子改性涤纶"];
    //横线
    for (NSInteger i = 0; i < 7; i++) {
        //横线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = LineColor;
        line.frame = CGRectMake(0, 40 + i * 40, bottomBg.frame.size.width, 1);
        [bottomBg addSubview:line];
        
        //左边的label
        UILabel *leftText = [[UILabel alloc] init];
        leftText.font = [UIFont systemFontOfSize:12];
        leftText.numberOfLines = 0;
        leftText.text = leftArr[i];
        if (i != 6) {
            leftText.frame = CGRectMake(KFit_W(16), i * 41, leftView.frame.size.width, 40);
        } else {
            leftText.frame = CGRectMake(KFit_W(16), i * 41, leftView.frame.size.width, 80);
            [HelperTool setRound:leftText corner:UIRectCornerBottomLeft radiu:5];
        }
        [leftView addSubview:leftText];
        
        //右边的label
        UILabel *rightText = [[UILabel alloc] init];
        rightText.font = [UIFont systemFontOfSize:12];
        rightText.text = rightArr[i];
        rightText.numberOfLines = 0;
        if (i != 6) {
            rightText.frame = CGRectMake(KFit_W(30), i * 41, leftView.frame.size.width, 40);
        } else {
            rightText.frame = CGRectMake(KFit_W(30), i * 41, leftView.frame.size.width, 80);
            [HelperTool setRound:rightText corner:UIRectCornerBottomRight radiu:5];
        }
        [rightView addSubview:rightText];
    }
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
