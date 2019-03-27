//
//  AuctionTBCell.m
//  QCY
//
//  Created by i7colors on 2019/3/4.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AuctionTBCell.h"
#import "MacroHeader.h"
#import "UIView+Geometry.h"
#import <Masonry.h>
#import "AuctionModel.h"
#import <YYWebImage.h>
#import <YYText.h>

@interface AuctionTBCell()
@property (nonatomic, strong)UIImageView *goodsImageView;
@property (nonatomic, strong)UIImageView *stateImageView;
@property (nonatomic, strong)UILabel *goodsNameLab;
@property (nonatomic, strong)UILabel *areaLab;
@property (nonatomic, strong)YYLabel *startPriceLab;
@property (nonatomic, strong)YYLabel *nowPriceLab;
@property (nonatomic, strong)UILabel *stateLab;
@end

@implementation AuctionTBCell

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
    //图片
    UIImageView *goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    [self.contentView addSubview:goodsImageView];
    _goodsImageView = goodsImageView;
    
    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(goodsImageView.right, 0, SCREEN_WIDTH - goodsImageView.right, 0.5)];
    lineView.top = goodsImageView.bottom - 0.5;
    lineView.backgroundColor = LineColor;
    [self.contentView addSubview:lineView];
    
    //左上角状态图片
    UIImageView *stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];;
    [self.contentView addSubview:stateImageView];
    _stateImageView = stateImageView;
    
    
    //名字
    UILabel *goodsNameLab = [[UILabel alloc] initWithFrame:CGRectMake(goodsImageView.right + 15, 8, SCREEN_WIDTH - goodsImageView.width - 25, 14)];
    goodsNameLab.font = [UIFont boldSystemFontOfSize:15];
    goodsNameLab.numberOfLines = 2;
    [self.contentView addSubview:goodsNameLab];
    _goodsNameLab = goodsNameLab;
    
    //地区
    UILabel *areaLab = [[UILabel alloc] initWithFrame:CGRectMake(goodsNameLab.left, goodsNameLab.bottom + 4, goodsNameLab.width, 12)];
    areaLab.font = [UIFont systemFontOfSize:12];
    areaLab.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:areaLab];
    _areaLab = areaLab;
    
    //当前价格
    YYLabel *nowPriceLab = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 23)];
    nowPriceLab.layer.borderColor = HEXColor(@"#ED3851", 1).CGColor;
    nowPriceLab.layer.borderWidth = 1.f;
    nowPriceLab.layer.cornerRadius = 23 / 2;
    nowPriceLab.bottom = goodsImageView.bottom - 6;
    [self.contentView addSubview:nowPriceLab];
    _nowPriceLab = nowPriceLab;
    
    //起拍价格
    YYLabel *startPriceLab = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 23)];
    startPriceLab.bottom = nowPriceLab.top - 2;
    [self.contentView addSubview:startPriceLab];
    _startPriceLab = startPriceLab;
    
    //显示状态的label
    UILabel *stateLab = [[UILabel alloc] initWithFrame:CGRectMake(0, goodsImageView.bottom, SCREEN_WIDTH, 40)];
    stateLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:stateLab];
    _stateLab = stateLab;
}


