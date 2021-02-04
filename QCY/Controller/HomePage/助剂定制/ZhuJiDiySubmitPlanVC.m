//
//  ZhuJiDiySubmitPlanVC.m
//  QCY
//
//  Created by i7colors on 2019/8/1.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ZhuJiDiySubmitPlanVC.h"
#import <YYText.h>
#import "BEMCheckBox.h"
#import "UITextField+Limit.h"
#import "UITextView+Placeholder.h"
#import "CddHUD.h"
#import "MobilePhone.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"

@interface ZhuJiDiySubmitPlanVC ()<BEMCheckBoxDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *productNameTF;
@property (nonatomic, strong) UITextField *numTF;
@property (nonatomic, strong) UILabel *numUnitLab;
@property (nonatomic, strong) BEMCheckBox *checkBox;
@property (nonatomic, strong) UITextField *otherUnitTF;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) BOOL isHaveDian;
@end

@implementation ZhuJiDiySubmitPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交方案";
    [self setupUI];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

//提交方案
- (void)submitPlan {
    if ([self judgeData] == NO) {
        return ;
    };
    NSDictionary *dict = @{@"token":User_Token,
                           @"zhujiDiyId":_zhuJiDiyID,
                           @"phone":_phoneTF.text,
                           @"productName":_productNameTF.text,
                           @"description":_textView.text,
                           };
    NSMutableDictionary *mDict = [dict mutableCopy];
    if (_numTF.text.length != 0) {
        [mDict setObject:_numTF.text forKey:@"num"];
        [mDict setObject:_numUnitLab.text forKey:@"numUnit"];
    }
    
    DDWeakSelf;
    [CddHUD showWithText:@"正在提交方案..." view:self.view];
    [ClassTool postRequest:URLPost_ZhuJiDiy_SubmitPlan Params:mDict Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"---- %@",json);
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            [CddHUD showTextOnlyDelay:@"提交成功" view:self.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }
    } Failure:^(NSError *error) {
        
    }];
    
}


- (void)setupUI {
    [self.view addSubview:self.scrollView];
    //提示
    YYLabel *tipLabel = [[YYLabel alloc] init];
    NSString *text = @"【提醒】提交定制方案后将会第一时间通过短信的方式告知采购需方！";
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGFloat fitHeight = [self getMessageHeight:text andLabel:tipLabel];
    tipLabel.frame = CGRectMake(KFit_W(8), 10, SCREEN_WIDTH - KFit_W(8) * 2, fitHeight + 20);
    [self.scrollView addSubview:tipLabel];
    tipLabel.layer.borderWidth = 1.f;
    tipLabel.layer.borderColor = HEXColor(@"#ED3851", 1).CGColor;
    tipLabel.layer.cornerRadius = 8.f;
    
    //for循环创建
    NSArray *titleArr = @[@"手机号:",@"供应产品名称:",@"需方提供样品:", @"产品应用工艺描述:"];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArr[i];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = HEXColor(@"#3C3C3C", 1);
        titleLabel.font = [UIFont systemFontOfSize:13];
        [_scrollView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(tipLabel.mas_bottom).offset((i + 1) * 20 + i * 32);
            make.width.mas_equalTo(KFit_W(95));
            make.height.mas_equalTo(32);
        }];
        
        if (i == 0 || i == 1) {
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
    
    //手机号
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.placeholder = @"请输入联系人手机号";
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    [self setTFProperty:phoneTF];
    [self.scrollView addSubview:phoneTF];
    [phoneTF lengthLimit:^{
        if (phoneTF.text.length > 11) {
            phoneTF.text = [phoneTF.text substringToIndex:11];
        }
    }];
    _phoneTF = phoneTF;
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(32);
        make.left.mas_equalTo(self.view.mas_left).offset(KFit_W(120));
        make.right.mas_equalTo(self.view.mas_right).offset(-8);
    }];
    
    //产品供应名称
    UITextField *productNameTF = [[UITextField alloc] init];
    productNameTF.placeholder = @"请输入供应商产品全称";
    productNameTF.delegate = self;
    productNameTF.tag = 10001;
    [self setTFProperty:productNameTF];
    [self.scrollView addSubview:productNameTF];
    _productNameTF = productNameTF;
    [productNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneTF.mas_bottom).offset(20);
        make.height.left.right.mas_equalTo(phoneTF);
    }];
    
    //样品提供数量
    UITextField *numTF = [[UITextField alloc] init];
    numTF.placeholder = @"请输入数量";
    numTF.keyboardType = UIKeyboardTypeDecimalPad;
    numTF.delegate = self;
    numTF.tag = 10002;
    [self setTFProperty:numTF];
    [self.scrollView addSubview:numTF];
    _numTF = numTF;
    [numTF lengthLimit:^{
        if (numTF.text.length > 4) {
            numTF.text = [numTF.text substringToIndex:4];
        }
    }];
    [numTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(productNameTF.mas_bottom).offset(20);
        make.height.left.mas_equalTo(phoneTF);
        make.width.mas_equalTo(KFit_W(80));
    }];
    
    //数量单位
    UILabel *numUnitLab = [[UILabel alloc] init];
    numUnitLab.text = @"KG";
    numUnitLab.numberOfLines = 2;
    numUnitLab.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:numUnitLab];
    _numUnitLab = numUnitLab;
    [numUnitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numTF.mas_right).offset(5);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(30);
        make.centerY.mas_equalTo(numTF);
    }];
    
