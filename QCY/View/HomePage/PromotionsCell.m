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
        self.contentView.backgroundColor = RGBA(0, 0, 0, 0.1);
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    NSURL *url = [NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3107510826,3774805506&fm=11&gp=0.jpg"];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_H(110));
    [imageView yy_setImageWithURL:url options:YYWebImageOptionSetImageWithFadeAnimation];
    [self.contentView addSubview:imageView];
    //文字描述
    UILabel *desText = [[UILabel alloc] init];
    desText.text = @"夏季大促销！更多优惠等你来，我是活动描述~";
    desText.font = [UIFont systemFontOfSize:12];
    desText.textColor = [UIColor colorWithHexString:@"#3C3C3C"];
    desText.backgroundColor = [UIColor whiteColor];
    desText.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:desText];
    [desText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom).offset(0);
    }];
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
