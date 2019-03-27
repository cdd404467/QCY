//
//  FCDetailCell.m
//  QCY
//
//  Created by i7colors on 2018/12/16.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCDetailCell.h"
#import "UIView+Geometry.h"
#import "MacroHeader.h"
#import <YYText.h>
#import "FriendCricleModel.h"
#import "Friend.h"
#import "TimeAbout.h"



#define labWidth SCREEN_WIDTH - 20 - 100
@interface FCDetailCell()
@property (nonatomic, strong)YYLabel *cUserLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *commentLabel;
@property (nonatomic, strong)UIButton *commentBtn;
@property (nonatomic, strong)UIButton *deleteBtn;
@end

@implementation FCDetailCell

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
    _cUserLabel = [[YYLabel alloc] init];
    _cUserLabel.frame = CGRectMake(20, 18, labWidth, 0);
    [self.contentView addSubview:_cUserLabel];
    
    // 时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.0];
    _timeLabel.frame = CGRectMake(SCREEN_WIDTH - 100, _cUserLabel.top , 87, 15);
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLabel];
    
    //评论
    _commentLabel = [[UILabel alloc] init];
    _commentLabel.numberOfLines = 0;
    _commentLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_commentLabel];
    
    //评论按钮
    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentBtn setImage:[UIImage imageNamed:@"comment_icon"] forState:UIControlStateNormal];
    [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    _commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _commentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [_commentBtn setTitleColor:_timeLabel.textColor forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(plOrDelete) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_commentBtn];
    _commentBtn.hidden = YES;
    
    //自己的评论就出现删除按钮
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_deleteBtn setTitleColor:_timeLabel.textColor forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(plOrDelete) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    _deleteBtn.hidden = YES;
}

- (void)setModel:(CommentListModel *)model {
    _model = model;
    NSString *text = [NSString string];
    if (isRightData(model.byCommentUser)) {
        text = [NSString stringWithFormat:@"%@ 回复 %@:",model.commentUser,model.byCommentUser];
    } else {
        text = [NSString stringWithFormat:@"%@ :",model.commentUser];
    }
    CGFloat labHeight = [self getMessageHeight:text];
    _cUserLabel.height = labHeight;
    
    //时间
    _timeLabel.text = [TimeAbout timestampToString:[model.createdAtStamp longLongValue] isSecondMin:NO];
    
    CGFloat width = SCREEN_WIDTH - 20 - 15;
    //评论内容
    CGFloat commentHeight = [model.content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}
                                                  context:nil].size.height;
    _commentLabel.text = model.content;
    _commentLabel.frame = CGRectMake(_cUserLabel.left, _cUserLabel.bottom + 15, width, commentHeight);
    
    //评论按钮
    if ([model.isCharger isEqualToString:@"1"]) {
        _deleteBtn.frame = CGRectMake(SCREEN_WIDTH - 75, _commentLabel.bottom + 10, 60, 20);
        [_deleteBtn sizeToFit];
        _deleteBtn.width = _deleteBtn.width + 1;
        _deleteBtn.left = SCREEN_WIDTH - _deleteBtn.width - 13;
        _deleteBtn.hidden = NO;
        _commentBtn.hidden = YES;
        model.cellHeight = _deleteBtn.bottom + 18;
    } else {
        _commentBtn.frame = CGRectMake(SCREEN_WIDTH - 75, _commentLabel.bottom + 10, 60, 20);
        [_commentBtn sizeToFit];
        _commentBtn.width = _commentBtn.width + 12;
        _commentBtn.left = SCREEN_WIDTH - _commentBtn.width - 13;
        _deleteBtn.hidden = YES;
        _commentBtn.hidden = NO;
        model.cellHeight = _commentBtn.bottom + 18;
    }
}

//YYLbael计算高度
- (CGFloat)getMessageHeight:(NSString *)mess {
    NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:mess];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为4
    [paragraphStyle  setLineSpacing:2];
    [mText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, mess.length)];
    mText.yy_font = [UIFont systemFontOfSize:kComTextFont];
    mText.yy_color = [UIColor blackColor];
    [mText yy_setFont:[UIFont boldSystemFontOfSize:kComTextFont] range:NSMakeRange(0, _model.commentUser.length)];
    //评论人点击事件
    [mText yy_setTextHighlightRange:NSMakeRange(0, _model.commentUser.length) color:kHLTextColor backgroundColor:kHLBgColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        NSLog(@"-------1");
    }];
    if (isRightData(_model.byCommentUser)) {
        [mText yy_setFont:[UIFont boldSystemFontOfSize:kComTextFont] range:NSMakeRange(_model.commentUser.length + 4, _model.byCommentUser.length)];
        //被评论人点击事件
        [mText yy_setTextHighlightRange:NSMakeRange(_model.commentUser.length + 4, _model.byCommentUser.length) color:kHLTextColor backgroundColor:kHLBgColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//            NSLog(@"-------2");
        }];
    }
    
    //    introText.yy_lineSpacing = 2;
//    mText.yy_firstLineHeadIndent = 6.f;
//    mText.yy_headIndent = 6.f;
    CGSize introSize = CGSizeMake(labWidth, CGFLOAT_MAX);
    _cUserLabel.attributedText = mText;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:mText];
    _cUserLabel.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight;
}

- (void)plOrDelete {
    if (self.clickPLBlock) {
        self.clickPLBlock(_model.commentID, _model.isCharger, _model.commentUser);
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FCDetailCell";
    FCDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FCDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
