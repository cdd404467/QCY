//
//  MineCollectionCell.m
//  QCY
//
//  Created by i7colors on 2018/10/21.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MineCollectionCell.h"
#import <SDAutoLayout.h>
#import <Masonry.h>
#import "MacroHeader.h"

@implementation MineCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    CGFloat width = (SCREEN_WIDTH - 110) / 3;
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconBtn setTitleColor:HEXColor(@"#A6A6A6", 1) forState:UIControlStateNormal];
    iconBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    iconBtn.adjustsImageWhenHighlighted = NO;
    iconBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:iconBtn];
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(width);
        make.center.mas_equalTo(self.contentView);
    }];
    _iconBtn = iconBtn;
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.hidden = YES;
    numberLabel.backgroundColor = HEXColor(@"#ED3851", 1);
    numberLabel.font = [UIFont systemFontOfSize:10];
    numberLabel.layer.cornerRadius = 8;
    numberLabel.layer.masksToBounds = YES;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.textColor = [UIColor whiteColor];
    [iconBtn addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.right.mas_equalTo(-25);
        make.height.width.mas_equalTo(16);
    }];
    _numberLabel = numberLabel;
    
    iconBtn.imageView.sd_layout
    .centerXEqualToView(iconBtn)
    .topSpaceToView(iconBtn, 12)
    .widthIs(18)
    .heightIs(18);
    
    iconBtn.titleLabel.sd_layout
    .centerXEqualToView(iconBtn)
    .heightIs(13)
    .bottomSpaceToView(iconBtn, 8);
    
}

- (void)configData:(NSString *)text {
    
    
    
    if (![text isEqualToString:@"0"] && isRightData(text)) {
        _numberLabel.hidden = NO;
    } else {
        _numberLabel.hidden = YES;
    }
    _numberLabel.text = text;
}


@end
