//
//  FCUnReadMsgView.m
//  QCY
//
//  Created by i7colors on 2018/12/14.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCUnReadMsgView.h"
#import "ClassTool.h"

@implementation FCUnReadMsgView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _unReadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unReadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _unReadBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 35);
        [ClassTool addLayer:_unReadBtn frame:_unReadBtn.frame];
        _unReadBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_unReadBtn];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [_unReadBtn setTitle:title forState:UIControlStateNormal];
}

@end
