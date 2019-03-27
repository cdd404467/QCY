//
//  GroupBuyingCell.m
//  QCY
//
//  Created by i7colors on 2018/11/1.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GroupBuyingCell.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import <YYWebImage.h>
#import "GroupBuyingModel.h"
#import <YYText.h>
#import "HelperTool.h"

@interface GroupBuyingCell()

@property (nonatomic, strong)UIView *stateView;
@property (nonatomic, strong) UIImageView *emojoImage;;
@end

@implementation GroupBuyingCell {
    UIImageView *_headerImageView;
    UIImageView *_stateImageView;
    UILabel *_productName;
    UILabel *_totalWeight;
    UILabel *_minBuy;
    UILabel *_maxBuy;
    UILabel *_stateLabelLeft;
    UILabel *_stateLabelRight;
    UIImageView *_priceImageView;
    YYLabel *_originalPrice;
    YYLabel *_currentPrice;
    UILabel *_alreadyGet;
    UIProgressView *_progressView;
    UILabel *_progressLabel;
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
    //图片
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.frame = CGRectMake(0, 0, 120, 120);
    headerImageView.layer.borderWidth = 1.f;
    headerImageView.layer.borderColor = LineColor.CGColor;
    [self.contentView addSubview:headerImageView];
    _headerImageView = headerImageView;
    
    //图片上的状态图片
    UIImageView *stateImageView = [[UIImageView alloc] init];
    stateImageView.frame = CGRectMake(0, 0, 55, 55);
    [self.contentView addSubview:stateImageView];
    _stateImageView = stateImageView;
    
    //名称
    UILabel *productName = [[UILabel alloc] init];
    productName.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:productName];
    [productName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerImageView.mas_right).offset(KFit_W(15));
        make.right.mas_equalTo(KFit_W(-15));
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(17);
    }];
    _productName = productName;
    
    //总量&剩余量
    UILabel *totalWeight = [[UILabel alloc] init];
    totalWeight.font = [UIFont systemFontOfSize:12];
    totalWeight.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:totalWeight];
    [totalWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(productName);
        make.top.mas_equalTo(productName.mas_bottom).offset(5);
        make.height.mas_equalTo(13);
    }];
    _totalWeight = totalWeight;
   
    
    //最小认购量
    UILabel *minBuy = [[UILabel alloc] init];
    minBuy.font = [UIFont systemFontOfSize:10];
    minBuy.textAlignment = NSTextAlignmentCenter;
    minBuy.layer.cornerRadius = 5;
    minBuy.layer.borderColor = HEXColor(@"#868686", 1).CGColor;
    minBuy.layer.borderWidth = 1.f;
    minBuy.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:minBuy];
    [minBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(productName.mas_centerX).offset(-5);
        make.top.mas_equalTo(totalWeight.mas_bottom).offset(7);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(KFit_W(102));
    }];
    _minBuy = minBuy;
    
    //最大认购量
    UILabel *maxBuy = [[UILabel alloc] init];
    maxBuy.font = [UIFont systemFontOfSize:10];
    maxBuy.textAlignment = NSTextAlignmentCenter;
    maxBuy.layer.cornerRadius = 5;
    maxBuy.layer.borderColor = HEXColor(@"#868686", 1).CGColor;
    maxBuy.layer.borderWidth = 1.f;
    maxBuy.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:maxBuy];
    [maxBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(productName.mas_centerX).offset(5);
        make.centerY.height.width.mas_equalTo(minBuy);
    }];
    _maxBuy = maxBuy;
    
    //分割线
    UIView *hLine = [[UIView alloc] init];
    hLine.backgroundColor = LineColor;
    [self.contentView addSubview:hLine];
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(headerImageView);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(0);
    }];
    //右边放状态的view
    UIView *stateView = [[UIView alloc] init];
    [self.contentView addSubview:stateView];
    [stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerImageView.mas_right);
        make.top.mas_equalTo(minBuy.mas_bottom);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(hLine.mas_top);
    }];
    _stateView = stateView;
    
    //图片
    UIImageView *emojoImage = [[UIImageView alloc] init];
    [stateView addSubview:emojoImage];
    [emojoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(stateView);
        make.width.height.mas_equalTo(36);
        make.left.mas_equalTo(stateView.mas_centerX).offset(5);
    }];
    _emojoImage = emojoImage;
    
    //左边文字label
    UILabel *stateLabelLeft = [[UILabel alloc] init];
    stateLabelLeft.textAlignment = NSTextAlignmentRight;
    stateLabelLeft.font = [UIFont boldSystemFontOfSize:15];
    [stateView addSubview:stateLabelLeft];
    [stateLabelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(stateView);
        make.right.mas_equalTo(emojoImage.mas_left).offset(-10);
    }];
    _stateLabelLeft = stateLabelLeft;
    
    //右边文字label
    UILabel *stateLabelRight = [[UILabel alloc] init];
    stateLabelRight.textColor = MainColor;
    stateLabelRight.textAlignment = NSTextAlignmentLeft;
    stateLabelRight.font = [UIFont boldSystemFontOfSize:15];
    [stateView addSubview:stateLabelRight];
    [stateLabelRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(stateView);
        make.left.mas_equalTo(emojoImage.mas_right).offset(10);
    }];
    _stateLabelRight = stateLabelRight;
    
    //显示价格的
    UIImageView *priceImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:priceImageView];
    [priceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImageView.mas_bottom);
        make.right.mas_equalTo(headerImageView);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    _priceImageView = priceImageView;
    
    //原价
    YYLabel *originalPrice = [[YYLabel alloc] init];
    [priceImageView addSubview:originalPrice];
    [originalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(priceImageView);
        make.top.mas_equalTo(4);
    }];
    _originalPrice = originalPrice;
    
    //现价
    YYLabel *currentPrice = [[YYLabel alloc] init];
    [priceImageView addSubview:currentPrice];
    [currentPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(priceImageView);
        make.top.mas_equalTo(originalPrice.mas_bottom).offset(0);
    }];
    _currentPrice = currentPrice;
    
    //已经认领
    UILabel *alreadyGet = [[UILabel alloc] init];
    alreadyGet.font = [UIFont systemFontOfSize:12];
    alreadyGet.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:alreadyGet];
    [alreadyGet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hLine.mas_bottom).offset(12);
        make.left.mas_equalTo(productName);
    }];
    _alreadyGet = alreadyGet;
    
    //进度条
    UIProgressView *progressView = [[UIProgressView alloc] init];
    progressView.layer.cornerRadius = 2.5;
    progressView.clipsToBounds = YES;
    progressView.tintColor = MainColor;
    [self.contentView addSubview:progressView];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(productName);
        make.width.mas_equalTo(KFit_W(170));
        make.height.mas_equalTo(5);
        make.bottom.mas_equalTo(priceImageView.mas_bottom).offset(-8);
    }];
    _progressView = progressView;
    
    //进度label
    UILabel *progressLabel = [[UILabel alloc] init];
    progressLabel.font = [UIFont systemFontOfSize:11];
    progressLabel.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:progressLabel];
    [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(progressView.mas_right).offset(KFit_W(8));
        make.centerY.mas_equalTo(progressView);
        make.right.mas_equalTo(-2);
    }];
    _progressLabel = progressLabel;

    //底部灰色条子
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = Cell_BGColor;
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceImageView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setModel:(GroupBuyingModel *)model {
    _model = model;
    //产品图片
    if isRightData(model.productPic)
        [_headerImageView yy_setImageWithURL:ImgUrl(model.productPic) placeholder:PlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    //产品名字
    if isRightData(model.productName)
        _productName.text = model.productName;
    
    //总量和剩余量
    if isRightData(model.totalNum) {
        NSString *total = [NSString stringWithFormat:@"总量 :%@%@ ",model.totalNum,model.numUnit];
        _totalWeight.text = total;
        if isRightData(model.remainNum) {
            NSString *rest = [NSString stringWithFormat:@"   剩余量 :%@%@",model.remainNum,model.numUnit];
            _totalWeight.text = [NSString stringWithFormat:@"%@%@",total,rest];
        }
    }
    
    //最小认购量
    if isRightData(model.minNum)
        _minBuy.text = [NSString stringWithFormat:@"最小认购量 :%@%@",model.minNum,model.numUnit];
    
    //最大认购量
    if isRightData(model.maxNum)
        _maxBuy.text = [NSString stringWithFormat:@"最大认购量 :%@%@",model.maxNum,model.numUnit];
    
    /*** 团购状态判断 ***/
    //左上角图片
    //未开始
    if ([model.endCode isEqualToString:@"00"]) {
        _stateImageView.image = [UIImage imageNamed:@"groupBuy_notStart"];
        _priceImageView.image = [UIImage imageWithColor:HEXColor(@"#868686", 1)];
    //已开始
    } else if ([model.endCode isEqualToString:@"10"]) {
        _stateImageView.image = [UIImage imageNamed:@"groupBuy_start"];
         _priceImageView.image = [UIImage imageNamed:@"price_state_bg"];
    //已结束
    } else {
        _stateImageView.image = [UIImage imageNamed:@"groupBuy_end"];
        _priceImageView.image = [UIImage imageWithColor:HEXColor(@"#BCBCBC", 1)];
    }
    //原价
    
    NSString *oPrice = [HelperTool getStringFrom:model.oldPrice];
    NSString *oText = [NSString stringWithFormat:@"原价: ¥%@元/%@",oPrice,model.priceUnit];
    NSMutableAttributedString *mutableOriginal = [[NSMutableAttributedString alloc] initWithString:oText];
    mutableOriginal.yy_color = [UIColor blackColor];
    mutableOriginal.yy_font = [UIFont systemFontOfSize:10];
    [mutableOriginal yy_setFont:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(5, oPrice.length)];
    NSRange range2 = [[mutableOriginal string] rangeOfString:oText options:NSCaseInsensitiveSearch];
    //下划线
    YYTextDecoration *decoration = [YYTextDecoration decorationWithStyle:YYTextLineStyleSingle
                                                                   width:@(1)
                                                                   color:RGBA(0, 0, 0, 0.8)];
    //删除样式
    [mutableOriginal yy_setTextStrikethrough:decoration range:range2];

    _originalPrice.attributedText = mutableOriginal;

    //现价
    NSString *cPrice = model.priceNew;
    NSString *cText = [NSString stringWithFormat:@"团购价: ¥%@元/%@",cPrice,model.priceUnit];
    NSMutableAttributedString *mutablecurrent = [[NSMutableAttributedString alloc] initWithString:cText];
    mutablecurrent.yy_color = HEXColor(@"#333333", 1);
    mutablecurrent.yy_font = [UIFont systemFontOfSize:10];
    [mutablecurrent yy_setFont:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(6, cPrice.length)];
    _currentPrice.attributedText = mutablecurrent;
    
    //右边文字状态
    //未开始
    if ([model.endCode isEqualToString:@"00"]) {
        _emojoImage.hidden = NO;
        _stateLabelRight.hidden = NO;
        _stateLabelLeft.textColor = MainColor;
        NSString *start = [model.startTime substringToIndex:10];
        NSString *end = [model.endTime substringToIndex:10];
        _stateLabelLeft.text = start;
        _stateLabelRight.text = end;
        _emojoImage.image = [UIImage imageNamed:@"groupBuy_time"];
        [_emojoImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20);
            make.center.mas_equalTo(self.stateView);
        }];
        [_stateLabelRight mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.stateView);
            make.left.mas_equalTo(self.emojoImage.mas_right).offset(10);
        }];
        [_stateLabelLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.stateView);
            make.right.mas_equalTo(self.emojoImage.mas_left).offset(-10);
        }];
        
    //进行中
    } else if ([model.endCode isEqualToString:@"10"]) {
        _emojoImage.hidden = YES;
        _stateLabelRight.hidden = YES;
        _stateLabelLeft.text = @"团购进行中...";
        _stateLabelLeft.textColor = MainColor;        
        [_stateLabelLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.stateView);
        }];
        
    //失败
    } else if ([model.endCode isEqualToString:@"20"]) {
        _emojoImage.hidden = NO;
        _stateLabelRight.hidden = YES;
        _stateLabelLeft.textColor = HEXColor(@"#868686", 1);;
        _stateLabelLeft.text = @"团购失败!";
        _emojoImage.image = [UIImage imageNamed:@"groupBuy_fail"];
        [_emojoImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.stateView);
            make.width.height.mas_equalTo(36);
            make.left.mas_equalTo(self.stateView.mas_centerX).offset(5);
        }];
        [_stateLabelLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.stateView);
            make.right.mas_equalTo(self.stateView.mas_centerX).offset(-5);
        }];
    //成功
    } else {
        _emojoImage.hidden = NO;
        _stateLabelRight.hidden = YES;
        _stateLabelLeft.textColor = MainColor;
        _stateLabelLeft.text = @"团购成功!";
        _emojoImage.image = [UIImage imageNamed:@"groupBuy_success"];
        [_emojoImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.stateView);
            make.width.height.mas_equalTo(36);
            make.left.mas_equalTo(self.stateView.mas_centerX).offset(5);
        }];
        [_stateLabelLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.stateView);
            make.right.mas_equalTo(self.stateView.mas_centerX).offset(-5);
        }];
        
    }
    
    //已经认领
    if isRightData(model.subscribedNum)
        _alreadyGet.text = [NSString stringWithFormat:@"已认领量:  %@%@",model.subscribedNum,model.numUnit];
    
    //进度条
    if (isRightData(model.numPercent)) {
        NSString *percentStr = [model.numPercent substringToIndex:model.numPercent.length - 1];
        CGFloat percent = [percentStr floatValue] / 100;
        _progressView.progress = percent;
        _progressLabel.text = [NSString stringWithFormat:@"达成%@",model.numPercent];
    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"InformationChildCell";
    GroupBuyingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[GroupBuyingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
