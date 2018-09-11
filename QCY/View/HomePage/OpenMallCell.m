//
//  OpenMallCell.m
//  QCY
//
//  Created by i7colors on 2018/9/10.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "OpenMallCell.h"
#import <Masonry.h>
#import "MacroHeader.h"
#import <YYWebImage.h>

@implementation OpenMallCell

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
    NSURL *url = [NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3107510826,3774805506&fm=11&gp=0.jpg"];
    //图片
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView yy_setImageWithURL:url options:YYWebImageOptionSetImageWithFadeAnimation];
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(30 * Scale_W));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(@(90 * Scale_H));
    }];
    //公司名称
    UILabel *companyName = [[UILabel alloc] init];
    companyName.text = @"上海七彩云电子商务有限公司";
    companyName.font = [UIFont systemFontOfSize:12 * Scale_H];
    companyName.textColor = RGBA(0, 0, 0, 0.7);
    [self.contentView addSubview:companyName];
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(25 * Scale_W);
        make.top.mas_equalTo(@(35 * Scale_H));
    }];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"openMallCell";
    OpenMallCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OpenMallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