//    BEMCheckBox *checkBox = [[BEMCheckBox alloc] init];
//    checkBox.delegate = self;
//    checkBox.boxType = BEMBoxTypeSquare;
//    checkBox.onTintColor = MainColor;
//    checkBox.onCheckColor = MainColor;
//    checkBox.onAnimationType = BEMAnimationTypeBounce;
//    checkBox.offAnimationType = BEMAnimationTypeStroke;
//    [self.scrollView addSubview:checkBox];
//    [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(25);
//        make.left.mas_equalTo(numUnitLab.mas_right).offset(5);
//        make.centerY.mas_equalTo(numUnitLab);
//    }];
//    _checkBox = checkBox;
//
//    UILabel *otherLabel = [[UILabel alloc] init];
//    otherLabel.numberOfLines = 2;
//    otherLabel.text = @"其他\n单位";
//    otherLabel.font = [UIFont systemFontOfSize:12];
//    otherLabel.textColor = HEXColor(@"#818181", 1);
//    otherLabel.textAlignment = NSTextAlignmentCenter;
//    [self.scrollView addSubview:otherLabel];
//    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(checkBox.mas_right).offset(5);
//        make.width.mas_equalTo(30);
//        make.centerY.mas_equalTo(checkBox);
//    }];
//
//    //输入单位
//    UITextField *otherUnitTF = [[UITextField alloc] init];
//    [otherUnitTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
//    otherUnitTF.placeholder = @"打勾输入";
//    otherUnitTF.delegate = self;
//    otherUnitTF.tag = 10003;
//    otherUnitTF.userInteractionEnabled = NO;
//    otherUnitTF.font = [UIFont systemFontOfSize:12];
//    otherUnitTF.backgroundColor = HEXColor(@"#E8E8E8", .3);
//    otherUnitTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 20)];
//    otherUnitTF.leftViewMode = UITextFieldViewModeAlways;
//    otherUnitTF.textColor = HEXColor(@"#1E2226", 1);
//    otherUnitTF.layer.borderWidth = 0.7f;
//    otherUnitTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
//    [self.scrollView addSubview:otherUnitTF];
//    //限制字数
//    [otherUnitTF lengthLimit:^{
//        if (otherUnitTF.text.length > 4) {
//            otherUnitTF.text = [otherUnitTF.text substringToIndex:4];
//        }
//    }];
//    _otherUnitTF = otherUnitTF;
//    [otherUnitTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(otherLabel.mas_right).offset(3);
//        make.right.height.mas_equalTo(phoneTF);
//        make.centerY.mas_equalTo(otherLabel);
//    }];
    
    //详细说明
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = HEXColor(@"#E8E8E8", 1);
    textView.placeholder = @"50字以内...";
    textView.placeholderColor = HEXColor(@"#868686", 1);
    textView.font = [UIFont systemFontOfSize:12];
    [self.scrollView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(phoneTF);
        make.height.mas_equalTo(90);
        make.top.mas_equalTo(numTF.mas_bottom).offset(20);
    }];
    _textView = textView;
    [textView.superview layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, textView.bottom + 50);
    
    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交方案" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitPlan) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ClassTool addLayer:submitBtn];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
}


