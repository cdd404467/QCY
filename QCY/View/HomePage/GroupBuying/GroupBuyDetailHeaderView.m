//
//  GroupBuyDetailHeaderView.m
//  QCY
//
//  Created by i7colors on 2018/11/2.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GroupBuyDetailHeaderView.h"
#import "MacroHeader.h"


@implementation GroupBuyDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

- (void)setupUI {
    UIImageView *productImageView = [[UIImageView alloc] init];
    productImageView.frame = CGRectMake(0, 0, 250, 250);
    [self addSubview:productImageView];
    
}

@end
