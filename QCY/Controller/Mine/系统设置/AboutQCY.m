//
//  AboutQCY.m
//  QCY
//
//  Created by i7colors on 2018/11/20.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AboutQCY.h"
#import <YYText.h>
#import "NavControllerSet.h"

@interface AboutQCY ()
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation AboutQCY

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于七彩云";
    [self vhl_setNavBarBackgroundColor:HEXColor(@"#DDA0DD", 1)];
    [self vhl_setNavBarShadowImageHidden:YES];
    [self vhl_setNavBarTitleColor:UIColor.whiteColor];
    self.backBtnTintColor = UIColor.whiteColor;
    [self setupUI];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

- (void)setupUI {
    CGFloat contentHeight;
    [self.view addSubview:self.scrollView];
    
    UIImageView *topImage = [[UIImageView alloc] init];
    topImage.image = [UIImage imageNamed:@"top_image"];
    topImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, KFit_W(220));
    [_scrollView addSubview:topImage];
    
    UIView *imgBg = [[UIView alloc] init];
    imgBg.backgroundColor = [UIColor whiteColor];
    imgBg.layer.shadowColor = RGBA(0, 0, 0, 0.3).CGColor;
    imgBg.layer.shadowOffset = CGSizeMake(0, 4);
    imgBg.layer.shadowOpacity = 1.0f;
    imgBg.layer.cornerRadius = 5;
    [_scrollView addSubview:imgBg];
    [imgBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(KFit_W(16));
        make.right.mas_equalTo(self.view).offset(KFit_W(-16));
        make.height.mas_equalTo(KFit_W(110));
        make.centerY.mas_equalTo(topImage.mas_bottom);
    }];
    
    UIImageView *img_1 = [[UIImageView alloc] init];
    img_1.image = [UIImage imageNamed:@"setting_img1"];
    [imgBg addSubview:img_1];
    [img_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(14));
        make.right.mas_equalTo(KFit_W(-14));
        make.height.mas_equalTo(KFit_W(60));
        make.centerY.mas_equalTo(imgBg);
    }];
    
    NSString *text_1 = @"      上海七彩云电子商务有限公司成立于2015年5月，由中国印染行业协会和中国染料工业协会共同发起成立，旨在整合国内外纺织印染和染料化工行业的优势资源，借助互联网力量和创新思维模式，推动合作伙伴更有效率地进行商业活动，降低产品流通成本，实现企业自身价值增长乃至跨越式发展；优化行业经营环境，促进纺织印染和染料化工行业健康发展和产业升级。";
    YYLabel *textLabel_1 = [[YYLabel alloc] init];
    textLabel_1.numberOfLines = 0;
    CGFloat fitHeight = [self getMessageHeight:text_1 andLabel:textLabel_1];
    textLabel_1.frame = CGRectMake(KFit_W(16), KFit_W(220 + 55) + 30, SCREEN_WIDTH - KFit_W(16 * 2), fitHeight);
    [_scrollView addSubview:textLabel_1];
    contentHeight = KFit_W(222 + 55) + 30 + fitHeight + 30;
    
    UIImageView *img_2 = [[UIImageView alloc] init];
    img_2.image = [UIImage imageNamed:@"setting_img2"];
    img_2.frame = CGRectMake(KFit_W(16), contentHeight, SCREEN_WIDTH - KFit_W(16 * 2), KFit_W(64));
    [_scrollView addSubview:img_2];
    contentHeight = contentHeight + KFit_W(64) + 30;
    
    NSString *text_2 = @"      七彩云染化电商目前拥有国内外220000+个行业会员、1500+家认证企业用户，在线销售染料、助剂、化学品，为印染企业提供一站式染整解决方案。七彩云染化电商通过网站、微信、小程序、APP等多种形式，支持供应商与客户的互动，为染化企业搭建一个高效率、低成本、广覆盖的互联网营销渠道。\n\n      七彩云染化电商平台是一家开放的多边的共赢的第三方垂直电商平台，于2016年4月13日正式上线运营，平台由B2B交易、产业信息、职业培训三大板块组成，平台交易产品主要包括染料、助剂和化学品。平台专注服务于印染企业，平台通过提供信息、提供市场、提供工具、提供内容管理等为平台各方创造价值。";
    YYLabel *textLabel_2 = [[YYLabel alloc] init];
    textLabel_2.numberOfLines = 0;
    CGFloat fitHeight_2 = [self getMessageHeight:text_2 andLabel:textLabel_2];
    textLabel_2.frame = CGRectMake(KFit_W(16), contentHeight, SCREEN_WIDTH - KFit_W(16 * 2), fitHeight_2);
    [_scrollView addSubview:textLabel_2];
    contentHeight = contentHeight + fitHeight_2 + 30;
    
    UIImageView *img_3 = [[UIImageView alloc] init];
    img_3.image = [UIImage imageNamed:@"setting_img3"];
    img_3.frame = CGRectMake(KFit_W(56), contentHeight, SCREEN_WIDTH - KFit_W(56 * 2), KFit_W(140));
    [_scrollView addSubview:img_3];
    contentHeight = contentHeight + KFit_W(140) + 50;
    
    UIImageView *img_4 = [[UIImageView alloc] init];
    img_4.image = [UIImage imageNamed:@"setting_img4"];
    img_4.frame = CGRectMake(KFit_W(25), contentHeight, SCREEN_WIDTH - KFit_W(25 * 2), KFit_W(183));
    [_scrollView addSubview:img_4];
    contentHeight = contentHeight + KFit_W(183) + 50;
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight + Bottom_Height_Dif);
}

//YYLbael计算高度
- (CGFloat)getMessageHeight:(NSString *)mess andLabel:(YYLabel *)label {
    NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:mess];
    mText.yy_color = HEXColor(@"#595757", 1);
    mText.yy_font = [UIFont systemFontOfSize:12];
    mText.yy_lineSpacing = 20;
    label.attributedText = mText;
    CGSize introSize = CGSizeMake(SCREEN_WIDTH - KFit_W(16) * 2, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:mText];
    label.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight;
}


@end
