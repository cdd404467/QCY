//
//  FriendBookCell.m
//  QCY
//
//  Created by i7colors on 2019/4/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FriendBookCell.h"
#import "BEMCheckBox.h"
#import "FriendCricleModel.h"
#import <UIImageView+WebCache.h>
#import "HelperTool.h"

@interface FriendBookCell()<BEMCheckBoxDelegate>

@end

@implementation FriendBookCell {
    BEMCheckBox *_checkBox;
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UILabel *_certNameLabel;
    UIImageView *_bigVImageView;
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
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    CGFloat width = 22;
    //复选框
    _checkBox = [[BEMCheckBox alloc] initWithFrame:CGRectMake(25, (65 - width) / 2, width, width)];
    _checkBox.boxType = BEMBoxTypeCircle;
    _checkBox.onAnimationType = BEMAnimationTypeBounce;
    _checkBox.offAnimationType = BEMAnimationTypeBounce;
    _checkBox.onCheckColor = [UIColor whiteColor];
    _checkBox.onTintColor = HEXColor(@"#F10215", 1);
    _checkBox.onFillColor = HEXColor(@"#F10215", 1);
    _checkBox.offFillColor = HEXColor(@"#f3f3f3", 1);
    _checkBox.lineWidth = 1.f;
    _checkBox.delegate = self;
    [self.contentView addSubview:_checkBox];
    
    //头像
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_checkBox.right + 25, 0, 50, 50)];
    [HelperTool setRound:_headerImageView corner:UIRectCornerAllCorners radiu:5.f];
    [self.contentView addSubview:_headerImageView];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.centerY = _checkBox.centerY;
    
    //名字
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerImageView.right + 10, 14, SCREEN_WIDTH - _headerImageView.right - 20, 15)];
    _nameLabel.textColor = UIColor.blackColor;
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    
    //认证名字
    _certNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + 6, _nameLabel.width, _nameLabel.height)];
    _certNameLabel.textColor = HEXColor(@"#868686", 1);
    _certNameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_certNameLabel];
    
    //大V认证图标
    _bigVImageView = [[UIImageView alloc] init];
    _bigVImageView.frame = CGRectMake(_headerImageView.width - 14, _headerImageView.width - 14, 14, 14);
    _bigVImageView.image = [UIImage imageNamed:@"bigV_img"];
    _bigVImageView.hidden = YES;
    [_headerImageView addSubview:_bigVImageView];
    [HelperTool setRound:_bigVImageView corner:UIRectCornerAllCorners radiu:7];
    
}

- (void)setModel:(FriendCricleInfoModel *)model {
    _model = model;
    
    _checkBox.on = model.isSelectFriend;
    
    //头像
    if isRightData(model.userCommunityPhoto) {
        [_headerImageView sd_setImageWithURL:ImgUrl(model.userCommunityPhoto) placeholderImage:PlaceHolderImg];
    } else {
        _headerImageView.image = DefaultImage;
    }
    
    //名字
    _nameLabel.text = model.userNickName;
    
    //认证名字
    if ([model.isCompanyType isEqualToString:@"1"]) {
        _certNameLabel.text = model.companyName;
        _certNameLabel.hidden = NO;
        _bigVImageView.hidden = NO;
        _nameLabel.height = 15;
    } else {
        if ([model.isDyeV isEqualToString:@"1"]) {
            _certNameLabel.text = model.dyeVName;
            _certNameLabel.hidden = NO;
            _bigVImageView.hidden = NO;
            _nameLabel.height = 15;
        } else {
            _certNameLabel.text = @"";
            _certNameLabel.hidden = YES;
            _bigVImageView.hidden = YES;
            _nameLabel.height = 65 - 14 * 2;
        }
    }
}

//复选框代理
- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    _model.isSelectFriend = _checkBox.on;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FriendBookCell";
    FriendBookCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FriendBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
