//
//  SelectStandardCell.m
//  QCY
//
//  Created by i7colors on 2019/2/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "SelectStandardCell.h"
#import "BEMCheckBox.h"
#import "PrchaseLeagueModel.h"


@interface SelectStandardCell()<BEMCheckBoxDelegate>
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)BEMCheckBox *checkBox;
@end

@implementation SelectStandardCell

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
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.contentView);
    }];
    _nameLabel = nameLabel;
    
    _checkBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 22, 11, 22, 22)];
    _checkBox.delegate = self;
    _checkBox.boxType = BEMBoxTypeSquare;
    _checkBox.onAnimationType = BEMAnimationTypeBounce;
    _checkBox.offAnimationType = BEMAnimationTypeBounce;
    _checkBox.onCheckColor = [UIColor whiteColor];
    _checkBox.onTintColor = HEXColor(@"#F10215", 1);
    _checkBox.onFillColor = HEXColor(@"#F10215", 1);
    _checkBox.lineWidth = 1.f;
    [self.contentView addSubview:_checkBox];
}

- (void)setModel:(MeetingTypeListModel *)model {
    _model = model;
    
    _nameLabel.text = model.referenceType;
    _checkBox.on = model.isSelectStand;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"SelectStandardCell";
    SelectStandardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SelectStandardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//复选框代理
- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    _model.isSelectStand = _checkBox.on;
}

@end
