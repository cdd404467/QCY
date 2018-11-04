//
//  ProductDetailBasicParaCell.m
//  QCY
//
//  Created by i7colors on 2018/10/31.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProductDetailBasicParaCell.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "OpenMallModel.h"

@implementation ProductDetailBasicParaCell {
    UILabel *_titleLabel;
    UILabel *_textLabel;
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
        self.contentView.backgroundColor = HEXColor(@"d9d9d9", 1);
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = HEXColor(@"#F5F5F5", 1);
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(13));
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(KFit_W(-13));
    }];
    _bgView = bgView;
    
    //左边title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = HEXColor(@"#F5F5F5", 1);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.numberOfLines = 0;
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(15));
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KFit_W(120));
    }];
    _titleLabel = titleLabel;
    
    //右边的text
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.numberOfLines = 0;
    textLabel.backgroundColor = HEXColor(@"#F5F5F5", 1);
    [bgView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.left.mas_equalTo(KFit_W(145));
        make.right.mas_equalTo(KFit_W(-15));
    }];
    _textLabel = textLabel;
    
    //竖线
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = LineColor;
    [self.contentView addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(KFit_W(133));
        make.width.mas_equalTo(1);
    }];
    
    //上面的横线
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = LineColor;
    [self.contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(KFit_W(13));
        make.right.mas_equalTo(KFit_W(-13));
        make.height.mas_equalTo(1);
    }];
    
    
    //没有基本参数的时候
    UILabel *noneLabel = [[UILabel alloc] init];
    noneLabel.hidden = YES;
    noneLabel.textAlignment = NSTextAlignmentCenter;
    noneLabel.backgroundColor = HEXColor(@"#F5F5F5", 1);
    noneLabel.font = [UIFont systemFontOfSize:14];
    noneLabel.text = @"暂无供应商报价";
    [self.contentView addSubview:noneLabel];
    [noneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(13));
        make.right.mas_equalTo(KFit_W(-13));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    _noneLabel = noneLabel;
    
}

- (void)setModel:(PropMap *)model {
    _model = model;
    
    _titleLabel.text = model.key;
    _textLabel.text = model.value;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ProductDetailBasicParaCell";
    ProductDetailBasicParaCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ProductDetailBasicParaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
