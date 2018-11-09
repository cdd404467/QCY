//
//  GroupBuyingHeaderView.m
//  QCY
//
//  Created by i7colors on 2018/11/1.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "GroupBuyingHeaderView.h"
#import "MacroHeader.h"
#import <SDCycleScrollView.h>

@interface GroupBuyingHeaderView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong)SDCycleScrollView *bannerView; //轮播图
@property (nonatomic, copy)NSArray *bannerArray;

@end

@implementation GroupBuyingHeaderView

- (instancetype)initWithArray:(NSArray *)bannerArray {
    self = [super init];
    if (self) {
        _bannerArray = bannerArray;
        [self addBanner];
    }
    return self;
}

- (void)addBanner {
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 144 * Scale_H);
    SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:PlaceHolderImgBanner];
    bannerView.imageURLStringsGroup = _bannerArray;
    bannerView.autoScrollTimeInterval = 3.f;
    bannerView.pageDotColor = RGBA(0, 0, 0, 0.3);
    bannerView.currentPageDotColor = [UIColor colorWithHexString:@"ee2788"];
    [self addSubview:bannerView];
    _bannerView = bannerView;
}

@end
