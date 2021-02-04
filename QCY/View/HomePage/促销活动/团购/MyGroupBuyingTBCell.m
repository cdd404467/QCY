//
//  MyGroupBuyingTBCell.m
//  QCY
//
//  Created by i7colors on 2019/7/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyGroupBuyingTBCell.h"
#import <YYText.h>
#import "GroupBuyingModel.h"
#import <UIImageView+WebCache.h>
#import "HelperTool.h"
#import "NSString+Extension.h"


@implementation MyGroupBuyingTBCell {
    UIImageView *_headerImageView;
    UIImageView *_stateImageView;
    UILabel *_productName;
    UILabel *_myBuyCountLab;
    YYLabel *_groupBuyPriceLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Like_Color;
        [self setupUI];
    }
    
    return self;
}


- (void)setupUI {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(9, 10, SCREEN_WIDTH - 18, 120)];
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = 3.f;
    [self.contentView addSubview:bgView];
    
    //图片
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    [bgView addSubview:headerImageView];
    _headerImageView = headerImageView;
    
    //状态图片
    UIImageView *stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    [headerImageView addSubview:stateImageView];
    _stateImageView = stateImageView;

    //产品名字
    UILabel *productName = [[UILabel alloc] init];
    productName.numberOfLines = 2;
    productName.font = [UIFont boldSystemFontOfSize:17];
    [bgView addSubview:productName];
    _productName = productName;
    [_productName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerImageView.mas_right).offset(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(40);
    }];
    
    //我的购买量
    UILabel *myBuyCountLab = [[UILabel alloc] init];
    myBuyCountLab.font = [UIFont systemFontOfSize:14];
    myBuyCountLab.textColor = HEXColor(@"#868686", 1);
    [bgView addSubview:myBuyCountLab];
    _myBuyCountLab = myBuyCountLab;
    [myBuyCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(productName);
        make.top.mas_equalTo(productName.mas_bottom).offset(20);
        make.height.mas_equalTo(15);
    }];
    
    //团购价
    YYLabel *groupBuyPriceLab = [[YYLabel alloc] init];
    [bgView addSubview:groupBuyPriceLab];
    _groupBuyPriceLab = groupBuyPriceLab;
    [groupBuyPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(productName);
        make.top.mas_equalTo(myBuyCountLab.mas_bottom).offset(8);
        make.height.mas_equalTo(17);
    }];
    
}



- (void)setModel:(GroupBuyingModel *)model {
    _model = model;
    //产品图片
    if isRightData(model.productPic)
        [_headerImageView sd_setImageWithURL:ImgUrl(model.productPic) placeholderImage:PlaceHolderImg];
    //产品名字
    if isRightData(model.productName) {
        _productName.text = model.productName;
    }
    
    //我的购买量
    _myBuyCountLab.text = [NSString stringWithFormat:@"我的购买量: %@ %@",model.num,model.numUnit];
    
    NSString *dtext = [NSString string];
    NSString *price = [NSString string];
    if ([_style isEqualToString:@"group"]) {
        dtext = @"团购价: ";
        NSString *doubleString = [NSString stringWithFormat:@"%lf", [model.priceNew doubleValue]];
        NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
        price = [decNumber stringValue];
    } else {
        dtext = @"当前价: ";
        NSString *doubleString = [NSString stringWithFormat:@"%lf", [model.realPrice doubleValue]];
        NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
        price = [decNumber stringValue];
    }
    //团购价
    NSString *text = [NSString stringWithFormat:@"%@%@ 元/%@",dtext,price,model.priceUnit];
    NSMutableAttributedString *mPrice = [[NSMutableAttributedString alloc] initWithString:text];
    mPrice.yy_color = HEXColor(@"#F10215", 1);
    mPrice.yy_font = [UIFont systemFontOfSize:14];
    [mPrice yy_setFont:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(dtext.length, price.length)];
    _groupBuyPriceLab.attributedText = mPrice;
    
    /*** 团购状态判断 ***/
    //左上角图片
    //未开始
    if ([model.endCode isEqualToString:@"00"]) {
        _stateImageView.image = [UIImage imageNamed:@"groupBuy_notStart"];
        //已开始
    } else if ([model.endCode isEqualToString:@"10"]) {
        _stateImageView.image = [UIImage imageNamed:@"groupBuy_start"];
        //已结束
    } else {
        _stateImageView.image = [UIImage imageNamed:@"groupBuy_end"];
    }
    
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"MyGroupBuyingTBCell";
    MyGroupBuyingTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyGroupBuyingTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
