//
//  AskToBuyBottomView.m
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuyBottomView.h"
#import "SelectedView.h"
#import "UITextView+Placeholder.h"
#import "ClassTool.h"
#import "UITextField+Limit.h"
#import "QCYAlertView.h"

@interface AskToBuyBottomView()
@property (nonatomic, strong) BEMCheckBoxGroup *cBoxGroup;
@end

@implementation AskToBuyBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    CGFloat gap = 20;
    CGFloat width = (SCREEN_WIDTH - KFit_W(114) - 25) / 2;
    CGFloat height = 32;
    //输入公司名字
    UIView *companyBg = [[UIView alloc] init];
    [self addSubview:companyBg];
    [companyBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(108));
        make.height.mas_equalTo(height);
        make.right.mas_equalTo(-9);
        make.top.mas_equalTo(gap);
    }];
    
    if (isCompanyUser) {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.text = Get_CompanyName;
        nameLabel.textColor = HEXColor(@"#868686", 1);
        [companyBg addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    } else {
        UITextField *companyNameTF = [[UITextField alloc] init];
        companyNameTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
        companyNameTF.layer.borderWidth = 1.f;
        companyNameTF.maxLength = 30;
        companyNameTF.placeholder = @"输入公司名称";
        companyNameTF.font = [UIFont systemFontOfSize:13];
        companyNameTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
        [companyBg addSubview:companyNameTF];
        [companyNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _companyNameTF = companyNameTF;
    }
    
    //产品分类1
    SelectedView *productClassifyOne = [[SelectedView alloc] init];
    productClassifyOne.textLabel.text = @"请选择分类";
    [self addSubview:productClassifyOne];
    [productClassifyOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(companyBg);
        make.top.mas_equalTo(companyBg.mas_bottom).offset(gap);
        make.width.mas_equalTo(width);
    }];
    _productClassifyOne = productClassifyOne;
    
    //产品分类2
    SelectedView *productClassifyTwo = [[SelectedView alloc] init];
    productClassifyTwo.textLabel.text = @"产品二级分类";
    [self addSubview:productClassifyTwo];
    [productClassifyTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.mas_equalTo(productClassifyOne);
        make.right.height.mas_equalTo(companyBg);
    }];
    _productClassifyTwo = productClassifyTwo;
    
    //输入产品名称
    UITextField *productNameTF = [[UITextField alloc] init];
    productNameTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
    productNameTF.layer.borderWidth = 1.f;
    productNameTF.placeholder = @"输入产品名称";
    productNameTF.font = [UIFont systemFontOfSize:13];
    productNameTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [self addSubview:productNameTF];
    [productNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(companyBg);
        make.top.mas_equalTo(productClassifyOne.mas_bottom).offset(gap);
    }];
    _productNameTF = productNameTF;
    
    //包装规格
    UITextField *specificationTF = [[UITextField alloc] init];
    specificationTF.backgroundColor = [UIColor whiteColor];
    specificationTF.keyboardType = UIKeyboardTypeNumberPad;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 32)];
    leftView.contentMode = UIViewContentModeCenter;
    specificationTF.leftView = leftView;
    specificationTF.leftViewMode = UITextFieldViewModeAlways;
    specificationTF.layer.borderWidth = 1.f;
    specificationTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    specificationTF.font = [UIFont systemFontOfSize:12];
    specificationTF.placeholder = @"例:25";
    [self addSubview:specificationTF];
    [specificationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(companyBg);
        make.width.mas_equalTo(width - KFit_W(30));
        make.top.mas_equalTo(productNameTF.mas_bottom).offset(gap);
    }];
    _specificationTF = specificationTF;
    
    //KG
    UILabel *weight = [[UILabel alloc] init];
    weight.text = @"KG/";
    weight.font = [UIFont systemFontOfSize:12];
    weight.textColor = HEXColor(@"#818181", 1);
    weight.textAlignment = NSTextAlignmentRight;
    [self addSubview:weight];
    [weight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(specificationTF.mas_right).offset(0);
        make.centerY.mas_equalTo(specificationTF);
        make.right.mas_equalTo(productClassifyOne);
    }];
    
    //单位
    SelectedView *unit = [[SelectedView alloc] init];
    unit.textLabel.text = @"请选择";
    [self addSubview:unit];
    [unit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.width.mas_equalTo(productClassifyTwo);
        make.top.mas_equalTo(specificationTF);
    }];
    _unit = unit;
    
    //求购数量
    UITextField *buyCountTF = [[UITextField alloc] init];
    buyCountTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
    buyCountTF.layer.borderWidth = 1.f;
    buyCountTF.keyboardType = UIKeyboardTypeNumberPad;
    buyCountTF.placeholder = @"数量";
    buyCountTF.font = [UIFont systemFontOfSize:13];
    buyCountTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [self addSubview:buyCountTF];
    [buyCountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(specificationTF);
        make.right.mas_equalTo(specificationTF.mas_right).offset(-40);
        make.top.mas_equalTo(specificationTF.mas_bottom).offset(gap);
    }];
    _buyCountTF = buyCountTF;
    
    //显示单位
    UILabel *unitDisplay = [[UILabel alloc] init];
    unitDisplay.font = [UIFont systemFontOfSize:12];
    unitDisplay.textColor = HEXColor(@"#818181", 1);
    unitDisplay.textAlignment = NSTextAlignmentCenter;
    [self addSubview:unitDisplay];
    [unitDisplay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(buyCountTF.mas_right).offset(5);
        make.width.mas_equalTo(20);
        make.centerY.mas_equalTo(buyCountTF);
    }];
    _unitDisplay = unitDisplay;
    
    //数量说明
    UILabel *explainLabel = [[UILabel alloc] init];
    explainLabel.font = [UIFont systemFontOfSize:11];
    explainLabel.textColor = HEXColor(@"#818181", 1);
    explainLabel.numberOfLines = 2;
    [self addSubview:explainLabel];
    [explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(unitDisplay.mas_right).offset(10);
        make.right.mas_equalTo(productClassifyTwo.mas_right);
        make.centerY.mas_equalTo(buyCountTF);
        make.height.mas_equalTo(productClassifyTwo);
    }];
    _explainLabel = explainLabel;
    
    //付款方式
    SelectedView *payType = [[SelectedView alloc] init];
    payType.textLabel.text = @"请选择";
    [self addSubview:payType];
    [payType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.mas_equalTo(productClassifyOne);
        make.top.mas_equalTo(buyCountTF.mas_bottom).offset(gap);
    }];
    _payType = payType;
    
    //帐期
    SelectedView *billDate = [[SelectedView alloc] init];
    billDate.textLabel.text = @"请选择";
    [self addSubview:billDate];
    [billDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.mas_equalTo(productClassifyOne);
        make.top.mas_equalTo(payType.mas_bottom).offset(gap);
    }];
    _billDate = billDate;
    
    //其他时间
    BEMCheckBox *dateCheckBox = [[BEMCheckBox alloc] init];
    dateCheckBox.delegate = self;
    dateCheckBox.boxType = BEMBoxTypeSquare;
    dateCheckBox.onAnimationType = BEMAnimationTypeBounce;
    dateCheckBox.offAnimationType = BEMAnimationTypeStroke;
    [self addSubview:dateCheckBox];
    [dateCheckBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25);
        make.left.mas_equalTo(billDate.mas_right).offset(25);
        make.centerY.mas_equalTo(billDate);
    }];
    _dateCheckBox = dateCheckBox;
    
    UILabel *otherLabel = [[UILabel alloc] init];
    otherLabel.text = @"其他时间";
    otherLabel.font = [UIFont systemFontOfSize:12];
    otherLabel.textColor = HEXColor(@"#818181", 1);
    otherLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:otherLabel];
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(dateCheckBox.mas_right).offset(10);
        make.centerY.mas_equalTo(dateCheckBox);
    }];
    
    //勾选其他时间选择的输入框
    UITextField *billTF = [[UITextField alloc] init];
    billTF.backgroundColor = HEXColor(@"#E8E8E8", 0.4);
    billTF.layer.borderWidth = 1.f;
    billTF.placeholder = @"输入帐期时间";
    billTF.userInteractionEnabled = NO;
    billTF.font = [UIFont systemFontOfSize:13];
    billTF.layer.borderColor = HEXColor(@"#E6E6E6", 0.1).CGColor;
    [self addSubview:billTF];
    [billTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(productClassifyOne);
        make.right.mas_equalTo(companyBg);
        make.top.mas_equalTo(billDate.mas_bottom).offset(10);
    }];
    _billTF = billTF;
    
    SelectedView *placeArea = [[SelectedView alloc] init];
    placeArea.textLabel.text = @"请选择地区";
    [self addSubview:placeArea];
    [placeArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(productClassifyOne);
        make.top.mas_equalTo(billTF.mas_bottom).offset(gap);
        make.right.mas_equalTo(companyBg);
    }];
    _placeArea = placeArea;
    
    //结束时间
    SelectedView *endTime = [[SelectedView alloc] init];
    endTime.textLabel.text = @"请选择时间";
    [self addSubview:endTime];
    [endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.mas_equalTo(productClassifyOne);
        make.top.mas_equalTo(placeArea.mas_bottom).offset(gap);
    }];
    _endTime = endTime;
    
    UILabel *desLabel_1 = [[UILabel alloc] init];
    desLabel_1.text = @"(求购结束时间不能小于3天，不能大于30天)";
    desLabel_1.font = [UIFont systemFontOfSize:12];
    desLabel_1.textColor = MainColor;
    [self addSubview:desLabel_1];
    [desLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(endTime);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(endTime.mas_bottom).offset(5);
        make.right.mas_equalTo(-5);
    }];
    
    //交货日期
    SelectedView *deliveryDate = [[SelectedView alloc] init];
    deliveryDate.textLabel.text = @"请选择日期";
    [self addSubview:deliveryDate];
    [deliveryDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.mas_equalTo(productClassifyOne);
        make.top.mas_equalTo(desLabel_1.mas_bottom).offset(gap);
    }];
    _deliveryDate = deliveryDate;
    
    UILabel *desLabel_2 = [[UILabel alloc] init];
    desLabel_2.text = @"(交货日期不能小于结束日期)";
    desLabel_2.font = [UIFont systemFontOfSize:12];
    desLabel_2.textColor = MainColor;
    [self addSubview:desLabel_2];
    [desLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(deliveryDate);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(deliveryDate.mas_bottom).offset(5);
        make.right.mas_equalTo(-5);
    }];
    
    //求购直通车
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.mas_equalTo(productNameTF);
        make.top.mas_equalTo(desLabel_2.mas_bottom).offset(gap);
    }];
    
    //同意
    BEMCheckBox *agreeZTC = [[BEMCheckBox alloc] init];
    agreeZTC.frame = CGRectMake(0, (height - 20) / 2, 20, 20);
    [self setupBox:agreeZTC];
    [bgView addSubview:agreeZTC];
    _agreeZTC = agreeZTC;
    
    UILabel *allowLab = [[UILabel alloc] init];
    allowLab.text = @"同意平台推荐供应商直接联系";
    allowLab.font = [UIFont systemFontOfSize:14];
    allowLab.textColor = HEXColor(@"#868686", 1);
    [bgView addSubview:allowLab];
    [allowLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(agreeZTC.mas_right).offset(7);
        make.centerY.height.mas_equalTo(agreeZTC);
    }];
    
    UIButton *readmeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [readmeBtn addTarget:self action:@selector(alertZTCview) forControlEvents:UIControlEventTouchUpInside];
    readmeBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [readmeBtn setImage:[UIImage imageNamed:@"readme_icon"] forState:UIControlStateNormal];
    readmeBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    [bgView addSubview:readmeBtn];
    [readmeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.left.mas_equalTo(allowLab.mas_right).offset(4);
        make.centerY.mas_equalTo(agreeZTC);
    }];
    
    UIView *bgView_1 = [[UIView alloc] init];
    bgView_1.backgroundColor = UIColor.whiteColor;
    [self addSubview:bgView_1];
    [bgView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.mas_equalTo(productNameTF);
        make.top.mas_equalTo(bgView.mas_bottom).offset(0);
    }];

    //不同意
    BEMCheckBox *disAgreeZTC = [[BEMCheckBox alloc] init];
    disAgreeZTC.frame = CGRectMake(0, (height - 20) / 2, 20, 20);
    [self setupBox:disAgreeZTC];
    [bgView_1 addSubview:disAgreeZTC];
    [disAgreeZTC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(bgView_1);
    }];
    _disAgreeZTC = disAgreeZTC;
    

    UILabel *allowLab_1 = [[UILabel alloc] init];
    allowLab_1.text = @"不同意平台推荐供应商直接联系";
    allowLab_1.font = [UIFont systemFontOfSize:14];
    allowLab_1.textColor = HEXColor(@"#868686", 1);
    [bgView_1 addSubview:allowLab_1];
    [allowLab_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(disAgreeZTC.mas_right).offset(7);
        make.centerY.height.mas_equalTo(disAgreeZTC);
    }];

    //按钮组
    self.cBoxGroup = [[BEMCheckBoxGroup alloc] init];
    [self.cBoxGroup addCheckBoxToGroup:_agreeZTC];
    [self.cBoxGroup addCheckBoxToGroup:_disAgreeZTC];
    self.cBoxGroup.selectedCheckBox = self.agreeZTC;
    self.cBoxGroup.mustHaveSelection = YES;
    
    //详细说明
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = HEXColor(@"#E8E8E8", 1);
    textView.placeholder = @"50字以内...";
    textView.placeholderColor = HEXColor(@"#868686", 1);
    textView.font = [UIFont systemFontOfSize:12];
    [self addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(companyBg);
        make.height.mas_equalTo(90);
        make.top.mas_equalTo(bgView_1.mas_bottom).offset(gap);
    }];
    _textView = textView;
    
    [textView.superview layoutIfNeeded];
    self.height = textView.bottom + 30;
    
    NSMutableArray<id> *uiArrar = [NSMutableArray arrayWithCapacity:0];
    [uiArrar addObject:companyBg];
    [uiArrar addObject:productClassifyOne];
    [uiArrar addObject:productNameTF];
    [uiArrar addObject:specificationTF];
    [uiArrar addObject:buyCountTF];
    [uiArrar addObject:payType];
    [uiArrar addObject:billDate];
    [uiArrar addObject:placeArea];
    [uiArrar addObject:endTime];
    [uiArrar addObject:deliveryDate];
    [uiArrar addObject:bgView];
    [uiArrar addObject:textView];
    
    
    NSArray *titleArr = @[@"公司名称:",@"产品分类:",@"产品名称:",@"包装规格:",@"求购数量:",@"付款方式:",@"账期:",@"需方所在地:",@"结束时间:",@"交货日期:",@"求购直通车:",@"详细说明:"];
    
    if (uiArrar.count != titleArr.count) return;
    
    for (NSInteger i = 0; i < uiArrar.count; i++) {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = titleArr[i];
        nameLabel.textColor = HEXColor(@"#3C3C3C", 1);
        nameLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.height.mas_equalTo(height);
            make.top.mas_equalTo(uiArrar[i]);
            make.width.mas_equalTo(KFit_W(80));
        }];

        if (i >= 0 && i < 10) {
            UIImageView *tabIcon = [[UIImageView alloc] init];
            tabIcon.image = [UIImage imageNamed:@"tab_icon"];
            [self addSubview:tabIcon];
            [tabIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(nameLabel);
                make.right.mas_equalTo(nameLabel.mas_left).offset(-5);
                make.width.height.mas_equalTo(4);
            }];
        }
    }
    
    [uiArrar removeAllObjects];
    uiArrar = nil;
}


