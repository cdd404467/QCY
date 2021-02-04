//
//  SelecteTopicCell.m
//  QCY
//
//  Created by i7colors on 2019/4/15.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "SelecteTopicCell.h"
#import "FriendCricleModel.h"
#import <YYText.h>

@implementation SelecteTopicCell {
    UILabel *_titleLab;
    YYLabel *_timesNumLab;
    UILabel *_desLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setModel:(FriendTopicModel *)model {
    _model = model;
    _titleLab.text = model.title;
    
    NSString *num = model.communityNum;
    if ([model.communityNum integerValue] > 9999)
        num = @"9999+";
    
    NSString *str = [NSString stringWithFormat:@"讨论%@次",num];
    NSMutableAttributedString *mutableStr = [[NSMutableAttributedString alloc] initWithString:str];
    mutableStr.yy_alignment = NSTextAlignmentRight;
    mutableStr.yy_font = [UIFont systemFontOfSize:12];
    mutableStr.yy_color = [UIColor colorWithHexString:@"#868686"];
    [mutableStr yy_setColor:MainColor range:NSMakeRange(2, num.length)];
    [mutableStr yy_setFont:[UIFont systemFontOfSize:14] range:NSMakeRange(2, num.length)];
    _timesNumLab.attributedText = mutableStr;
    
    _desLab.text = model.descriptionStr;
}

- (void)setupUI {
    _titleLab = [[UILabel alloc] init];
    _titleLab.frame = CGRectMake(9, 14, SCREEN_WIDTH - 9 * 2 - 75 - 5, 15);
    _titleLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLab];
    
    _timesNumLab = [[YYLabel alloc] init];
    _timesNumLab.frame = CGRectMake(_titleLab.right + 5, _titleLab.top, 75, _titleLab.height);
    [self.contentView addSubview:_timesNumLab];
    
    _desLab = [[UILabel alloc] init];
    _desLab.frame = CGRectMake(_titleLab.left, _titleLab.bottom + 9, SCREEN_WIDTH - _titleLab.left * 2, 30);
    _desLab.font = [UIFont systemFontOfSize:12];
    _desLab.textColor = HEXColor(@"#868686", 1);
    _desLab.numberOfLines = 2;
    [self.contentView addSubview:_desLab];
    
    
    UIView *cellGap = [[UIView alloc] init];
    cellGap.frame = CGRectMake(0, 79.5, SCREEN_WIDTH, 0.5);
    cellGap.backgroundColor = LineColor;
    [self.contentView addSubview:cellGap];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"SelecteTopicCell";
    SelecteTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SelecteTopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
