//
//  PrchaseLeagueCell.m
//  QCY
//
//  Created by i7colors on 2019/1/8.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PrchaseLeagueCell.h"
#import "PrchaseLeagueModel.h"
#import "UIView+Border.h"
#import <YYText.h>
#import "ClassTool.h"

@implementation PrchaseLeagueCell {
    UILabel *_leagueName;
    UIButton *_caigouBtn;
    UIButton *_gonghuoBtn;
    YYLabel *_allDH;
    YYLabel *_allDHCompany;
    YYLabel *_allGH;
    YYLabel *_allGHsup;
    UILabel *_stateLabel;
    UIImageView *_bgImgView;
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
    UILabel *leagueName = [[UILabel alloc] init];
    leagueName.font = [UIFont boldSystemFontOfSize:15];
    leagueName.textColor = HEXColor(@"#202020", 1);
    leagueName.numberOfLines = 2;
    leagueName.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 60);
    [self.contentView addSubview:leagueName];
    _leagueName = leagueName;
    
    UIView *handleView = [[UIView alloc] init];
    handleView.frame = CGRectMake(0, leagueName.bottom, SCREEN_WIDTH, 35);
    [self.contentView addSubview:handleView];
    [handleView addBorderView:RGBA(190, 190, 190, 1) width:0.5f direction:BorderDirectionTop | BorderDirectionBottom];
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 12.5;
        btn.layer.borderWidth = 1.f;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [handleView addSubview:btn];
        if (i == 0) {
            //我要采购按钮
            btn.frame = CGRectMake(0, 5, 130, 25);
            [btn setTitle:@"我要采购" forState:UIControlStateNormal];
            btn.centerX = SCREEN_WIDTH / 4;
            _caigouBtn = btn;
        } else {
            //我要供货按钮
            btn.frame = CGRectMake(0, 5, 130, 25);
            [btn setTitle:@"我要供货" forState:UIControlStateNormal];
            btn.centerX = SCREEN_WIDTH / 4 * 3;
            [handleView addSubview:btn];
            _gonghuoBtn = btn;
        }
    }
    
    CGFloat width = SCREEN_WIDTH / 4;
    //4块view
    for (NSInteger i = 0; i < 4; i ++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(i * width, handleView.bottom, width, 50);
        [self.contentView addSubview:view];
        
        YYLabel *label = [[YYLabel alloc] init];
        label.numberOfLines = 2;
        label.frame = CGRectMake(2, 2, width - 4, 46);
        [view addSubview:label];
        [view addBorderView:RGBA(190, 190, 190, 1) width:0.5f direction:BorderDirectionBottom];
        if (i != 0) {
            [view addBorderView:RGBA(190, 190, 190, 1) width:0.5f direction:BorderDirectionLeft];
        }
        
        if (i == 0) {
            _allDH = label;
        } else if (i == 1) {
            _allDHCompany = label;
        } else if (i == 2) {
            _allGH = label;
        } else {
            _allGHsup = label;
        }
        
    }
    
    //活动状态
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, handleView.bottom + 50, SCREEN_WIDTH, 30);
    [self.contentView addSubview:bgImgView];
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.font = [UIFont systemFontOfSize:15];
    stateLabel.frame = CGRectMake(0, 0, bgImgView.width, bgImgView.height);
    [bgImgView addSubview:stateLabel];
    _stateLabel = stateLabel;
    _bgImgView = bgImgView;
    //间隔
    UIView *bottomGap = [[UIView alloc] init];
    bottomGap.backgroundColor = HEXColor(@"#EDEDED", 1);
    bottomGap.frame = CGRectMake(0, 175, SCREEN_WIDTH, 12);
    [self.contentView addSubview:bottomGap];
}

- (void)btnClick:(UIButton *)sender {
    if (self.btnClickBlock) {
        self.btnClickBlock(sender.tag, _model);
    }
}


