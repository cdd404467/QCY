//
//  FriendCricleCell.m
//  QCY
//
//  Created by i7colors on 2018/11/25.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FriendCricleCell.h"
#import "Friend.h"
#import "FriendCricleModel.h"
#import <UIImageView+WebCache.h>
#import "WeiChatPhotoView.h"
#import "Utility.h"
#import "OperateMenuView.h"
#import "HelperTool.h"
#import <UIImageView+WebCache.h>
#import "PLView.h"
#import "HelperTool.h"
#import <MLLinkLabel.h>
#import "FCZiXunView.h"
#import <YYText.h>

// 最大高度限制
CGFloat maxLimitHeight = 110;
#define TimeBackGround 0.08

@interface FriendCricleCell()
// 头像
@property (nonatomic, strong) UIImageView *headImageView;
//是否已经认证
@property (nonatomic, strong) UILabel *isCertLabel;
//大V认证图标
@property (nonatomic, strong) UIImageView *bigVImageView;
//粉丝
@property (nonatomic, strong) UILabel *fansCountLabel;
// 名称
@property (nonatomic, strong) YYLabel *nameLabel;
//认证名字
@property (nonatomic, strong) UILabel *certNameLabel;
//话题
@property (nonatomic, strong) UIButton *topicBtn;
//关注按钮
@property (nonatomic, strong) UIButton *focusBtn;
// 正文
@property (nonatomic, strong) MLLinkLabel *mainLabel;
// 全文按钮
@property (nonatomic, strong) UIButton *showAllBtn;
// 图片九宫格
@property (nonatomic, strong) WeiChatPhotoView *photoGroup;
//分享咨询view
@property (nonatomic, strong) FCZiXunView *ziXunView;
//定位位置
@property (nonatomic, strong) UIButton *locationBtn;
// 时间
@property (nonatomic, strong) UILabel *timeLabel;
//点击进入详情的按钮
@property (nonatomic, strong) UIButton *lookDetailBtn;
// 删除
@property (nonatomic, strong) UIButton *deleteBtn;
//菜单按钮
@property (nonatomic, strong) UIButton *menuBtn;
// 赞和评论视图
@property (nonatomic, strong) UIImageView *commentView;

@end

