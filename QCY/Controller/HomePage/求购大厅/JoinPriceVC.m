//
//  JoinPriceVC.m
//  QCY
//
//  Created by i7colors on 2018/10/17.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "JoinPriceVC.h"
#import "MacroHeader.h"
#import "PaddingLabel.h"
#import <YYText.h>
#import <Masonry.h>
#import <SDAutoLayout.h>
#import "UITextView+Placeholder.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import <BRPickerView.h>
#import "HelperTool.h"
#import "TimeAbout.h"
#import "CddHUD.h"
#import "UITextField+Limit.h"


@interface JoinPriceVC ()

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIButton *selectedBtn; //选中按钮
@property (nonatomic, strong)UITextField *companyTF;
@property (nonatomic, strong)UITextField *priceTF;
@property (nonatomic, strong)UITextField *contactTF;
@property (nonatomic, strong)PaddingLabel *timeEffective;
@property (nonatomic, strong)UITextView *expTextView;
@end

@implementation JoinPriceVC {
    NSInteger currentSelectBtnTag;  //记录是否的tag
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"参与报价";
    currentSelectBtnTag = 0;
    [self.view addSubview:self.scrollView];
    [self setupUI];
    [self addGes];
}

- (void)touchesBegan {
    [self.view endEditing:YES];
}

- (void)addGes {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesBegan)];
    gesture.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:gesture];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
        //150 + 680 + 6
        sv.contentSize = CGSizeMake(SCREEN_WIDTH, 600);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.bounces = NO;
        _scrollView = sv;
    }

    return _scrollView;
}

#pragma mark - 发布报价
- (void)joinOffer {
    if ([self judgeData] == NO) {
        return ;
    };
    DDWeakSelf;
    NSString *tagStr = [NSString stringWithFormat:@"%zd",currentSelectBtnTag];
    NSDictionary *dict = @{@"token":GET_USER_TOKEN,
                           @"enquiryId":_productID,             //求购id
                           @"price":_priceTF.text,              //报价
                           @"priceUnit":@"KG",                  //价格单位KG
                           @"isIncludeTrans":tagStr,            //是否包含运费
                           @"phone":_contactTF.text,            //手机号
                           @"validTime":_timeEffective.text,    //有效期至
                           @"description":_expTextView.text     //报价描述
                           };
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    //公司名称（个人报价时必填），企业用户不需要
    NSString *companyName = [NSString string];
    if ([isCompany boolValue] == NO) {
        companyName = _companyTF.text;
    } else {
        companyName = @"";
    }
    [mDict setObject:companyName forKey:@"companyName2"];
    
    [CddHUD show];
    [ClassTool postRequest:URL_JOIN_OFFER Params:mDict Success:^(id json) {
        
        [CddHUD hideHUD];
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            BOOL isSuc = [json[@"data"] boolValue];
            if (isSuc == YES) {
                [CddHUD showTextOnlyDelay:@"发布报价成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself refresh];
                });
            } else if (isSuc == NO){
                
            }
        }
    } Failure:^(NSError *error) {
        
    }];
}

//设置有效时间
- (void)setEffctiveTime {
    DDWeakSelf;
    //开始日期
    NSDate *minDate = [NSDate date];
    //最大日期
    NSDate *maxDate = [TimeAbout getNDay:30];
//    NSDate *maxDate = [NSDate br_setYear:2030 month:1 day:1];
    [BRDatePickerView showDatePickerWithTitle:@"选择有效日期" dateType:BRDatePickerModeYMD defaultSelValue:[TimeAbout stringFromDate:minDate] minDate:minDate maxDate:maxDate isAutoSelect:NO themeColor:MainColor resultBlock:^(NSString *selectValue) {
        weakself.timeEffective.text = selectValue;
    }];
}

