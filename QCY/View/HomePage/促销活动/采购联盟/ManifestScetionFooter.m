//
//  ManifestScetionFooter.m
//  QCY
//
//  Created by i7colors on 2019/1/23.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ManifestScetionFooter.h"
#import "PrchaseLeagueModel.h"
#import "ClassTool.h"
#import "UIView+Border.h"

@implementation ManifestScetionFooter {
    UILabel *_stateLabel;
    UIImageView *_bgImgView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    //活动状态
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    [self.contentView addSubview:bgImgView];
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.font = [UIFont systemFontOfSize:15];
    stateLabel.frame = CGRectMake(0, 0, bgImgView.width, bgImgView.height);
    [bgImgView addSubview:stateLabel];
    _stateLabel = stateLabel;
    _bgImgView = bgImgView;
    
    [bgImgView addBorderView:LineColor width:0.5 direction:BorderDirectionTop];
}

- (void)setModel:(PrchaseLeagueModel *)model {
    _model = model;
    
    //状态 - 0，已结束，1未开始，2进行中
    if ([model.isType isEqualToString:@"0"]) {
        //活动文字
        _stateLabel.text = @"活动已结束!";
        _stateLabel.textColor = HEXColor(@"#3C3C3C", 1);
        _bgImgView.image = [UIImage imageWithColor:HEXColor(@"#cccccc", 1)];
    } else {
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
}

+ (instancetype)footerWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ManifestScetionFooter";
    // 1.缓存中取
    ManifestScetionFooter *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    // 2.创建
    if (header == nil) {
        header = [[ManifestScetionFooter alloc] initWithReuseIdentifier:identifier];
    }
    
    return header;
}
@end
