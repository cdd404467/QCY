//
//  AskForDemoVC.m
//  QCY
//
//  Created by i7colors on 2020/3/24.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AskForDemoVC.h"
#import <YYText.h>
#import "SelectedView.h"
#import "ClassTool.h"
#import "HelperTool.h"
#import "UITextView+Placeholder.h"
#import "CddHUD.h"
#import "NetWorkingPort.h"
#import "BRPickerView.h"
#import "MobilePhone.h"
#import "ProxySaleModel.h"
#import "UITextField+Limit.h"

@interface AskForDemoVC ()<UITextFieldDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITextField *buyNumTF;
@property (nonatomic, strong)UITextField *contactTF;
@property (nonatomic, strong)UITextField *phoneTF;
@property (nonatomic, strong)UITextField *companyTF;
@property (nonatomic, strong)SelectedView *placeArea;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, assign)BOOL isHaveDian;
@end

@implementation AskForDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([_pageType isEqualToString:@"buy"]) {
        self.title = @"我要购买";
    } else {
        self.title = @"索取样品";
    }
    [self.view addSubview:self.scrollView];
    [self getDefaultInfo];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
        //150 + 680 + 6
//        sv.contentSize = CGSizeMake(SCREEN_WIDTH, 600);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

//自动填充
- (void)getDefaultInfo {
    NSString *urlString = [NSString stringWithFormat:URL_Default_Address,User_Token];
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//        NSLog(@"---- %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"] && isRightData(To_String(json[@"data"]))) {
            [weakself setupUIWithInfoDict:json[@"data"]];
        } else {
            [weakself setupUIWithInfoDict:nil];
        }
    } Failure:^(NSError *error) {
        NSLog(@" Error : %@",error);
    }];
}

