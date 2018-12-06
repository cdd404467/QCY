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
#import "HelperTool.h"

@implementation HomePageSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors = @[(__bridge id)RGBA(0, 0, 0, 0.1).CGColor, (__bridge id)RGBA(0, 0, 0, 0.05).CGColor];
//    //    gradientLayer.colors = @[(__bridge id)[UIColor blackColor].CGColor, (__bridge id)[UIColor whiteColor].CGColor];
//    gradientLayer.locations = @[@0.0, @1.0];
//    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
//    gradientLayer.endPoint = CGPointMake(0.0,1.0);
//    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 6);
//    [self.contentView.layer addSublayer:gradientLayer];
    
    UIView *bgView = [[UIView alloc] init];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    //淡淡的黑线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.7);
    }];
    
    //图片
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.image = [UIImage imageNamed:@"leftLine"];
    [self.contentView addSubview:leftImageView];
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.height.mas_equalTo(24);
        make.left.mas_equalTo(@(9 * Scale_W));
        make.width.mas_equalTo(@(3));
    }];
    
    //左侧文字
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.left.mas_equalTo(leftImageView.mas_right).offset(4);
    }];
    _titleLabel = titleLabel;
    //右侧按钮
    UILabel *moreLabel = [[UILabel alloc] init];
    moreLabel.text = @"查看全部";
    moreLabel.textColor = [UIColor colorWithHexString:@"#868686"];
    moreLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:moreLabel];
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(@(-11 * Scale_W));
        make.centerY.mas_equalTo(bgView.mas_centerY);
    }];
    _moreLabel = moreLabel;
    [HelperTool addTapGesture:moreLabel withTarget:self andSEL:@selector(transmitEvent)];
}

//点击事件传递
- (void)transmitEvent {
    if (self.clickMoreBlock) {
        self.clickMoreBlock();
    }
}

+ (instancetype)headerWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"sectionHeader";
    // 1.缓存中取
    HomePageSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    // 2.创建
    if (header == nil) {
        header = [[HomePageSectionHeader alloc] initWithReuseIdentifier:identifier];
    }
    
    return header;
}

@end
