//
//  AskToBuyBottomView.m
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskToBuyBottomView.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "SelectedView.h"
#import "UITextView+Placeholder.h"
#import "ClassTool.h"
#import "UITextField+Limit.h"

@implementation AskToBuyBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    //输入公司名字
    UIView *companyBg = [[UIView alloc] init];
    [self addSubview:companyBg];
    [companyBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(108));
        make.height.mas_equalTo(32);
        make.right.mas_equalTo(-9);
        make.top.mas_equalTo(20);
    }];
    
    if ([isCompany boolValue] == YES) {
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
        companyNameTF.placeholder = @"输入公司名称";
        companyNameTF.font = [UIFont systemFontOfSize:13];
        companyNameTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
        [companyBg addSubview:companyNameTF];
        [companyNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        //限制字数
        [companyNameTF lengthLimit:^{
            if (companyNameTF.text.length > 30) {
                companyNameTF.text = [companyNameTF.text substringToIndex:30];
            }
        }];
        _companyNameTF = companyNameTF;
    }
    
    CGFloat gap = 25;
    CGFloat width = (SCREEN_WIDTH - KFit_W(114) - gap) / 2;
    //产品分类1
    SelectedView *productClassifyOne = [[SelectedView alloc] init];
    productClassifyOne.textLabel.text = @"请选择分类";
    [self addSubview:productClassifyOne];
    [productClassifyOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(companyBg);
        make.top.mas_equalTo(companyBg.mas_bottom).offset(20);
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
        make.top.mas_equalTo(productClassifyOne.mas_bottom).offset(20);
    }];
    _productNameTF = productNameTF;
    
    //包装规格
    UITextField *specificationTF = [[UITextField alloc] init];
    specificationTF.backgroundColor = [UIColor whiteColor];
    specificationTF.keyboardType = UIKeyboardTypeNumberPad;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KFit_W(20), 32)];
    leftView.contentMode = UIViewContentModeCenter;
    specificationTF.leftView = leftView;
    specificationTF.leftViewMode = UITextFieldViewModeAlways;
    specificationTF.layer.borderWidth = 1.f;
    specificationTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    specificationTF.font = [UIFont systemFontOfSize:12];
    specificationTF.placeholder = @"例:25";
    //placeholder颜色
    [specificationTF setValue:HEXColor(@"#868686", 1) forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:specificationTF];
    [specificationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(companyBg);
        make.width.mas_equalTo(width - KFit_W(30));
        make.top.mas_equalTo(productNameTF.mas_bottom).offset(20);
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
        make.top.mas_equalTo(specificationTF.mas_bottom).offset(20);
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
        make.top.mas_equalTo(buyCountTF.mas_bottom).offset(20);
    }];
    _payType = payType;
    
    //帐期
    SelectedView *billDate = [[SelectedView alloc] init];
    billDate.textLabel.text = @"请选择";
    [self addSubview:billDate];
    [billDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.mas_equalTo(productClassifyOne);
        make.top.mas_equalTo(payType.mas_bottom).offset(20);
    }];
    _billDate = billDate;
    
    //其他时间
    BEMCheckBox *checkBox = [[BEMCheckBox alloc] init];
    checkBox.boxType = BEMBoxTypeSquare;
    checkBox.onAnimationType = BEMAnimationTypeFade;
    checkBox.offAnimationType = BEMAnimationTypeFade;
    [self addSubview:checkBox];
    [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.left.mas_equalTo(billDate.mas_right).offset(20);
        make.centerY.mas_equalTo(billDate);
    }];
    _checkBox = checkBox;
    
    UILabel *otherLabel = [[UILabel alloc] init];
    otherLabel.text = @"其他时间";
    otherLabel.font = [UIFont systemFontOfSize:12];
    otherLabel.textColor = HEXColor(@"#818181", 1);
    otherLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:otherLabel];
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(checkBox.mas_right).offset(10);
        make.centerY.mas_equalTo(checkBox);
    }];
    
    //勾选其他时间选择的输入框
    UITextField *billTF = [[UITextField alloc] init];
    billTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
    billTF.layer.borderWidth = 1.f;
    billTF.userInteractionEnabled = NO;
    billTF.placeholder = @"输入帐期时间";
    billTF.font = [UIFont systemFontOfSize:13];
    billTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [self addSubview:billTF];
    [billTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(productClassifyOne);
        make.right.mas_equalTo(companyBg);
        make.top.mas_equalTo(billDate.mas_bottom).offset(10);
    }];
    _billTF = billTF;
    
    //需方所在地
