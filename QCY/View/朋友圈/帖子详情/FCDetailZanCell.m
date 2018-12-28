//
//  FCDetailZanCell.m
//  QCY
//
//  Created by i7colors on 2018/12/16.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCDetailZanCell.h"
#import "MacroHeader.h"
#import "UIView+Geometry.h"
#import "HelperTool.h"
#import "Friend.h"
#import <UIImageView+WebCache.h>
#import "FriendCricleModel.h"
#import "TimeAbout.h"

@interface FCDetailZanCell()
@property (nonatomic, strong)UIImageView *headerImageView;
@property (nonatomic, strong)UILabel *nickNameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@end

@implementation FCDetailZanCell

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
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.frame = CGRectMake(20, 15, 40, 40);
    [HelperTool setRound:_headerImageView corner:UIRectCornerAllCorners radiu:40 * 0.5];
    [self.contentView addSubview:_headerImageView];
    
    _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerImageView.right + 10, _headerImageView.top, SCREEN_WIDTH - 90, 17)];
    _nickNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
    _nickNameLabel.textColor = kHLTextColor;
    _nickNameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_nickNameLabel];
    
    //时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.0];
    _timeLabel.frame = CGRectMake(_nickNameLabel.left, _nickNameLabel.bottom + 8, _nickNameLabel.width, 14);
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_timeLabel];
    
}

- (void)setModel:(LikeListModel *)model {
    _model = model;
    //头像
    if isRightData(model.likeUserPhoto) {
        [_headerImageView sd_setImageWithURL:ImgUrl(model.likeUserPhoto) placeholderImage:PlaceHolderImg];
    } else {
        _headerImageView.image = DefaultImage;
    }
    
    //昵称
    if isRightData(model.likeUser)
        _nickNameLabel.text = model.likeUser;
    
    //时间
    _timeLabel.text = [TimeAbout timestampToString:[model.createdAtStamp longLongValue]];
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FCDetailZanCell";
    FCDetailZanCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FCDetailZanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
