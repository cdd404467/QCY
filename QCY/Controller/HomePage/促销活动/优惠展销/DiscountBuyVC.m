//
//  DiscountBuyVC.m
//  QCY
//
//  Created by i7colors on 2019/1/18.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "DiscountBuyVC.h"
#import "CommonNav.h"
#import "MacroHeader.h"
#import <YYText.h>
#import <Masonry.h>
#import "SelectedView.h"
#import <SDAutoLayout.h>
#import "HelperTool.h"
#import "ClassTool.h"
#import "UITextView+Placeholder.h"
#import <BRPickerView.h>
#import "CddHUD.h"
#import "MobilePhone.h"
#import "NetWorkingPort.h"

@interface DiscountBuyVC ()<UITextFieldDelegate>
@property (nonatomic, strong)CommonNav *nav;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITextField *buyTF;
@property (nonatomic, strong)UITextField *contactTF;
@property (nonatomic, strong)UITextField *phoneTF;
@property (nonatomic, strong)UITextField *companyTF;
@property (nonatomic, strong)UIButton *selectedBtn; //选中按钮
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)SelectedView *placeArea;
@end

@implementation DiscountBuyVC {
    NSInteger currentSelectBtnTag;  //记录是否的tag
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self.view addSubview:self.nav];
    [self.view addSubview:self.scrollView];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
        //150 + 680 + 6
        sv.contentSize = CGSizeMake(SCREEN_WIDTH, 600);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

- (CommonNav *)nav {
    if (!_nav) {
        _nav = [[CommonNav alloc] init];
        _nav.titleLabel.text = @"展销详情";
        //        _nav.bottomLine.hidden = YES;
        //        _nav.titleLabel.textColor = RGBA(0, 0, 0, 0);
        [_nav.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _nav;
}

- (void)setupUI {
    CGFloat newCoordinateHeight ;
    //提示
    YYLabel *tipLabel = [[YYLabel alloc] init];
    NSString *text = @"购买提交后，1个工作日内，平台将会电话确认。确认最终交易细 节，引导双方签署协议履行合同！";
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGFloat fitHeight = [self getMessageHeight:text andLabel:tipLabel];
    tipLabel.frame = CGRectMake(KFit_W(8), 10, SCREEN_WIDTH - KFit_W(8) * 2, fitHeight + 20);
    newCoordinateHeight = 10 + fitHeight + 20;
    [self.scrollView addSubview:tipLabel];
    tipLabel.layer.borderWidth = 1.f;
    tipLabel.layer.borderColor = HEXColor(@"#ED3851", 1).CGColor;
    tipLabel.layer.cornerRadius = 8.f;
    
    //for循环创建
    NSArray *titleArr = @[@"我的购买量:",@"是否需要样品:",@"联系人:",@"联系人方式:", @"公司名称",@"公司所属区域:",@"公司详细地址:"];
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArr[i];
        titleLabel.textColor = HEXColor(@"#3C3C3C", 1);
        titleLabel.font = [UIFont systemFontOfSize:12];
        //        titleLabel.frame = CGRectMake(18, 20 * (i + 1) + 32 * i + 9, KFit_W(80), 14);
        [_scrollView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(tipLabel.mas_bottom).offset(20 * (i + 1) + 32 * i);
            make.width.mas_equalTo(KFit_W(80));
            make.height.mas_equalTo(32);
        }];
        
        if (i != titleArr.count - 1) {
            UIImageView *tabIcon = [[UIImageView alloc] init];
            tabIcon.image = [UIImage imageNamed:@"tab_icon"];
            [_scrollView addSubview:tabIcon];
            [tabIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(titleLabel);
                make.right.mas_equalTo(titleLabel.mas_left).offset(-5);
                make.width.height.mas_equalTo(4);
            }];
        }
    }
    
    
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KFit_W(12), 30)];
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KFit_W(12), 30)];
    UIView *leftView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KFit_W(12), 30)];
    UIView *leftView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KFit_W(12), 30)];
    
    //我的认领量
    UITextField *buyTF = [[UITextField alloc] init];
    buyTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
    buyTF.font = [UIFont systemFontOfSize:12];
    buyTF.textColor = HEXColor(@"#1E2226", 1);
    buyTF.leftViewMode = UITextFieldViewModeAlways;
    buyTF.placeholder = @"请输入认领量";
    buyTF.layer.borderWidth = 1.f;
    buyTF.keyboardType = UIKeyboardTypeDecimalPad;
    buyTF.leftView = leftView1;
    buyTF.delegate = self;
    buyTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [_scrollView addSubview:buyTF];
    [buyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(KFit_W(100));
        make.left.mas_equalTo(KFit_W(120));
    }];
    _buyTF = buyTF;
    
    UILabel *unitLabel = [[UILabel alloc] init];
    unitLabel.textColor = HEXColor(@"#3C3C3C", 1);