//    SelectedView *placeShen = [[SelectedView alloc] init];
//    placeShen.textLabel.text = @"请选择省";
//    [self addSubview:placeShen];
//    [placeShen mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.height.width.mas_equalTo(productClassifyOne);
//        make.top.mas_equalTo(billTF.mas_bottom).offset(20);
//    }];
//    _placeShen = placeShen;
//
//    SelectedView *placeShi = [[SelectedView alloc] init];
//    placeShi.textLabel.text = @"请选择市";
//    [self addSubview:placeShi];
//    [placeShi mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.height.width.mas_equalTo(productClassifyTwo);
//        make.top.mas_equalTo(placeShen);
//    }];
//    _placeShi = placeShi;
    
    SelectedView *placeArea = [[SelectedView alloc] init];
    placeArea.textLabel.text = @"请选择地区";
    [self addSubview:placeArea];
    [placeArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(productClassifyOne);
        make.top.mas_equalTo(billTF.mas_bottom).offset(20);
        make.right.mas_equalTo(companyBg);
    }];
    _placeArea = placeArea;
    
    //结束时间
    SelectedView *endTime = [[SelectedView alloc] init];
    endTime.textLabel.text = @"请选择时间";
    [self addSubview:endTime];
    [endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.mas_equalTo(productClassifyOne);
        make.top.mas_equalTo(placeArea.mas_bottom).offset(20);
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
        make.top.mas_equalTo(desLabel_1.mas_bottom).offset(20);
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
        make.top.mas_equalTo(desLabel_2.mas_bottom).offset(20);
    }];
    _textView = textView;
    
    
    
    NSArray *titleArr = @[@"公司名称:",@"产品分类:",@"产品名称:",@"包装规格:",@"求购数量:",@"付款方式:",@"账期:",@"需方所在地:",@"结束时间:",@"交货日期:",@"详细说明:"];
    UILabel *nameLabel1 = [[UILabel alloc] init];
    [self configLabel:nameLabel1 title:titleArr[0]];
    [self addSubview:nameLabel1];
    [nameLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(companyBg);
        make.width.mas_equalTo(KFit_W(80));
    }];
    UIImageView *tabIcon1 = [[UIImageView alloc] init];
    tabIcon1.image = [UIImage imageNamed:@"tab_icon"];
    [self addSubview:tabIcon1];
    [tabIcon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel1);
        make.right.mas_equalTo(nameLabel1.mas_left).offset(-5);
        make.width.height.mas_equalTo(4);
    }];
    
    UILabel *nameLabel2 = [[UILabel alloc] init];
    [self configLabel:nameLabel2 title:titleArr[1]];
    [self addSubview:nameLabel2];
    [nameLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(productClassifyOne);
        make.width.mas_equalTo(KFit_W(80));
    }];
    UIImageView *tabIcon2 = [[UIImageView alloc] init];
    tabIcon2.image = [UIImage imageNamed:@"tab_icon"];
    [self addSubview:tabIcon2];
    [tabIcon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel2);
        make.right.mas_equalTo(nameLabel2.mas_left).offset(-5);
        make.width.height.mas_equalTo(4);
    }];
    
    UILabel *nameLabel3 = [[UILabel alloc] init];
    [self configLabel:nameLabel3 title:titleArr[2]];
    [self addSubview:nameLabel3];
    [nameLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(productNameTF);
        make.width.mas_equalTo(KFit_W(80));
    }];
    UIImageView *tabIcon3 = [[UIImageView alloc] init];
    tabIcon3.image = [UIImage imageNamed:@"tab_icon"];
    [self addSubview:tabIcon3];
    [tabIcon3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel3);
        make.right.mas_equalTo(nameLabel3.mas_left).offset(-5);
        make.width.height.mas_equalTo(4);
    }];
    
    UILabel *nameLabel4 = [[UILabel alloc] init];
    [self configLabel:nameLabel4 title:titleArr[3]];
    [self addSubview:nameLabel4];
    [nameLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(specificationTF);
        make.width.mas_equalTo(KFit_W(80));
    }];
    UIImageView *tabIcon4 = [[UIImageView alloc] init];
    tabIcon4.image = [UIImage imageNamed:@"tab_icon"];
    [self addSubview:tabIcon4];
    [tabIcon4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel4);
        make.right.mas_equalTo(nameLabel4.mas_left).offset(-5);
        make.width.height.mas_equalTo(4);
    }];
    
    UILabel *nameLabel5 = [[UILabel alloc] init];
    [self configLabel:nameLabel5 title:titleArr[4]];
    [self addSubview:nameLabel5];
    [nameLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(buyCountTF);
        make.width.mas_equalTo(KFit_W(80));
    }];
    UIImageView *tabIcon5 = [[UIImageView alloc] init];
    tabIcon5.image = [UIImage imageNamed:@"tab_icon"];
    [self addSubview:tabIcon5];
    [tabIcon5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel5);
        make.right.mas_equalTo(nameLabel5.mas_left).offset(-5);
        make.width.height.mas_equalTo(4);
    }];
    
    UILabel *nameLabel6 = [[UILabel alloc] init];
    [self configLabel:nameLabel6 title:titleArr[5]];
    [self addSubview:nameLabel6];
    [nameLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(payType);
        make.width.mas_equalTo(KFit_W(80));
    }];
    UIImageView *tabIcon6 = [[UIImageView alloc] init];
    tabIcon6.image = [UIImage imageNamed:@"tab_icon"];
    [self addSubview:tabIcon6];
    [tabIcon6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel6);
        make.right.mas_equalTo(nameLabel6.mas_left).offset(-5);
        make.width.height.mas_equalTo(4);
    }];
    
    UILabel *nameLabel7 = [[UILabel alloc] init];
    [self configLabel:nameLabel7 title:titleArr[6]];
    [self addSubview:nameLabel7];
    [nameLabel7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(billDate);
        make.width.mas_equalTo(KFit_W(80));
    }];
    UIImageView *tabIcon7 = [[UIImageView alloc] init];
    tabIcon7.image = [UIImage imageNamed:@"tab_icon"];
    [self addSubview:tabIcon7];
    [tabIcon7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel7);
        make.right.mas_equalTo(nameLabel7.mas_left).offset(-5);
        make.width.height.mas_equalTo(4);
    }];
    
    UILabel *nameLabel8 = [[UILabel alloc] init];
    [self configLabel:nameLabel8 title:titleArr[7]];
    [self addSubview:nameLabel8];
    [nameLabel8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(placeArea);
        make.width.mas_equalTo(KFit_W(80));
    }];
    UIImageView *tabIcon8 = [[UIImageView alloc] init];
    tabIcon8.image = [UIImage imageNamed:@"tab_icon"];
    [self addSubview:tabIcon8];
    [tabIcon8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel8);
        make.right.mas_equalTo(nameLabel8.mas_left).offset(-5);
        make.width.height.mas_equalTo(4);
    }];
    
    UILabel *nameLabel9 = [[UILabel alloc] init];
    [self configLabel:nameLabel9 title:titleArr[8]];
    [self addSubview:nameLabel9];
    [nameLabel9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(endTime);
        make.width.mas_equalTo(KFit_W(80));
    }];
    UIImageView *tabIcon9 = [[UIImageView alloc] init];
    tabIcon9.image = [UIImage imageNamed:@"tab_icon"];
    [self addSubview:tabIcon9];
    [tabIcon9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel9);
        make.right.mas_equalTo(nameLabel9.mas_left).offset(-5);
        make.width.height.mas_equalTo(4);
    }];
    
    UILabel *nameLabel10 = [[UILabel alloc] init];
    [self configLabel:nameLabel10 title:titleArr[9]];
    [self addSubview:nameLabel10];
    [nameLabel10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.centerY.mas_equalTo(deliveryDate);
        make.width.mas_equalTo(KFit_W(80));
    }];
    UIImageView *tabIcon10 = [[UIImageView alloc] init];
    tabIcon10.image = [UIImage imageNamed:@"tab_icon"];
    [self addSubview:tabIcon10];
    [tabIcon10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel10);
        make.right.mas_equalTo(nameLabel10.mas_left).offset(-5);
        make.width.height.mas_equalTo(4);
    }];
    
    UILabel *nameLabel11 = [[UILabel alloc] init];
    [self configLabel:nameLabel11 title:titleArr[10]];
    [self addSubview:nameLabel11];
    [nameLabel11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(desLabel_2.mas_bottom).offset(28);
        make.width.mas_equalTo(KFit_W(80));
        make.height.mas_equalTo(14);
    }];

}


- (void)configLabel:(UILabel *)label title:(NSString *)title {
    label.text = title;
    label.textColor = HEXColor(@"#3C3C3C", 1);
    label.font = [UIFont systemFontOfSize:13];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
