//
//  LookOverHowToUseVC.m
//  QCY
//
//  Created by i7colors on 2018/11/23.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "LookOverHowToUseVC.h"
#import <YYText.h>

@interface LookOverHowToUseVC ()
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation LookOverHowToUseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用说明";
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
    [self.view addSubview:self.scrollView];
    
    NSString *text = @"\n活动详情：\n参与人群：印染行业从业者\n参与方式：通过七彩云官网或者微信公众号报名\n活动与奖励：\n1、 申请：凡是参与七彩云“染者江湖英雄招募”，将授予专属英雄唯一的邀请码。\n2、 使用方式：将英雄邀请码发送给采购商，让他在参与七彩云【团购活动】时，输入你的专属英雄码即可。在团购交易完成后（采购商签订合同且付款成功），七彩云将统计每次团购的英雄码分别属于哪位英雄，将给与对应英雄奖励。\n3、 奖励:  (1)奖励标准为：每推荐一位成功参加七彩云团购者（采购商签订合同且付款成功），奖励此次采购商实际采购额的百分之0.5%。\n举例：\n->张三推荐“某某采购商”参与七彩云团购，\n->“某某采购商” 在参与七彩云【团购活动】时，输入张三的专属英雄码，采购了50万的产品\n->最终团购成功且“某某采购商”签订了合同和付款成功\n->张三将获得50万X 0.005 = 2500￥，2500元奖励\n(2)奖励可累加，推荐越多奖励越多\n(3)最终解释权归七彩云所有。";
    
    YYLabel *textLabel = [[YYLabel alloc] init];
    textLabel.numberOfLines = 0;
    CGFloat fitHeight = [self getMessageHeight:text andLabel:textLabel];
    textLabel.frame = CGRectMake(KFit_W(16), 0, SCREEN_WIDTH - KFit_W(16 * 2), fitHeight);
    [_scrollView addSubview:textLabel];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, fitHeight + Bottom_Height_Dif + 30);
}

//YYLbael计算高度
- (CGFloat)getMessageHeight:(NSString *)mess andLabel:(YYLabel *)label {
    NSMutableAttributedString *mText = [[NSMutableAttributedString alloc] initWithString:mess];
    mText.yy_color = HEXColor(@"#595757", 1);
    mText.yy_font = [UIFont systemFontOfSize:13];
    mText.yy_lineSpacing = 10;
    label.attributedText = mText;
    CGSize introSize = CGSizeMake(SCREEN_WIDTH - KFit_W(16) * 2, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:mText];
    label.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight;
}

@end
