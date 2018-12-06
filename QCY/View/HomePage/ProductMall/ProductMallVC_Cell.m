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
#import <YYWebImage.h>
#import "OpenMallModel.h"
#import "LXTagsView.h"

@implementation ProductMallVC_Cell {
    UIImageView *_headerImageView;
    UILabel *_supName;
    UILabel *_productName;
    YYLabel *_priceLabel;
    LXTagsView *_tagsView;
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
    bgView.frame = CGRectMake(KFit_W(9), 6, SCREEN_WIDTH - KFit_W(9) * 2, 120);
    [HelperTool setRound:bgView corner:UIRectCornerAllCorners radiu:6];
    [self.contentView addSubview:bgView];
    
    //图片
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.frame = CGRectMake(0, 0, 120, 120);
    [HelperTool setRound:headerImageView corner:UIRectCornerTopLeft | UIRectCornerBottomLeft radiu:6];
    [bgView addSubview:headerImageView];
    _headerImageView = headerImageView;
    
    //产品名字
    UILabel *productName = [[UILabel alloc] init];
    productName.font = [UIFont boldSystemFontOfSize:14];
    productName.textColor = [UIColor blackColor];
    [bgView addSubview:productName];
    [productName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerImageView.mas_right).offset(KFit_W(11));
        make.top.mas_equalTo(@17);
        make.height.mas_equalTo(14);
        make.right.mas_equalTo(@(-11 * Scale_W));
    }];
    _productName = productName;
    
    //供应商
    UILabel *supName = [[UILabel alloc] init];
    supName.font = [UIFont systemFontOfSize:13];
    supName.textColor = HEXColor(@"#868686", 1);
    [bgView addSubview:supName];
    [supName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(productName.mas_left);
        make.right.mas_equalTo(productName.mas_right);
        make.height.mas_equalTo(productName.mas_height);
        make.top.mas_equalTo(productName.mas_bottom).offset(5);
    }];
    _supName = supName;
    
    //价格
    YYLabel *priceLabel = [[YYLabel alloc] init];
    [bgView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(productName.mas_left);
        make.width.mas_equalTo(KFit_W(150));
        make.height.mas_equalTo(15);
        make.bottom.mas_equalTo(@-14);
    }];
    _priceLabel = priceLabel;
    
    //流水标签
    LXTagsView *tagsView = [[LXTagsView alloc]init];
    tagsView.allWidth = SCREEN_WIDTH - 150;
    tagsView.backgroundColor = [UIColor redColor];
    [bgView addSubview:tagsView];
    [tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(supName.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(supName.mas_left);
        make.bottom.mas_equalTo(priceLabel.mas_top).offset(-2);
    }];
    _tagsView = tagsView;
    
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



- (void)setModel:(ProductInfoModel *)model {
    _model = model;
    
    //公司头像
    if isRightData(model.pic) {
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic]];
//        [_headerImageView yy_setImageWithURL:url options:YYWebImageOptionSetImageWithFadeAnimation];
        [_headerImageView yy_setImageWithURL:[NSURL URLWithString:ImgStr(model.pic)] placeholder:PlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    }
    
    //产品名称
    if isRightData(model.productName)
        _productName.text = model.productName;
    
    
    //供应商
    if isRightData(model.supplierShotName)
        _supName.text = model.supplierShotName;
    
    
    //价格
    if isRightData(model.price) {
        NSString *price = model.price;
        NSString *text = [NSString stringWithFormat:@"¥ %@",price];
        NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:text];
        mutableText.yy_color = HEXColor(@"#F10215", 1);
        mutableText.yy_font = [UIFont systemFontOfSize:12];
        [mutableText yy_setFont:[UIFont systemFontOfSize:18] range:NSMakeRange(2, price.length)];
        _priceLabel.attributedText = mutableText;
    }
    
    //标签
    if (model.tagList.count != 0)
        _tagsView.dataA = model.tagList;

}


- (void)callPhone {
    NSString *phoneNum = [NSString string];
    if isRightData(_model.phone) {
        phoneNum = _model.phone;
    } else {
        phoneNum = CompanyContact;
    }
    NSString *tel = [NSString stringWithFormat:@"tel://%@",phoneNum];
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
