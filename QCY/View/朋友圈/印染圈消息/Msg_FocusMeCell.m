//
//  Msg_FocusMeCell.m
//  QCY
//
//  Created by i7colors on 2019/4/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "Msg_FocusMeCell.h"
#import <YYText.h>
#import <UIImageView+WebCache.h>
#import "HelperTool.h"
#import "TimeAbout.h"
#import "Friend.h"
#import "ClassTool.h"
#import "HelperTool.h"
#import "FriendCricleModel.h"


@interface Msg_FocusMeCell()
@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong)YYLabel *nickLabel;
@property (nonatomic, strong)UILabel *contentLab;
@property (nonatomic, strong)UILabel *certNameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *tagLab;
@property (nonatomic, strong)UIButton *addBtn;
@end

@implementation Msg_FocusMeCell

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
        make.left.right.mas_equalTo(nickLabel);
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
    
    //评论内容
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.textColor = HEXColor(@"#868686", 1);
    contentLab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:contentLab];
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(certNameLabel);
        make.top.mas_equalTo(certNameLabel.mas_bottom).offset(8);
    }];
    _contentLab = contentLab;
    
    //添加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.hidden = YES;
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(headerImage.mas_bottom);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
        make.right.mas_equalTo(timeLabel.mas_right);
    }];
    [ClassTool addLayer:addBtn frame:CGRectMake(0, 0, 50, 20)];
    [HelperTool setRound:addBtn corner:UIRectCornerAllCorners radiu:10.f];
    _addBtn = addBtn;
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
    
    //是否显示添加按钮
    _addBtn.hidden = model.isFollow == 1 ? YES : NO;
    
    //类型
    NSString *str1 = @"内容: 你好,希望加您为好友相互关注。";
    NSString *str2 = @"内容: 我们已经是好友了";
    _contentLab.text = [model.type isEqualToString:@"follow"] ? str1 : str2;
    
    //是否已读
    _tagLab.hidden = model.isRead == 0 ? NO : YES;
}

- (void)addBtnClick {
    if (self.addFriendsBlock)
        self.addFriendsBlock(_model);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"Msg_FocusMeCell";
    Msg_FocusMeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[Msg_FocusMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
