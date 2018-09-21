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
#import "HelperTool.h"
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

//创建轮播图, 8 + 144
- (void)addBanner {
    
    NSArray *arr = @[@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1240469072,2191573380&fm=26&gp=0.jpg",
                     @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=889553397,2093664619&fm=26&gp=0.jpg",
                     @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1397299872,1564665821&fm=26&gp=0.jpg",
                     @"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=4225846828,2497659140&fm=11&gp=0.jpg"];
    CGRect frame = CGRectMake(0, 8 * Scale_H, SCREEN_WIDTH, 144 * Scale_H);
    SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:frame imageURLStringsGroup:arr];
    bannerView.delegate = self;
    bannerView.autoScrollTimeInterval = 3.f;
    bannerView.pageDotColor = RGBA(0, 0, 0, 0.3);
    bannerView.currentPageDotColor = [UIColor colorWithHexString:@"ee2788"];
    [self addSubview:bannerView];
    _bannerView = bannerView;
}

//创建轮播图下方的四个图标  90
- (void)addIcons {
    UIView *iconBg = [[UIView alloc] init];
    iconBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:iconBg];
    [iconBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(@0);
        make.top.mas_equalTo(self.bannerView.mas_bottom).offset(0);
        make.height.mas_equalTo(@(90 * Scale_H));
    }];
    
    CGFloat leftGap = KFit_W(13.f);
    CGFloat imageWidth = KFit_W(47.f), imageHeight = KFit_W(47.f);
    CGFloat centerGap = (SCREEN_WIDTH - leftGap * 2 - imageWidth * 4) / 3;
    NSArray *titleArr = @[@"产品大厅",@"求购大厅",@"开放商城",@"产业资讯"];
    for (uint8_t i = 0; i < 4; i ++) {
        //图片
        UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"image%d",i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:iconImage];
        [HelperTool addTapGesture:imageView withTarget:self andSEL:@selector(tapImageView:)];
        imageView.tag = i;
        imageView.frame = CGRectMake(leftGap + i * (centerGap + imageWidth), KFit_H(10), imageWidth, imageHeight);
        [iconBg addSubview:imageView];
        //文字
        UILabel *iconTitle = [[UILabel alloc] init];
        iconTitle.text = titleArr[i];
        iconTitle.font = [UIFont systemFontOfSize:12];
        iconTitle.textColor = [UIColor colorWithHexString:@"#3C3C3C"];
        iconTitle.textAlignment = NSTextAlignmentCenter;
        [iconBg addSubview:iconTitle];
        [iconTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imageView.mas_centerX);
            make.top.mas_equalTo(imageView.mas_bottom).offset(7 * Scale_H);
        }];
    }
}

//点击事件
- (void)tapImageView:(id)sender {
    if (self.tapIconsBlock) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
        UIView *view = (UIView *)tap.view;
        self.tapIconsBlock(view.tag);
    }
}


@end
