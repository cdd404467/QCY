//
//  SelectedView.m
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "SelectedView.h"
#import "MacroHeader.h"
#import <Masonry.h>

@implementation SelectedView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = HEXColor(@"#E8E8E8", 1).CGColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIImageView *rightImg = [[UIImageView alloc] init];
    rightImg.image = [UIImage imageNamed:@"selected_icon"];
    [self addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(9);
        make.height.mas_equalTo(5);
    }];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.textColor = HEXColor(@"#868686", 1);
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(self.mas_height);
        make.right.mas_equalTo(rightImg.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    _textLabel = textLabel;
}

@end
