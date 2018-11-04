//
//  AskToBuyInfoCell.m
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuyInfoCell.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "UIView+Border.h"

@implementation AskToBuyInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = Main_BgColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = HEXColor(@"#F9F8F8", 1);
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(13));
        make.right.mas_equalTo(KFit_W(-13));
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(0);
    }];
    //左边文字
    UILabel *productExplain = [[UILabel alloc] init];
    productExplain.textColor = HEXColor(@"#868686", 1);
    productExplain.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:productExplain];
    [productExplain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(25));
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(self.contentView);
    }];
    _productExplain = productExplain;
    
    //右边文字
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = HEXColor(@"#212121", 1);
    detailLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(130));
        make.height.mas_equalTo(13);
        make.centerY.mas_equalTo(self.contentView);
    }];
    _detailLabel = detailLabel;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AskToBuyInfoCell";
    AskToBuyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AskToBuyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