//通知刷新
- (void)refresh {
    if (self.refreshDataBlock) {
        self.refreshDataBlock();
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)judgeData {
    if ([isCompany boolValue] == NO && _companyTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入公司名称"];
        return NO;
    } else if (_contactTF.text.length != 11) {
        [CddHUD showTextOnlyDelay:@"请输入正确手机号"];
        return NO;
    } else if (_priceTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入价格"];
        return NO;
    } else if (_timeEffective.text.length < 5) {
        [CddHUD showTextOnlyDelay:@"请选择有效时间"];
        return NO;
    }
    
    return YES;
}

- (void)setupUI {
    
    CGFloat newCoordinateHeight ;
    //提示
    YYLabel *tipLabel = [[YYLabel alloc] init];
    NSString *text = @"【提醒】报价将会第一时间通过短信的方式告知求购方，您的报价被接受后系统将生成后续的交易订单，帮助你完成该笔交易。";
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGFloat fitHeight = [self getMessageHeight:text andLabel:tipLabel];
    tipLabel.frame = CGRectMake(KFit_W(8), 10, SCREEN_WIDTH - KFit_W(8) * 2, fitHeight + 20);
    newCoordinateHeight = 10 + fitHeight + 20;
    [self.scrollView addSubview:tipLabel];
    tipLabel.layer.borderWidth = 1.f;
    tipLabel.layer.borderColor = HEXColor(@"#ED3851", 1).CGColor;
    tipLabel.layer.cornerRadius = 8.f;
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"分散染料 七彩云 分散红FB 200%";
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = HEXColor(@"#1E2226", 1);
    [_scrollView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(12);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(14);
        make.centerX.mas_equalTo(self.scrollView);
    }];

    //for循环创建
    NSArray *titleArr = @[@"报价方:",@"联系电话:",@"价格:", @"价格单位",@"是否包含运费:",@"有效时间:"];
    for (NSInteger i = 0; i < 6; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArr[i];
        titleLabel.textColor = HEXColor(@"#3C3C3C", 1);
        titleLabel.font = [UIFont systemFontOfSize:12];
//        titleLabel.frame = CGRectMake(18, 20 * (i + 1) + 32 * i + 9, KFit_W(80), 14);
        [_scrollView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(16 * (i + 1) + 20 * i + 12);
            make.width.mas_equalTo(KFit_W(80));
            make.height.mas_equalTo(12);
        }];

        UIImageView *tabIcon = [[UIImageView alloc] init];
        tabIcon.image = [UIImage imageNamed:@"tab_icon"];
        [_scrollView addSubview:tabIcon];
        [tabIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(titleLabel);
            make.right.mas_equalTo(titleLabel.mas_left).offset(-5);
            make.width.height.mas_equalTo(4);
        }];
    }

    //公司名称
    UIView *companyBgView = [[UILabel alloc] init];
    companyBgView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:companyBgView];
    [companyBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(KFit_W(120));
        make.right.mas_equalTo(self.view.mas_right).offset(KFit_W(-15));
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(16 + 8);
    }];
    //判断是否是企业用户来显示不同的ui
    if ([isCompany boolValue]) {
        UILabel *companyNameLabel = [[UILabel alloc] init];
        companyNameLabel.font = [UIFont systemFontOfSize:12];
        companyNameLabel.textColor = HEXColor(@"#1E2226", 1);
        companyNameLabel.text = Get_CompanyName;
        [_scrollView addSubview:companyNameLabel];
        [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(companyBgView);
        }];
    } else {
        UITextField *companyTF = [[UITextField alloc] init];
        companyTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
        companyTF.font = [UIFont systemFontOfSize:12];
        companyTF.textColor = HEXColor(@"#1E2226", 1);
        companyTF.layer.borderWidth = 1.f;
        companyTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
        [_scrollView addSubview:companyTF];
        [companyTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(companyBgView);
        }];
        _companyTF = companyTF;
    }
    
    //联系电话
    UITextField *contactTF = [[UITextField alloc] init];
    contactTF.keyboardType = UIKeyboardTypeNumberPad;
    contactTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
    contactTF.font = [UIFont systemFontOfSize:12];
    contactTF.textColor = HEXColor(@"#1E2226", 1);
    contactTF.layer.borderWidth = 1.f;
    contactTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [_scrollView addSubview:contactTF];
    [contactTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(companyBgView);
        make.top.mas_equalTo(companyBgView.mas_bottom).offset(16);
    }];
    //限制字数
    [contactTF lengthLimit:^{
        if (contactTF.text.length > 11) {
            contactTF.text = [contactTF.text substringToIndex:11];
        }
    }];
    _contactTF = contactTF;

    //价格
    UITextField *priceTF = [[UITextField alloc] init];
    priceTF.keyboardType = UIKeyboardTypeNumberPad;
    priceTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
    priceTF.font = [UIFont systemFontOfSize:12];
    priceTF.textColor = HEXColor(@"#1E2226", 1);
    priceTF.layer.borderWidth = 1.f;
    priceTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [_scrollView addSubview:priceTF];
    [priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(companyBgView);
        make.top.mas_equalTo(contactTF.mas_bottom).offset(16);
    }];
    _priceTF = priceTF;

    //单位
    UILabel *priceUnit = [[UILabel alloc] init];
    priceUnit.text = @"KG";
    priceUnit.textColor = HEXColor(@"#1E2226", 1);
    priceUnit.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:priceUnit];
    [priceUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(companyBgView);
        make.top.mas_equalTo(priceTF.mas_bottom).offset(16);
    }];

    //是否包含运费
    UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yesBtn.tag = 1;
    [yesBtn setTitle:@"是" forState:UIControlStateNormal];
    yesBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [yesBtn setTitleColor:HEXColor(@"#1E2226", 1) forState:UIControlStateNormal];
    [yesBtn setImage:[UIImage imageNamed:@"btn_unselected"] forState:UIControlStateNormal];
    [yesBtn setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
    yesBtn.adjustsImageWhenHighlighted = NO;
    [yesBtn addTarget:self action:@selector(btnClickSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:yesBtn];
    //默认选中
//    yesBtn.selected = YES;
//    self.selectedBtn = yesBtn;
//    currentSelectBtnTag = yesBtn.tag;

    yesBtn.sd_layout
    .leftEqualToView(companyBgView)
    .widthIs(45)
    .heightIs(20)
    .topSpaceToView(priceUnit, 16);

    yesBtn.imageView.sd_layout
    .leftSpaceToView(yesBtn, 0)
    .centerYEqualToView(yesBtn)
    .widthIs(15)
    .heightIs(15);

    yesBtn.titleLabel.sd_layout
    .rightSpaceToView(yesBtn, 0)
    .centerYEqualToView(yesBtn)
    .widthIs(15)
    .heightIs(15);
//
    //否
    UIButton *noBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    noBtn.tag = 0;
    [noBtn setTitle:@"否" forState:UIControlStateNormal];
    noBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [noBtn setTitleColor:HEXColor(@"#1E2226", 1) forState:UIControlStateNormal];
    [noBtn setImage:[UIImage imageNamed:@"btn_unselected"] forState:UIControlStateNormal];
    [noBtn setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
    noBtn.adjustsImageWhenHighlighted = NO;
    [noBtn addTarget:self action:@selector(btnClickSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:noBtn];

    //默认选否
    noBtn.selected = YES;
    self.selectedBtn = noBtn;
    currentSelectBtnTag = noBtn.tag;
    
    noBtn.sd_layout
    .leftSpaceToView(yesBtn, 21)
    .widthIs(45)
    .heightIs(20)
    .topEqualToView(yesBtn);

    noBtn.imageView.sd_layout
    .leftSpaceToView(noBtn, 0)
    .centerYEqualToView(noBtn)
    .widthIs(15)
    .heightIs(15);

    noBtn.titleLabel.sd_layout
    .rightSpaceToView(noBtn, 0)
    .centerYEqualToView(noBtn)
    .widthIs(15)
    .heightIs(15);

    //有效时间
    PaddingLabel *timeEffective = [[PaddingLabel alloc] init];
    timeEffective.leftEdge = 15;
    [HelperTool addTapGesture:timeEffective withTarget:self andSEL:@selector(setEffctiveTime)];
//    timeEffective.text = @"2018-09-17";
    timeEffective.font = [UIFont systemFontOfSize:12];
    timeEffective.textColor = HEXColor(@"#1E2226", 1);
    timeEffective.backgroundColor = HEXColor(@"#E8E8E8", 1);
    timeEffective.layer.borderWidth = 1.f;
    timeEffective.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [_scrollView addSubview:timeEffective];
    [timeEffective mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(companyBgView);
        make.top.mas_equalTo(yesBtn.mas_bottom).offset(16);
    }];
    _timeEffective = timeEffective;

    //报价说明
    UILabel *explainPrice = [[UILabel alloc] init];
    explainPrice.text = @"报价说明";
    explainPrice.font = [UIFont systemFontOfSize:15];
    explainPrice.textColor = HEXColor(@"#1E2226", 1);
    explainPrice.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:explainPrice];

    [explainPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(16);
        make.top.mas_equalTo(timeEffective).offset(47);
        make.centerX.mas_equalTo(self.view);
    }];

    //textView
    //详细说明
    UITextView *expTextView = [[UITextView alloc] init];
    expTextView.backgroundColor = HEXColor(@"#E8E8E8", 1);
    expTextView.placeholder = @"50字以内...";
    expTextView.placeholderColor = HEXColor(@"#868686", 1);
    expTextView.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:expTextView];
    [expTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(KFit_W(20));
        make.right.mas_equalTo(self.view.mas_right).offset(KFit_W(-20));
        make.height.mas_equalTo(208);
        make.top.mas_equalTo(explainPrice.mas_bottom).offset(7);
    }];
    _expTextView = expTextView;

    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交报价" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(joinOffer) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ClassTool addLayer:submitBtn];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
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
    introText.yy_alignment = NSTextAlignmentCenter;
    CGSize introSize = CGSizeMake(SCREEN_WIDTH - KFit_W(8) * 2, CGFLOAT_MAX);
    label.attributedText = introText;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:introText];
    label.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight;
}

//判断选择的按钮
- (void)btnClickSelected:(UIButton *)sender {
    //其他按钮
    self.selectedBtn.selected = NO;
//    self.selectedBtn.backgroundColor = RGBA(245, 244, 244, 1);
//    self.selectedBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    //当前选中按钮
    //如果按下的按钮是之前已经按下的，并且是高亮状态，设置背景变灰色
    if (sender == self.selectedBtn ) {
//        sender.backgroundColor = [UIColor whiteColor];
//        sender.layer.borderColor = RGBA(84, 204, 84, 1).CGColor;
        sender.selected = YES;
    } else {
        sender.selected = !sender.selected;
//        sender.backgroundColor = [UIColor whiteColor];
//        sender.layer.borderColor = RGBA(84, 204, 84, 1).CGColor;
        currentSelectBtnTag = sender.tag;
    }
    
    self.selectedBtn = sender;
}

@end
