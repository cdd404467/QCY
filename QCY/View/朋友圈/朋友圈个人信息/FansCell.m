//
//  FansCell.m
//  QCY
//
//  Created by i7colors on 2018/12/6.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FansCell.h"
#import <YYText.h>
#import "FriendCricleModel.h"
#import <UIImageView+WebCache.h>
#import "HelperTool.h"
#import "TimeAbout.h"
#import "Friend.h"
#import "ClassTool.h"

@interface FansCell()

@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong)YYLabel *nickLabel ;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *timeLabel;
//粉丝
@property (nonatomic, strong) UIButton *focusBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
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
    _headerImage.contentMode = UIViewContentModeScaleAspectFill;
    [HelperTool setRound:_headerImage corner:UIRectCornerAllCorners radiu:56 / 2];
    [self.contentView addSubview:_headerImage];
    //昵称
    _nickLabel = [[YYLabel alloc] init];
    _nickLabel.numberOfLines = 2;
    _nickLabel.frame = CGRectMake(_headerImage.right + 10, _headerImage.top, SCREEN_WIDTH - _headerImage.right - 10 - 100, 0);
    [self.contentView addSubview:_nickLabel];
    //企业认证名字
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(_nickLabel.left, 0, SCREEN_WIDTH - _nickLabel.left - 65, 13);
    _nameLabel.textColor = HEXColor(@"#686D74", 1);
    _nameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.bottom = _headerImage.bottom;
//    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.nickLabel);
//        make.bottom.mas_equalTo(self.headerImage);
//    }];

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
    
    //关注按钮
    UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    focusBtn.hidden = YES;
    [focusBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
    focusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    focusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [focusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    focusBtn.layer.borderWidth = 1.f;
    focusBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [focusBtn addTarget:self action:@selector(focusClick) forControlEvents:UIControlEventTouchUpInside];
    focusBtn.layer.cornerRadius = 6;
    [self.contentView addSubview:focusBtn];
    [focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(timeLabel);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(self.headerImage);
    }];
    _focusBtn = focusBtn;
    
    //取消关注按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.hidden = YES;
    [cancelBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [cancelBtn addTarget:self action:@selector(cancelFocusClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headerImage);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(22);
        make.right.mas_equalTo(timeLabel);
    }];
    [ClassTool addLayer:cancelBtn frame:CGRectMake(0, 0, 65, 22)];
    [HelperTool setRound:cancelBtn corner:UIRectCornerAllCorners radiu:6.f];
    _cancelBtn = cancelBtn;
}

- (void)setModel:(FriendCricleModel *)model {
    _model = model;
    if isRightData(model.userCommunityPhoto) {
        if ([[model.userCommunityPhoto substringToIndex:4] isEqualToString:@"http"]) {
            [_headerImage sd_setImageWithURL:[NSURL URLWithString:model.userCommunityPhoto] placeholderImage:PlaceHolderImg];
        } else {
            [_headerImage sd_setImageWithURL:ImgUrl(model.userCommunityPhoto) placeholderImage:PlaceHolderImg];
        }
    } else {
        _headerImage.image = DefaultImage;
    }

    //昵称
    if isRightData(model.userNickName) {
        NSMutableAttributedString *mtitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",model.userNickName]];
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
    CGFloat labelHeight = [_nickLabel.text boundingRectWithSize:CGSizeMake(_nickLabel.width, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
                                                context:nil].size.height;
    _nickLabel.height = labelHeight;
    
    //是否企业，显示企业名字
    if ([model.isCompanyType isEqualToString:@"1"]) {
        _nameLabel.text = model.companyName;
    } else {
        if ([model.isDyeV isEqualToString:@"1"]) {
            _nameLabel.text = model.dyeVName;
        } else {
            _nameLabel.text = @"";
        }
    }
    
    //关注时间
    if isRightData(model.createdAtStamp) {
        _timeLabel.text = [TimeAbout timestampToString:[model.createdAtStamp longLongValue] isSecondMin:NO];
    } else {
        _timeLabel.text = @"未知";
    }
    
    //显示关注还是取消关注按钮,关注按钮是否隐藏
    //未登陆按钮逗不展示
    if (!GET_USER_TOKEN) {
        _focusBtn.hidden = YES;
        _cancelBtn.hidden = YES;
    } else {
        //登陆后，如果是已经关注的，显示取消关注按钮
        if (model.isFollow == 1) {
            _focusBtn.hidden = YES;
            _cancelBtn.hidden = NO;
            _nameLabel.width = SCREEN_WIDTH - _nickLabel.left - 85;
        } else {
            if ([model.isSelf integerValue] == 1) {
                _focusBtn.hidden = YES;
                _cancelBtn.hidden = YES;
                _nameLabel.width = SCREEN_WIDTH - _nickLabel.left - 15;
            } else {
                _focusBtn.hidden = NO;
                _cancelBtn.hidden = YES;
                _nameLabel.width = SCREEN_WIDTH - _nickLabel.left - 65;
            }
        }
    }
    
}

- (void)focusClick {
    if (self.focusBlock)
        self.focusBlock(_model.userId);
}

- (void)cancelFocusClick {
    if (self.cancelFocusBlock)
        self.cancelFocusBlock(_model.userId, _model.userNickName);
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