@implementation FriendCricleCell

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

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI {
    DDWeakSelf;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:@"cellMenu" object:nil];
    // 头像视图
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KFit_W(12), kBlank , kHeadWidth, kHeadWidth)];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [HelperTool addTapGesture:_headImageView withTarget:self andSEL:@selector(userHeaderClick)];
    [HelperTool setRound:_headImageView corner:UIRectCornerAllCorners radiu:5];
    [self.contentView addSubview:_headImageView];
    
    //大V认证图标
    _bigVImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHeadWidth - 14, kHeadWidth - 14, 14, 14)];
    _bigVImageView.image = [UIImage imageNamed:@"bigV_img"];
    _bigVImageView.hidden = YES;
    [HelperTool setRound:_bigVImageView corner:UIRectCornerAllCorners radiu:7];
    [_headImageView addSubview:_bigVImageView];
    
    //头像下方是否已经认证
    _isCertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _headImageView.bottom + 5, kHeadWidth, 16)];
    _isCertLabel.font = [UIFont systemFontOfSize:9];
    _isCertLabel.textAlignment = NSTextAlignmentCenter;
    _isCertLabel.layer.cornerRadius = 8;
    _isCertLabel.layer.borderWidth = 0.6;
    _isCertLabel.centerX = _headImageView.centerX;
    [self.contentView addSubview:_isCertLabel];
    
    //粉丝label
    UILabel *fansText = [[UILabel alloc] initWithFrame:CGRectMake(_isCertLabel.left, _isCertLabel.bottom + 3, kHeadWidth, 12)];
    fansText.textColor = HEXColor(@"#708090", 1);
    fansText.font = [UIFont systemFontOfSize:9];
    fansText.text = @"粉丝";
    fansText.textAlignment = NSTextAlignmentCenter;
    fansText.centerX = _headImageView.centerX;
    [self.contentView addSubview:fansText];
    
    //粉丝
    _fansCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, fansText.bottom + 1, 55, 12)];
    _fansCountLabel.textColor = HEXColor(@"#ED3851", 1);
    _fansCountLabel.font = [UIFont systemFontOfSize:11];
    _fansCountLabel.textAlignment = NSTextAlignmentCenter;
    _fansCountLabel.centerX = _headImageView.centerX;
    [self.contentView addSubview:_fansCountLabel];
    
    // 名字视图
    _nameLabel = [[YYLabel alloc] initWithFrame:CGRectMake(_headImageView.right + 10, _headImageView.top, SCREEN_WIDTH - _headImageView.right - 75, 0)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:17.0];
    _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _nameLabel.numberOfLines = 2;
    _nameLabel.textColor = kHLTextColor;
    [self.contentView addSubview:_nameLabel];
    
    //认证名字，可能没有
    _certNameLabel = [[UILabel alloc] init];
    _certNameLabel.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + kPaddingValue, kTextWidth, 0);
    _certNameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    _certNameLabel.textColor = HEXColor(@"#808080", 1.0);
    _certNameLabel.numberOfLines = 2;
    _certNameLabel.hidden = YES;
    [self.contentView addSubview:_certNameLabel];
    
    //话题，可能没有
    _topicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _topicBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [_topicBtn setTitleColor:MainColor forState:UIControlStateNormal];
    [_topicBtn addTarget:self action:@selector(gotoTopicList:) forControlEvents:UIControlEventTouchUpInside];
    [_topicBtn setBackgroundImage:[UIImage imageWithColor:kHLBgColor] forState:UIControlStateHighlighted];
    [self.contentView addSubview:_topicBtn];
    
    //关注按钮
    _focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _focusBtn.frame = CGRectMake(SCREEN_WIDTH - 45 - 15, 0, 45, 20);
    _focusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _focusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _focusBtn.top = _nameLabel.top;
    [_focusBtn addTarget:self action:@selector(focusClick) forControlEvents:UIControlEventTouchUpInside];
    _focusBtn.layer.cornerRadius = 6;
    [self.contentView addSubview:_focusBtn];
    
    // 正文视图
    _mainLabel = [[MLLinkLabel alloc] init];;
    _mainLabel.font = kTextFont;
    _mainLabel.numberOfLines = 0;
    _mainLabel.textColor = RGBA(0, 0, 0, 0.9);
    _mainLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _mainLabel.hidden = YES;
    [self.contentView addSubview:_mainLabel];
    
    // 查看'全文'按钮
    _showAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _showAllBtn.titleLabel.font = kTextFont;
    _showAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _showAllBtn.backgroundColor = [UIColor whiteColor];
    [_showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
    [_showAllBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_showAllBtn addTarget:self action:@selector(fullTextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_showAllBtn setBackgroundImage:[UIImage imageWithColor:kHLBgColor] forState:UIControlStateHighlighted];
    [self.contentView addSubview:_showAllBtn];
    
    // 图片九宫格
    _photoGroup = [[WeiChatPhotoView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_photoGroup];
    
    //咨询view
    _ziXunView = [[FCZiXunView alloc] initWithFrame:CGRectMake(_nameLabel.left, 0, SCREEN_WIDTH - kRightMargin - _nameLabel.left, 50)];
    _ziXunView.backgroundColor = HEXColor(@"#f3f3f3", 1);
    _ziXunView.clickZiXunViewBlock = ^{
        [weakself gotoZiXunDetail];
    };
    [self.contentView addSubview:_ziXunView];
    
    //定位
    _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_locationBtn setImage:[UIImage imageNamed:@"location_icon"] forState:UIControlStateNormal];
    _locationBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_locationBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(gotoMap:) forControlEvents:UIControlEventTouchUpInside];
    [_locationBtn setBackgroundImage:[UIImage imageWithColor:kHLBgColor] forState:UIControlStateHighlighted];
    [self.contentView addSubview:_locationBtn];
    
    // 时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.0];
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_timeLabel];
    
    //点击详情
    _lookDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lookDetailBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_lookDetailBtn setTitle:@"详情" forState:UIControlStateNormal];
    [_lookDetailBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_lookDetailBtn addTarget:self action:@selector(lookDetail:) forControlEvents:UIControlEventTouchUpInside];
    [_lookDetailBtn setBackgroundImage:[UIImage imageWithColor:kHLBgColor] forState:UIControlStateHighlighted];
    [self.contentView addSubview:_lookDetailBtn];
    
    // 删除视图
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteDyn:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setBackgroundImage:[UIImage imageWithColor:kHLBgColor] forState:UIControlStateHighlighted];
    [self.contentView addSubview:_deleteBtn];
    
    //赞和评论的view
    _commentView = [[UIImageView alloc] init];
    _commentView.userInteractionEnabled = YES;
    _commentView.image = [[UIImage imageNamed:@"comment_Bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
    [self.contentView addSubview:_commentView];
    
    //弹出点赞、评论视图
    _menuView = [[OperateMenuView alloc] init];
    _menuView.show = NO;
    [_menuView setLikeMoment:^{
        if ([weakself.friendDelegate respondsToSelector:@selector(didZan:)]) {
            [weakself.friendDelegate didZan:weakself.model.tieziID];
        }
    }];
    [_menuView setCommentMoment:^{
        if ([weakself.friendDelegate respondsToSelector:@selector(didComment:)]) {
            [weakself.friendDelegate didComment:weakself.model.tieziID];
        }
    }];
    
    [self.contentView addSubview:_menuView];
}



//设置数据，计算cell高度
- (void)setModel:(FriendCricleModel *)model {
    _model = model;
    CGFloat bottom = 0.0;
    /*** 头像 ***/
    if isRightData(model.postUserPhoto) {
        if ([[model.postUserPhoto substringToIndex:4] isEqualToString:@"http"]) {
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.postUserPhoto] placeholderImage:PlaceHolderImg];
        } else {
            [_headImageView sd_setImageWithURL:ImgUrl(model.postUserPhoto) placeholderImage:PlaceHolderImg];
        }
    } else {
        _headImageView.image = DefaultImage;
    }
    
    /*** 是否认证 ***/
        //公司是企业类型或者经过大V认证的,都是已经认证的
    if (model.isCompanyType.integerValue == 1 || model.isDyeV.integerValue == 1) {
        _isCertLabel.text = @"已认证";
        _isCertLabel.textColor = HEXColor(@"#F10215", 1);
        _isCertLabel.layer.borderColor = HEXColor(@"#F10215", 1).CGColor;
        _bigVImageView.hidden = NO;
    } else {
        _isCertLabel.text = @"未认证";
        _isCertLabel.textColor = HEXColor(@"#868686", 1);
        _isCertLabel.layer.borderColor = HEXColor(@"#868686", 1).CGColor;
        _bigVImageView.hidden = YES;
    }
    
    /*** 粉丝 ***/
    _fansCountLabel.text = model.dyeFollowCount.integerValue > 9999 ? @"9999+" : model.dyeFollowCount;
    
    /*** 昵称 ***/
    if isRightData(model.postUser) {
        NSString *nickName = [model.postUser stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        _nameLabel.text = nickName;
        NSMutableAttributedString *mtitle = [[NSMutableAttributedString alloc] initWithString:nickName];
        if (isRightData(model.bossLevel) && model.bossLevel.integerValue != 0) {
            UIImageView *levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
            levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level_%@",model.bossLevel]];
            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:levelImageView contentMode:UIViewContentModeCenter attachmentSize:levelImageView.size alignToFont:_nameLabel.font alignment:YYTextVerticalAlignmentCenter];
            [mtitle appendAttributedString:attachText];
        }
        mtitle.yy_color = _nameLabel.textColor;
        mtitle.yy_font = _nameLabel.font;
        mtitle.yy_lineBreakMode = NSLineBreakByCharWrapping;
        if (!GET_USER_TOKEN || model.isCharger == 1) {
            _nameLabel.width = SCREEN_WIDTH - _headImageView.right - 25;
        } else {
            _nameLabel.width = SCREEN_WIDTH - _headImageView.right - 70;
        }
        
        //YYLabel计算高度
        _nameLabel.attributedText = mtitle;
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(_nameLabel.width, MAXFLOAT) text:mtitle];
        _nameLabel.textLayout = layout;
        CGFloat nameHeight = layout.textBoundingSize.height;
        _nameLabel.height = nameHeight;
        bottom = _nameLabel.bottom + kPaddingValue;
    }
    
    /*** 是否已关注 ***/
    if (!GET_USER_TOKEN || model.isCharger == 1) {
        _focusBtn.hidden = YES;
    } else {
        _focusBtn.hidden = NO;
        if (model.isFollow == 0) {
            [_focusBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
            [_focusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _focusBtn.layer.borderWidth = 1.f;
            _focusBtn.layer.borderColor = [UIColor blackColor].CGColor;
            [_focusBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        } else {
            [_focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [_focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _focusBtn.layer.borderWidth = 0.f;
            [_focusBtn setBackgroundImage:[UIImage imageNamed:@"friend_btn_bg"] forState:UIControlStateNormal];
        }
    }
    
    /*** 认证名字 ***/
    _certNameLabel.top = bottom - 4;
    if (model.isCompanyType.integerValue == 1) {
        _certNameLabel.hidden = NO;
        _certNameLabel.text = [model.companyName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        CGFloat certHeight = [_certNameLabel.text boundingRectWithSize:CGSizeMake(kTextWidth, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:_certNameLabel.font}
                                                              context:nil].size.height;
        _certNameLabel.height = certHeight;
        bottom = _certNameLabel.bottom + kPaddingValue;
    } else {
        if (model.isDyeV.integerValue == 1) {
            _certNameLabel.text = [model.dyeVName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            _certNameLabel.hidden = NO;
            CGFloat certHeight = [_certNameLabel.text boundingRectWithSize:CGSizeMake(kTextWidth, CGFLOAT_MAX)
                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                attributes:@{NSFontAttributeName:_certNameLabel.font}
                                                                   context:nil].size.height + 1;
            _certNameLabel.height = certHeight;
            bottom = _certNameLabel.bottom + kPaddingValue;
        } else {
            _certNameLabel.hidden = YES;
            bottom = _nameLabel.bottom + kPaddingValue;
        }
    }
    
    /*** 话题 ***/
    if ([_cellType isEqualToString:@"noTopic"]) {
        _topicBtn.hidden = YES;
    } else {
        if (isRightData([model.topic.topicList[0] title])) {
            _topicBtn.hidden = NO;
            NSString *text = [NSString stringWithFormat:@"#%@#",[model.topic.topicList[0] title]];
            NSString *btnText = [NSString stringWithFormat:@"参与话题:%@",text];
            NSMutableAttributedString *btnAttStr = [[NSMutableAttributedString alloc] initWithString:btnText];
            [btnAttStr addAttribute:NSForegroundColorAttributeName value:HEXColor(@"#333333", .8) range:NSMakeRange(0, 5)];
            [btnAttStr addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(5, text.length)];
            btnAttStr.yy_font = _topicBtn.titleLabel.font;
            [_topicBtn setAttributedTitle:btnAttStr forState:UIControlStateNormal];
            CGFloat topicWidth = [btnText boundingRectWithSize:CGSizeMake(kTextWidth - 50, kTimeLabelH)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:_topicBtn.titleLabel.font}
                                                       context:nil].size.width;
            _topicBtn.frame = CGRectMake(_nameLabel.left, bottom, topicWidth, kTimeLabelH);
            bottom = _topicBtn.bottom + kPaddingValue;
        } else {
            _topicBtn.hidden = YES;
        }
    }
    
    /*** 正文 ***/
    _showAllBtn.hidden = YES;
    //如果有文本
    if isRightData(model.content) {
        _mainLabel.hidden = NO;
        //去掉首尾空格和换行
        NSString *content = [model.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        _mainLabel.text = content;
        CGFloat mainHeight = [_mainLabel.text boundingRectWithSize:CGSizeMake(kTextWidth, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : _mainLabel.font}
                                                       context:nil].size.height;
        //如果文字大于6行
        if (mainHeight > maxLimitHeight) {
            if (model.isFullText) {
                [self.showAllBtn setTitle:@"收起" forState:UIControlStateNormal];
                _mainLabel.numberOfLines = 0;
            } else {
                mainHeight = _mainLabel.font.lineHeight * 6;
                [self.showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
                _mainLabel.numberOfLines = 6;
            }
            _showAllBtn.hidden = NO;
        } else {
            _showAllBtn.hidden = YES;
        }
        
        _mainLabel.frame = CGRectMake(_nameLabel.left, bottom, kTextWidth, mainHeight);
        
        //展开全文按钮的frame
        CGFloat btnWidth = [_showAllBtn.titleLabel.text boundingRectWithSize:CGSizeMake(kMoreLabWidth, _showAllBtn.height)
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName : _showAllBtn.titleLabel.font}
                                                                     context:nil].size.width;
        _showAllBtn.frame = CGRectMake(_nameLabel.left, _mainLabel.bottom + kPaddingValue, btnWidth, kMoreLabHeight);
        //正文中的链接
        [_mainLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            if (link.linkType == MLLinkTypeURL) {
                //没有加http协议头的网址要加上
                if (![linkText hasPrefix:@"http://"] && ![linkText hasPrefix:@"https://"]) {
                    linkText = [NSString stringWithFormat:@"https://%@",linkText];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkText]];
                });
            } else if (link.linkType == MLLinkTypePhoneNumber) {
                NSString *tel = [NSString stringWithFormat:@"tel://%@",linkText];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
                });
            }
        }];
        
        bottom = _showAllBtn.hidden == YES ? _mainLabel.bottom + kPaddingValue : _showAllBtn.bottom + kPaddingValue;
    } else {
        _mainLabel.hidden = YES;
    }
    
    /*** 9宫格图片 ***/
    NSMutableArray *imgArr = [self addPic:model];
    _photoGroup.videoURL = [NSString stringWithFormat:@"%@%@",Photo_URL,model.url];
    _photoGroup.videoPicWidth = model.videoPicWidth;
    _photoGroup.videoPicHight = model.videoPicHigh;
    _photoGroup.pic1Width = model.pic1Width;
    _photoGroup.pic1Hight = model.pic1High;
    _photoGroup.type = model.type;
    _photoGroup.urlArray = imgArr;  //放在最后
    if (imgArr.count > 0) {
        _photoGroup.hidden = NO;
        _photoGroup.origin = CGPointMake(_nameLabel.left, bottom);
        bottom = _photoGroup.bottom + kPaddingValue;
    } else {
        _photoGroup.hidden = YES;
    }

    /*** 咨询View ***/
    if (isRightData(model.shareBean.title)) {
        _ziXunView.model = model.shareBean;
        _ziXunView.top = bottom;
        _ziXunView.hidden = NO;
        bottom = _ziXunView.bottom + kPaddingValue;
    } else {
        _ziXunView.hidden = YES;
    }
    
    /*** 定位地址 ***/
    if isRightData(model.locationTitle) {
        [_locationBtn setTitle:model.locationTitle forState:UIControlStateNormal];
        _locationBtn.hidden = NO;
        CGFloat locWidth = [model.locationTitle boundingRectWithSize:CGSizeMake(kTextWidth, kTimeLabelH)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:_locationBtn.titleLabel.font}
                                                          context:nil].size.width + 14;
        _locationBtn.frame = CGRectMake(_nameLabel.left, bottom, locWidth, kTimeLabelH);
        bottom = _locationBtn.bottom + kPaddingValue;
    } else {
        _locationBtn.hidden = YES;
    }
    
    //发布时间
    if isRightData(model.createdAtStamp) {
        _timeLabel.text = [Utility getDateFormatByTimestamp:[model.createdAtStamp longLongValue]];
        CGFloat timeWidth = [_timeLabel.text boundingRectWithSize:CGSizeMake(200, kTimeLabelH)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:_timeLabel.font}
                                                          context:nil].size.width;
        _timeLabel.frame = CGRectMake(_nameLabel.left, bottom, timeWidth, kTimeLabelH);
        bottom = _timeLabel.bottom;
    }
    
    //详情按钮
    _lookDetailBtn.frame = CGRectMake(_timeLabel.right + 20, _timeLabel.top, 30, kTimeLabelH);
    
    // 删除按钮
    _deleteBtn.frame = CGRectMake(_lookDetailBtn.right + 20, _timeLabel.top, 30, kTimeLabelH);
    
    /*** 如果是本人,显示删除按钮 ***/
    if (model.isCharger == 1) {
        _deleteBtn.hidden = NO;
    } else {
        _deleteBtn.hidden = YES;
    }
    
    //弹出点赞视图
    _menuView.top = _timeLabel.top - (kOperateHeight - kTimeLabelH) / 2;
    //显示赞还是已赞
    if ([model.isLike isEqualToString:@"1"]) {
        _menuView.zanBtnTitle = @"已赞";
        _menuView.zanBtn.enabled = NO;
    } else {
        _menuView.zanBtnTitle = @"赞";
        _menuView.zanBtn.enabled = YES;
    }
    
    //赞和评论的视图
    [_commentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _commentView.frame = CGRectZero;

    CGFloat width = SCREEN_WIDTH - kRightMargin - _nameLabel.left;
    CGFloat pltop = kArrowHeight;
    if (model.likeList.count > 0) {
        bottom = bottom + kPaddingValue - 3;
        //行数
        NSInteger lineNum = 1;
        //每一行的个数
        NSInteger lineControl = 0;
        //添加一个点赞的图标
        UIImageView *zanIcon = [[UIImageView alloc] init];
        zanIcon.image = [UIImage imageNamed:@"like_img"];
        zanIcon.frame = CGRectMake(zanLeftGap, 22, 16, 16);
        [_commentView addSubview:zanIcon];
        
        for (NSInteger i = 0; i < model.likeList.count; i++) {
            UIImageView *zanHeader = [[UIImageView alloc] init];
            zanHeader.contentMode = UIViewContentModeScaleAspectFill;
            if (lineNum == 1) {
                if (( zanImgWidth + zanLeftGap) * (lineControl + 1) + zanIcon.right > width) {
                    lineNum ++;
                    lineControl = 0;
                }
                
                if (lineNum == 1) {
                    zanHeader.frame = CGRectMake((lineControl + 1) * zanLeftGap + lineControl * zanImgWidth + zanIcon.right, kArrowHeight + (lineNum - 1) * zanLineGap + (lineNum - 1) * zanImgWidth, zanImgWidth, zanImgWidth);
                } else {
                    zanHeader.frame = CGRectMake((lineControl + 1) * zanLeftGap + lineControl * zanImgWidth , kArrowHeight + (lineNum - 1) * zanLineGap + (lineNum - 1) * zanImgWidth, zanImgWidth, zanImgWidth);
                }
                
            } else {
                if (( zanImgWidth + zanLeftGap) * (lineControl + 1) > width) {
                    lineNum ++;
                    lineControl = 0;
                }
                if (lineNum > 2) {
                    lineNum = 2;
                    break;
                }
                zanHeader.frame = CGRectMake((lineControl + 1) * zanLeftGap + lineControl * zanImgWidth , kArrowHeight + (lineNum - 1) * zanLineGap + (lineNum - 1) * zanImgWidth, zanImgWidth, zanImgWidth);
            }
            
            LikeListModel *zanModel = model.likeList[i];
            if (isRightData(zanModel.likeUserPhoto)) {
                if ([[zanModel.likeUserPhoto substringToIndex:4] isEqualToString:@"http"]) {
                    [zanHeader sd_setImageWithURL:[NSURL URLWithString:zanModel.likeUserPhoto] placeholderImage:PlaceHolderImg];
                } else {
                    [zanHeader sd_setImageWithURL:ImgUrl(zanModel.likeUserPhoto) placeholderImage:PlaceHolderImg];
                }
            } else {
                zanHeader.image = DefaultImage;
            }
            [HelperTool setRound:zanHeader corner:UIRectCornerAllCorners radiu:zanImgWidth / 2];
            HeaderTapGestureRecognizer * tap = [[HeaderTapGestureRecognizer alloc] initWithTarget:self action:@selector(clickZanUserHeader:)];
            tap.model = zanModel;
            zanHeader.userInteractionEnabled = YES;
            [zanHeader addGestureRecognizer:tap];
            
            [_commentView addSubview:zanHeader];
            lineControl ++;
        }
        
        _commentView.frame = CGRectMake(_nameLabel.left, bottom, width, kArrowHeight + lineNum *(zanImgWidth + zanLineGap));
        bottom = _commentView.bottom + kBlank;
        pltop = pltop + lineNum * (zanImgWidth + zanLineGap);
    }

    //评论
    NSInteger count = [model.commentList count];
    if (count > 0) {
        if (model.likeList.count > 0) {
            // 分割线
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, pltop - 0.5, width, 0.5)];
            line.backgroundColor = [kHLBgColor colorWithAlphaComponent:0.3];
            [_commentView addSubview:line];
        }

        for (NSInteger i = 0; i < count; i++) {
            PLView *view = [[PLView alloc] initWithFrame:CGRectMake(0, pltop, width, 0)];
            view.labelWidth = width;
            view.index = i;
            view.commentModel = model.commentList[i];
            DDWeakSelf;
            //回复别人的评论，有可能是删除自己的评论
            view.clickTextBlock = ^(NSInteger index) {
                if ([weakself.friendDelegate respondsToSelector:@selector(commentUserComment:index:)]) {
                    [weakself.friendDelegate commentUserComment:weakself.model.tieziID index:index];
                }
            };
            view.clickNameBlock = ^(CommentListModel * _Nonnull model, NSString * _Nonnull type) {
                if ([weakself.friendDelegate respondsToSelector:@selector(didClickUserName:userType:)]) {
                    [weakself.friendDelegate didClickUserName:model userType:type];
                }
            };
            [_commentView addSubview:view];
            pltop += view.height;
        }
    }

    if (pltop > kArrowHeight) {
        _commentView.frame = CGRectMake(_nameLabel.left, _timeLabel.bottom + kPaddingValue - 3, width, pltop);
        bottom = _commentView.bottom + kBlank;
    } else {
        bottom = _timeLabel.bottom + kBlank;
    }
    
    if (bottom < _fansCountLabel.bottom + kBlank)
        bottom = _fansCountLabel.bottom + kBlank;
    
    model.cellHeight = bottom;
}

