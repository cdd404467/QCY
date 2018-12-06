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

// 最大高度限制
CGFloat maxLimitHeight = 110;

@interface FriendCricleCell()
// 头像
@property (nonatomic, strong) UIImageView *headImageView;
// 名称
@property (nonatomic, strong) UILabel *nameLabel;
// 正文
@property (nonatomic, strong) UILabel *mainLabel;
// 全文按钮
@property (nonatomic, strong) UIButton *showAllBtn;
// 图片九宫格
@property (nonatomic, strong)WeiChatPhotoView *photoGroup;
// 时间
@property (nonatomic, strong)UILabel *timeLabel;
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

- (void)setupUI {
    // 头像视图
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KFit_W(14), kBlank, kFaceWidth, kFaceWidth)];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.userInteractionEnabled = YES;
    _headImageView.layer.masksToBounds = YES;
    [HelperTool addTapGesture:_headImageView withTarget:self andSEL:@selector(userHeaderClick)];
    [self.contentView addSubview:_headImageView];
    // 名字视图
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImageView.right + 10, _headImageView.top, kTextWidth, 20)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:17.0];
    _nameLabel.textColor = kHLTextColor;
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_nameLabel];
    // 正文视图
    _mainLabel = [[UILabel alloc] init];;
    _mainLabel.font = kTextFont;
    _mainLabel.numberOfLines = 0;
    _mainLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _mainLabel.hidden = YES;
    [self.contentView addSubview:_mainLabel];
    // 查看'全文'按钮
    _showAllBtn = [[UIButton alloc]init];
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
    //赞和评论的view
    _commentView = [[UIImageView alloc] init];
    _commentView.userInteractionEnabled = YES;
    _commentView.image = [[UIImage imageNamed:@"comment_Bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30];
    [self.contentView addSubview:_commentView];
    
    
    //弹出点赞、评论视图
    _menuView = [[OperateMenuView alloc] initWithFrame:CGRectZero];
    _menuView.show = NO;
    DDWeakSelf;
    [_menuView setLikeMoment:^{
        if ([weakself.friendDelegate respondsToSelector:@selector(didZan:)]) {
            [weakself.friendDelegate didZan:weakself.indexPath];
        }
    }];
    [_menuView setCommentMoment:^{
        if ([weakself.friendDelegate respondsToSelector:@selector(didComment:)]) {
            [weakself.friendDelegate didComment:weakself.indexPath];
        }
    }];
    
    [self.contentView addSubview:_menuView];
}

//设置数据，计算cell高度
- (void)setModel:(FriendCricleModel *)model {
    _model = model;
    //头像
    if isRightData(model.postUserPhoto) {
        [_headImageView sd_setImageWithURL:ImgUrl(model.postUserPhoto) placeholderImage:nil];
    } else {
        _headImageView.image = DefaultImage;
    }
    //名字（昵称）
    if isRightData(model.postUser) {
        _nameLabel.text = model.postUser;
    }
    
    _showAllBtn.hidden = YES;
    //正文
    CGFloat bottom = _nameLabel.bottom + kPaddingValue;
    
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
//                [self.showAllBtn setTitle:[NSString stringWithFormat:@"收起%ld",(long)_indexPath.row] forState:UIControlStateNormal];
                _mainLabel.numberOfLines = 0;
            } else {
                mainHeight = _mainLabel.font.lineHeight * 6;
                [self.showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
//                [self.showAllBtn setTitle:[NSString stringWithFormat:@"全文%ld",(long)_indexPath.row] forState:UIControlStateNormal];
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
            bottom = _mainLabel.bottom + kPaddingValue;
        } else {
            bottom = _showAllBtn.bottom + kPaddingValue;
        }
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
        bottom = _photoGroup.bottom + kPaddingValue;
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
        _timeLabel.frame = CGRectMake(_nameLabel.left, bottom, timeWidth, kTimeLabelH);
        bottom = _timeLabel.bottom;
    }
    //弹出点赞视图
    _menuView.frame = CGRectMake(SCREEN_WIDTH - kOperateWidth, _timeLabel.top - (kOperateHeight - kTimeLabelH) / 2, kOperateWidth, kOperateHeight);
    //赞和评论的视图
    [_commentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _commentView.frame = CGRectZero;

    CGFloat width = SCREEN_WIDTH - kRightMargin - _nameLabel.left;
    CGFloat pltop = kArrowHeight;
    if (model.likeList.count > 0) {
        bottom = bottom + kPaddingValue - 3;
        NSInteger lineNum = 1;
        NSInteger lineControl = 0;
        for (NSInteger i = 0; i < model.likeList.count; i++) {
            UIImageView *zanHeader = [[UIImageView alloc] init];
            if (( zanImgWidth + zanLeftGap) * (lineControl + 1) > width) {
                lineNum ++;
                lineControl = 0;
            }
            LikeListModel *zanModel = model.likeList[i];
            if (isRightData(zanModel.likeUserPhoto)) {
                [zanHeader sd_setImageWithURL:ImgUrl(zanModel.likeUserPhoto) placeholderImage:PlaceHolderImg];
            } else {
                zanHeader.image = DefaultImage;
            }

            zanHeader.frame = CGRectMake((lineControl + 1) * zanLeftGap + lineControl * zanImgWidth , kArrowHeight + (lineNum - 1) * zanLineGap + (lineNum - 1) * zanImgWidth, zanImgWidth, zanImgWidth);
            [HelperTool setRound:zanHeader corner:UIRectCornerAllCorners radiu:zanImgWidth / 2];
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
            view.clickTextBlock = ^(NSInteger index) {
                if ([weakself.friendDelegate respondsToSelector:@selector(commentUserComment:index:)]) {
                    [weakself.friendDelegate commentUserComment:weakself.indexPath index:index];
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
    _showAllBtn.titleLabel.backgroundColor = kHLBgColor;
    DDWeakSelf;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        weakself.showAllBtn.titleLabel.backgroundColor = [UIColor clearColor];
        weakself.model.isFullText = !weakself.model.isFullText;
        if ([weakself.friendDelegate respondsToSelector:@selector(didSelectFullText:)]) {
            [weakself.friendDelegate didSelectFullText:weakself.indexPath];
        }
    });
}

//点击头像
- (void)userHeaderClick {
    if ([self.friendDelegate respondsToSelector:@selector(didClickHeaderImage:)]) {
        [self.friendDelegate didClickHeaderImage:_model.userId];
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
