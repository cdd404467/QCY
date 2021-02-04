//
//  TopicSelectCollectionCell.m
//  QCY
//
//  Created by i7colors on 2019/4/15.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "TopicSelectCollectionCell.h"
#import "FriendCricleModel.h"

@implementation TopicSelectCollectionCell {
    UIButton *_titleBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setModel:(FriendTopicModel *)model {
    _model = model;
    [_titleBtn setTitle:model.title forState:UIControlStateNormal];
    if (_index == _selecteIndex) {
        [_titleBtn setTitleColor:MainColor forState:UIControlStateNormal];
        _titleBtn.layer.borderColor = MainColor.CGColor;
    } else {
        [_titleBtn setTitleColor:HEXColor(@"#818181", 1) forState:UIControlStateNormal];
        _titleBtn.layer.borderColor = HEXColor(@"#cccccc", 1).CGColor;
    }
}


- (void)setupUI {
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleBtn.layer.cornerRadius = 15.f;
    _titleBtn.layer.borderWidth = 0.8f;
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:KFit_W(12)];
    [_titleBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_titleBtn];
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)btnClick {
    if (self.selectedIndexBlock) {
        self.selectedIndexBlock(_index);
    }
}

@end
