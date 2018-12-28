//
//  FansCell.m
//  QCY
//
//  Created by i7colors on 2018/12/6.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FansCell.h"
#import "UIView+Geometry.h"
#import "MacroHeader.h"
#import <YYText.h>
#import "FriendCricleModel.h"
#import <UIImageView+WebCache.h>
#import "HelperTool.h"
#import <Masonry.h>
#import "TimeAbout.h"

@interface FansCell()

@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong)YYLabel *nickLabel ;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@end

@implementation FansCell

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
    //头像
    _headerImage = [[UIImageView alloc] init];
    _headerImage.frame = CGRectMake(14, (90 - 56) / 2, 56, 56);
    [HelperTool setRound:_headerImage corner:UIRectCornerAllCorners radiu:56 / 2];
    [self.contentView addSubview:_headerImage];
    //昵称
    _nickLabel = [[YYLabel alloc] init];
    _nickLabel.numberOfLines = 2;
    _nickLabel.frame = CGRectMake(_headerImage.right + 10, _headerImage.top, SCREEN_WIDTH - _headerImage.right - 10 - 100, 0);
    [self.contentView addSubview:_nickLabel];
    //企业认证名字
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = HEXColor(@"#686D74", 1);
    _nameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.nickLabel);
        make.bottom.mas_equalTo(self.headerImage);
    }];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = HEXColor(@"#868686", 1);
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerImage.mas_top);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.nickLabel.mas_right).offset(0);
    }];
    _timeLabel = timeLabel;
}

- (void)setModel:(FriendCricleModel *)model {
    _model = model;
    if isRightData(model.userCommunityPhoto) {
        [_headerImage sd_setImageWithURL:ImgUrl(model.userCommunityPhoto) placeholderImage:PlaceHolderImg];
    } else {
        _headerImage.image = DefaultImage;
    }

    //昵称
    if isRightData(model.userNickName) {
        NSMutableAttributedString *mtitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",model.userNickName]];
        mtitle.yy_color = HEXColor(@"#ED3851", 1);
        UIFont *font = [UIFont boldSystemFontOfSize:15];
        mtitle.yy_font = font;

        UIImageView *levelImageView = [[UIImageView alloc] init];
        levelImageView.frame = CGRectMake(0, 0, 15, 15);
        NSString *imageStr = [NSString string];
        if ([model.bossLevel isEqualToString:@"1"]) {
            imageStr = @"level_1";
        } else if ([model.bossLevel isEqualToString:@"2"]) {
            imageStr = @"level_2";
        } else if ([model.bossLevel isEqualToString:@"3"]) {
            imageStr = @"level_3";
        } else {
            imageStr = @" ";
        }
        levelImageView.image = [UIImage imageNamed:imageStr];
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:levelImageView contentMode:UIViewContentModeCenter attachmentSize:levelImageView.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [mtitle appendAttributedString:attachText];

        
        _nickLabel.attributedText = mtitle;
    }
    CGFloat labelHeight = [_nickLabel.text boundingRectWithSize:CGSizeMake(_nickLabel.width, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
                                                context:nil].size.height;
    _nickLabel.height = labelHeight;
    
    //是否企业，显示x企业名字
    if ([model.isCompanyType isEqualToString:@"1"]) {
        _nameLabel.text = model.companyName;
    } else {
        _nameLabel.text = @" ";
    }
    
    //关注时间
    if isRightData(model.createdAtStamp) {
        _timeLabel.text = [TimeAbout timestampToString:[model.createdAtStamp longLongValue] isSecondMin:NO];
    } else {
        _timeLabel.text = @"未知";
    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FansCell";
    FansCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
