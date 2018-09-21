//
//  TodaysNewsCell.m
//  QCY
//
//  Created by i7colors on 2018/9/13.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "TodaysNewsCell.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "HelperTool.h"

@implementation TodaysNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    //背景view，用来添加渐变的layer，再把label放在这个view上，直接在label上添加渐变layer，label不能显示数字，能显示中文
    UIView *numberView = [[UIView alloc] init];
    [self.contentView addSubview:numberView];
    [numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(@(9 * Scale_W));
    }];
    //渐变的layer
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#f26c27"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#ee2788"].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0.0, 0.3);
    gradientLayer.endPoint = CGPointMake(1.0,0.7);
    gradientLayer.frame = CGRectMake(0, 0, 15, 15);
    [numberView.layer addSublayer:gradientLayer];
    //前面的数字
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.frame = gradientLayer.frame;
    countLabel.font = [UIFont systemFontOfSize:12];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.textAlignment = NSTextAlignmentCenter;
    [numberView addSubview:countLabel];
    _countLabel = countLabel;
    //切圆角
    [HelperTool setRound:numberView corner:UIRectCornerAllCorners radiu:KFit_W(15)];
    
    //显示文字的label
    UILabel *news = [[UILabel alloc] init];
    news.text = @"迈进新时代 染出新未来--专访中国印染行业协会会长陈志华";
    news.font = [UIFont systemFontOfSize:14];
    news.textColor = [UIColor colorWithHexString:@"#575757"];
    [self.contentView addSubview:news];
    [news mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numberView.mas_right).with.offset(8 * Scale_W);
        make.right.mas_equalTo(@-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
 }

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"todaysNewsCell";
    TodaysNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TodaysNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
