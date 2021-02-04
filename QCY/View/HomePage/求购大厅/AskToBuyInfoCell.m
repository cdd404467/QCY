//
//  AskToBuyInfoCell.m
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuyInfoCell.h"
#import "UIView+Border.h"
#import "HomePageModel.h"

@interface AskToBuyInfoCell()
@property (nonatomic, strong) UILabel *productExplain;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *bgView;
@end

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
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(13, 0, SCREEN_WIDTH - 13 * 2, 34)];
    _bgView.backgroundColor = HEXColor(@"#F9F8F8", 1);
    [self.contentView addSubview:_bgView];

    //左边文字
    UILabel *productExplain = [[UILabel alloc] initWithFrame:CGRectMake(25, 11, 100, 12)];
    productExplain.textColor = HEXColor(@"#868686", 1);
    productExplain.font = [UIFont systemFontOfSize:12];
    [_bgView addSubview:productExplain];
    _productExplain = productExplain;
    
    //右边文字
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(productExplain.right, productExplain.top, _bgView.width - productExplain.right, productExplain.height)];
    detailLabel.numberOfLines = 0;
    detailLabel.textColor = HEXColor(@"#212121", 1);
    detailLabel.font = [UIFont systemFontOfSize:12];
    [_bgView addSubview:detailLabel];
    _detailLabel = detailLabel;
}


- (void)setModel:(AskDetailInfoModel *)model {
    _model = model;
    _productExplain.text = model.leftText;
    _detailLabel.text = model.rightText;
    CGFloat leftHeight = [_productExplain.text boundingRectWithSize:CGSizeMake(_productExplain.width, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:_productExplain.font}
                                                          context:nil].size.height;
    CGFloat rightHeight = [_detailLabel.text boundingRectWithSize:CGSizeMake(_detailLabel.width, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:_detailLabel.font}
                                                           context:nil].size.height;
    _bgView.height = rightHeight + 34 - _detailLabel.height;
    _detailLabel.height = rightHeight;
    _productExplain.height = leftHeight;
    model.cellHeight = _bgView.height;
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
