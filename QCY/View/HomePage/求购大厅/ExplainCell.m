//
//  ExplainCell.m
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ExplainCell.h"
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
    
    YYLabel *explainText = [[YYLabel alloc] initWithFrame:CGRectMake(13, 0, SCREEN_WIDTH - 13 * 2, 80)];
    explainText.numberOfLines = 0;
    explainText.backgroundColor = HEXColor(@"#F9F8F8", 1);
    [self.contentView addSubview:explainText];
    _explainText = explainText;
    
}

- (void)setModel:(AskToBuyModel *)model {
    _model = model;
    
    NSString *text = [NSString string];
    if isRightData(model.descriptionStr) {
        text = model.descriptionStr;
    } else {
        text = @"无";
    }
    CGFloat height = [self getMessageHeight:text andLabel:_explainText];
    _explainText.height = height + 40;
    model.cellHeight = _explainText.height;
}

//YYLbael计算高度
- (CGFloat)getMessageHeight:(NSString *)mess andLabel:(YYLabel *)label {
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:mess];
//    [introText yy_setLineSpacing:7 range:NSMakeRange(0, mess.length)];
    introText.yy_lineSpacing = 4;
    introText.yy_lineBreakMode = NSLineBreakByCharWrapping;
    introText.yy_font = [UIFont systemFontOfSize:12];
    introText.yy_color = HEXColor(@"#212121", 1);
    introText.yy_firstLineHeadIndent = 24.f;
    introText.yy_headIndent = 10.f;
    
    CGSize introSize = CGSizeMake(label.width, CGFLOAT_MAX);
    label.attributedText = introText;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:introText];
    label.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight;
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
