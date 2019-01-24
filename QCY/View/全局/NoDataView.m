//
//  NoDataView.m
//  QCY
//
//  Created by i7colors on 2018/11/22.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "NoDataView.h"
#import <Masonry.h>
#import "MacroHeader.h"

@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UILabel *noLabel = [[UILabel alloc]init];
    noLabel.textColor = RGBA(153, 153, 153, 1);
    noLabel.font = [UIFont boldSystemFontOfSize:KFit_W(16)];
    noLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:noLabel];
    [noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    _noLabel = noLabel;
}

@end
