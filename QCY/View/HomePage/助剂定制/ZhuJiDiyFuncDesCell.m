//
//  ZhuJiDiyFuncDesCell.m
//  QCY
//
//  Created by i7colors on 2019/8/1.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ZhuJiDiyFuncDesCell.h"
#import "ZhuJiDiyModel.h"

@implementation ZhuJiDiyFuncDesCell {
    UIView *_bgView;
    UILabel *_desLab;
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
        self.backgroundColor = Main_BgColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(13, 0, SCREEN_WIDTH - 26, 82)];
    _bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_bgView];
    
    _desLab = [[UILabel alloc] initWithFrame:CGRectMake(25, 11, _bgView.width - 50, 60)];
    _desLab.numberOfLines = 0;
    _desLab.textColor = HEXColor(@"#212121", 1);
    _desLab.font = [UIFont systemFontOfSize:12];
    [_bgView addSubview:_desLab];
}

- (void)setModel:(ZhuJiDiyDetailInfoModel *)model {
    _model = model;
    _desLab.text = model.rightText;
    CGFloat height = [_desLab.text boundingRectWithSize:CGSizeMake(_desLab.width, CGFLOAT_MAX)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:_desLab.font}
                                                            context:nil].size.height;
    if (height > 60) {
        _desLab.height = height;
        _bgView.height = height + 22;
    } else {
        _desLab.height = 60;
        _bgView.height = 82;
    }
    
    _model.cellHeight = _bgView.height;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ZhuJiDiyFuncDesCell";
    ZhuJiDiyFuncDesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ZhuJiDiyFuncDesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
