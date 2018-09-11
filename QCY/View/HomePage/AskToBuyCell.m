//
//  AskToBuyCell.m
//  QCY
//
//  Created by i7colors on 2018/9/7.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuyCell.h"
#import <Masonry.h>
#import "MacroHeader.h"

@implementation AskToBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"活性测试";
    nameLabel.font = [UIFont systemFontOfSize:KFit_H(14)];
    nameLabel.textColor = RGBA(0, 0, 0, 0.7);
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(10 * Scale_H));
        make.left.mas_equalTo(@(15 * Scale_W));
    }];
    //数量和地区
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.text = @"数量: 48吨 地区: 上海市 徐汇区";
    countLabel.font = [UIFont systemFontOfSize:KFit_H(12)];
    countLabel.textColor = RGBA(0, 0, 0, 0.7);
    [self.contentView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(10 * Scale_H);
        make.left.mas_equalTo(nameLabel.mas_left);
    }];
    //剩余时间
    UILabel *leftTimeLabel = [[UILabel alloc] init];
    leftTimeLabel.text = @"剩余时间: 1天48小时66分22秒";
    leftTimeLabel.font = [UIFont systemFontOfSize:KFit_H(12)];
    leftTimeLabel.textColor = RGBA(0, 0, 0, 0.7);
    [self.contentView addSubview:leftTimeLabel];
    [leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(countLabel.mas_bottom).offset(10 * Scale_H);
        make.left.mas_equalTo(countLabel.mas_left);
    }];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AskToBuyCell";
    AskToBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AskToBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
