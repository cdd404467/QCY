//
//  AskToBuySectionHeader.m
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuySectionHeader.h"
#import "MacroHeader.h"
#import "UIView+Border.h"

@implementation AskToBuySectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView.backgroundColor = Main_BgColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    bgView.backgroundColor = RGBA(0, 0, 0, 0.08);
    [self.contentView addSubview:bgView];
    
    CGFloat width = SCREEN_WIDTH - KFit_W(13) * 2;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(KFit_H(13), 0, width, 40);
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = HEXColor(@"#818181", 1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    //分割线
    UIImageView *lineImage = [[UIImageView alloc] init];
    lineImage.frame = CGRectMake(KFit_H(13), 39, width, 1);
    lineImage.image = [UIImage imageNamed:@"line_header"];
    [bgView addSubview:lineImage];
    
}

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AskToBuySectionHeader";
    // 1.缓存中取
    AskToBuySectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    // 2.创建
    if (header == nil) {
        header = [[AskToBuySectionHeader alloc] initWithReuseIdentifier:identifier];
    }
    
    return header;
}

@end