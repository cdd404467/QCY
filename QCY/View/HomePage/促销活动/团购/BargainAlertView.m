//
//  BargainAlertView.m
//  QCY
//
//  Created by i7colors on 2019/7/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BargainAlertView.h"
#import <YYText.h>
#import "ClassTool.h"
#import "HelperTool.h"

@interface BargainAlertView()
@property (nonatomic, strong) UIView *alertView;
@end

@implementation BargainAlertView

- (instancetype)initWithPrice:(NSString *)price unit:(NSString *)unit {
    if (self = [super init]) {
        [self setupUI:price unit:unit];
    }
    
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.frame = SCREEN_BOUNDS;
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    
    _alertView = [[UIView alloc] initWithFrame:CGRectMake(28, 0, SCREEN_WIDTH - 28 * 2, 260)];
    _alertView.layer.cornerRadius = 20.f;
    _alertView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_alertView];
    _alertView.layer.position = self.center;
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"groupBuy_alert_img"]];
    img.frame = CGRectMake(-20, -64, _alertView.width + 40, 195);
    [_alertView addSubview:img];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"团购下单成功~";
    titleLab.font = [UIFont boldSystemFontOfSize:20];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [_alertView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(80);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *desLab = [[UILabel alloc] init];
    desLab.text = @"立刻分享，好友助力砍价，还能享受比当前团购价更优惠的价格!";
    desLab.font = [UIFont systemFontOfSize:16];
    desLab.textColor = HEXColor(@"#868686", 1);
    desLab.textAlignment = NSTextAlignmentCenter;
    desLab.numberOfLines = 3;
    [_alertView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(10);
        make.height.mas_equalTo(60);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"团购价购买" forState:UIControlStateNormal];
    [button setTitleColor:HEXColor(@"#333333", 1) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.backgroundColor = Like_Color;
    [button addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.alertView.width / 2);
        make.height.mas_equalTo(44);
    }];
    [button layoutIfNeeded];
    [HelperTool setRound:button corner:UIRectCornerBottomLeft radiu:20.f];

    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setTitle:@"分享砍价" forState:UIControlStateNormal];
    [shareButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(button.mas_right).offset(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [shareButton layoutIfNeeded];
    [ClassTool addLayer:shareButton frame:CGRectMake(0, 0, button.width, button.height)];
    [HelperTool setRound:shareButton corner:UIRectCornerBottomRight radiu:20.f];
    
    
    DDWeakSelf;
    _alertView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakself.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
    
}

- (void)setupUI:(NSString *)price unit:(NSString *)unit {
    self.frame = SCREEN_BOUNDS;
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    
    _alertView = [[UIView alloc] initWithFrame:CGRectMake(28, 0, SCREEN_WIDTH - 28 * 2, 260)];
    _alertView.layer.cornerRadius = 20.f;
    _alertView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_alertView];
    _alertView.layer.position = self.center;
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"groupBuy_alert_img"]];
    img.frame = CGRectMake(-20, -64, _alertView.width + 40, 195);
    [_alertView addSubview:img];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"砍价成功";
    titleLab.font = [UIFont boldSystemFontOfSize:20];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [_alertView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(80);
        make.height.mas_equalTo(22);
    }];
    
    UILabel *desLab = [[UILabel alloc] init];
    desLab.text = @"恭喜您，成功帮好友砍掉";
    desLab.font = [UIFont systemFontOfSize:18];
    desLab.textColor = HEXColor(@"#868686", 1);
    desLab.textAlignment = NSTextAlignmentCenter;
    [_alertView addSubview:desLab];
    [desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleLab.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    YYLabel *priceLab = [[YYLabel alloc] init];
    [_alertView addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(desLab.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    NSString *text = [NSString stringWithFormat:@"¥%@元/%@",price,unit];
    NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:text];
    mText.yy_color = HEXColor(@"#ED3851", 1);
    mText.yy_font = [UIFont systemFontOfSize:20];
    mText.yy_alignment = NSTextAlignmentCenter;
    [mText yy_setFont:[UIFont boldSystemFontOfSize:26] range:NSMakeRange(1, price.length)];
    priceLab.attributedText = mText;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确认" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    button.layer.cornerRadius = 22.f;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.height.mas_equalTo(44);
    }];
    [button layoutIfNeeded];
    [ClassTool addLayer:button frame:CGRectMake(0, 0, button.width, button.height)];
    
    DDWeakSelf;
    _alertView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakself.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:nil];
}

- (void)remove {
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        self.alertView.top = SCREEN_HEIGHT + 90;
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

- (void)share {
    [self remove];
    if (self.shareBlock) {
        self.shareBlock();
    }
}

@end
