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
   
    CGRect frame = CGRectMake(0, 8 * Scale_H, SCREEN_WIDTH, 144 * Scale_H);
//    SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:PlaceHolderImgBanner];
    SDCycleScrollView *bannerView = [[SDCycleScrollView alloc] initWithFrame:frame];
    bannerView.placeholderImage = PlaceHolderImgBanner;
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
        make.height.mas_equalTo(@(65 * Scale_H));
    }];
    
    CGFloat leftGap = KFit_W(8.f);
    CGFloat imageWidth = KFit_W(60.f), imageHeight = KFit_H(50.f);
    CGFloat centerGap = (SCREEN_WIDTH - leftGap * 2 - imageWidth * 4) / 3;
    NSArray *titleArr = @[@"产品大厅",@"求购大厅",@"开放商城",@"产业资讯"];
    
    for (uint8_t i = 0; i < 4; i ++) {
        UIButton *iconbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconbtn.frame = CGRectMake(leftGap + i * (centerGap + imageWidth), KFit_H(10), imageWidth, imageHeight);
        [iconbtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"image%d",i]] forState:UIControlStateNormal];
        [iconbtn setTitle:titleArr[i] forState:UIControlStateNormal];
        iconbtn.tag = i;
        [iconbtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
        iconbtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [iconbtn setTitleColor:HEXColor(@"#3C3C3C", 1) forState:UIControlStateNormal];
        iconbtn.titleEdgeInsets = UIEdgeInsetsMake(iconbtn.imageView.frame.size.height + KFit_H(4), -iconbtn.imageView.frame.size.width, KFit_H(-4), 0);
        iconbtn.imageEdgeInsets = UIEdgeInsetsMake(-iconbtn.imageView.frame.size.height, 0, 0, -iconbtn.titleLabel.bounds.size.width);
        //去掉按下时的高亮
        iconbtn.adjustsImageWhenHighlighted = NO;
        [iconBg addSubview:iconbtn];
    }
}

- (void)setBannerArray:(NSArray *)bannerArray {
    _bannerArray = bannerArray;
    _bannerView.imageURLStringsGroup = bannerArray;
}


//点击事件
- (void)tapBtn:(UIButton *)sender {
    if (self.tapIconsBlock) {
//        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
//        UIView *view = (UIView *)tap.view;
        self.tapIconsBlock(sender.tag);
    }
}


@end