- (void)alertZTCview {
    NSString *title = @"同意平台推荐供应商直接联系!\n快速求购完成交易";
    NSString *text = @"【1】选择“是”，优质供应商将可直接查看到你的联系方式。\n\n【2】选择“否”，则平台所有会员都不能查看其联系方式。";
    [QCYAlertView showWithTitle:title text:text cancel:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

//复选按钮代理
- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    if (checkBox == self.dateCheckBox) {
        _billTF.userInteractionEnabled = !_billTF.userInteractionEnabled;
        _billDate.userInteractionEnabled = !_billDate.userInteractionEnabled;
        _billTF.backgroundColor = _billTF.userInteractionEnabled ? HEXColor(@"#E8E8E8", 1) : HEXColor(@"#E8E8E8", 0.4);
        _billTF.layer.borderColor = _billTF.userInteractionEnabled ? HEXColor(@"#E6E6E6", 1).CGColor : HEXColor(@"#E6E6E6", 0.1).CGColor;
        _billDate.textLabel.textColor = _billDate.userInteractionEnabled ? HEXColor(@"#868686", 1) : HEXColor(@"#868686", 0.3);
        if (_billTF.userInteractionEnabled == NO) {
            _billTF.text = @"";
        } else {
            _billDate.textLabel.text = @"请选择";
        }
    } 
}

- (void)setupBox:(BEMCheckBox *)box {
    box.delegate = self;
    box.boxType = BEMBoxTypeSquare;
    box.onTintColor = UIColor.blackColor;
    box.onCheckColor = UIColor.blackColor;
    box.onAnimationType = BEMAnimationTypeBounce;
    box.offAnimationType = BEMAnimationTypeBounce;
}
@end
