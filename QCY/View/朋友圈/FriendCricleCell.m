//
//  FriendCricleCell.m
//  QCY
//
//  Created by i7colors on 2018/11/25.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FriendCricleCell.h"
#import "Friend.h"
#import "UIView+Geometry.h"
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

// 最大高度限制
CGFloat maxLimitHeight = 110;

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
@property (nonatomic, strong) UILabel *nameLabel;
//等级图标
@property (nonatomic, strong)UIImageView *levelImage;
//认证名字
@property (nonatomic, strong) UILabel *certNameLabel;
//关注按钮
@property (nonatomic, strong) UIButton *focusBtn;
// 正文
@property (nonatomic, strong) MLLinkLabel *mainLabel;
// 全文按钮
@property (nonatomic, strong) UIButton *showAllBtn;
// 图片九宫格
@property (nonatomic, strong) WeiChatPhotoView *photoGroup;
// 时间
@property (nonatomic, strong) UILabel *timeLabel;
//点击进入详情的按钮
@property (nonatomic, strong) UIButton *lookDetailBtn;
// 删除
@property (nonatomic, strong) UIButton *deleteBtn;
//菜单按钮
@property (nonatomic, strong)UIButton *menuBtn;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:@"cellMenu" object:nil];
    // 头像视图
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KFit_W(12), kBlank , kFaceWidth, kFaceWidth)];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [HelperTool addTapGesture:_headImageView withTarget:self andSEL:@selector(userHeaderClick)];
    [self.contentView addSubview:_headImageView];
    [HelperTool setRound:_headImageView corner:UIRectCornerAllCorners radiu:5];
    

    //大V认证图标
    _bigVImageView = [[UIImageView alloc] init];
    _bigVImageView.frame = CGRectMake(kFaceWidth - 14, kFaceWidth - 14, 14, 14);
    _bigVImageView.layer.cornerRadius = 9;
    _bigVImageView.clipsToBounds = YES;
    _bigVImageView.image = [UIImage imageNamed:@"bigV_img"];
    _bigVImageView.hidden = YES;
    [_headImageView addSubview:_bigVImageView];
    
    //头像下方是否已经认证
    _isCertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, kFaceWidth, 16)];
    _isCertLabel.font = [UIFont systemFontOfSize:9];
    _isCertLabel.textAlignment = NSTextAlignmentCenter;
    _isCertLabel.layer.cornerRadius = 8;
    _isCertLabel.layer.borderWidth = 0.8;
    _isCertLabel.centerX = _headImageView.centerX;
    [self.contentView addSubview:_isCertLabel];
    //粉丝label
    UILabel *fansText = [[UILabel alloc] init];
    fansText.textColor = HEXColor(@"#708090", 1);
    fansText.font = [UIFont systemFontOfSize:9];
    fansText.text = @"粉丝";
    fansText.textAlignment = NSTextAlignmentCenter;
    fansText.frame = CGRectMake(_isCertLabel.left, _isCertLabel.bottom + 3, kFaceWidth, 12);
    fansText.centerX = _headImageView.centerX;
    [self.contentView addSubview:fansText];
    
    //粉丝
    _fansCountLabel = [[UILabel alloc] init];
    _fansCountLabel.textColor = HEXColor(@"#ED3851", 1);
    _fansCountLabel.font = [UIFont systemFontOfSize:11];
    _fansCountLabel.textAlignment = NSTextAlignmentCenter;
    _fansCountLabel.frame = CGRectMake(0, fansText.bottom + 1, 55, 12);
    _fansCountLabel.centerX = _headImageView.centerX;
    [self.contentView addSubview:_fansCountLabel];
    
    // 名字视图
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.right + 10, _headImageView.top, 0, 20)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:17.0];
    _nameLabel.textColor = kHLTextColor;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_nameLabel];
    //等级图标
    _levelImage = [[UIImageView alloc] init];
    _levelImage.frame = CGRectMake(0, _nameLabel.top, 20, 20);
    _levelImage.contentMode = UIViewContentModeCenter;
    [self addSubview:_levelImage];
    
    //认证名字，可能没有
    _certNameLabel = [[UILabel alloc] init];
    _certNameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    _certNameLabel.textColor = HEXColor(@"#708090", 1);
    _certNameLabel.backgroundColor = [UIColor clearColor];
    _certNameLabel.hidden = YES;
    _certNameLabel.frame = CGRectMake(_nameLabel.left, _nameLabel.bottom + kPaddingValue, kTextWidth - 50, 15);
    [self.contentView addSubview:_certNameLabel];
    
    //关注按钮
    _focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _focusBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _focusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _focusBtn.frame = CGRectMake(SCREEN_WIDTH - 45 - 15, 0, 45, 20);
    _focusBtn.centerY = _nameLabel.centerY;
    [_focusBtn addTarget:self action:@selector(focusClick) forControlEvents:UIControlEventTouchUpInside];
    _focusBtn.layer.cornerRadius = 6;
    [self.contentView addSubview:_focusBtn];
    
    // 正文视图
    _mainLabel = [[MLLinkLabel alloc] init];;
    _mainLabel.font = kTextFont;
    _mainLabel.numberOfLines = 0;
    _mainLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _mainLabel.hidden = YES;
    [self.contentView addSubview:_mainLabel];
    // 查看'全文'按钮
    _showAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _showAllBtn.titleLabel.font = kTextFont;
    _showAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _showAllBtn.backgroundColor = [UIColor clearColor];
