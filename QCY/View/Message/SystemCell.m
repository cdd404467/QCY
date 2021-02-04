//
//  SystemCell.m
//  QCY
//
//  Created by i7colors on 2018/11/15.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "SystemCell.h"
#import "MessageModel.h"
#import <UIImageView+WebCache.h>
#import "UIView+Border.h"
#import "HelperTool.h"
#import <YYText.h>


@implementation SystemCell {
    UILabel *_msgTitle;
    UILabel *_timeLabel;
    YYLabel *_msgContent;
    UIImageView *_contentImage;
    YYLabel *_desLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = View_Color;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    //时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = UIColor.blackColor;
    _timeLabel.frame = CGRectMake(8, 5, SCREEN_WIDTH - 8 * 2 , 25);
    _timeLabel.font = [UIFont systemFontOfSize:16];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    
    //标题
    _msgTitle = [[UILabel alloc] init];
    _msgTitle.frame = CGRectMake(_timeLabel.left, _timeLabel.bottom + 5, _timeLabel.width , 44);
    _msgTitle.textColor = HEXColor(@"#000000", 1);
    _msgTitle.font = [UIFont boldSystemFontOfSize:16];
     _msgTitle.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_msgTitle];
    [HelperTool setRound:_msgTitle corner:UIRectCornerTopLeft | UIRectCornerTopRight radiu:6.f];
    
    //图片
    _contentImage = [[UIImageView alloc] init];
    _contentImage.frame = CGRectMake(_timeLabel.left, _msgTitle.bottom, _msgTitle.width, KFit_W(150));
    [self.contentView addSubview:_contentImage];
    
    //文本
    _msgContent = [[YYLabel alloc] init];
    _msgContent.textColor = HEXColor(@"#333333", 1);
    _msgContent.frame = CGRectMake(_msgTitle.left, _msgTitle.bottom, _msgTitle.width, 10);
    _msgContent.font = [UIFont systemFontOfSize:15];
    _msgContent.numberOfLines = 0;
    _msgContent.backgroundColor = UIColor.whiteColor;
    [self.contentView addSubview:_msgContent];
    
    CALayer *line = [[CALayer alloc] init];
    line.frame = CGRectMake(_msgTitle.left, _msgTitle.bottom - .5, _msgContent.width, .5);
    line.backgroundColor = Like_Color.CGColor;
    [self.contentView.layer addSublayer:line];
    
    //描述
    _desLabel = [[YYLabel alloc] initWithFrame:CGRectMake(_contentImage.left, 0, _contentImage.width, 0)];
    _desLabel.numberOfLines = 0;
    _desLabel.backgroundColor = UIColor.whiteColor;
    _desLabel.font = [UIFont boldSystemFontOfSize:14];
    _desLabel.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:_desLabel];
}

//YYLbael计算高度
- (CGFloat)getMessageHeight:(NSString *)mess andLabel:(YYLabel *)label {
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:mess];
    introText.yy_lineSpacing = 4;
    introText.yy_lineBreakMode = NSLineBreakByCharWrapping;
    introText.yy_font = label.font;
    introText.yy_color = label.textColor;
    introText.yy_firstLineHeadIndent = 24.f;
    introText.yy_headIndent = 5.f;
    CGSize introSize = CGSizeMake(label.width, CGFLOAT_MAX);
    label.attributedText = introText;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:introText];
    label.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight;
}

- (void)setModel:(MessageModel *)model {
    _model = model;
    //创建时间
    if isRightData(model.createdAt)
        _timeLabel.text = [model.createdAt substringToIndex:10];
    
    //标题
    if isRightData(model.title)
        _msgTitle.text = [NSString stringWithFormat:@"    %@",model.title];
    CGFloat bottom = _msgTitle.bottom;

    //不是纯文本就加载图片
    if(![model.type isEqualToString:@"txt"]) {
        if isRightData(model.pic) {
            _contentImage.hidden = NO;
            _msgContent.hidden = YES;
            _desLabel.hidden = NO;
            [_contentImage sd_setImageWithURL:ImgUrl(model.pic) placeholderImage:PlaceHolderImg];
            bottom = _contentImage.bottom;
            if isRightData(model.content) {
                _desLabel.text = model.content;
                CGFloat mHeight = [self getMessageHeight:_desLabel.text andLabel:_desLabel];
                _desLabel.height = mHeight + 30;
                _desLabel.top = _contentImage.bottom;
                bottom = _desLabel.bottom;
                [HelperTool setRound:_desLabel corner:UIRectCornerBottomLeft | UIRectCornerBottomRight radiu:6.f];
            }
        } else {
            _msgContent.hidden = NO;
            _contentImage.hidden = YES;
            _desLabel.hidden = NO;
            if isRightData(model.content) {
                _desLabel.text = model.content;
                CGFloat mHeight = [self getMessageHeight:_desLabel.text andLabel:_desLabel];
                _desLabel.height = mHeight + 30;
                _desLabel.top = _msgTitle.bottom;
                bottom = _desLabel.bottom;
                [HelperTool setRound:_desLabel corner:UIRectCornerBottomLeft | UIRectCornerBottomRight radiu:6.f];
            }
        }
        
    } else {
        _msgContent.hidden = NO;
        _contentImage.hidden = YES;
        _desLabel.hidden = YES;
        if isRightData(model.content) {
            _msgContent.text = model.content;
            CGFloat mHeight = [self getMessageHeight:_msgContent.text andLabel:_msgContent];
            _msgContent.height = mHeight + 35;
            bottom = _msgContent.bottom;
        }
    }
    model.cellHeight = bottom + 15;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"SystemCell";
    SystemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SystemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
