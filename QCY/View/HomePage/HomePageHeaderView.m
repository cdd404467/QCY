//
//  HomePageHeaderView.m
//  QCY
//
//  Created by zz on 2018/9/5.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HomePageHeaderView.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import <SDCycleScrollView.h>

@interface HomePageHeaderView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong)SDCycleScrollView *bannerView; //轮播图

@end

@implementation HomePageHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addBanner];
        [self addIcons];
    }
    
    return self;
}

//创建轮播图
- (void)addBanner {
    
    NSArray *arr = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1240469072,2191573380&fm=26&gp=0.jpg",
                     @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=889553397,2093664619&fm=26&gp=0.jpg",
                     @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1397299872,1564665821&fm=26&gp=0.jpg",
                     @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4225846828,2497659140&fm=11&gp=0.jpg"];
    CGRect frame = CGRectMake(0, 20 * Scale_H, SCREEN_WIDTH, 165 * Scale_H);
    SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:arr];
    bannerView.delegate = self;
    bannerView.autoScrollTimeInterval = 3.f;
//    bannerView.pageDotColor = RGBA(84, 204, 84, 0.2);
//    bannerView.currentPageDotColor = MAIN_COLOR;
    [self addSubview:bannerView];
    _bannerView = bannerView;
}

//创建轮播图下方的四个图标
- (void)addIcons {
    UIView *iconBg = [[UIView alloc] init];
    [self addSubview:iconBg];
    [iconBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(@0);
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(0);
        make.height.mas_equalTo(@(70 * Scale_H));
    }];
    
    CGFloat leftGap = KFit_W(35.f), centerGap = KFit_W(25.f);
    CGFloat imageWidth = (SCREEN_WIDTH - leftGap * 2 - centerGap * 3) / 4, imageHeight = KFit_H(50.f);
    NSArray *titleArr = @[@"产品大厅",@"求购大厅",@"开放商城",@"产业资讯"];
    for (uint8_t i = 0; i < 4; i ++) {
        //图片
        UIImage *iconImage = [UIImage imageNamed:@"icon1-1"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:iconImage];
        imageView.frame = CGRectMake(leftGap + i * (centerGap + imageWidth), KFit_H(10), imageWidth, imageHeight);
        [iconBg addSubview:imageView];
        //文字
        UILabel *iconTitle = [[UILabel alloc] init];
        iconTitle.text = titleArr[i];
        iconTitle.font = [UIFont systemFontOfSize:KFit_H(13)];
        iconTitle.textColor = [UIColor blackColor];
        iconTitle.textAlignment = NSTextAlignmentCenter;
        iconTitle.frame = CGRectMake(0, 0, imageWidth, imageHeight);
        [imageView addSubview:iconTitle];
    }
}

@end