- (void)setModel:(PrchaseLeagueModel *)model {
    _model = model;
    
    _leagueName.text = model.meetingName;
    
    //状态 - 0，已结束，1未开始，2进行中
    if ([model.isType isEqualToString:@"0"]) {
        //按钮状态
        _caigouBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [_caigouBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _caigouBtn.backgroundColor = HEXColor(@"#A6A6A6", 1);
        _gonghuoBtn.layer.borderColor = [UIColor clearColor].CGColor;
        [_gonghuoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _gonghuoBtn.backgroundColor = HEXColor(@"#A6A6A6", 1);
        //活动文字
        _stateLabel.text = @"活动已结束!";
        _stateLabel.textColor = HEXColor(@"#3C3C3C", 1);
        _bgImgView.image = [UIImage imageWithColor:HEXColor(@"#cccccc", 1)];
    } else {
        //按钮状态
        _caigouBtn.layer.borderColor = HEXColor(@"#FF7E00", 1).CGColor;
        [_caigouBtn setTitleColor:HEXColor(@"#FF7E00", 1) forState:UIControlStateNormal];
        _caigouBtn.backgroundColor = [UIColor whiteColor];
        _gonghuoBtn.layer.borderColor = HEXColor(@"#4A81FF", 1).CGColor;
        [_gonghuoBtn setTitleColor:HEXColor(@"#4A81FF", 1) forState:UIControlStateNormal];
        _gonghuoBtn.backgroundColor = [UIColor whiteColor];
        NSString *sTime = [model.startTime substringToIndex:10];
        NSString *eTime = [model.endTime substringToIndex:10];
        if ([model.isType isEqualToString:@"1"]) {
            _stateLabel.text = [NSString stringWithFormat:@"尚未开始(活动时间:%@ 至 %@)",sTime,eTime];
            _stateLabel.textColor = HEXColor(@"#3C3C3C", 1);
            _bgImgView.image = [UIImage imageWithColor:[UIColor whiteColor]];
        } else {
            _stateLabel.text = [NSString stringWithFormat:@"进行中(结束时间: %@)",eTime];
            _stateLabel.textColor = [UIColor whiteColor];
            UIImage *img = [ClassTool getGradedImage:_stateLabel colors:@[HEXColor(@"#FF7E00", 1),HEXColor(@"#F10215", 1)] gradientType:1];
            _bgImgView.image = img;
        }
    }
    
    for (NSInteger i = 0; i < 4; i ++) {
        NSString *text = [NSString string];
        NSString *comText = [NSString string];
        NSString *unit = [NSString string];
        if (i == 0) {
            text = model.allNum;
            comText = @"商品订货量";
            unit = @"吨";
        } else if (i == 1) {
            text = model.placeCount;
            comText = @"参与印染企业";
            unit = @"家";
        } else if (i == 2) {
            text = model.allOutputNum;
            comText = @"商品总供贷量";
            unit = @"吨";
        } else {
            text = model.supplyCount;
            comText = @"参与供应商";
            unit = @"家";
        }
        NSString *saleText = [NSString stringWithFormat:@"%@ %@\n%@",text ,unit ,comText];
        NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:saleText];
        mutableText.yy_color = HEXColor(@"#333333", 1);
        mutableText.yy_alignment = NSTextAlignmentCenter;
        mutableText.yy_font = [UIFont systemFontOfSize:8];
        [mutableText yy_setFont:[UIFont systemFontOfSize:13] range:NSMakeRange(0, text.length)];
        [mutableText yy_setColor:HEXColor(@"#F10215", 1) range:NSMakeRange(0, text.length)];
        [mutableText yy_setColor:HEXColor(@"#B7B7B7", 1) range:NSMakeRange(text.length + 1, 1)];
        switch (i) {
            case 0:
                _allDH.attributedText = mutableText;
                break;
            case 1:
                _allDHCompany.attributedText = mutableText;
            case 2:
                _allGH.attributedText = mutableText;
            case 3:
                _allGHsup.attributedText = mutableText;
            default:
                break;
        }
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"PrchaseLeagueCell";
    PrchaseLeagueCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PrchaseLeagueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
