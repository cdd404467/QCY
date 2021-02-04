//
//  FCMapRecommendShopCell.m
//  QCY
//
//  Created by i7colors on 2019/6/30.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FCMapRecommendShopCell.h"
#import "HelperTool.h"
#import <UIImageView+WebCache.h>
#import "FriendCricleModel.h"


@implementation FCMapRecommendShopCell {
    UIImageView *_companyImageView;
    UILabel *_recommendCompany;
    UILabel *_nameLabel;
    UILabel *_contactLabel;
    UILabel *_areaLabel;
    UILabel *_distanceLabel;
    UIButton *_navBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    //图片
    _companyImageView = [[UIImageView alloc] init];
    _companyImageView.frame = CGRectMake(8, 10, 64, 64);
    [HelperTool setRound:_companyImageView corner:UIRectCornerAllCorners radiu:3];
    [self.contentView addSubview:_companyImageView];
    
    //推荐企业的标志
    _recommendCompany = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _companyImageView.width, 12)];
    _recommendCompany.textAlignment = NSTextAlignmentCenter;
    _recommendCompany.backgroundColor = HEXColor(@"#F10215", 1);
    _recommendCompany.font = [UIFont systemFontOfSize:11];
    _recommendCompany.textColor = UIColor.whiteColor;
    _recommendCompany.hidden = YES;
    _recommendCompany.text = @"推荐企业";
    [_companyImageView addSubview:_recommendCompany];
    
    //公司名称
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_companyImageView.right + 14, _companyImageView.top, SCREEN_WIDTH - _companyImageView.right - 14 - 8, 16)];
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
    
    //联系方式
    _contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 15, _nameLabel.width, 14)];
    _contactLabel.font = [UIFont systemFontOfSize:12];
    _contactLabel.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:_contactLabel];
    
    //地区
    _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, 0, _nameLabel.width / 5 * 3, 14)];
    _areaLabel.bottom = _companyImageView.bottom;
    _areaLabel.font = [UIFont systemFontOfSize:12];
    _areaLabel.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:_areaLabel];
    
    //距离
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_areaLabel.right, _areaLabel.top, _nameLabel.width / 5 * 2, _areaLabel.height)];
    _distanceLabel.textAlignment = NSTextAlignmentRight;
    _distanceLabel.font = [UIFont systemFontOfSize:12];
    _distanceLabel.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:_distanceLabel];
    
    //查看路线
    _navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_navBtn setTitle:@"查看路线" forState:UIControlStateNormal];
    _navBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_navBtn setTitleColor:[UIColor colorWithRed:0.28 green:0.35 blue:0.54 alpha:1.0] forState:UIControlStateNormal];
    [_navBtn setTitleColor:[UIColor colorWithRed:0.28 green:0.35 blue:0.54 alpha:.5] forState:UIControlStateHighlighted];
    [_navBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_navBtn];
    CGFloat locWidth = [_navBtn.titleLabel.text boundingRectWithSize:CGSizeMake(100, 34)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:_navBtn.titleLabel.font}
                                           context:nil].size.width;
    _navBtn.frame = CGRectMake(0, _nameLabel.bottom + 1, locWidth, 34);
    _navBtn.right = _nameLabel.right;
}

- (void)btnClick {
    FCMapNavigationModel *model = [[FCMapNavigationModel alloc] init];
    model.nowLat = _model.nowLatitude;
    model.nowLon = _model.nowLongitude;
    model.targetLat = _model.latitude;
    model.targetLon = _model.longitude;
    model.endLocationName = _model.address;
    if (self.searchRouteBlock) {
        self.searchRouteBlock(model);
    }
}

- (void)setModel:(FCMapModel *)model {
    _model = model;
    //店铺logo
    [_companyImageView sd_setImageWithURL:ImgUrl(model.market.logo) placeholderImage:PlaceHolderImg];
    
    _recommendCompany.hidden = [model.from compare:@"market"] == NSOrderedSame ? NO : YES;

    //店铺名字
    _nameLabel.text = model.companyName;
    
    
    //联系方式
    NSString *phone = [NSString string];
    if (isRightData(_model.market.phone)) {
        phone = [NSString stringWithFormat:@"联系方式: %@",model.market.phone];
    } else {
        phone = @"联系方式: 暂无";
    }
    _contactLabel.text = [NSString stringWithFormat:@"联系方式: %@",model.market.phone];
    
    _areaLabel.text = [NSString stringWithFormat:@"所在地区: %@",model.shopArea];
    
    _distanceLabel.text = [NSString stringWithFormat:@"距离 %@",model.distance];
    
    if (model.latitude != 0.0 && model.longitude != 0.0) {
        _navBtn.hidden = NO;
    } else {
        _navBtn.hidden = YES;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FCMapRecommendShopCell";
    FCMapRecommendShopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FCMapRecommendShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
