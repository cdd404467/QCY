//
//  HomePageHeaderView.m
//  QCY
//
//  Created by zz on 2018/9/5.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HomePageHeaderView.h"
#import "HelperTool.h"
#import <SDCycleScrollView.h>
#import "HomePageModel.h"
#import <UIButton+WebCache.h>
#import "UIButton+Extension.h"

@interface HomePageHeaderView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *bannerView; //轮播图
@property (nonatomic, strong) UIView *iconBgView;
@end

@implementation HomePageHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addBanner];
    }
    
    return self;
}

//创建轮播图, 8 + 144
- (void)addBanner {
   
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(144));
//    SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:PlaceHolderImgBanner];
    SDCycleScrollView *bannerView = [[SDCycleScrollView alloc] initWithFrame:frame];
    bannerView.backgroundColor = HEXColor(@"#f3f3f3", 1);
//    bannerView.placeholderImage = PlaceHolderImgBanner;
    bannerView.delegate = self;
    bannerView.autoScrollTimeInterval = 3.f;
    bannerView.pageDotColor = RGBA(0, 0, 0, 0.3);
    bannerView.currentPageDotColor = [UIColor colorWithHexString:@"ee2788"];
    [self addSubview:bannerView];
    _bannerView = bannerView;
    
    UIView *iconBgView = [[UIView alloc] init];
    iconBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:iconBgView];
    [iconBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(@0);
        make.top.mas_equalTo(bannerView.mas_bottom).offset(0);
        make.height.mas_equalTo(65);
    }];
    _iconBgView = iconBgView;
    
    UIView *bottomGap = [[UIView alloc] init];
    bottomGap.backgroundColor = Cell_BGColor;
    [self addSubview:bottomGap];
    [bottomGap mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconBgView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

//创建轮播图下方的N个图标  90
- (void)addIconsWithArray:(NSArray<BannerModel *> *)iconArray {
    NSInteger iconCount = iconArray.count;
    CGFloat imageWidth = KFit_W(60 + (5 - iconCount) * 20), imageHeight = 50;
    CGFloat centerGap = (SCREEN_WIDTH - imageWidth * iconCount) / (iconCount + 1);
    for (uint8_t i = 0; i < iconCount; i ++) {
        BannerModel *model = iconArray[i];
        
        __block UIButton *iconbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconbtn.frame = CGRectMake(centerGap + i * (centerGap + imageWidth), 10, imageWidth, imageHeight);
        [iconbtn setTitle:model.ad_desc forState:UIControlStateNormal];
        iconbtn.titleLabel.font = [UIFont systemFontOfSize:11];
//        [iconbtn sd_setImageWithURL:ImgUrl(model.ad_image) forState:UIControlStateNormal];
        [iconbtn sd_setImageWithURL:ImgUrl(model.ad_image) forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            UIImage *refined = [UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:image.imageOrientation];
            [iconbtn setImage:refined forState:UIControlStateNormal];
            iconbtn.titleEdgeInsets = UIEdgeInsetsMake(iconbtn.imageView.frame.size.height + 4, -iconbtn.imageView.frame.size.width, -4, 0);
            iconbtn.imageEdgeInsets = UIEdgeInsetsMake(-iconbtn.imageView.frame.size.height, 0, 0, -iconbtn.titleLabel.bounds.size.width);
        }];
        
        DDWeakSelf;
        [iconbtn addEventHandler:^{
            [weakself tapBtnWithCodeName:model.ad_name];
        }];
//        iconbtn.tag = i;
//        [iconbtn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
        [iconbtn setTitleColor:HEXColor(@"#3C3C3C", 1) forState:UIControlStateNormal];
//        iconbtn.titleEdgeInsets = UIEdgeInsetsMake(iconbtn.imageView.frame.size.height + 4, -iconbtn.imageView.frame.size.width, -4, 0);
//        iconbtn.imageEdgeInsets = UIEdgeInsetsMake(-iconbtn.imageView.frame.size.height, 0, 0, -iconbtn.titleLabel.bounds.size.width);
        
        //去掉按下时的高亮
        iconbtn.adjustsImageWhenHighlighted = NO;
        [self.iconBgView addSubview:iconbtn];
    }
}

- (void)setBannerArray:(NSArray *)bannerArray {
    _bannerArray = bannerArray;
    NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:0];
    for (BannerModel *model in bannerArray) {
        [imageArr addObject:ImgUrl(model.ad_image)];
    }
    _bannerView.imageURLStringsGroup = imageArr;
}

- (void)setIconArray:(NSArray *)iconArray {
    _iconArray = iconArray;
    [self.iconBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addIconsWithArray:iconArray];
}

//点击事件
- (void)tapBtnWithCodeName:(NSString *)code {
    if (self.tapIconsBlock) {
        self.tapIconsBlock(code);
    }
}

//点击回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    BannerModel *model = self.bannerArray[index];
    if (self.clickBanerBlock)
        self.clickBanerBlock(model);
}

@end
