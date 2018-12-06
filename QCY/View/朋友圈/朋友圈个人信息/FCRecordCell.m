//
//  FCRecordCell.m
//  QCY
//
//  Created by i7colors on 2018/12/6.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCRecordCell.h"
#import "UIView+Geometry.h"
#import "MacroHeader.h"
#import <YYText.h>
#import "FriendCricleModel.h"
#import "TimeAbout.h"
#import <UIImageView+WebCache.h>

@interface FCRecordCell()
@property (nonatomic, strong)YYLabel *timeLabel;
@property (nonatomic, strong)UIImageView *recordImage;
@property (nonatomic, strong)UILabel *mainLabel;
@property (nonatomic, strong)UIImageView *play;
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
    timeLabel.numberOfLines = 3;
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
    mainLabel.numberOfLines = 0;
    mainLabel.frame = CGRectMake(0, timeLabel.top, 0, 0);
    [self.contentView addSubview:mainLabel];
    _mainLabel = mainLabel;
    
}

- (void)setModel:(FriendCricleModel *)model {
    _model = model;
    //时间
    CGFloat cx = 0;
    NSString *timeStr = [TimeAbout checkTheDate:[model.createdAtStamp longLongValue]];
    if (timeStr.length > 3) {
        NSArray *array = [timeStr componentsSeparatedByString:@"-"];
        _timeLabel.text = [NSString stringWithFormat:@"%@\n%@/%@",array[0],array[1],array[2]];
    } else {
        _timeLabel.text = timeStr;
    }
    CGFloat labelHeight = [_timeLabel.text boundingRectWithSize:CGSizeMake(_timeLabel.width, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20]}
                                                  context:nil].size.height;
    _timeLabel.height = labelHeight;
    cx = _timeLabel.width;
    //图片
    if ([model.type isEqualToString:@"photo"]) {
        if isRightData(model.pic1) {
            _recordImage.hidden = NO;
            _play.hidden = YES;
            [_recordImage sd_setImageWithURL:ImgUrl(model.pic1) placeholderImage:PlaceHolderImg];
            cx = cx + _recordImage.width + 8;
        } else {
            _recordImage.hidden = YES;
            _play.hidden = YES;
        }
    } else {
        _recordImage.hidden = NO;
        _play.hidden = NO;
        [_recordImage sd_setImageWithURL:ImgUrl(model.videoPicUrl) placeholderImage:PlaceHolderImg];
        cx = cx + _recordImage.width + 8;
    }
    
    
    //文本
    if isRightData(model.content) {
        _mainLabel.hidden = NO;
        _mainLabel.text = model.content;
        _mainLabel.left = cx;
        _mainLabel.width = SCREEN_WIDTH - cx - 8;
        CGFloat mHeight = [model.content boundingRectWithSize:CGSizeMake(_mainLabel.width, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
                                                          context:nil].size.height;
        _mainLabel.height = mHeight;
    } else {
        _mainLabel.hidden = YES;
    }
    
    
    
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