//复选按钮代理
- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    if (!_checkBox.on) {
        _otherUnitTF.text = @"";
        _numUnitLab.text = @"KG";
    }
    
    [_otherUnitTF resignFirstResponder];
    _otherUnitTF.userInteractionEnabled = checkBox.on;
    _otherUnitTF.backgroundColor = checkBox.on ? HEXColor(@"#E8E8E8", 1) : HEXColor(@"#E8E8E8", .3);
    _otherUnitTF.placeholder = checkBox.on ? @"输入单位" : @"打勾输入";
}

- (void)textFieldTextDidChange:(UITextField *)tf {
    if (tf.text.length > 0) {
        if (tf.markedTextRange == nil && tf.text.length < 5) {
            _numUnitLab.text = tf.text;
        }
    } else {
        _numUnitLab.text = @"KG";
    }
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string {
    //禁止输入空格
    NSString*tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if(![string isEqualToString:tem]) {
        return NO;
    }
    
    if (textField.tag == 10002) {
        // 判断是否有小数点
        if ([textField.text containsString:@"."]) {
            self.isHaveDian = YES;
        }else{
            self.isHaveDian = NO;
        }
        
        if (string.length > 0) {
            //当前输入的字符
            unichar single = [string characterAtIndex:0];
            // 不能输入.0-9以外的字符
            if (!((single >= '0' && single <= '9') || single == '.'))
            {
                //            [MBProgressHUD bwm_showTitle:@"您的输入格式不正确" toView:self hideAfter:1.0];
                return NO;
            }
            // 只能有一个小数点
            if (self.isHaveDian && single == '.') {
                //            [MBProgressHUD bwm_showTitle:@"最多只能输入一个小数点" toView:self hideAfter:1.0];
                return NO;
            }
            // 如果第一位是.则前面加上0.
            if ((textField.text.length == 0) && (single == '.')) {
                textField.text = @"0";
            }
            // 如果第一位是0则后面必须输入点，否则不能输入。
            if ([textField.text hasPrefix:@"0"]) {
                if (textField.text.length > 2) {
                    NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                    if (![secondStr isEqualToString:@"."]) {
                        return NO;
                    }
                }else{
                    if (![string isEqualToString:@"."]) {
                        return NO;
                    }
                }
            }
            // 小数点后最多能输入1位
            if (self.isHaveDian) {
                NSRange ran = [textField.text rangeOfString:@"."];
                // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
                if (range.location > ran.location) {
                    if ([textField.text pathExtension].length > 0) {
                        return NO;
                    }
                }
            }
            
        }
        
        return YES;
    }
    
    return YES;
}

- (BOOL)judgeData {
    if ([MobilePhone isValidMobile:_phoneTF.text] == NO) {
        [CddHUD showTextOnlyDelay:@"请输入正确手机号" view:self.view];
        return NO;
    } else if (_productNameTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入供应产品名称" view:self.view];
        return NO;
    }
    return YES;
}

//设置输入框
- (void)setTFProperty:(UITextField *)tf {
    tf.font = [UIFont systemFontOfSize:13];
    tf.backgroundColor = HEXColor(@"#E8E8E8", 1);
    tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 20)];
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.textColor = HEXColor(@"#1E2226", 1);
    tf.layer.borderWidth = 0.7f;
    tf.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
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


@end