//    _showAllBtn.hidden = YES;
    _showAllBtn.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
    [_showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
    [_showAllBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_showAllBtn addTarget:self action:@selector(fullTextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_showAllBtn];
    // 图片九宫格
    _photoGroup = [[WeiChatPhotoView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_photoGroup];
    // 时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.0];
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.contentView addSubview:_timeLabel];
    //点击详情
    _lookDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lookDetailBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _lookDetailBtn.backgroundColor = [UIColor clearColor];
    [_lookDetailBtn setTitle:@"详情" forState:UIControlStateNormal];
    [_lookDetailBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_lookDetailBtn addTarget:self action:@selector(lookDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_lookDetailBtn];
    
    // 删除视图
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    _deleteBtn.backgroundColor = [UIColor clearColor];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:kHLTextColor forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteDyn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteBtn];
    
//    _deleteBtn.backgroundColor = [UIColor redColor];
    //赞和评论的view
    _commentView = [[UIImageView alloc] init];
    _commentView.userInteractionEnabled = YES;
    _commentView.image = [[UIImage imageNamed:@"comment_Bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
    [self.contentView addSubview:_commentView];
    
    //弹出点赞、评论视图
//    _menuView = [[OperateMenuView alloc] initWithFrame:CGRectZero];
    _menuView = [[OperateMenuView alloc] init];
    _menuView.show = NO;
    DDWeakSelf;
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
    //头像
    if isRightData(model.postUserPhoto) {
        [_headImageView sd_setImageWithURL:ImgUrl(model.postUserPhoto) placeholderImage:PlaceHolderImg];
    } else {
        _headImageView.image = DefaultImage;
    }
    //是否认证
    if ([model.isCompanyType isEqualToString:@"1"]) {
        _isCertLabel.text = @"已认证";
        _isCertLabel.textColor = HEXColor(@"#F10215", 1);
        _isCertLabel.layer.borderColor = HEXColor(@"#F10215", 1).CGColor;
        _bigVImageView.hidden = NO;
    } else {
        if ([model.isDyeV isEqualToString:@"0"]) {
            _isCertLabel.text = @"未认证";
            _isCertLabel.textColor = HEXColor(@"#868686", 1);
            _isCertLabel.layer.borderColor = HEXColor(@"#868686", 1).CGColor;
            _bigVImageView.hidden = YES;
        } else {
            _isCertLabel.text = @"已认证";
            _isCertLabel.textColor = HEXColor(@"#F10215", 1);
            _isCertLabel.layer.borderColor = HEXColor(@"#F10215", 1).CGColor;
            _bigVImageView.hidden = NO;
        }
    }
    
    //粉丝
    if ([model.dyeFollowCount integerValue] > 99999) {
        _fansCountLabel.text = @"99999+";
    } else {
        _fansCountLabel.text = model.dyeFollowCount;
    }
    //昵称
    if isRightData(model.postUser) {
        _nameLabel.text = model.postUser;
        CGFloat nameWidth = [model.postUser boundingRectWithSize:CGSizeMake(kTextWidth - 72, 20)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName:_nameLabel.font}
                                                               context:nil].size.width;
        _nameLabel.width = nameWidth;
        _levelImage.left = _nameLabel.right + 2;
        //等级图标
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
        _levelImage.image = [UIImage imageNamed:imageStr];
    }
    
    //是否已关注
    if (GET_USER_TOKEN) {
        
        if ([model.isCharger isEqualToString:@"1"]) {
            _focusBtn.hidden = YES;
        } else {
            _focusBtn.hidden = NO;
            if ([model.isFollow isEqualToString:@"0"]) {
                [_focusBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
                [_focusBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _focusBtn.layer.borderWidth = 1.f;
                _focusBtn.layer.borderColor = [UIColor blackColor].CGColor;
                [_focusBtn setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            } else {
                [_focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [_focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _focusBtn.layer.borderWidth = 0.f;
                _focusBtn.layer.borderColor = [UIColor clearColor].CGColor;
                [_focusBtn setBackgroundImage:[UIImage imageNamed:@"friend_btn_bg"] forState:UIControlStateNormal];
            }
        }
        
    } else {
        _focusBtn.hidden = NO;
    }
    CGFloat bottom;
    //认证名字
    if ([model.isCompanyType isEqualToString:@"1"]) {
        _certNameLabel.text = model.companyName;
        _certNameLabel.hidden = NO;
        bottom = _certNameLabel.bottom + kPaddingValue;
    } else {
        if ([model.isDyeV isEqualToString:@"1"]) {
            _certNameLabel.text = model.dyeVName;
            _certNameLabel.hidden = NO;
            bottom = _certNameLabel.bottom + kPaddingValue;
        } else {
            _certNameLabel.text = @"";
            _certNameLabel.hidden = YES;
            bottom = _nameLabel.bottom + kPaddingValue + 4;
        }
    }
    
    _showAllBtn.hidden = YES;
    //正文
    //如果有文本
    if isRightData(model.content) {
        _mainLabel.hidden = NO;
        _mainLabel.text = model.content;
        CGSize mainSize = [model.content boundingRectWithSize:CGSizeMake(kTextWidth, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : kTextFont}
                                                       context:nil].size;
        CGFloat mainHeight = mainSize.height;
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
        _showAllBtn.frame = CGRectMake(_nameLabel.left, _mainLabel.bottom + kPaddingValue, kMoreLabWidth, kMoreLabHeight);
        if (_showAllBtn.hidden) {
            bottom = _mainLabel.bottom + kPaddingValue + 2;
        } else {
            bottom = _showAllBtn.bottom + kPaddingValue + 2;
        }
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
        
    } else {
        _mainLabel.hidden = YES;
    }
    //9个图片
    NSMutableArray *imgArr = [self addPic:model];
    
    _photoGroup.videoURL = [NSString stringWithFormat:@"%@%@",Photo_URL,model.url];
    _photoGroup.videoPicWidth = model.videoPicWidth;
    _photoGroup.videoPicHight = model.videoPicHigh;
    _photoGroup.pic1Width = model.pic1Width;
    _photoGroup.pic1Hight = model.pic1High;
    _photoGroup.type = model.type;
    //放在最后
    _photoGroup.urlArray = imgArr;
    if (imgArr.count > 0) {
        _photoGroup.hidden = NO;
        _photoGroup.origin = CGPointMake(_nameLabel.left, bottom);
        bottom = _photoGroup.bottom + kPaddingValue + 2;
    } else {
        _photoGroup.hidden = YES;
    }

    if (_mainLabel.hidden && _photoGroup.hidden) {
        bottom = _headImageView.bottom + kBlank;
    }

    //发布时间
    if isRightData(model.createdAtStamp) {
        _timeLabel.text = [Utility getDateFormatByTimestamp:[model.createdAtStamp longLongValue]];
        CGFloat timeWidth = [_timeLabel.text boundingRectWithSize:CGSizeMake(200, kTimeLabelH)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:_timeLabel.font}
                                                          context:nil].size.width;
        _timeLabel.frame = CGRectMake(_nameLabel.left, bottom + 2, timeWidth, kTimeLabelH);
        bottom = _timeLabel.bottom;
    }
    
    //详情按钮
    _lookDetailBtn.frame = CGRectMake(_timeLabel.right + 20, _timeLabel.top, 30, kTimeLabelH);
    
    // 删除按钮
    _deleteBtn.frame = CGRectMake(_lookDetailBtn.right + 20, _timeLabel.top, 30, kTimeLabelH);
    
    /*** 如果是本人,显示删除按钮 ***/
    if ([model.isCharger isEqualToString:@"1"]) {
        _deleteBtn.hidden = NO;
    } else {
        _deleteBtn.hidden = YES;
    }
    
    //弹出点赞视图
//    _menuView.frame = CGRectMake(SCREEN_WIDTH - kOperateWidth, _timeLabel.top - (kOperateHeight - kTimeLabelH) / 2, kOperateWidth, kOperateHeight);
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
                [zanHeader sd_setImageWithURL:ImgUrl(zanModel.likeUserPhoto) placeholderImage:PlaceHolderImg];
            } else {
                zanHeader.image = DefaultImage;
            }
            [HelperTool setRound:zanHeader corner:UIRectCornerAllCorners radiu:zanImgWidth / 2];
            HeaderTapGestureRecognizer * tap = [[HeaderTapGestureRecognizer alloc] initWithTarget:self action:@selector(clickZanUserHeader:)];
            tap.userId = zanModel.userId;
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
            line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
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
            view.clickNameBlock = ^(NSString * _Nonnull userID) {
                if ([weakself.friendDelegate respondsToSelector:@selector(didClickUserName:)]) {
                    [weakself.friendDelegate didClickUserName:userID];
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
    model.cellHeight = bottom;
}

//添加图片.......
- (NSMutableArray *)addPic:(FriendCricleModel *)model {
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:0];
//    NSMutableArray *previewImgArr = [NSMutableArray arrayWithCapacity:0];
    if ([model.type isEqualToString:@"photo"]) {
        if isRightData(model.pic1) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic1]];
//            [previewImgArr addObject:[NSString stringWithFormat:@"%@/dye_community_compress%@",Photo_URL,model.pic1]];
        }
        if isRightData(model.pic2) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic2]];
//            [previewImgArr addObject:[NSString stringWithFormat:@"%@/dye_community_compress%@",Photo_URL,model.pic2]];
        }
        if isRightData(model.pic3) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic3]];
