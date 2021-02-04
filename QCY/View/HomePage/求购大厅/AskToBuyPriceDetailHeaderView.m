//
//  AskToBuyPriceDetailHeaderView.m
//  QCY
//
//  Created by i7colors on 2018/10/23.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuyPriceDetailHeaderView.h"
#import <YYText.h>
#import "UIView+Border.h"



@implementation AskToBuyPriceDetailHeaderView {
    YYLabel *_productName;
    YYLabel *_stateLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
}

- (void)setupUI {
    //求购进度
    YYLabel *stateLabel = [[YYLabel alloc] init];
    stateLabel.numberOfLines = 2;
    stateLabel.frame = CGRectMake(0, 0, KFit_W(80), 50);
    stateLabel.backgroundColor = HEXColor(@"#F5F5F5", 1);
    [stateLabel addBorderView:HEXColor(@"#E5E5E5", 1) width:1 direction:BorderDirectionBottom];
    [self addSubview:stateLabel];
    _stateLabel = stateLabel;
    
    //名称
    YYLabel *productName = [[YYLabel alloc] init];
    productName.font = [UIFont boldSystemFontOfSize:15];
    [productName addBorderView:HEXColor(@"#E5E5E5", 1) width:1 direction:BorderDirectionBottom | BorderDirectionLeft];
    [self addSubview:productName];
    [productName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stateLabel.mas_right);
        make.height.mas_equalTo(50);
        make.right.top.mas_equalTo(0);
    }];
    _productName = productName;
    
}

- (void)configData {
    
    
}

@end