//    unitLabel.text = _numUnit;
    unitLabel.text = @"吨";
    unitLabel.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:unitLabel];
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(buyTF);
        make.left.mas_equalTo(buyTF.mas_right).offset(3);
        make.height.mas_equalTo(buyTF);
    }];
    
    
    CGFloat imageWH = 20.0;
    //是否需要样品
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
    yesBtn.selected = YES;
    self.selectedBtn = yesBtn;
    currentSelectBtnTag = yesBtn.tag;
    
    yesBtn.sd_layout
    .leftEqualToView(buyTF)
    .widthIs(50)
    .heightIs(32)
    .topSpaceToView(buyTF, 20);
    
    yesBtn.imageView.sd_layout
    .leftSpaceToView(yesBtn, 0)
    .centerYEqualToView(yesBtn)
    .widthIs(imageWH)
    .heightIs(imageWH);
    
    yesBtn.titleLabel.sd_layout
    .rightSpaceToView(yesBtn, 0)
    .centerYEqualToView(yesBtn)
    .widthIs(imageWH)
    .heightIs(imageWH);
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
    
    //    //默认选否
    //    noBtn.selected = YES;
    //    self.selectedBtn = noBtn;
    //    currentSelectBtnTag = noBtn.tag;
    
    noBtn.sd_layout
    .leftSpaceToView(yesBtn, 25)
    .widthIs(50)
    .heightIs(32)
    .topEqualToView(yesBtn);
    
    noBtn.imageView.sd_layout
    .leftSpaceToView(noBtn, 0)
    .centerYEqualToView(noBtn)
    .widthIs(imageWH)
    .heightIs(imageWH);
    
    noBtn.titleLabel.sd_layout
    .rightSpaceToView(noBtn, 0)
    .centerYEqualToView(noBtn)
    .widthIs(imageWH)
    .heightIs(imageWH);
    
    //联系人
    UITextField *contactTF = [[UITextField alloc] init];
    contactTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
    contactTF.font = [UIFont systemFontOfSize:12];
    contactTF.textColor = HEXColor(@"#1E2226", 1);
    contactTF.leftViewMode = UITextFieldViewModeAlways;
    contactTF.layer.borderWidth = 1.f;
    contactTF.leftView = leftView2;
    contactTF.placeholder = @"请输入联系人";
    contactTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [_scrollView addSubview:contactTF];
    [contactTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yesBtn.mas_bottom).offset(20);
        make.height.left.mas_equalTo(buyTF);
        make.right.mas_equalTo(self.view.mas_right).offset(KFit_W(-9));
    }];
    _contactTF = contactTF;
    
    //联系人方式
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
    phoneTF.font = [UIFont systemFontOfSize:12];
    phoneTF.textColor = HEXColor(@"#1E2226", 1);
    phoneTF.leftViewMode = UITextFieldViewModeAlways;
    phoneTF.layer.borderWidth = 1.f;
    phoneTF.leftView = leftView3;
    phoneTF.placeholder = @"请输入联系方式";
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [_scrollView addSubview:phoneTF];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contactTF.mas_bottom).offset(20);
        make.height.left.mas_equalTo(buyTF);
        make.right.mas_equalTo(contactTF);
    }];
    _phoneTF = phoneTF;
    
    //联系人公司
    UITextField *companyTF = [[UITextField alloc] init];
    companyTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
    companyTF.font = [UIFont systemFontOfSize:12];
    companyTF.textColor = HEXColor(@"#1E2226", 1);
    companyTF.leftViewMode = UITextFieldViewModeAlways;
    companyTF.layer.borderWidth = 1.f;
    companyTF.placeholder = @"请输入公司名称";
    companyTF.leftView = leftView4;
    companyTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [_scrollView addSubview:companyTF];
    [companyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneTF.mas_bottom).offset(20);
        make.height.left.mas_equalTo(buyTF);
        make.right.mas_equalTo(contactTF);
    }];
    _companyTF = companyTF;
    
    //公司所在区域
    SelectedView *placeArea = [[SelectedView alloc] init];
    placeArea.textLabel.text = @"请选择地区";
    [_scrollView addSubview:placeArea];
    [HelperTool addTapGesture:placeArea withTarget:self andSEL:@selector(showPickView_area)];
    [placeArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(buyTF);
        make.top.mas_equalTo(companyTF.mas_bottom).offset(20);
        make.right.mas_equalTo(contactTF);
    }];
    _placeArea = placeArea;
    
    //详细说明
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = HEXColor(@"#E8E8E8", 1);
    textView.placeholder = @"50字以内...";
    textView.placeholderColor = HEXColor(@"#868686", 1);
    textView.font = [UIFont systemFontOfSize:12];
    [_scrollView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(placeArea);
        make.height.mas_equalTo(63);
        make.top.mas_equalTo(placeArea.mas_bottom).offset(20);
    }];
    _textView = textView;
    
    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(discountBuy) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ClassTool addLayer:submitBtn];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
    
}

