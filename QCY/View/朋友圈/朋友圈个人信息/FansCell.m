//
//  FansCell.m
//  QCY
//
//  Created by i7colors on 2018/12/6.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "FansCell.h"
#import "UIView+Geometry.h"
#import "MacroHeader.h"
#import <YYText.h>
#import "FriendCricleModel.h"
#import <UIImageView+WebCache.h>
#import "HelperTool.h"

@interface FansCell()

@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong)YYLabel *nickLabel ;
@end

@implementation FansCell

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
    _headerImage = [[UIImageView alloc] init];
    _headerImage.frame = CGRectMake(14, (90 - 56) / 2, 56, 56);
    [HelperTool setRound:_headerImage corner:UIRectCornerAllCorners radiu:56 / 2];
    [self.contentView addSubview:_headerImage];
    
    _nickLabel = [[YYLabel alloc] init];
    _nickLabel.numberOfLines = 2;
    _nickLabel.frame = CGRectMake(80, _headerImage.top, SCREEN_WIDTH - 80 - 100, 40);
    [self.contentView addSubview:_nickLabel];
    
}

- (void)setModel:(FriendCricleModel *)model {
    _model = model;
    if isRightData(model.userCommunityPhoto) {
        [_headerImage sd_setImageWithURL:ImgUrl(model.userCommunityPhoto) placeholderImage:PlaceHolderImg];
    } else {
        _headerImage.image = DefaultImage;
    }
    
    //昵称
    if isRightData(model.userNickName) {
        NSMutableAttributedString *mtitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",model.userNickName]];
//        [mtitle appendAttributedString:[[NSAttributedString alloc] initWithString:title attributes:nil]];
        UIFont *font = [UIFont systemFontOfSize:15];
        mtitle.yy_font = font;
        if (![model.bossLevel isEqualToString:@"0"]) {
            UIImageView *levelImageView = [[UIImageView alloc] init];
            levelImageView.frame = CGRectMake(0, 0, 20, 20);
            NSString *imageStr = [NSString string];
            if ([model.bossLevel isEqualToString:@"1"]) {
                imageStr = @"default_116";
            } else if ([model.bossLevel isEqualToString:@"1"]) {
                imageStr = @"default_116";
            } else {
                imageStr = @"default_116";
            }
            levelImageView.image = [UIImage imageNamed:imageStr];
            NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:levelImageView contentMode:UIViewContentModeCenter attachmentSize:levelImageView.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
            [mtitle appendAttributedString:attachText];
        }
        
        _nickLabel.attributedText = mtitle;
    }
    
    
}



+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"FansCell";
    FansCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