//添加图片.......
- (NSMutableArray *)addPic:(FriendCricleModel *)model {
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:0];
//    NSMutableArray *previewImgArr = [NSMutableArray arrayWithCapacity:0];
    if ([model.type isEqualToString:@"photo"]) {
        if isRightData(model.pic1) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic1]];
        }
        if isRightData(model.pic2) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic2]];
        }
        if isRightData(model.pic3) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic3]];
        }
        if isRightData(model.pic4) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic4]];
        }
        if isRightData(model.pic5) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic5]];
        }
        if isRightData(model.pic6) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic6]];
        }
        if isRightData(model.pic7) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic7]];
        }
        if isRightData(model.pic8) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic8]];
        }
        if isRightData(model.pic9) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic9]];
        }
    } else {
        if isRightData(model.videoPicUrl) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.videoPicUrl]];
        }
    }

    return imgArr;
}

#pragma mark - 点击事件
// 查看全文/收起
- (void)fullTextClicked:(UIButton *)sender {
    _showAllBtn.backgroundColor = kHLBgColor;
    DDWeakSelf;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TimeBackGround * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        weakself.showAllBtn.backgroundColor = [UIColor whiteColor];
        weakself.model.isFullText = !weakself.model.isFullText;
        if ([weakself.friendDelegate respondsToSelector:@selector(didSelectFullText:)]) {
            [weakself.friendDelegate didSelectFullText:weakself.model.tieziID];
        }
    });
}

