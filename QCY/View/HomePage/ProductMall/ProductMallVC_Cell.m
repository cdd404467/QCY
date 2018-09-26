//
//  ProductMallVC_Cell.m
//  QCY
//
//  Created by i7colors on 2018/9/25.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProductMallVC_Cell.h"
#import <Masonry.h>
#import "MacroHeader.h"
#import "HelperTool.h"
#import <YYText.h>

@implementation ProductMallVC_Cell {
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UILabel *_productName;
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
        [self configData];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = CGRectMake(KFit_W(9), 5, SCREEN_WIDTH - KFit_W(9) * 2, 120);
    [HelperTool setRound:bgView corner:UIRectCornerAllCorners radiu:6];
    [self.contentView addSubview:bgView];
    
    //图片
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.image = [UIImage imageNamed:@"test1"];
    headerImageView.frame = CGRectMake(0, 0, 120, 120);
    [HelperTool setRound:headerImageView corner:UIRectCornerTopLeft | UIRectCornerBottomLeft radiu:6];
    [bgView addSubview:headerImageView];
    _headerImageView = headerImageView;
    
    //公司名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"山东索玛德染料有限公司";
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.textColor = [UIColor blackColor];
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerImageView.mas_right).offset(KFit_W(11));
        make.top.mas_equalTo(@17);
        make.height.mas_equalTo(@(14 * Scale_H));
        make.right.mas_equalTo(@(-11 * Scale_W));
    }];
    _nameLabel = nameLabel;
    
    //产品描述
    UILabel *productName = [[UILabel alloc] init];
    productName.text = @"分散染料 分散大红Gs(R153#)200%";
    productName.font = [UIFont systemFontOfSize:13];
    productName.textColor = HEXColor(@"#868686", 1);
    [bgView addSubview:productName];
    [productName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.right.mas_equalTo(nameLabel.mas_right);
        make.height.mas_equalTo(nameLabel.mas_height);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(5);
    }];
    _productName = productName;
    
    //价格
    YYLabel *priceLabel = [[YYLabel alloc] init];
    [bgView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.width.mas_equalTo(KFit_W(150));
        make.height.mas_equalTo(KFit_H(15));
        make.bottom.mas_equalTo(@-14);
    }];
    _priceLabel = priceLabel;
    
    //一键呼叫按钮
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn setImage:[UIImage imageNamed:@"call_btn_100x23"] forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:callBtn];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@(-10 * Scale_W));
        make.bottom.mas_equalTo(priceLabel.mas_bottom);
        make.width.mas_equalTo(@(KFit_W(100)));
        make.height.mas_equalTo(@23);
    }];
}

- (void)configData {
    NSString *price = @"33.3";
    NSString *text = [NSString stringWithFormat:@"¥ %@",price];
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:text];
//    mutableText.yy_font = [UIFont systemFontOfSize:12];
//    mutableText.yy_color = [UIColor colorWithHexString:@"#5F5F5F"];
    [mutableText yy_setFont:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    [mutableText yy_setFont:[UIFont systemFontOfSize:18] range:NSMakeRange(2, price.length)];
    [mutableText yy_setColor:[UIColor colorWithHexString:@"#ED3851"] range:NSMakeRange(0, 1)];
    [mutableText yy_setColor:[UIColor colorWithHexString:@"#F10215"] range:NSMakeRange(2, price.length)];
    _priceLabel.attributedText = mutableText;
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
    static NSString *identifier = @"ProductMallVC_Cell";
    ProductMallVC_Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ProductMallVC_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