- (void)setModel:(AuctionModel *)model {
    _model = model;
    //商品图片
    [_goodsImageView yy_setImageWithURL:ImgUrl(model.productPic) placeholder:PlaceHolderImg options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    
    //状态图片
    _stateImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"jp_state_%@",model.isType]];
    
    //商品名字
    CGFloat nameHeihgt = [model.shopName boundingRectWithSize:CGSizeMake(_goodsNameLab.width, CGFLOAT_MAX)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName :_goodsNameLab.font}
                                                  context:nil].size.height;
    if (nameHeihgt > 40)
        nameHeihgt = 36;
    _goodsNameLab.height = nameHeihgt;
    _goodsNameLab.text = [NSString stringWithFormat:@"%@",model.shopName];
    
    //地区
    _areaLab.top = _goodsNameLab.bottom + 5;
    _areaLab.text = [NSString stringWithFormat:@"所在地区: %@",model.address];
    
    
    //当前价格
    NSString *nowPrice = [NSString stringWithFormat:@"     当前价格: ¥ %@%@     ",model.maxPrice,model.priceUnit];
    NSMutableAttributedString *mutableNowPrice = [[NSMutableAttributedString alloc] initWithString:nowPrice];
    mutableNowPrice.yy_font = [UIFont systemFontOfSize:11];
    mutableNowPrice.yy_color = HEXColor(@"#F10215", 1);
    [mutableNowPrice yy_setFont:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(13, model.maxPrice.length)];
    _nowPriceLab.attributedText = mutableNowPrice;
    CGSize introSize = CGSizeMake(CGFLOAT_MAX, _nowPriceLab.height);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:mutableNowPrice];
    _nowPriceLab.textLayout = layout;
    CGFloat width1 = layout.textBoundingSize.width;
    _nowPriceLab.width = width1;
    _nowPriceLab.left = SCREEN_WIDTH - width1 - 8;
    
    //起拍价格
    NSString *startPrice = [NSString stringWithFormat:@"起拍价格: ¥ %@%@",model.price,model.priceUnit];
    NSMutableAttributedString *mutablestartPrice = [[NSMutableAttributedString alloc] initWithString:startPrice];
    mutablestartPrice.yy_font = [UIFont systemFontOfSize:11];
    mutablestartPrice.yy_color = HEXColor(@"#868686", 1);
    [mutablestartPrice yy_setFont:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(8, model.price.length)];
    _startPriceLab.attributedText = mutablestartPrice;
    CGSize introSize1 = CGSizeMake(CGFLOAT_MAX, _startPriceLab.height);
    YYTextLayout *layout1 = [YYTextLayout layoutWithContainerSize:introSize1 text:mutablestartPrice];
    _startPriceLab.textLayout = layout1;
    CGFloat width2 = layout1.textBoundingSize.width;
    _startPriceLab.width = width2;
    _startPriceLab.centerX = _nowPriceLab.centerX;
    
    //状态Label- 1未开始，2进行中，3成交，0已流拍
    switch ([model.isType integerValue]) {
        case 0:
            _stateLab.backgroundColor = HEXColor(@"#868686", 1);
            _stateLab.textColor = [UIColor whiteColor];
            _stateLab.text = @"竞拍已流拍!";
            _stateLab.font = [UIFont systemFontOfSize:15];
            break;
        case 1:
            _stateLab.backgroundColor = [UIColor whiteColor];
            _stateLab.textColor = HEXColor(@"#868686", 1);
            _stateLab.text = [NSString stringWithFormat:@"未开始(活动时间: %@ 至 %@)",[_model.startTime substringToIndex:10],[_model.endTime substringToIndex:10]];
            _stateLab.font = [UIFont systemFontOfSize:13];
            break;
        case 2:
            _stateLab.backgroundColor = HEXColor(@"#ef3673", 1);
            _stateLab.textColor = [UIColor whiteColor];
//           _stateLab.text = [NSString stringWithFormat:@"进心中(结束时间: %@)",[_model.endTime substringToIndex:10]];
            _stateLab.text = [NSString stringWithFormat:@"进心中(结束时间: %@)",_model.endTime];
            _stateLab.font = [UIFont systemFontOfSize:13];
            break;
        case 3:
            _stateLab.backgroundColor = HEXColor(@"#067DEC", 1);
            _stateLab.textColor = [UIColor whiteColor];
            _stateLab.text = @"竞拍已成交!";
            _stateLab.font = [UIFont systemFontOfSize:15];
            break;
        default:
            break;
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 10;
    [super setFrame:frame];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AuctionTBCell";
    AuctionTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AuctionTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
