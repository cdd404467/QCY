//
//  TopicVCHeaderView.m
//  QCY
//
//  Created by i7colors on 2019/4/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "TopicVCHeaderView.h"
#import <UIImageView+WebCache.h>
#import "FriendCricleModel.h"


@implementation TopicVCHeaderView {
    UIImageView *_posterImage;
    UILabel *_desLab;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXColor(@"#E5E5E5", 1);
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 144);
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 144 * Scale_W);
    UIImageView *posterImage = [[UIImageView alloc] init];
    posterImage.frame = frame;
    
    [self addSubview:posterImage];
    _posterImage = posterImage;
    
    //描述
    _desLab = [[UILabel alloc] init];
    _desLab.frame = CGRectMake(20, posterImage.bottom, SCREEN_WIDTH - 20 * 2, 0);
    _desLab.font = [UIFont systemFontOfSize:14];
    _desLab.numberOfLines = 0;
    _desLab.textColor = UIColor.blackColor;
    [self addSubview:_desLab];
}

- (void)setModel:(FriendTopicModel *)model {
    _model = model;
    if (isRightData(model.banner)) {
        [_posterImage sd_setImageWithURL:ImgUrl(model.banner) placeholderImage:PlaceHolderImgBanner];
    } else {
        _posterImage.image = PlaceHolderImgBanner;
    }
    
    //描述
    if (isRightData(model.descriptionStr)) {
        _desLab.text = model.descriptionStr;
        CGFloat height = [model.descriptionStr boundingRectWithSize:CGSizeMake(_desLab.width, CGFLOAT_MAX)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName : _desLab.font}
                                                             context:nil].size.height + 20;
        _desLab.height = height;
        _desLab.hidden = NO;
        model.height = _desLab.bottom;
    } else {
        _desLab.hidden = YES;
        model.height = _desLab.bottom;
    }
    
    
}

@end
