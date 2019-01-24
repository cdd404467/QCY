//
//  ImageCell.m
//  QCY
//
//  Created by i7colors on 2018/11/7.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ImageCell.h"
#import <Masonry.h>
#import "MacroHeader.h"

@implementation ImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = Cell_BGColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIImageView *cellImageView = [[UIImageView alloc]init];
    cellImageView.contentMode =UIViewContentModeScaleAspectFill;
    cellImageView.backgroundColor = [UIColor whiteColor];
    cellImageView.layer.cornerRadius = 5.f;
    cellImageView.clipsToBounds = YES;
    [self.contentView addSubview:cellImageView];
    [cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(KFit_W(13));
        make.right.mas_equalTo(KFit_W(-13));
        make.bottom.mas_equalTo(0);
    }];
    _cellImageView = cellImageView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ImageCell";
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