- (void)setupUIWithInfoDict:(NSDictionary *)dict {
    CGFloat newCoordinateHeight ;
    //提示
    YYLabel *tipLabel = [[YYLabel alloc] init];
    
    NSString *text = [NSString string];
    if ([_pageType isEqualToString:@"buy"]) {
        text = @"购买提交后，平台客服人员将在1个工作日内与您电话联系。 确认最终交易细节，签订合同！";
    } else {
        text = @"索要样品后，平台客服人员将在1个工作日内与您电话联系，安排寄样！";
    }
    
    tipLabel.numberOfLines = 0;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGFloat fitHeight = [self getMessageHeight:text andLabel:tipLabel];
    tipLabel.frame = CGRectMake(KFit_W(8), 10, SCREEN_WIDTH - KFit_W(8) * 2, fitHeight + 20);
    newCoordinateHeight = 10 + fitHeight + 20;
    [self.scrollView addSubview:tipLabel];
    tipLabel.layer.borderWidth = 1.f;
    tipLabel.layer.borderColor = HEXColor(@"#ED3851", 1).CGColor;
    tipLabel.layer.cornerRadius = 8.f;
    
    
    CGFloat gap = 22.f;
    //for循环创建
    NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"联系人:",@"联系人方式:", @"公司名称:",@"公司所属区域:",@"公司详细地址:", nil];
    if ([_pageType isEqualToString:@"buy"]) {
        [titleArr insertObject:@"我的购买量" atIndex:0];
    }
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArr[i];
        titleLabel.textColor = HEXColor(@"#3C3C3C", 1);
        titleLabel.font = [UIFont systemFontOfSize:12];
        //        titleLabel.frame = CGRectMake(18, 20 * (i + 1) + 32 * i + 9, KFit_W(80), 14);
        [_scrollView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(tipLabel.mas_bottom).offset(gap * (i + 1) + 32 * i);
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
    /****** 自动填写信息 ******/
    if ([_pageType isEqualToString:@"buy"]) {
        UITextField *buyNumTF = [[UITextField alloc] init];
        buyNumTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
        buyNumTF.font = [UIFont systemFontOfSize:12];
        buyNumTF.textColor = HEXColor(@"#1E2226", 1);
        buyNumTF.leftViewMode = UITextFieldViewModeAlways;
        buyNumTF.layer.borderWidth = 1.f;
        buyNumTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KFit_W(12), 30)];
        buyNumTF.placeholder = @"请输入购买量";
        buyNumTF.delegate = self;
        buyNumTF.keyboardType = UIKeyboardTypeDecimalPad;
        buyNumTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
        [_scrollView addSubview:buyNumTF];
        [buyNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(KFit_W(120));
            make.top.mas_equalTo(newCoordinateHeight + gap);
            make.width.mas_equalTo(KFit_W(105));
            make.height.mas_equalTo(32);
        }];
        _buyNumTF = buyNumTF;
        
        UILabel *numLab = [[UILabel alloc] init];
        numLab.text = [NSString stringWithFormat:@"0吨<购买量<%@吨",_dataSource.remainNum];
        numLab.textColor = HEXColor(@"#ED3851", 1);
        numLab.font = [UIFont systemFontOfSize:12];
        [_scrollView addSubview:numLab];
        [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(buyNumTF.mas_right).offset(15);
            make.centerY.mas_equalTo(buyNumTF);
            make.right.mas_equalTo(self.view.mas_right).offset(-9);
        }];
    }
    
    //联系人
    UITextField *contactTF = [[UITextField alloc] init];
    contactTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
    contactTF.font = [UIFont systemFontOfSize:12];
    contactTF.textColor = HEXColor(@"#1E2226", 1);
    contactTF.leftViewMode = UITextFieldViewModeAlways;
    contactTF.layer.borderWidth = 1.f;
    contactTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KFit_W(12), 30)];
    contactTF.placeholder = @"请输入联系人";
    contactTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [_scrollView addSubview:contactTF];
    [contactTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KFit_W(120));
        if ([_pageType isEqualToString:@"buy"]) {
            make.top.mas_equalTo(newCoordinateHeight + gap * 2 + 32);
        } else {
            make.top.mas_equalTo(newCoordinateHeight + gap);
        }
        make.right.mas_equalTo(self.view.mas_right).offset(-9);
        make.height.mas_equalTo(32);
    }];
    _contactTF = contactTF;
    if isRightData(dict[@"contact"])
        contactTF.text = dict[@"contact"];
    
    //联系人方式
    UITextField *phoneTF = [[UITextField alloc] init];
    phoneTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
    phoneTF.font = [UIFont systemFontOfSize:12];
    phoneTF.textColor = HEXColor(@"#1E2226", 1);
    phoneTF.leftViewMode = UITextFieldViewModeAlways;
    phoneTF.layer.borderWidth = 1.f;
    phoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KFit_W(12), 30)];
    phoneTF.placeholder = @"请输入联系方式";
    phoneTF.maxLength = 11;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [_scrollView addSubview:phoneTF];
    [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contactTF.mas_bottom).offset(gap);
        make.height.left.right.mas_equalTo(contactTF);
    }];
    _phoneTF = phoneTF;
    if isRightData(dict[@"phone"])
        phoneTF.text = dict[@"phone"];
    
    //联系人公司
    UITextField *companyTF = [[UITextField alloc] init];
    companyTF.backgroundColor = HEXColor(@"#E8E8E8", 1);
    companyTF.font = [UIFont systemFontOfSize:12];
    companyTF.textColor = HEXColor(@"#1E2226", 1);
    companyTF.leftViewMode = UITextFieldViewModeAlways;
    companyTF.layer.borderWidth = 1.f;
    companyTF.placeholder = @"请输入公司名称";
    companyTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KFit_W(12), 30)];
    companyTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [_scrollView addSubview:companyTF];
    [companyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(phoneTF.mas_bottom).offset(gap);
        make.height.left.right.mas_equalTo(contactTF);
    }];
    _companyTF = companyTF;
    if isRightData(dict[@"companyName"])
        companyTF.text = dict[@"companyName"];
    
    //公司所在区域
    SelectedView *placeArea = [[SelectedView alloc] init];
    placeArea.textLabel.text = @"请选择地区";
    [_scrollView addSubview:placeArea];
    [HelperTool addTapGesture:placeArea withTarget:self andSEL:@selector(showPickView_area)];
    [placeArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(companyTF.mas_bottom).offset(gap);
        make.height.left.right.mas_equalTo(contactTF);
    }];
    _placeArea = placeArea;
    if (isRightData(dict[@"province"]) && isRightData(dict[@"city"]))
        placeArea.textLabel.text = [NSString stringWithFormat:@"%@-%@",dict[@"province"],dict[@"city"]];
    
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
        make.top.mas_equalTo(placeArea.mas_bottom).offset(gap);
    }];
    _textView = textView;
    if isRightData(dict[@"address"])
        textView.text = dict[@"address"];
    [textView.superview layoutIfNeeded];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, textView.bottom + 30);
    
    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ClassTool addLayer:submitBtn];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
    
}

