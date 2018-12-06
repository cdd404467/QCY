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
#import <YYWebImage.h>
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
    UILabel *msgTitle = [[UILabel alloc] init];
    msgTitle.frame = CGRectMake(Margin, 14, KFit_W(200), 16);
    msgTitle.textColor = HEXColor(@"#000000", 1);
    [self.contentView addSubview:msgTitle];
    _msgTitle = msgTitle;
    
    
//    UILabel *timeLabel = [[UILabel alloc] init];
//    timeLabel.textColor = HEXColor(@"#868686", 1);
//    timeLabel.textAlignment = NSTextAlignmentRight;
//    timeLabel.font = [UIFont systemFontOfSize:12];
//    [self.contentView addSubview:timeLabel];
//    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15);
//        make.top.mas_equalTo(15);
////        make.height.mas_equalTo(16);
//        make.width.mas_equalTo(KFit_W(125));
//    }];
//    _timeLabel = timeLabel;
//
//    UILabel *msgTitle = [[UILabel alloc] init];
//    msgTitle.textColor = HEXColor(@"#000000", 1);
//    msgTitle.font = [UIFont boldSystemFontOfSize:14];
//    [self.contentView addSubview:msgTitle];
//    [msgTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(15);
//        make.left.mas_equalTo(12);
////        make.height.mas_equalTo(16);
//        make.right.mas_equalTo(timeLabel.mas_left).offset(5);
//    }];
//
//    _msgTitle = msgTitle;
//
//    UIImageView *contentImage = [[UIImageView alloc] init];
//    contentImage.backgroundColor = HEXColor(@"#E5E5E5", 1);
//    [self.contentView addSubview:contentImage];
//    [contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.height.mas_greaterThanOrEqualTo(KFit_W(156));
//        make.top.mas_equalTo(msgTitle.mas_bottom).offset(14);
////        make.bottom.mas_equalTo(0);
//    }];
//    _contentImage = contentImage;
//
////
////    UILabel *onlyText = [[UILabel alloc] init];
////    _onlyText = onlyText;
////
//    //描述
//    UILabel *desLabel = [[UILabel alloc] init];
//    desLabel.textColor = HEXColor(@"#868686", 1);
//    desLabel.text = @"我是描述";
//    desLabel.font = [UIFont boldSystemFontOfSize:14];
//    [self.contentView addSubview:desLabel];
//    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(msgTitle);
//        make.right.mas_equalTo(-15);
//        make.top.mas_equalTo(contentImage.mas_bottom).offset(0);
//        make.bottom.mas_equalTo(0);
//    }];
//    _desLabel = desLabel;
    
   
    
}

- (void)setModel:(MessageModel *)model {
    _model = model;
    //标题
    if isRightData(model.title)
        _msgTitle.text = model.title;
    //创建时间
    if isRightData(model.createdAt)
        _timeLabel.text = model.createdAt;
    
    //图片
    if isRightData(model.type) {
        //不是纯文本就加载图片
        if(![model.type isEqualToString:@"txt"]) {

            [_contentImage yy_setImageWithURL:ImgUrl(model.pic) placeholder:PlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];

        }
    }
    
    
    if isRightData(model.pic)
        _desLabel.text = model.pic;
    
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
