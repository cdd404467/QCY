//
//  HomePageSectionHeader.m
//  QCY
//
//  Created by i7colors on 2018/9/6.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HomePageSectionHeader.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "ClassTool.h"

@implementation HomePageSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier leftTitle:(NSString *)leftTitle {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUIWithTitle:leftTitle];
    }
    
    return self;
}

- (void)setupUIWithTitle:(NSString *)title {
    //左侧文字
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithHexString:@"#f26c27"];
    titleLabel.font = [UIFont systemFontOfSize:KFit_H(16)];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(@(10 * Scale_W));
        make.height.mas_equalTo(30 * Scale_H);
    }];
    //右侧按钮
    UILabel *moreLabel = [[UILabel alloc] init];
    moreLabel.text = @"查看全部";
    moreLabel.textColor = [UIColor colorWithHexString:@"#101010"];
    moreLabel.font = [UIFont systemFontOfSize:KFit_H(14)];
    [self.contentView addSubview:moreLabel];
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@(-10 * Scale_W));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(@(30 * Scale_H));
    }];
    [ClassTool addTapGesture:moreLabel withTarget:self andSEL:@selector(transmitEvent)];
}

//点击事件传递
- (void)transmitEvent {
    if (self.clickMoreBlock) {
        self.clickMoreBlock();
    }
}

+ (instancetype)headerWithTableView:(UITableView *)tableView leftTitle:(NSString *)leftTitle{
    static NSString *identifier = @"sectionHeader";
    // 1.缓存中取
    HomePageSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    // 2.创建
    if (header == nil) {
        header = [[HomePageSectionHeader alloc] initWithReuseIdentifier:identifier leftTitle:leftTitle];
    }
    
    return header;
}

@end
