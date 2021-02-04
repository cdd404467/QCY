//
//  ADAlertView.m
//  QCY
//
//  Created by i7colors on 2019/10/29.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ADAlertView.h"
#import <UIImageView+WebCache.h>
#import "UIButton+Extension.h"

static CGFloat aniTime = 0.4f;

@implementation ADAlertView

- (instancetype)initWithURL:(NSString *)url handler:(void (^ __nullable)(void))handler {
    if (self = [super init]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        [self setupUI:url handler:handler];
    }
    
    return self;
}


- (void)setupUI:(NSString *)url handler:(void (^ __nullable)(void))handler {
    self.frame = SCREEN_BOUNDS;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = UIColor.clearColor;
    [self addSubview:bgView];
    
    CGFloat scale_screen = 0.84;
    CGFloat scale_width = 1.2;
    CGFloat width = SCREEN_WIDTH * scale_screen;
    CGFloat height = width * scale_width;
    DDWeakSelf;
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView addEventHandler:^{
        [weakself remove];
        if (handler) {
            handler();
        }
    }];
//    [imageView sd_setImageWithURL:ImgUrl(url) placeholderImage:PlaceHolderImg];
    [imageView sd_setImageWithURL:ImgUrl(url)];
//    imageView.frame = CGRectMake((SCREEN_WIDTH - width) / 2, 0, width, height);
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.center.mas_equalTo(bgView);
    }];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.adjustsImageWhenHighlighted = NO;
    [closeBtn setImage:[UIImage imageNamed:@"alert_close"] forState:UIControlStateNormal];
    [bgView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerX.mas_equalTo(imageView);
        make.top.mas_equalTo(imageView.mas_bottom).offset(20);
    }];
    [closeBtn addEventHandler:^{
        [weakself remove];
    }];
    
    [UIView animateWithDuration:aniTime animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
        bgView.center = self.center;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIApplication.sharedApplication.keyWindow addSubview:self];
}

+ (ADAlertView *)showWithURL:(NSString *)url handler:(void (^ __nullable)(void))handler {
    ADAlertView *view = [[ADAlertView alloc] initWithURL:url handler:handler];
    return view;
}

- (void)remove {
    [UIView animateWithDuration:aniTime animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
