//
//  CompanyApproveVC.m
//  QCY
//
//  Created by i7colors on 2018/11/19.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "CompanyApproveVC.h"
#import "ClassTool.h"
#import "MacroHeader.h"
#import "HomePageSectionHeader.h"
#import <Masonry.h>
#import <YYText.h>

@interface CompanyApproveVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITextField *companyTF;
@end

@implementation CompanyApproveVC {
    CGFloat _contentHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupUI];
}

- (void)setupNav {
    self.nav.titleLabel.text = @"企业认证";
    [ClassTool addLayer:self.nav frame:self.nav.frame];
    self.nav.titleLabel.textColor = [UIColor whiteColor];
    self.nav.bottomLine.hidden = YES;
    [self.nav.backBtn setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [self.view addSubview:self.nav];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
        //150 + 680 + 6
        sv.contentSize = CGSizeMake(SCREEN_WIDTH, 600);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    HomePageSectionHeader *header1 = [[HomePageSectionHeader alloc] init];
    header1.titleLabel.text = @"账户信息";
    header1.moreLabel.hidden = YES;
    header1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    [self.scrollView addSubview:header1];
    _contentHeight = 40;
    
    //提示
    YYLabel *tipLabel = [[YYLabel alloc] init];
    NSString *text = @"【说明】：申请的企业账号将会自动生产一个全新的账号，此账户的 登录名为企业名称，使用企业认证账户登录后，将可以使用商城 的全部功能";
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGFloat fitHeight = [self getMessageHeight:text andLabel:tipLabel];
    tipLabel.frame = CGRectMake(KFit_W(8), _contentHeight + 12, SCREEN_WIDTH - KFit_W(8) * 2, fitHeight + 20);
    _contentHeight = 12 + fitHeight + 12 + _contentHeight;
    [self.scrollView addSubview:tipLabel];
    tipLabel.layer.borderWidth = 1.f;
    tipLabel.layer.borderColor = HEXColor(@"#ED3851", 1).CGColor;
    tipLabel.layer.cornerRadius = 8.f;
    
    //for循环创建
    NSArray *titleArr = @[@"企业名称:",@"登录密码:",@"确认密码", @"企业地址:",@"",@"企业类型:",@"指定联系人:",@"指定手机号:"];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArr[i];
        titleLabel.textColor = HEXColor(@"#3C3C3C", 1);
        titleLabel.font = [UIFont systemFontOfSize:12];
        //        titleLabel.frame = CGRectMake(18, 20 * (i + 1) + 32 * i + 9, KFit_W(80), 14);
        [_scrollView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(tipLabel.mas_bottom).offset(12 + (32 + 20) * i);
            make.width.mas_equalTo(KFit_W(80));
            make.height.mas_equalTo(32);
        }];
        
        if (i != 4) {
            UIImageView *tabIcon = [[UIImageView alloc] init];
            tabIcon.image = [UIImage imageNamed:@"tab_icon"];
            [_scrollView addSubview:tabIcon];
            [tabIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(titleLabel);
                make.right.mas_equalTo(titleLabel.mas_left).offset(-5);
                make.width.height.mas_equalTo(4);
            }];
        }
        
        //每次创建总高度增加
        _contentHeight = _contentHeight + 52;
    }
    _contentHeight = _contentHeight + 30;
    UIView *gapView = [[UIView alloc] init];
    gapView.frame = CGRectMake(0, _contentHeight, SCREEN_WIDTH, 12);
    gapView.backgroundColor = Cell_BGColor;
    [_scrollView addSubview:gapView];
    
    //公司名称
    UITextField *companyTF = [[UITextField alloc] init];
    [_scrollView addSubview:companyTF];
    [companyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    _companyTF = companyTF;
    [self setTextField:_companyTF];
}

//YYLbael计算高度
- (CGFloat)getMessageHeight:(NSString *)mess andLabel:(YYLabel *)label {
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:mess];
    introText.yy_font = [UIFont systemFontOfSize:12];
    introText.yy_lineSpacing = 7;
    introText.yy_color = HEXColor(@"#ED3851", 1);
    introText.yy_firstLineHeadIndent = 10.f;
    introText.yy_headIndent = 5.f;
    introText.yy_tailIndent = -5.f;
    introText.yy_alignment = NSTextAlignmentLeft;
    CGSize introSize = CGSizeMake(SCREEN_WIDTH - KFit_W(8) * 2, CGFLOAT_MAX);
    label.attributedText = introText;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:introText];
    label.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight;
}


//设置textfield
- (void)setTextField:(UITextField *)tf {
    
    tf.textColor = HEXColor(@"#1E2226", 1);
    tf.layer.borderWidth = 1.f;
    tf.backgroundColor = HEXColor(@"#E8E8E8", 1);
    tf.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    //添加leftView
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 30)];
    leftView.contentMode = UIViewContentModeCenter;
    tf.leftView = leftView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    //placeholder颜色
    [tf setValue:HEXColor(@"#C8C8C8", 1) forKeyPath:@"_placeholderLabel.textColor"];
    tf.delegate = self;
    tf.font = [UIFont systemFontOfSize:14];
}

@end
