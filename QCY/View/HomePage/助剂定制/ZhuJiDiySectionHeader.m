//
//  ZhuJiDiySectionHeader.m
//  QCY
//
//  Created by i7colors on 2019/7/31.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ZhuJiDiySectionHeader.h"

@implementation ZhuJiDiySectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = Main_BgColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(13, 0, SCREEN_WIDTH - 26, 35);
    bgView.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:bgView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:12];
    titleLab.backgroundColor = UIColor.whiteColor;
    titleLab.textColor = HEXColor(@"#868686", 1);
    [bgView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.right.mas_equalTo(-11);
        make.top.mas_equalTo(13);
        make.height.mas_equalTo(15);
    }];
    _titleLab = titleLab;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXColor(@"#C8C8C8", 1);
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(titleLab);
        make.height.mas_equalTo(0.8);
        make.bottom.mas_equalTo(0);
    }];
}

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ZhuJiDiySectionHeader";
    // 1.缓存中取
    ZhuJiDiySectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    // 2.创建
    if (header == nil) {
        header = [[ZhuJiDiySectionHeader alloc] initWithReuseIdentifier:identifier];
    }
    
    return header;
}
@end
