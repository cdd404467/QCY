//
//  LiveOnlineCell.m
//  QCY
//
//  Created by i7colors on 2020/3/27.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "LiveOnlineCell.h"
#import <UIImageView+WebCache.h>


@interface LiveOnlineCell()
@property (nonatomic, strong) UIImageView *picture;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *desLab;
@property (nonatomic, strong) UILabel *teacherLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UIImageView *stateImg;
@end


@implementation LiveOnlineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        self.contentView.backgroundColor = RGBA(0, 0, 0, 0.1);
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIImageView *picture = [[UIImageView alloc] init];
    picture.frame = CGRectMake(10, 0, 135, 90);
    [self.contentView addSubview:picture];
    _picture = picture;
    
    UIImageView *stateImg = [[UIImageView alloc] init];
    [picture addSubview:stateImg];
    [stateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(24);
    }];
    _stateImg = stateImg;
    
    
    UIImageView *playImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_video"]];
    [picture addSubview:playImg];
    [playImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(54);
        make.center.mas_equalTo(picture);
    }];
    
    
    //名字
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.textColor = HEXColor(@"#262626", 1);
    nameLab.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(picture.mas_right).offset(10);
        make.top.mas_equalTo(picture.mas_top).offset(0);
        make.right.mas_equalTo(-10);
    }];
    _nameLab = nameLab;
    
    //描述
    UILabel *desLab = [[UILabel alloc] init];
    desLab.textColor = HEXColor(@"#999999", 1);
    desLab.numberOfLines = 3;
    desLab.font = [UIFont boldSystemFontOfSize:10];
    [self.contentView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(nameLab);
        make.top.mas_equalTo(nameLab.mas_bottom).offset(6);
    }];
    _desLab = desLab;
    
    //讲师
    UILabel *teacherLab = [[UILabel alloc] init];
    teacherLab.textColor = HEXColor(@"#999999", 1);
    teacherLab.font = [UIFont boldSystemFontOfSize:12];
    [self.contentView addSubview:teacherLab];
    [teacherLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLab);
        make.width.mas_equalTo(125);
        make.bottom.mas_equalTo(picture);
    }];
    _teacherLab = teacherLab;
    
    //价格
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.textAlignment = NSTextAlignmentRight;
    priceLab.font = [UIFont systemFontOfSize:12];
    priceLab.textColor = HEXColor(@"#F10215", 1);
    [self.contentView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(teacherLab.mas_right).offset(5);
        make.right.mas_equalTo(nameLab);
        make.centerY.mas_equalTo(teacherLab);
    }];
    _priceLab = priceLab;
    
}

- (void)setModel:(LiveOnlineModel *)model {
    _model = model;
    [_picture sd_setImageWithURL:ImgUrl(model.banner) placeholderImage:PlaceHolderImg];
    _nameLab.text = model.title;
    _desLab.text = model.descriptionStr;
    _teacherLab.text = [NSString stringWithFormat:@"讲师: %@",model.teacher];
    
    if (model.isEnd.integerValue == 0) {
        _stateImg.image = [UIImage imageNamed:@"liveOnline_3"];
        _priceLab.text = @"直播已结束";
    } else if (model.isEnd.integerValue == 1) {
        _stateImg.image = [UIImage imageNamed:@"liveOnline_2"];
        _priceLab.text = [NSString stringWithFormat:@"¥%@",model.price];
    } else if (model.isEnd.integerValue ==2) {
        _stateImg.image = [UIImage imageNamed:@"liveOnline_1"];
        _priceLab.text = [NSString stringWithFormat:@"¥%@",model.price];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"LiveOnlineCell";
    LiveOnlineCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LiveOnlineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
