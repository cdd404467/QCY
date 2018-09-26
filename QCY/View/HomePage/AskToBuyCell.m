//
//  AskToBuyCell.m
//  QCY
//
//  Created by i7colors on 2018/9/7.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuyCell.h"
#import <Masonry.h>
#import "MacroHeader.h"
#import <YYText.h>

@interface AskToBuyCell()
@property (nonatomic, strong)YYLabel *offerCount;

@end


@implementation AskToBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBA(0, 0, 0, 0.1);
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@8);
        make.left.mas_equalTo(@7);
        make.right.mas_equalTo(@-10);
        make.height.mas_equalTo(@80);
    }];
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"活性染料WNN黑活性染料WNN";
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textColor = RGBA(0, 0, 0, 1);
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(@(20 * Scale_W));
        make.height.mas_equalTo(@14);
        make.width.mas_equalTo(@(190 * Scale_W));
    }];
    //数量和地区
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.text = @"数量: 48吨 地区: 上海市 徐汇区";
    countLabel.font = [UIFont systemFontOfSize:12];
    countLabel.textColor = [UIColor colorWithHexString:@"#868686"];
    [bgView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(9);
        make.height.mas_equalTo(@12);
        make.left.mas_equalTo(nameLabel.mas_left);
    }];
    //剩余时间
    UILabel *leftTimeLabel = [[UILabel alloc] init];
    leftTimeLabel.text = @"剩余时间: 1天48小时66分22秒";
    leftTimeLabel.font = [UIFont systemFontOfSize:12];
    leftTimeLabel.textColor = [UIColor colorWithHexString:@"#5F5F5F"];
    [bgView addSubview:leftTimeLabel];
    [leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(countLabel.mas_bottom).offset(5);
        make.bottom.mas_equalTo(@-14);
        make.height.mas_equalTo(@12);
        make.left.mas_equalTo(countLabel.mas_left);
    }];
    
    //一键呼叫按钮
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [callBtn setImage:[UIImage imageNamed:@"call_btn_110x25"] forState:UIControlStateNormal];
    [bgView addSubview:callBtn];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_top);
        make.right.mas_equalTo(@(-25 * Scale_W));
        make.height.mas_equalTo(@(25 * Scale_H));
        make.width.mas_equalTo(@(110 * Scale_W));
    }];
    
    //标签
    UIImageView *labelImage = [[UIImageView alloc] init];
    labelImage.image = [UIImage imageNamed:@"price_parity"];
    [bgView insertSubview:labelImage belowSubview:callBtn];
    [labelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@42);
        make.height.mas_equalTo(@43);
        make.top.mas_equalTo(@-3);
        make.right.mas_equalTo(@3);
    }];
    
    //多少人参与
    YYLabel *offerCount = [[YYLabel alloc] init];
    [bgView addSubview:offerCount];
    [offerCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(callBtn.mas_centerX);
        make.bottom.mas_equalTo(leftTimeLabel.mas_bottom);
    }];
    _offerCount = offerCount;
    [self configData];
}

- (void)configData {

    NSString *str = @"7";
    NSString *text = [NSString stringWithFormat:@"已有%@家参与报价",str];
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:text];
    mutableText.yy_font = [UIFont systemFontOfSize:12];
    mutableText.yy_color = [UIColor colorWithHexString:@"#5F5F5F"];
    [mutableText yy_setColor:[UIColor colorWithHexString:@"#FF7F00"] range:NSMakeRange(2, 1)];
    _offerCount.attributedText = mutableText;
}

- (void)callPhone {
    NSString *tel = [NSString stringWithFormat:@"tel://10086"];
    //开线程，解决ios10调用慢的问题
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:tel]];
        });
    });
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AskToBuyCell";
    AskToBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AskToBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
