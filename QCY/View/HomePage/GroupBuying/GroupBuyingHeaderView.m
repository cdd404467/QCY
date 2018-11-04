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


@end

@implementation GroupBuyingHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self addBanner];
    }
    
    return self;
}

- (void)addBanner:(NSArray *)array {
    
//    NSArray *arr = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1240469072,2191573380&fm=26&gp=0.jpg",
//                     @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=889553397,2093664619&fm=26&gp=0.jpg",
//                     @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1397299872,1564665821&fm=26&gp=0.jpg",
//                     @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4225846828,2497659140&fm=11&gp=0.jpg"];
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 144 * Scale_H);
    SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:array];
    bannerView.delegate = self;
    bannerView.autoScrollTimeInterval = 3.f;
    bannerView.pageDotColor = RGBA(0, 0, 0, 0.3);
    bannerView.currentPageDotColor = [UIColor colorWithHexString:@"ee2788"];
    [self addSubview:bannerView];
    _bannerView = bannerView;
}

@end
