//
//  AuctionPriceRecordCell.m
//  QCY
//
//  Created by i7colors on 2019/3/7.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AuctionPriceRecordCell.h"
#import "AuctionModel.h"

@implementation AuctionPriceRecordCell {
    UILabel *_phoneLab;
    UILabel *_areaLab;
    UILabel *_priceLab;
    UILabel *_timeLab;
//    UIImageView *_maxPriceImageView;
}

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
    CGFloat width1 = SCREEN_WIDTH * 0.25;
    CGFloat width2 = SCREEN_WIDTH * 0.25;
    CGFloat width3 = SCREEN_WIDTH * 0.25;
    CGFloat width4 = SCREEN_WIDTH * 0.25;
    CGFloat height = 40;
    
    for (NSInteger i = 0; i < 4; i++) {
        UILabel *tLabel = [[UILabel alloc] init];
        tLabel.textAlignment = NSTextAlignmentCenter;
        tLabel.textColor = HEXColor(@"#818181", 1);
        tLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:tLabel];
        
        if (i == 0) {
            tLabel.frame = CGRectMake(0, 0, width1, height);
            _phoneLab = tLabel;
        } else if (i == 1) {
            tLabel.frame = CGRectMake(width1 , 0, width2, height);
            _areaLab = tLabel;
        } else if (i == 2) {
            tLabel.frame = CGRectMake(width1 + width2, 0, width3, height);
            _priceLab = tLabel;
        } else {
            tLabel.frame = CGRectMake(width1 + width2 + width3, 0, width4, height);
            tLabel.numberOfLines = 2;
            _timeLab = tLabel;
        }
    }
    
//    _maxPriceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 5 / 8 + 20, 0, 48, 25)];
//    _maxPriceImageView.image = [UIImage imageNamed:@"jp_max_price"];
//    _maxPriceImageView.hidden = YES;
//    [self.contentView addSubview:_maxPriceImageView];
}

- (void)setModel:(AuctionRecordModel *)model {
    _model = model;
    _phoneLab.text = model.phone;
    
    _areaLab.text = model.city;
    
    _priceLab.text = [NSString stringWithFormat:@"¥%@",model.price];
    
    _timeLab.text = [NSString stringWithFormat:@"%@\n%@",[model.createdAt substringToIndex:10],[model.createdAt substringFromIndex:11]];
    
    if (_index == 0) {
        _phoneLab.textColor = HEXColor(@"#ED3851", 1);
        _areaLab.textColor = HEXColor(@"#ED3851", 1);
        _priceLab.textColor = HEXColor(@"#ED3851", 1);
        _timeLab.textColor = HEXColor(@"#ED3851", 1);
//        _maxPriceImageView.hidden = NO;
    } else {
        _phoneLab.textColor = HEXColor(@"#818181", 1);
        _areaLab.textColor = HEXColor(@"#818181", 1);
        _priceLab.textColor = HEXColor(@"#818181", 1);
        _timeLab.textColor = HEXColor(@"#818181", 1);
//        _maxPriceImageView.hidden = YES;
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AuctionPriceRecordCell";
    AuctionPriceRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AuctionPriceRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
