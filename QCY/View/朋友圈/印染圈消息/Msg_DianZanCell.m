//
//  Msg_DianZanCell.m
//  QCY
//
//  Created by i7colors on 2019/4/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "Msg_DianZanCell.h"
#import <YYText.h>
#import <UIImageView+WebCache.h>
#import "HelperTool.h"
#import "TimeAbout.h"
#import "Friend.h"
#import "FriendCricleModel.h"

@interface Msg_DianZanCell()
@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong)YYLabel *nickLabel ;
@property (nonatomic, strong)UILabel *certNameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *zanLab;
@property (nonatomic, strong)UILabel *tagLab;

@end

@implementation Msg_DianZanCell

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
    UIImageView *headerImage = [[UIImageView alloc] init];
    headerImage.frame = CGRectMake(14, (80 - 50) / 2, 50, 50);
    [HelperTool setRound:headerImage corner:UIRectCornerAllCorners radiu:56 / 2];
    [self.contentView addSubview:headerImage];
    _headerImage = headerImage;
    
    UILabel *tagLab = [[UILabel alloc] initWithFrame:CGRectMake(headerImage.left, headerImage.top, 7, 7)];
    tagLab.backgroundColor = UIColor.redColor;
    tagLab.hidden = YES;
    [self.contentView addSubview:tagLab];
    [HelperTool setRound:tagLab corner:UIRectCornerAllCorners radiu:tagLab.width * .5];
    _tagLab = tagLab;
    
    //昵称
    YYLabel *nickLabel = [[YYLabel alloc] init];
    nickLabel.frame = CGRectMake(headerImage.right + 10, headerImage.top - 3 , SCREEN_WIDTH - headerImage.right - 7 - 130, 16);
    [self.contentView addSubview:nickLabel];
    _nickLabel = nickLabel;
    
    //企业认证名字
    UILabel *certNameLabel = [[UILabel alloc] init];
    certNameLabel.textColor = HEXColor(@"#686D74", 1);
    certNameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:certNameLabel];
    [certNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(nickLabel);
        make.top.mas_equalTo(nickLabel.mas_bottom).offset(6);
    }];
    _certNameLabel = certNameLabel;
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = HEXColor(@"#868686", 1);
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImage.mas_top);
        make.right.mas_equalTo(-7);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(nickLabel.mas_right).offset(0);
    }];
    _timeLabel = timeLabel;
    
    //赞了我
    UIImageView *zanImageView = [[UIImageView alloc] init];
    zanImageView.image = [UIImage imageNamed:@"fc_msg_zan"];
    [self.contentView addSubview:zanImageView];
    [zanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(certNameLabel);
        make.top.mas_equalTo(certNameLabel.mas_bottom).offset(6);
        make.width.mas_equalTo(17);
        make.height.mas_equalTo(15);
    }];

    UILabel *zanLab = [[UILabel alloc] init];
    zanLab.text = @"赞了我";
    zanLab.textColor = HEXColor(@"#868686", 1);
    zanLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:zanLab];
    [zanLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(zanImageView.mas_right).offset(7);
        make.right.height.mas_equalTo(certNameLabel);
        make.centerY.mas_equalTo(zanImageView.mas_centerY);
    }];
    
    //详情
    UILabel *detailLab = [[UILabel alloc] init];
    detailLab.text = @"详情";
    detailLab.textAlignment = NSTextAlignmentRight;
    detailLab.font = [UIFont systemFontOfSize:13];
    detailLab.textColor = HEXColor(@"#637CB4", 1);
    [self.contentView addSubview:detailLab];
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.width.height.mas_equalTo(timeLabel);
        make.bottom.mas_equalTo(headerImage);
    }];
    
}

- (void)setModel:(FCMsgModel *)model {
    _model = model;
    //头像
    if isRightData(model.postUserPhoto) {
        if ([[model.postUserPhoto substringToIndex:4] isEqualToString:@"http"]) {
            [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.postUserPhoto] placeholderImage:PlaceHolderImg];
        } else {
            [_headerImage sd_setImageWithURL:ImgUrl(model.postUserPhoto) placeholderImage:PlaceHolderImg];
        }
    } else {
        _headerImage.image = DefaultImage;
    }
    
    //昵称
    if isRightData(model.postUserName) {
        NSMutableAttributedString *mtitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",model.postUserName]];
        mtitle.yy_color = kHLTextColor;
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
    
    //是否企业，显示企业名字
    if ([model.postUserIsCompany isEqualToString:@"1"]) {
        _certNameLabel.text = model.postUserCompanyName;
    } else {
        if ([model.postUserIsDyeV isEqualToString:@"1"]) {
            _certNameLabel.text = model.postUserDyeVName;
        } else {
            _certNameLabel.text = @"";
        }
    }
    
    //关注时间
    if isRightData(model.createdAtStamp) {
        _timeLabel.text = [TimeAbout timestampToStringAsOfMin:[model.createdAtStamp longLongValue]];
    } else {
        _timeLabel.text = @"未知";
    }
    
    //是否已读
    _tagLab.hidden = model.isRead == 0 ? NO : YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"Msg_DianZanCell";
    Msg_DianZanCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[Msg_DianZanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
