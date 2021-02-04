//
//  ZhuJiDiySpecialCell.m
//  QCY
//
//  Created by i7colors on 2019/10/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ZhuJiDiySpecialCell.h"
#import <UIImageView+WebCache.h>
#import "ZhuJiDiyModel.h"

@interface ZhuJiDiySpecialCell()
@property (nonatomic, strong) UIImageView *companyImageView;
@property (nonatomic, strong) UILabel *companyLab;
@property (nonatomic, strong) UILabel *desLab;
@end

@implementation ZhuJiDiySpecialCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Cell_BGColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 3.f;
    bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(9);
        make.right.mas_equalTo(-9);
        make.height.mas_equalTo(120);
    }];
    
    _companyImageView = [[UIImageView alloc] init];
    [bgView addSubview:_companyImageView];
    [_companyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(100);
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(bgView);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXColor(@"#E5E5E5", 1);
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.companyImageView.mas_right).offset(10);
        make.width.mas_equalTo(0.5);
        make.top.bottom.mas_equalTo(0);
    }];
    
    //公司名字
    _companyLab = [[UILabel alloc] init];
    _companyLab.textColor = UIColor.blackColor;
    _companyLab.numberOfLines = 2;
    _companyLab.font = [UIFont boldSystemFontOfSize:15];
    [bgView addSubview:_companyLab];
    [_companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.companyImageView.mas_right).offset(15);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(50);
    }];
    
    UIView *spLine = [[UIView alloc] init];
    spLine.backgroundColor = line.backgroundColor;
    [bgView addSubview:spLine];
    [spLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.companyLab);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.companyLab.mas_bottom).offset(1);
    }];
    
    _desLab = [[UILabel alloc] init];
    _desLab.numberOfLines = 0;
    _desLab.font = [UIFont systemFontOfSize:10.5];
    _desLab.textColor = HEXColor(@"#868686", 1);
    [bgView addSubview:_desLab];
    [_desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(spLine.mas_bottom).offset(7);
        make.left.right.mas_equalTo(spLine);
        make.bottom.mas_equalTo(-11);
    }];
    
}

- (void)setModel:(ZhuJiDiySpecialModel *)model {
    _model = model;
    [_companyImageView sd_setImageWithURL:ImgUrl(model.logo) placeholderImage:PlaceHolderImg];
    _companyLab.text = model.name;
    _desLab.text = model.descriptionStr;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *const identifier = @"ZhuJiDiySpecialCell";
    ZhuJiDiySpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ZhuJiDiySpecialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
