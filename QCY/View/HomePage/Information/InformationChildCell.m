//
//  InformationChildCell.m
//  QCY
//
//  Created by i7colors on 2018/11/1.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "InformationChildCell.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import <YYWebImage.h>
#import "InfomationModel.h"

@implementation InformationChildCell {
    UIImageView *_headerImageView;
    UILabel *_bigTitle;
    UILabel *_someText;
    UILabel *_newsDate;
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
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 6);
    topView.backgroundColor = RGBA(0, 0, 0, 0.08);
    [self.contentView addSubview:topView];
    
    //图片
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.frame = CGRectMake(0, 6, 110, 110);
    [self.contentView addSubview:headerImageView];
    _headerImageView = headerImageView;
    
    //大标题
    UILabel *bigTitle = [[UILabel alloc] init];
    bigTitle.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:bigTitle];
    [bigTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerImageView.mas_right).offset(KFit_W(15));
        make.right.mas_equalTo(KFit_W(-10));
        make.top.mas_equalTo(21);
        make.height.mas_equalTo(17);
    }];
    _bigTitle = bigTitle;
    
    //部分文本
    UILabel *someText = [[UILabel alloc] init];
    someText.numberOfLines = 2;
    someText.font = [UIFont systemFontOfSize:12];
    someText.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:someText];
    [someText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(bigTitle);
        make.top.mas_equalTo(bigTitle.mas_bottom).offset(7);
    }];
    _someText = someText;
    
    //新闻日期
    UILabel *newsDate = [[UILabel alloc] init];
    newsDate.font = [UIFont systemFontOfSize:12];
    newsDate.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:newsDate];
    [newsDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(bigTitle);
        make.bottom.mas_equalTo(-15);
    }];
    _newsDate = newsDate;
}

- (void)setModel:(InfomationModel *)model {
    _model = model;
    
    if isRightData(model.img_url)
        [_headerImageView yy_setImageWithURL:[NSURL URLWithString:ImgStr(model.img_url)] placeholder:PlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    
    if isRightData(model.title)
        _bigTitle.text = model.title;
    
    if isRightData(model.content_summary)
        _someText.text = model.content_summary;
    
    if isRightData(model.news_date) {
        NSArray *array = [model.news_date componentsSeparatedByString:@" "];
        _newsDate.text = [NSString stringWithFormat:@"新闻日期: %@",array[0]];
    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"InformationChildCell";
    InformationChildCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[InformationChildCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
