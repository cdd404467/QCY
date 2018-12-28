//
//  FCUnReadMsgCell.m
//  QCY
//
//  Created by i7colors on 2018/12/17.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCUnReadMsgCell.h"
#import "MacroHeader.h"
#import "UIView+Geometry.h"
#import "Friend.h"
#import "HelperTool.h"
#import <UIImageView+WebCache.h>
#import "FriendCricleModel.h"
#import "TimeAbout.h"

@interface FCUnReadMsgCell()

@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong)UILabel *nickNameLabel;
@property (nonatomic, strong)UILabel *mainLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@end

@implementation FCUnReadMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    _headerImage = [[UIImageView alloc] init];
    _headerImage.frame = CGRectMake(12, 15, kFaceWidth, kFaceWidth);
    [HelperTool setRound:_headerImage corner:UIRectCornerAllCorners radiu:3];
    [self.contentView addSubview:_headerImage];
    
    //昵称
    _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerImage.right + 10, _headerImage.top, SCREEN_WIDTH - _headerImage.right - 20, 17)];
    _nickNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    _nickNameLabel.textColor = kHLTextColor;
    _nickNameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_nickNameLabel];
    
    //文本
    _mainLabel = [[UILabel alloc] init];;
    _mainLabel.font = [UIFont systemFontOfSize:14];
    _mainLabel.frame = CGRectMake(_nickNameLabel.left, _nickNameLabel.bottom + 6, _nickNameLabel.width, 16);
//    _mainLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_mainLabel];
    
    // 时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.0];
    _timeLabel.frame = CGRectMake(_mainLabel.left, _mainLabel.bottom + 6, _nickNameLabel.width, 14);
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_timeLabel];
}

- (void)setModel:(CommentListModel *)model {
    _model = model;
    //头像
    if isRightData(model.commentPhoto) {
        [_headerImage sd_setImageWithURL:ImgUrl(model.commentPhoto) placeholderImage:PlaceHolderImg];
    } else {
        _headerImage.image = DefaultImage;
    }
    
    //昵称
    _nickNameLabel.text = model.commentUser;
    
    //文本
    _mainLabel.text = model.content;
    
    //时间
    _timeLabel.text = [TimeAbout timestampToString:[model.createdAtStamp longLongValue]];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FCUnReadMsgCell";
    FCUnReadMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FCUnReadMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
