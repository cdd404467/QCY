//
//  PromotionsCell.m
//  QCY
//
//  Created by i7colors on 2018/9/6.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PromotionsCell.h"
#import <Masonry.h>
#import "MacroHeader.h"
#import <YYWebImage.h>

@implementation PromotionsCell

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
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_H(140));
    [imageView yy_setImageWithURL:url options:YYWebImageOptionSetImageWithFadeAnimation];
    [self.contentView addSubview:imageView];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"promotionsCell";
    PromotionsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PromotionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
