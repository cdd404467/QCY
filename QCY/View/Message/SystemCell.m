//
//  SystemCell.m
//  QCY
//
//  Created by i7colors on 2018/11/15.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "SystemCell.h"
#import "MacroHeader.h"
#import "MessageModel.h"
#import <Masonry.h>
#import "UIView+Geometry.h"
#import <UIImageView+WebCache.h>
#import "UIView+Geometry.h"


#define Margin 12
@implementation SystemCell {
    UILabel *_msgState;
    UILabel *_msgTitle;
    UILabel *_timeLabel;
    UILabel *_msgContent;
    UIImageView *_contentImage;
    UILabel *_onlyText;
    UILabel *_desLabel;
    UIView *_gap;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    //已读未读状态
    _msgState = [[UILabel alloc] init];
    _msgState.font = [UIFont boldSystemFontOfSize:15];
    _msgState.frame = CGRectMake(0, 15, 46, 16);
    _msgState.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_msgState];
    
    //标题
    _msgTitle = [[UILabel alloc] init];
    _msgTitle.frame = CGRectMake(_msgState.right, _msgState.top, SCREEN_WIDTH - _msgState.right, _msgState.height);
    _msgTitle.textColor = HEXColor(@"#000000", 1);
    _msgTitle.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:_msgTitle];
    //时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = HEXColor(@"#868686", 1);
    _timeLabel.frame = CGRectMake(SCREEN_WIDTH - KFit_W(135), _msgState.top, KFit_W(125), 14);
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    //图片
    _contentImage = [[UIImageView alloc] init];
    _contentImage.frame = CGRectMake(10, _msgState.bottom + 14, SCREEN_WIDTH - 20, KFit_W(156));
    [self.contentView addSubview:_contentImage];
    
    //描述
    _desLabel = [[UILabel alloc] init];
    _desLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:_desLabel];
    
    //文本
    _msgContent = [[UILabel alloc] init];
    _msgContent.textColor = HEXColor(@"#868686", 1);
    _msgContent.frame = CGRectMake(_msgTitle.left, _msgState.bottom + 14, SCREEN_WIDTH - _msgTitle.left - 10, 0);
    _msgContent.font = [UIFont systemFontOfSize:12];
    _msgContent.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:_msgContent];
    
    //间隔
    _gap = [[UIView alloc] init];
    _gap.frame = CGRectMake(0, 0, SCREEN_WIDTH, 6);
    _gap.backgroundColor = Cell_BGColor;
    [self.contentView addSubview:_gap];
}

- (void)setModel:(MessageModel *)model {
    _model = model;
    //已读还是未读
    if (isRightData(model.isRead)) {
        //已读
        if ([model.isRead isEqualToString:@"1"]) {
            _msgState.text = @"已读";
            _msgState.textColor = HEXColor(@"#868686", 1);
        } else {
            _msgState.text = @"未读";
            _msgState.textColor = HEXColor(@"#F10215", 1);
        }
        
    }
    //标题
    if isRightData(model.title)
        _msgTitle.text = model.title;
    //创建时间
    if isRightData(model.createdAt)
        _timeLabel.text = model.createdAt;
    
    CGFloat bottom = _msgTitle.bottom;
    
    //不是纯文本就加载图片
    if(![model.type isEqualToString:@"txt"]) {
        _contentImage.hidden = NO;
        _msgContent.hidden = YES;
        [_contentImage sd_setImageWithURL:ImgUrl(model.pic) placeholderImage:PlaceHolderImg];
        bottom = _contentImage.bottom;
    } else {
        _msgContent.hidden = NO;
        _contentImage.hidden = YES;
        if isRightData(model.content) {
            _msgContent.text = model.content;
            CGFloat mHeight = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - _msgTitle.left - 10, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName : _msgContent.font}
                                                          context:nil].size.height;
            _msgContent.height = mHeight;
            bottom = _msgContent.bottom;
        }
    }
    
    _gap.top = bottom + 20;
    
    model.cellHeight = _gap.bottom + 5;

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