- (void)submit {
    if ([self judgeRight] == NO) {
        return;
    }
    
    NSArray *areaArray = [_placeArea.textLabel.text componentsSeparatedByString:@"-"];
    NSDictionary *dict = @{@"token":User_Token,
                           @"proxyMarketId":_dataSource.proxyID,
                           @"proxyMarketUpdateId":_dataSource.proxyMarketUpdateId,
                           @"phone":_phoneTF.text,
                           @"contact":_contactTF.text,
                           @"province":areaArray[0],
                           @"city":areaArray[1],
                           @"companyName":_companyTF.text,
                           @"address":_textView.text,
                           @"numUnit":_dataSource.numUnit,
                           @"price":_dataSource.price,
                           @"priceUnit":_dataSource.priceUnit
                           };
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    if ([_pageType isEqualToString:@"buy"]) {
        [mDict setValue:@"buy" forKey:@"buyType"];
        [mDict setValue:_buyNumTF.text forKey:@"num"];
    } else {
        [mDict setValue:@"sample" forKey:@"buyType"];
        [mDict setValue:@" " forKey:@"num"];
    }
    
    DDWeakSelf;
    
    [CddHUD showWithText:@"提交中..." view:self.view];
    [ClassTool postRequest:URLPost_Proxy_Buy_Demo Params:mDict Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
//                        NSLog(@"-----== %@",json);
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            [CddHUD showTextOnlyDelay:@"提交成功" view:weakself.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }
    } Failure:^(NSError *error) {
        
    }];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
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
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    //                    [MBProgressHUD bwm_showTitle:@"第二个字符需要是小数点" toView:self hideAfter:1.0];
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    //                    [MBProgressHUD bwm_showTitle:@"第二个字符需要是小数点" toView:self hideAfter:1.0];
                    return NO;
                }
            }
        }
        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 0) {
                    //                    [MBProgressHUD bwm_showTitle:@"小数点后最多有两位小数" toView:self hideAfter:1.0];
                    return NO;
                }
            }
        }
        
    }
    
    return YES;
}

-  (BOOL)judgeRight {
    if ([_pageType isEqualToString:@"buy"]) {
        if (_buyNumTF.text.length == 0) {
            [CddHUD showTextOnlyDelay:@"请输入购买量" view:self.view];
            return NO;
        } else if (_buyNumTF.text.doubleValue <= 0) {
            [CddHUD showTextOnlyDelay:@"购买量不能为0" view:self.view];
            return NO;
        } else if (_buyNumTF.text.doubleValue > _dataSource.remainNum.doubleValue) {
            [CddHUD showTextOnlyDelay:@"购买量不能大于库存量" view:self.view];
            return NO;
        }
    }
    if (_contactTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入联系人" view:self.view];
        return NO;
    } else if (_phoneTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请输入手机号" view:self.view];
        return NO;
    } else if ([MobilePhone isValidMobile:_phoneTF.text] == NO) {
        [CddHUD showTextOnlyDelay:@"请输入有效的手机号" view:self.view];
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
@end
