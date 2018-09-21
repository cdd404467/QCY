//
//  OpenMallCollectionCell.m
//  QCY
//
//  Created by i7colors on 2018/9/14.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "OpenMallCollectionCell.h"
#import <Masonry.h>
#import "MacroHeader.h"

@interface OpenMallCollectionCell()

@property (nonatomic, strong)UICollectionView *collectionView;
@end

@implementation OpenMallCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    //公司图标
    UIImageView *companyIcon = [[UIImageView alloc] init];
    companyIcon.image = [UIImage imageNamed:@"test1"];
    [self.contentView addSubview:companyIcon];
    [companyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(37 * Scale_W));
        make.top.mas_equalTo(@(15 * Scale_H));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    //公司名字
    UILabel *companyName = [[UILabel alloc] init];
    companyName.numberOfLines = 2;
    companyName.textAlignment = NSTextAlignmentCenter;
    companyName.text = @"徐州开达精细化工有限公司";
    companyName.font = [UIFont boldSystemFontOfSize:12];
    [self.contentView addSubview:companyName];
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(companyIcon.mas_bottom).offset(3);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(@(100 * Scale_W));
    }];
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.text = @"主营：阳离子染料、油溶";
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.font = [UIFont systemFontOfSize:12];
    descriptionLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:descriptionLabel];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.left.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@(-20 * Scale_H));
    }];
    
    //左边黑线
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = LineColor;
    leftLine.frame = CGRectMake(0, 0, 0.5, self.contentView.frame.size.height);
    [self.contentView addSubview:leftLine];
    _leftLine = leftLine;
}

@end
