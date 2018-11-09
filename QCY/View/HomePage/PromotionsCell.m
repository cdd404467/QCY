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
#import "HomePageModel.h"

@implementation PromotionsCell {
    UIImageView *_imageView;
    UILabel *_desText;
}

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
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_H(110));
    [self.contentView addSubview:imageView];
    _imageView = imageView;
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
    _desText = desText;
}

- (void)setModel:(BannerModel *)model {
    _model = model;
    [_imageView yy_setImageWithURL:[NSURL URLWithString:ImgStr(model.ad_image)] placeholder:PlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    
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
