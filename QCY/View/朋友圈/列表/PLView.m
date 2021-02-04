//
//  PLView.m
//  QCY
//
//  Created by i7colors on 2018/11/29.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PLView.h"
#import <YYText.h>
#import "Friend.h"
#import "FriendCricleModel.h"

@interface PLView()

@property (nonatomic, strong)YYLabel *commentLabel;
@end

@implementation PLView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _commentLabel = [[YYLabel alloc] init];
    _commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _commentLabel.numberOfLines = 0;
    [self addSubview:_commentLabel];
}

- (void)setCommentModel:(CommentListModel *)commentModel {
    _commentModel = commentModel;
    
    NSString *text = [NSString string];
    if (isRightData(commentModel.byCommentUser)) {
        text = [NSString stringWithFormat:@"%@回复%@: %@",commentModel.commentUser,commentModel.byCommentUser,commentModel.content];
    } else {
        text = [NSString stringWithFormat:@"%@: %@",commentModel.commentUser,commentModel.content];
    }
    CGFloat labHeight = [self getMessageHeight:text];

    _commentLabel.frame = CGRectMake(6, 0, _labelWidth - 10, labHeight + 5);
    self.height = _commentLabel.height;
}

//YYLbael计算高度
- (CGFloat)getMessageHeight:(NSString *)mess {
    __block NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:mess];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为4
    [paragraphStyle setLineSpacing:2];
    [mText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, mess.length)];
    mText.yy_font = [UIFont systemFontOfSize:kComTextFont];
    mText.yy_color = [UIColor blackColor];
    [mText yy_setFont:[UIFont boldSystemFontOfSize:kComTextFont] range:NSMakeRange(0, _commentModel.commentUser.length)];
    //评论人点击事件
    DDWeakSelf;
    [mText yy_setTextHighlightRange:NSMakeRange(0, _commentModel.commentUser.length) color:kHLTextColor backgroundColor:kHLBgColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        
        dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC));
        dispatch_after(when, dispatch_get_main_queue(), ^{
            if (weakself.clickNameBlock) {
                weakself.clickNameBlock(weakself.commentModel, @"name");
            }
        });
    }];
    
    if (isRightData(_commentModel.byCommentUser)) {
        [mText yy_setFont:[UIFont boldSystemFontOfSize:kComTextFont] range:NSMakeRange(_commentModel.commentUser.length + 2, _commentModel.byCommentUser.length)];
        //被评论人点击事件
        [mText yy_setTextHighlightRange:NSMakeRange(_commentModel.commentUser.length + 2, _commentModel.byCommentUser.length) color:kHLTextColor backgroundColor:kHLBgColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (weakself.clickNameBlock) {
                weakself.clickNameBlock(weakself.commentModel, @"byName");
            }
        }];
    }

//    mText.yy_lineSpacing = 2;
//    mText.yy_firstLineHeadIndent = 6.f;
//    mText.yy_headIndent = mText.yy_firstLineHeadIndent;
    CGSize introSize = CGSizeMake(_labelWidth - 10, MAXFLOAT);
    _commentLabel.attributedText = mText;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:mText];
    _commentLabel.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight;
}

#pragma mark - 点击
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = kHLBgColor;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    DDWeakSelf;
    dispatch_after(when, dispatch_get_main_queue(), ^{
        self.backgroundColor = [UIColor clearColor];
        if (self.clickTextBlock) {
            self.clickTextBlock(weakself.index);
        }
    });
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
}


@end
