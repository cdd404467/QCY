//
//  ExplainCell.m
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ExplainCell.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import <YYText.h>
#import "HomePageModel.h"

@interface ExplainCell()
@property (nonatomic, strong) YYLabel *explainText;
@end

@implementation ExplainCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = Main_BgColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    YYLabel *explainText = [[YYLabel alloc] init];
    explainText.numberOfLines = 0;
    explainText.backgroundColor = HEXColor(@"#F5F5F5", 1);
    [self.contentView addSubview:explainText];
    [explainText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(13));
        make.right.mas_equalTo(KFit_W(-13));
        make.bottom.mas_equalTo(-10);
        make.top.mas_equalTo(0);
    }];
    _explainText = explainText;
    
}

- (void)configDate:(AskToBuyDetailModel *)model {
    NSString *text = [NSString string];
    if isRightData(model.descriptionStr) {
        text = model.descriptionStr;
    } else {
        text = @"无";
    }
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:text];
    [mutableText yy_setLineSpacing:7 range:NSMakeRange(0, text.length)];
    mutableText.yy_lineBreakMode = NSLineBreakByCharWrapping;
    mutableText.yy_font = [UIFont systemFontOfSize:12];
    mutableText.yy_color = HEXColor(@"#212121", 1);
    mutableText.yy_firstLineHeadIndent = 24.f;
    mutableText.yy_headIndent = 10.f;
    _explainText.attributedText = mutableText;
}

- (void)setModel:(AskToBuyDetailModel *)model {
    _model = model;
    
    [self configDate:model];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ExplainCell";
    ExplainCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ExplainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