//点击头像
- (void)userHeaderClick {
    if ([self.friendDelegate respondsToSelector:@selector(didClickHeaderImage:)]) {
        [self.friendDelegate didClickHeaderImage:_model];
    }
}

//点击点赞人的头像
- (void)clickZanUserHeader:(UITapGestureRecognizer *)tapRecognizer {
    if ([self.friendDelegate respondsToSelector:@selector(didClickZanUserHeader:)]) {
        HeaderTapGestureRecognizer *tap = (HeaderTapGestureRecognizer *)tapRecognizer;
        [self.friendDelegate didClickZanUserHeader:tap.model];
    }
}

//关注或者取消关注
- (void)focusClick {
    if ([self.friendDelegate respondsToSelector:@selector(focusOrCancel:)]) {
        [self.friendDelegate focusOrCancel:_model.tieziID];
    }
}

// 删除动态
- (void)deleteDyn:(UIButton *)sender {
    DDWeakSelf;
    _deleteBtn.backgroundColor = kHLBgColor;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TimeBackGround * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        weakself.deleteBtn.backgroundColor = [UIColor whiteColor];
        if ([weakself.friendDelegate respondsToSelector:@selector(didDeleteDynamic:)]) {
            [weakself.friendDelegate didDeleteDynamic:weakself.model.tieziID];
        }
    });
}

