//
//  ZhuJiDiyInfoCell.m
//  QCY
//
//  Created by i7colors on 2019/7/31.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ZhuJiDiyInfoCell.h"
#import "ZhuJiDiyModel.h"

@interface ZhuJiDiyInfoCell()
@property (nonatomic, strong) UILabel *leftText;
@property (nonatomic, strong) UILabel *rightText;
@end

@implementation ZhuJiDiyInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    _bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_bgView];
    
    //左边文字
    UILabel *leftText = [[UILabel alloc] initWithFrame:CGRectMake(25, 11, 100, 12)];
    leftText.textColor = HEXColor(@"#868686", 1);
    leftText.font = [UIFont systemFontOfSize:12];
    [_bgView addSubview:leftText];
    _leftText = leftText;
    
    //右边文字
    UILabel *rightText = [[UILabel alloc] initWithFrame:CGRectMake(leftText.right, leftText.top, _bgView.width - leftText.right, leftText.height)];
    rightText.numberOfLines = 0;
    rightText.textColor = HEXColor(@"#212121", 1);
    rightText.font = [UIFont systemFontOfSize:12];
    [_bgView addSubview:rightText];
    _rightText = rightText;
}

- (void)setModel:(ZhuJiDiyDetailInfoModel *)model {
    _model = model;
    _leftText.text = model.leftText;
    _rightText.text = model.rightText;
//    _rightText.text = @"助剂性能描述助剂性能描述助剂性能描述助剂性能描述助剂性能描述助剂性能描述助剂性能描述助剂性能描述助剂性能描述助剂性能描述助剂性";
    CGFloat leftHeight = [_leftText.text boundingRectWithSize:CGSizeMake(_leftText.width, CGFLOAT_MAX)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:_leftText.font}
                                                            context:nil].size.height;
    CGFloat rightHeight = [_rightText.text boundingRectWithSize:CGSizeMake(_rightText.width, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:_rightText.font}
                                                          context:nil].size.height;
    _leftText.height = leftHeight;
    _rightText.height = rightHeight;
    _bgView.height = _rightText.bottom + 11;
    
    model.cellHeight = _bgView.bottom - 1;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *const identifier = @"ZhuJiDiyInfoCell";
    ZhuJiDiyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ZhuJiDiyInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
