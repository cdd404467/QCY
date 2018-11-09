//
//  GroupBuyAlreadyCell.m
//  QCY
//
//  Created by i7colors on 2018/11/7.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GroupBuyAlreadyCell.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "GroupBuyingModel.h"

@implementation GroupBuyAlreadyCell {
    UILabel *_numberLabel;
    UILabel *_companyLabel;
    UILabel *_contactLabel;
    UILabel *_alreadyBuyLabel;
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

- (void)setupUI {
    
    CGFloat leftGap = KFit_W(15);
    CGFloat centerGap = KFit_W(5);
    CGFloat width1 = KFit_W(50);
    CGFloat width2 = (SCREEN_WIDTH - leftGap * 2 - centerGap * 3 - width1 * 2) / 2;
    CGFloat height = 40;
    for (NSInteger i = 0; i < 4; i++) {
        UILabel *tLabel = [[UILabel alloc] init];
        tLabel.textAlignment = NSTextAlignmentCenter;
        tLabel.textColor = HEXColor(@"#818181", 1);
        tLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:tLabel];
        
        if (i == 0) {
            tLabel.frame = CGRectMake(leftGap, 0, width1, height);
            _numberLabel = tLabel;
        } else if (i == 1) {
            tLabel.frame = CGRectMake(leftGap + width1 + centerGap, 0, width2, height);
            _companyLabel = tLabel;
        } else if (i == 2) {
            tLabel.frame = CGRectMake(leftGap + width1 + width2 + centerGap * 2, 0, width2, height);
            _contactLabel = tLabel;
        } else {
            tLabel.frame = CGRectMake(leftGap + width1 + width2 * 2 + centerGap * 3, 0, width1, height);
            _alreadyBuyLabel = tLabel;
        }
    }
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = LineColor;
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(18));
        make.right.mas_equalTo(KFit_W(-18));
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setModel:(GroupBuyFinishModel *)model {
    _model = model;
    
    if isRightData(model.number)
        _numberLabel.text = model.number;
        
    if isRightData(model.companyName)
        _companyLabel.text = [NSString stringWithFormat:@"%@******公司",model.province];
//         _companyLabel.text = model.companyName;
        
    if isRightData(model.phone)
        _contactLabel.text = model.phone;
                
    if isRightData(model.num)
        _alreadyBuyLabel.text = [NSString stringWithFormat:@"%@%@",model.num,model.numUnit];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"GroupBuyAlreadyCell";
    GroupBuyAlreadyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GroupBuyAlreadyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