//            [previewImgArr addObject:[NSString stringWithFormat:@"%@/dye_community_compress%@",Photo_URL,model.pic3]];
        }
        if isRightData(model.pic4) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic4]];
//            [previewImgArr addObject:[NSString stringWithFormat:@"%@/dye_community_compress%@",Photo_URL,model.pic4]];
        }
        if isRightData(model.pic5) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic5]];
//            [previewImgArr addObject:[NSString stringWithFormat:@"%@/dye_community_compress%@",Photo_URL,model.pic5]];
        }
        if isRightData(model.pic6) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic6]];
//            [previewImgArr addObject:[NSString stringWithFormat:@"%@/dye_community_compress%@",Photo_URL,model.pic6]];
        }
        if isRightData(model.pic7) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic7]];
//            [previewImgArr addObject:[NSString stringWithFormat:@"%@/dye_community_compress%@",Photo_URL,model.pic7]];
        }
        if isRightData(model.pic8) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic8]];
//            [previewImgArr addObject:[NSString stringWithFormat:@"%@/dye_community_compress%@",Photo_URL,model.pic8]];
        }
        if isRightData(model.pic9) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.pic9]];
//            [previewImgArr addObject:[NSString stringWithFormat:@"%@/dye_community_compress%@",Photo_URL,model.pic9]];
        }
    } else {
        if isRightData(model.videoPicUrl) {
            [imgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.videoPicUrl]];
//            [previewImgArr addObject:[NSString stringWithFormat:@"%@%@",Photo_URL,model.videoPicUrl]];
        }
    }

