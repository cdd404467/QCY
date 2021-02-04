//
//  MineHeaderView.m
//  QCY
//
//  Created by i7colors on 2018/10/21.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MineHeaderView.h"
#import <YYText.h>
#import <UIImageView+WebCache.h>
#import "PaddingLabel.h"
#import <SDAutoLayout.h>

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT + 106);
    [self addSubview:topView];
    
    //上方彩色背景
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#f26c27"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#ee2788"].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0.0, 0.3);
    gradientLayer.endPoint = CGPointMake(1.0,0.7);
    gradientLayer.frame = topView.frame;
    [topView.layer addSublayer:gradientLayer];
    
    //头像
    UIImageView *userHeader = [[UIImageView alloc] init];
    
    if (Get_Header) {
        NSURL *headerUrl = Get_Header;
        [userHeader sd_setImageWithURL:headerUrl placeholderImage:nil];
    } else {
        userHeader.image = DefaultImage;
    }
    
    userHeader.layer.cornerRadius = 58 / 2;
    userHeader.clipsToBounds = YES;
    userHeader.backgroundColor = [UIColor whiteColor];
    [topView addSubview:userHeader];
    [userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(58);
        make.bottom.mas_equalTo(-46);
        make.left.mas_equalTo(@(27 * Scale_W));
    }];
    _userHeader = userHeader;
    
    //显示的名字
    NSString *name = [[UserDefault objectForKey:@"userInfo"] objectForKey:@"userName"];
    NSString *userType = [NSString string];
    if (isCompanyUser) {
        userType = @"企业用户";
    } else {
        userType = @"个人用户";
    }

    NSString *nameText = [NSString stringWithFormat:@"%@ | %@",name,userType];
    YYLabel *userName = [[YYLabel alloc] init];
    [topView addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userHeader.mas_right).offset(KFit_W(18));
        make.top.mas_equalTo(userHeader).offset(10);
        make.height.mas_equalTo(16);
    }];
    _userName = userName;
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:nameText];
    mutableText.yy_color = [UIColor whiteColor];
    [mutableText yy_setFont:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, name.length + 2)];
    [mutableText yy_setFont:[UIFont systemFontOfSize:12] range:NSMakeRange(name.length + 2, userType.length)];
    userName.attributedText = mutableText;

    //历史求购数量和报价
    PaddingLabel *historyLabel = [[PaddingLabel alloc] init];
    historyLabel.font = [UIFont systemFontOfSize:12];
    historyLabel.contentEdgeInsets = UIEdgeInsetsMake(1, 6, 1, 6);
    historyLabel.textColor = [UIColor whiteColor];
    [topView addSubview:historyLabel];
    [historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(userHeader.mas_bottom).offset(-10);
        make.left.mas_equalTo(userName);
    }];
    _historyLabel = historyLabel;

    //账号切换
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.shadowColor = RGBA(0, 0, 0, 0.3).CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0, 6);
    bgView.layer.shadowOpacity = 1.0f;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(70);
        make.top.mas_equalTo(topView.mas_bottom).offset(-35);
    }];

    //竖线
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = HEXColor(@"#D5D5D5", 1);
    [bgView addSubview:vLine];
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(bgView);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(1);
    }];

    //买家按钮
    UIButton *buyerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyerBtn.adjustsImageWhenHighlighted = NO;
    buyerBtn.titleLabel.numberOfLines = 0;
    buyerBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [buyerBtn setImage:[UIImage imageNamed:@"buyer_icon"] forState:UIControlStateNormal];
    [buyerBtn setImage:[UIImage imageNamed:@"buyer_icon_select"] forState:UIControlStateSelected];
    [buyerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buyerBtn setTitle:@"买家中心" forState:UIControlStateNormal];
    buyerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    buyerBtn.tag = 100;
    buyerBtn.selected = YES;
    [buyerBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [buyerBtn setTitleColor:HEXColor(@"#ED3851", 1) forState:UIControlStateSelected];
    [bgView addSubview:buyerBtn];
    buyerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
    buyerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 7);
    [buyerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(vLine.mas_left);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    _buyerBtn = buyerBtn;
    //卖家按钮
    UIButton *sellerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sellerBtn.adjustsImageWhenHighlighted = NO;
    sellerBtn.titleLabel.numberOfLines = 0;
    sellerBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [sellerBtn setImage:[UIImage imageNamed:@"seller_icon"] forState:UIControlStateNormal];
    [sellerBtn setImage:[UIImage imageNamed:@"seller_icon_select"] forState:UIControlStateSelected];
    sellerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [sellerBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [sellerBtn setTitleColor:HEXColor(@"#ED3851", 1) forState:UIControlStateSelected];
    [sellerBtn setTitle:@"卖家中心" forState:UIControlStateNormal];
    sellerBtn.tag = 101;
    [bgView addSubview:sellerBtn];
    sellerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
    sellerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 7);
    [sellerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(vLine.mas_right).offset(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    _sellerBtn = sellerBtn;

}

- (void)configData:(NSString *)historyAsk offer:(NSString *)hisOffer {
    
    _historyLabel.text = [NSString stringWithFormat:@"历史求购:%@   历史报价:%@",historyAsk,hisOffer];
}

@end
