//
//  FCRecordCell.m
//  QCY
//
//  Created by i7colors on 2018/12/6.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCRecordCell.h"
#import <YYText.h>
#import "FriendCricleModel.h"
#import "TimeAbout.h"
#import <UIImageView+WebCache.h>
#import "FCZiXunView.h"
#import "Friend.h"
#import "HelperTool.h"

// 最大高度限制
CGFloat maxHeight = 60;

@interface FCRecordCell()
@property (nonatomic, strong)YYLabel *timeLabel;
@property (nonatomic, strong)UIImageView *recordImage;
@property (nonatomic, strong)UILabel *mainLabel;
@property (nonatomic, strong)UIImageView *play;
//分享咨询view
@property (nonatomic, strong) FCZiXunView *ziXunView;
@end

@implementation FCRecordCell

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
    //时间
    YYLabel *timeLabel = [[YYLabel alloc] init];
    timeLabel.numberOfLines = 0;
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.font = [UIFont boldSystemFontOfSize:20];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.frame = CGRectMake(0, 15, 75, 0);
    [self.contentView addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    //图片
    UIImageView *recordImage = [[UIImageView alloc] init];
    recordImage.frame = CGRectMake(timeLabel.width, timeLabel.top, 50, 50);
    [self.contentView addSubview:recordImage];
    _recordImage = recordImage;
    UIImageView *play = [[UIImageView alloc] init];
    play.frame = CGRectMake((recordImage.width - 40) / 2, (recordImage.height - 40) / 2, 40, 40);
    play.image = [UIImage imageNamed:@"bofang"];
//    play.backgroundColor = [UIColor redColor];
    [recordImage addSubview:play];
    _play = play;
    
    //文本
    UILabel *mainLabel = [[UILabel alloc] init];
    mainLabel.textColor = [UIColor blackColor];
    mainLabel.font = [UIFont systemFontOfSize:15];
    mainLabel.numberOfLines = 3;
    mainLabel.frame = CGRectMake(0, timeLabel.top, 0, 0);
    [self.contentView addSubview:mainLabel];
    _mainLabel = mainLabel;
    
    //咨询view
    _ziXunView = [[FCZiXunView alloc] initWithFrame:CGRectMake(_recordImage.left, 0, kTextWidth - 50, 50)];
    _ziXunView.userInteractionEnabled = NO;
    _ziXunView.backgroundColor = HEXColor(@"#e5e5e5", 1);
    [self.contentView addSubview:_ziXunView];
}

- (void)setModel:(FriendCricleModel *)model {
    _model = model;
    //时间
    CGFloat cx = 0;
    NSString *timeStr = [TimeAbout checkTheDate:[model.createdAtStamp longLongValue]];
    CGFloat labelHeight;
    if (timeStr.length > 4) {
        NSArray *array = [timeStr componentsSeparatedByString:@"-"];
        NSString *strY = array[0], *strM = array[1], *strD = array[2];
        NSString *time = [NSString stringWithFormat:@"%@\n%@/%@",strY,strM,strD];
        NSMutableAttributedString * mutabTitle = [[NSMutableAttributedString alloc] initWithString:time];
//        mutabTitle.yy_font = [UIFont boldSystemFontOfSize:18];
        mutabTitle.yy_alignment = NSTextAlignmentCenter;
        [mutabTitle yy_setFont:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, strY.length)];
        [mutabTitle yy_setFont:[UIFont systemFontOfSize:16] range:NSMakeRange(strY.length + 1, strM.length)];
        [mutabTitle yy_setFont:[UIFont systemFontOfSize:16] range:NSMakeRange(strY.length + strM.length + 2, strD.length)];
        _timeLabel.attributedText = mutabTitle;
        CGSize introSize = CGSizeMake(_timeLabel.width, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:mutabTitle];
        _timeLabel.textLayout = layout;
        labelHeight = layout.textBoundingSize.height;
    } else {
        _timeLabel.text = timeStr;
        labelHeight = [_timeLabel.text boundingRectWithSize:CGSizeMake(_timeLabel.width, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20]}
                                                    context:nil].size.height;
    }
    
    CGFloat bottom = 15;
    _timeLabel.height = labelHeight;
    cx = _timeLabel.width;
    //图片
    if ([model.type isEqualToString:@"photo"]) {
        if isRightData(model.pic1) {
            _recordImage.hidden = NO;
            _play.hidden = YES;
            [_recordImage sd_setImageWithURL:ImgUrl(model.pic1) placeholderImage:PlaceHolderImg];
            cx = cx + _recordImage.width + 8;
            bottom = _recordImage.bottom + 10;
        } else {
            _recordImage.hidden = YES;
            _play.hidden = YES;
        }
        
        //视频
    } else {
        _recordImage.hidden = NO;
        _play.hidden = NO;
        [_recordImage sd_setImageWithURL:ImgUrl(model.videoPicUrl) placeholderImage:PlaceHolderImg];
        cx = cx + _recordImage.width + 8;
        bottom = _recordImage.bottom + 10;
    }
    
    //文本
    if isRightData(model.content) {
        CGFloat mainHeight;
        _mainLabel.hidden = NO;
        _mainLabel.text = model.content;
        _mainLabel.left = cx;
        _mainLabel.width = SCREEN_WIDTH - cx - 8;
        CGFloat mHeight = [model.content boundingRectWithSize:CGSizeMake(_mainLabel.width, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
                                                          context:nil].size.height;
        if (mHeight > maxHeight) {
           mainHeight = _mainLabel.font.lineHeight * 3;
        } else {
            mainHeight = mHeight;
        }
        _mainLabel.height = mainHeight;
        
        if (_recordImage.hidden == YES)
            bottom = _mainLabel.bottom + 10;
        
        
    } else {
        _mainLabel.hidden = YES;
        _mainLabel.height = 0;
        _mainLabel.left = 0;
        _mainLabel.width = 0;
    }
    
    //咨询View
    if (isRightData(model.shareBean.title)) {
        _ziXunView.model = model.shareBean;
        _ziXunView.top = bottom;
        _ziXunView.hidden = NO;
        bottom = _ziXunView.bottom + 22;
    } else {
        _ziXunView.hidden = YES;
        bottom = bottom + 12;
    }
    
    _model.cellHeight = bottom;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FCRecordCell";
    FCRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FCRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