- (void)discountBuy {
    if ([self judgeRight] == NO) {
        return;
    }
    
    NSArray *areaArray = [_placeArea.textLabel.text componentsSeparatedByString:@"-"];
    NSDictionary *dict = @{@"salesId":_productID,
                           @"contact":_contactTF.text,
                           @"phone":_phoneTF.text,
                           @"companyName":_companyTF.text,
                           @"num":_buyTF.text,
                           @"numUnit":@"吨",
//                           @"numUnit":_numUnit,
                           @"province":areaArray[0],
                           @"city":areaArray[1],
                           @"address":_textView.text,
                           @"isSendSample":[NSString stringWithFormat:@"%ld",(long)currentSelectBtnTag],
//                           @"from":@"from=app",
                           };
    DDWeakSelf;
    
    [CddHUD showWithText:@"参与团购中..." view:self.view];
    [ClassTool postRequest:URL_Join_Discount_Buy Params:[dict mutableCopy] Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                        NSLog(@"-----== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CddHUD showTextOnlyDelay:@"参与成功" view:weakself.view];
                NSString *notiName = @"groupBuySuc";
                [[NSNotificationCenter defaultCenter]postNotificationName:notiName object:nil userInfo:nil];
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }
    } Failure:^(NSError *error) {
        
    }];
    
}

//地址选择
- (void)showPickView_area {
    [self.view endEditing:YES];
    DDWeakSelf;
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:nil defaultSelected:nil isAutoSelect:NO themeColor:MainColor resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        weakself.placeArea.textLabel.text = [NSString stringWithFormat:@"%@-%@", province.name, city.name];
    } cancelBlock:^{
        //        NSLog(@"点击了背景视图或取消按钮");
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

-  (BOOL)judgeRight {
    if (_buyTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入认购量" view:self.view];
        return NO;
    } else if (_contactTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入联系人" view:self.view];
        return NO;
    } else if (_phoneTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入手机号" view:self.view];
        return NO;
    } else if ([MobilePhone isValidMobile:_phoneTF.text] == NO) {
        [CddHUD showTextOnlyDelay:@"请输入o有效的手机号" view:self.view];
        return NO;
    } else if (_companyTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入公司名称" view:self.view];
        return NO;
    } else if ([_placeArea.textLabel.text isEqualToString:@"请选择地区"]) {
        [CddHUD showTextOnlyDelay:@"请选择地区" view:self.view];
        return NO;
    }
    
    return YES;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
