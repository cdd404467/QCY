//
//  UpgradeVIPVC.m
//  QCY
//
//  Created by i7colors on 2019/10/21.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "UpgradeVIPVC.h"
#import <UIImageView+WebCache.h>
#import <XHWebImageAutoSize.h>
#import "UIButton+Extension.h"
#import "ClassTool.h"
#import "JudgeTools.h"

@interface UpgradeVIPVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation UpgradeVIPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开放商城会员服务";
    [self setupUI];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = UIColor.whiteColor;
        sv.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
        //150 + 680 + 6
        sv.contentSize = CGSizeMake(SCREEN_WIDTH, sv.height);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, self.scrollView.width, self.scrollView.height);
    [self.scrollView addSubview:imageView];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://static.i7colors.com/VIP.jpg"] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        CGFloat height = SCREEN_WIDTH / image.size.width * image.size.height;
        imageView.height = height;
        if (height > self.scrollView.height) {
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height);
        }
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.userInteractionEnabled = NO;
    [btn setImage:[UIImage imageNamed:@"app_icon_logo"] forState:UIControlStateNormal];
    [btn setTitle:@"服务热线" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitleColor:HEXColor(@"#161E6D", 1) forState:UIControlStateNormal];
    btn.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(SCREEN_WIDTH / 2);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
    }];
    [btn.superview layoutIfNeeded];
    [btn layoutWithEdgeInsetsStyle:ButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn setTitle:@"15201937838" forState:UIControlStateNormal];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.view addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(btn.mas_right);
        make.height.width.bottom.mas_equalTo(btn);
    }];
    [phoneBtn.superview layoutIfNeeded];
    [ClassTool addLayerAutoSize:phoneBtn];
}

- (void)call {
    [JudgeTools callWithPhoneNumber:@"15201937838"];
}

@end
