//
//  ProductDetailSectionHeader.m
//  QCY
//
//  Created by i7colors on 2018/10/31.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ProductDetailSectionHeader.h"
#import "HelperTool.h"

@implementation ProductDetailSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = Cell_BGColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *headerBg = [[UIView alloc] init];
    headerBg.frame = CGRectMake(KFit_W(13), 11, SCREEN_WIDTH - KFit_W(13) * 2, 40);
    headerBg.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:headerBg];
    [HelperTool setRound:headerBg corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:10];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"基本参数";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerBg addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(headerBg);
    }];
}

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ProductDetailSectionHeader";
    // 1.缓存中取
    ProductDetailSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    // 2.创建
    if (header == nil) {
        header = [[ProductDetailSectionHeader alloc] initWithReuseIdentifier:identifier];
    }
    
    return header;
}

@end
