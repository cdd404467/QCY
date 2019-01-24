//
//  PromotionsHeaderView.m
//  QCY
//
//  Created by i7colors on 2019/1/15.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PromotionsHeaderView.h"
#import "MacroHeader.h"
#import <UIImageView+WebCache.h>


@implementation PromotionsHeaderView {
    UIImageView *_posterImage;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
}

- (void)setBannerArray:(NSArray *)bannerArray {
    _bannerArray = bannerArray;
    
    if (bannerArray && bannerArray.count > 0) {
        [_posterImage sd_setImageWithURL:_bannerArray[0] placeholderImage:PlaceHolderImgBanner];
    }
}

@end