//    if (isOriginal == YES) {
        return imgArr;
//    } else {
//        return previewImgArr;
//    }
}

#pragma mark - 点击事件
// 查看全文/收起
- (void)fullTextClicked:(UIButton *)sender {
    _showAllBtn.titleLabel.backgroundColor = kHLBgColor;
    DDWeakSelf;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        weakself.showAllBtn.titleLabel.backgroundColor = [UIColor clearColor];
        weakself.model.isFullText = !weakself.model.isFullText;
        if ([weakself.friendDelegate respondsToSelector:@selector(didSelectFullText:)]) {
            [weakself.friendDelegate didSelectFullText:weakself.model.tieziID];
        }
    });
}

//点击头像
- (void)userHeaderClick {
    if ([self.friendDelegate respondsToSelector:@selector(didClickHeaderImage:)]) {
        [self.friendDelegate didClickHeaderImage:_model.userId];
    }
}

//点击点赞人的头像
- (void)clickZanUserHeader:(UITapGestureRecognizer *)tapRecognizer {
    if ([self.friendDelegate respondsToSelector:@selector(didClickZanUserHeader:)]) {
        HeaderTapGestureRecognizer *tap = (HeaderTapGestureRecognizer *)tapRecognizer;
        [self.friendDelegate didClickZanUserHeader:tap.userId];
    }
}

//关注或者取消关注
- (void)focusClick {
    if ([self.friendDelegate respondsToSelector:@selector(focusOrCancel:)]) {
        [self.friendDelegate focusOrCancel:_model.tieziID];
    }
}

// 删除动态
- (void)deleteDyn:(UIButton *)sender
{
    DDWeakSelf;
    _deleteBtn.titleLabel.backgroundColor = [UIColor lightGrayColor];
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        weakself.deleteBtn.titleLabel.backgroundColor = [UIColor clearColor];
        if ([weakself.friendDelegate respondsToSelector:@selector(didDeleteDynamic:)]) {
            [weakself.friendDelegate didDeleteDynamic:weakself.model.tieziID];
        }
    });
}

//查看详情
- (void)lookDetail:(UIButton *)sender {
    DDWeakSelf;
    _lookDetailBtn.titleLabel.backgroundColor = [UIColor lightGrayColor];
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        weakself.lookDetailBtn.titleLabel.backgroundColor = [UIColor clearColor];
        if ([weakself.friendDelegate respondsToSelector:@selector(didLookDetail:)]) {
            [weakself.friendDelegate didLookDetail:weakself.model.tieziID];
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
