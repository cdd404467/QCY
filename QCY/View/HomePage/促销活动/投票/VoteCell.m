//
//  VoteCell.m
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "VoteCell.h"
#import "MacroHeader.h"
#import "UIView+Geometry.h"
#import "VoteModel.h"
#import <UIImageView+WebCache.h>
#import "UIView+Border.h"
#import "HelperTool.h"

@interface VoteCell()

@property (nonatomic, strong)UIImageView *posterImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *competitorLab;
@property (nonatomic, strong)UILabel *voteLab;
@property (nonatomic, strong)UILabel *visitLab;
@property (nonatomic, strong)UIImageView *stateImageView;
@end

@implementation VoteCell

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
    //图片
    UIImageView *posterImageView = [[UIImageView alloc] init];
    posterImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 144);
    [self.contentView addSubview:posterImageView];
    _posterImageView = posterImageView;
    
    //左上角活动的状态图片
    UIImageView *stateImageView = [[UIImageView alloc] init];
    stateImageView.frame = CGRectMake(0, 0, 60, 60);
    [posterImageView addSubview:stateImageView];
    stateImageView.hidden = YES;
    _stateImageView = stateImageView;
    
    //投票的标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = HEXColor(@"#333333", 1);
    titleLabel.numberOfLines = 2;
    titleLabel.frame = CGRectMake(0, posterImageView.bottom, posterImageView.width, 60);
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    [titleLabel addBorderLayer:RGBA(235, 235, 235, 1) width:0.5 direction:BorderDirectionBottom];
    
    //参赛者，投票数，访问量的显示
    CGFloat width = SCREEN_WIDTH / 3;
    NSArray *title = @[@"参赛者",@"投票数",@"访问量"];
    for (NSInteger i = 0; i < 3; i++) {
        //显示数字
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(i * width, titleLabel.bottom + 12, width, 22);
        label.font = [UIFont boldSystemFontOfSize:22];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        
        //显示文本
        UILabel *txtLabel = [[UILabel alloc] init];
        txtLabel.frame = CGRectMake(i * width, label.bottom + 2, width, 12);
        txtLabel.font = [UIFont systemFontOfSize:12];
        txtLabel.textAlignment = NSTextAlignmentCenter;
        txtLabel.text = title[i];
        [self.contentView addSubview:txtLabel];
        
        if (i == 0) {
            _competitorLab = label;
            [HelperTool textGradientview:label bgVIew:self.contentView gradientColors:@[(id)HEXColor(@"#55B5FF", 1).CGColor,(id)HEXColor(@"#8CCFFF", 1).CGColor] gradientStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
        } else if (i == 1) {
            _voteLab = label;
            [HelperTool textGradientview:label bgVIew:self.contentView gradientColors:@[(id)HEXColor(@"#FF5153", 1).CGColor,(id)HEXColor(@"#FF6B6E", 1).CGColor] gradientStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
        } else {
            _visitLab = label;
            [HelperTool textGradientview:label bgVIew:self.contentView gradientColors:@[(id)HEXColor(@"#FF8803", 1).CGColor,(id)HEXColor(@"#FFAD4F", 1).CGColor] gradientStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(1.0, 0)];
        }
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 16;
    [super setFrame:frame];
}

- (void)setModel:(VoteModel *)model {
    _model = model;
    
    [_posterImageView sd_setImageWithURL:ImgUrl(model.banner) placeholderImage:PlaceHolderImgBanner];
    _titleLabel.text = model.name;
    
    _competitorLab.text = model.applicationNum;
    _voteLab.text = model.joinNum;
    _visitLab.text = model.clickNum;
    //活动状态码，0,：未开始；1,：进行中，2：已结束
    if ([model.endCode isEqualToString:@"0"]) {
        _stateImageView.hidden = YES;
    } else {
        _stateImageView.hidden = NO;
        if ([model.endCode isEqualToString:@"1"]) {
            _stateImageView.image = [UIImage imageNamed:@"tp_ongoing"];
        } else {
            _stateImageView.image = [UIImage imageNamed:@"tp_end"];
        }
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"VoteCell";
    VoteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[VoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
