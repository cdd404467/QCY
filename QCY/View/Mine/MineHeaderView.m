//
//  MineHeaderView.m
//  QCY
//
//  Created by i7colors on 2018/10/21.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MineHeaderView.h"
#import "MacroHeader.h"
#import <Masonry.h>
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
    }
    
    userHeader.layer.cornerRadius = KFit_W(58) / 2;
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
    if ([isCompany boolValue] == YES) {
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
    historyLabel.text = @"历史求购：0 | 历史报价：0";
    historyLabel.layer.borderWidth = 1.f;
    historyLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    historyLabel.layer.cornerRadius = 7;
    historyLabel.font = [UIFont systemFontOfSize:11];
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

    //卖家按钮
    NSString *title = @"买家中心";
    UIButton *idBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    idBtn.adjustsImageWhenHighlighted = NO;
    idBtn.titleLabel.numberOfLines = 0;
    idBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [idBtn setImage:[UIImage imageNamed:@"buyer_icon"] forState:UIControlStateNormal];
    idBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [idBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [idBtn setTitle:title forState:UIControlStateNormal];
    
    [bgView addSubview:idBtn];
    idBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
    idBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 7);
    [idBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(vLine.mas_left);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    _idBtn = idBtn;


    //切换按钮
    NSString *sTitle = @"点击切换\n选择您的身份";
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.adjustsImageWhenHighlighted = NO;
    switchBtn.titleLabel.numberOfLines = 0;
    switchBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [switchBtn setImage:[UIImage imageNamed:@"switch_icon"] forState:UIControlStateNormal];

    NSMutableAttributedString *mutableTitle_1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",sTitle]];
    NSMutableParagraphStyle *paragraphStyle_1 = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为4
    [paragraphStyle_1  setLineSpacing:2];
    [mutableTitle_1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle_1 range:NSMakeRange(0, sTitle.length)];
    [mutableTitle_1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,4)];
    //    [mutableTitle addAttribute:NSForegroundColorAttributeName value:HEXColor(@"#818181", 1) range:NSMakeRange(0,4)];
    [mutableTitle_1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(4,7)];
    [mutableTitle_1 addAttribute:NSForegroundColorAttributeName value:HEXColor(@"#868686", 1) range:NSMakeRange(4,7)];
    [switchBtn setAttributedTitle:mutableTitle_1 forState:UIControlStateNormal];
    switchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, KFit_W(7), 0, KFit_W(-7));
    switchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, KFit_W(-7), 0, KFit_W(7));
    [bgView addSubview:switchBtn];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(vLine.mas_right).offset(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    _switchBtn = switchBtn;

    
}

- (void)configData:(NSString *)historyAsk offer:(NSString *)hisOffer {
    
    _historyLabel.text = [NSString stringWithFormat:@"历史求购：%@ | 历史报价：%@",historyAsk,hisOffer];
}

@end