//查看详情
- (void)lookDetail:(UIButton *)sender {
    DDWeakSelf;
    _lookDetailBtn.backgroundColor = kHLBgColor;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TimeBackGround * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        weakself.lookDetailBtn.backgroundColor = [UIColor whiteColor];
        if ([weakself.friendDelegate respondsToSelector:@selector(didLookDetail:)]) {
            [weakself.friendDelegate didLookDetail:weakself.model.tieziID];
        }
    });
}

//跳转到地图
- (void)gotoMap:(UIButton *)sender {
    DDWeakSelf;
    _locationBtn.backgroundColor = kHLBgColor;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TimeBackGround * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        weakself.locationBtn.backgroundColor = [UIColor whiteColor];
        if ([weakself.friendDelegate respondsToSelector:@selector(didGotoLocationMap:)]) {
            [weakself.friendDelegate didGotoLocationMap:weakself.model];
        }
    });
}

//跳转到资讯详情
- (void)gotoZiXunDetail {
    if ([self.friendDelegate respondsToSelector:@selector(didGotoZiXunDetail:)]) {
        [self.friendDelegate didGotoZiXunDetail:self.model.shareBean.zixunID];
    }
}

//跳转到话题
- (void)gotoTopicList:(UIButton *)sender {
    DDWeakSelf;
    _topicBtn.backgroundColor = kHLBgColor;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TimeBackGround * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        weakself.topicBtn.backgroundColor = [UIColor whiteColor];
        if ([weakself.friendDelegate respondsToSelector:@selector(didGotoTopicList:)]) {
            [weakself.friendDelegate didGotoTopicList:weakself.model.topic.topicList[0]];
        }
    });
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != _menuView.menuBtn && _menuView.show) {
        _menuView.showAnima = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellMenu" object:_menuView.menuBtn];
    if (_menuView.show) {
        _menuView.showAnima = NO;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FriendCricleCell";
    FriendCricleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FriendCricleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end


/*** 手势点击头像传值 ***/

@interface HeaderTapGestureRecognizer()

@end

@implementation HeaderTapGestureRecognizer

@end
