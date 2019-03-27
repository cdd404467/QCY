//
//  SupplyGoodsTBCell.m
//  QCY
//
//  Created by i7colors on 2019/3/2.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//
#import "SupplyGoodsTBCell.h"
#import "BEMCheckBox.h"
#import "MacroHeader.h"
#import "UIView+Geometry.h"
#import <Masonry.h>
#import "PrchaseLeagueModel.h"
#import "SelectedView.h"
#import <BRPickerView.h>
#import "HelperTool.h"
#import "SelectStandardView.h"
#import "TimeAbout.h"
#import "HelperTool.h"


@interface SupplyGoodsTBCell()<BEMCheckBoxDelegate,UITextFieldDelegate>
@property (nonatomic, strong)BEMCheckBox *checkBox;
@property (nonatomic, strong)UILabel *productName;
@property (nonatomic, strong)UILabel *isCustomLab;
@property (nonatomic, strong)UITextField *orderTF;
@property (nonatomic, strong)UITextField *priceTF;
@property (nonatomic, strong)SelectedView *standardSelect;
@property (nonatomic, strong)SelectedView *dateSelectedView;
@property (nonatomic, assign)BOOL isHaveDian;
@property (nonatomic, strong)UILabel *tipLab;
@end

@implementation SupplyGoodsTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    //单选框
    BEMCheckBox *checkBox = [[BEMCheckBox alloc] init];
    checkBox.frame = CGRectMake(9, 16, 22, 22);
    checkBox.delegate = self;
    checkBox.boxType = BEMBoxTypeSquare;
    checkBox.onAnimationType = BEMAnimationTypeFade;
    checkBox.offAnimationType = BEMAnimationTypeFade;
    checkBox.onCheckColor = [UIColor whiteColor];
    checkBox.onTintColor = HEXColor(@"#F10215", 1);
    checkBox.onFillColor = HEXColor(@"#F10215", 1);
    checkBox.lineWidth = 1.f;
    [self.contentView addSubview:checkBox];
    _checkBox = checkBox;
    //产品名字
    UILabel *productName = [[UILabel alloc] init];
    productName.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:productName];
    [productName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(checkBox.mas_right).offset(26);
        make.centerY.mas_equalTo(checkBox);
        make.height.mas_equalTo(16);
        make.right.mas_equalTo(-9);
    }];
    _productName = productName;
    
    //是否是自定义的标签
    UILabel *isCustomLab = [[UILabel alloc] init];
    isCustomLab.text = @"自定义商品";
    isCustomLab.font = [UIFont systemFontOfSize:12];
    isCustomLab.textColor = [UIColor whiteColor];
    isCustomLab.textAlignment = NSTextAlignmentCenter;
    isCustomLab.hidden = YES;
    isCustomLab.backgroundColor = HEXColor(@"#F10215", 1);
    [self.contentView addSubview:isCustomLab];
    [isCustomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(productName);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(16);
        make.top.mas_equalTo(0);
    }];
    _isCustomLab = isCustomLab;
    
    
    //提示删除lab
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.text = @"左滑可删除";
    tipLab.hidden = YES;
    tipLab.font = [UIFont systemFontOfSize:12];
    tipLab.textColor = isCustomLab.backgroundColor;
    [self.contentView addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(isCustomLab.mas_right).offset(10);
        make.width.height.top.mas_equalTo(isCustomLab);
    }];
    _tipLab = tipLab;
    
    //预定量文字
    UILabel *orderTxt = [[UILabel alloc] initWithFrame:CGRectMake(checkBox.left, checkBox.bottom + 20, 100, 14)];
    orderTxt.text = @"供货量:";
    orderTxt.font = [UIFont systemFontOfSize:12];
    orderTxt.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:orderTxt];
    [orderTxt sizeToFit];
    
    //预定量TF
    UITextField *orderTF = [[UITextField alloc] init];
    orderTF.delegate = self;
    orderTF.backgroundColor = HEXColor(@"#F7F7F7", 1);
    orderTF.layer.borderColor = HEXColor(@"#E5E5E5", 1).CGColor;
    orderTF.layer.borderWidth = 1.f;
    orderTF.layer.cornerRadius = 3.f;
    orderTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    orderTF.leftViewMode = UITextFieldViewModeAlways;
    [orderTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    orderTF.textColor = HEXColor(@"#F10215", 1);
    orderTF.font = [UIFont systemFontOfSize:16];
    orderTF.frame = CGRectMake(orderTxt.right + 30, 0, SCREEN_WIDTH - orderTxt.right - 140, 24);
    orderTF.centerY = orderTxt.centerY;
    orderTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:orderTF];
    _orderTF = orderTF;
    
    //单位 - 吨
    UILabel *numUnit = [[UILabel alloc] initWithFrame:CGRectMake(orderTF.right + 5, orderTF.top, 50, 14)];
    numUnit.centerY = orderTF.centerY;
    numUnit.text = @"吨";
    numUnit.font = [UIFont systemFontOfSize:12];
    numUnit.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:numUnit];
    [numUnit sizeToFit];
    
    //价格文字
    UILabel *priceTxt = [[UILabel alloc] initWithFrame:CGRectMake(checkBox.left, orderTxt.bottom + 22, 100, 14)];
    priceTxt.text = @"价格:";
    priceTxt.font = [UIFont systemFontOfSize:12];
    priceTxt.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:priceTxt];
    [orderTxt sizeToFit];
    
    //价格TF
    UITextField *priceTF = [[UITextField alloc] init];
    priceTF.delegate = self;
    priceTF.backgroundColor = HEXColor(@"#F7F7F7", 1);
    priceTF.layer.borderColor = HEXColor(@"#E5E5E5", 1).CGColor;
    priceTF.layer.borderWidth = 1.f;
    priceTF.layer.cornerRadius = 3.f;
    priceTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    priceTF.leftViewMode = UITextFieldViewModeAlways;
    [priceTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    priceTF.textColor = HEXColor(@"#F10215", 1);
    priceTF.font = [UIFont systemFontOfSize:16];
    priceTF.frame = CGRectMake(orderTF.left, 0, orderTF.width, 24);
    priceTF.centerY = priceTxt.centerY;
    priceTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:priceTF];
    _priceTF = priceTF;
    
    //单位 - 元/KG
    UILabel *priceUnit = [[UILabel alloc] initWithFrame:CGRectMake(priceTF.right + 5, priceTF.top, 50, 14)];
    priceUnit.centerY = priceTxt.centerY;
    priceUnit.text = @"元/KG";
    priceUnit.font = [UIFont systemFontOfSize:12];
    priceUnit.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:priceUnit];
    [priceUnit sizeToFit];
    
    //参考标准文字
    UILabel *standardTxt = [[UILabel alloc] initWithFrame:CGRectMake(priceTxt.left, priceTxt.bottom + 22, 100, 14)];
    standardTxt.text = @"参考标准:";
    standardTxt.font = [UIFont systemFontOfSize:12];
    standardTxt.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:standardTxt];
    [standardTxt sizeToFit];
    
    //选择参考标准
    SelectedView *standardSelect = [[SelectedView alloc] initWithFrame:CGRectMake(priceTF.left, 0, priceTF.width + 100, 24)];
    standardSelect.centerY = standardTxt.centerY;
    standardSelect.textLabel.text = @"请选择";
    [HelperTool addTapGesture:standardSelect withTarget:self andSEL:@selector(selectStandard)];
    standardSelect.layer.cornerRadius = 3.f;
    [self.contentView addSubview:standardSelect];
    _standardSelect = standardSelect;
    
    //报价有效期
    UILabel *dateTxt = [[UILabel alloc] initWithFrame:CGRectMake(priceTxt.left, standardTxt.bottom + 22, 100, 14)];
    dateTxt.text = @"报价有效期:";
    dateTxt.font = [UIFont systemFontOfSize:12];
    dateTxt.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:dateTxt];
    [dateTxt sizeToFit];

    //报价有效期
    SelectedView *dateSelectedView = [[SelectedView alloc] initWithFrame:CGRectMake(standardSelect.left, 0, standardSelect.width, 24)];
    dateSelectedView.centerY = dateTxt.centerY;
    dateSelectedView.textLabel.text = @"请选择时间";
    [HelperTool addTapGesture:dateSelectedView withTarget:self andSEL:@selector(showPickView_seleTime)];
    [self addSubview:dateSelectedView];
    _dateSelectedView = dateSelectedView;
    
}

- (void)setModel:(MeetingShopListModel *)model {
    _model = model;
    _productName.text = model.shopName;
    _checkBox.on = model.isSelect;
    _isCustomLab.hidden = !model.isCustom;
    _tipLab.hidden = _isCustomLab.hidden;
    _priceTF.text = model.price;
    //预定量输入框
    _orderTF.text = model.outputNum;
    //参考标准
    NSMutableArray *alreadySelArr = [NSMutableArray arrayWithCapacity:0];
    for (MeetingTypeListModel *m in model.meetingTypeList) {
        //遍历模型，从meetingTypeList拿出已经打钩的标准，准备展示出来
        if (m.isSelectStand == YES) {
            [alreadySelArr addObject:m];
        }
    }

    if (alreadySelArr.count != 0) {
        NSMutableArray *stArr = [NSMutableArray arrayWithCapacity:0];
        for (MeetingTypeListModel *m in alreadySelArr) {
            [stArr addObject:m.referenceType];
        }
        _standardSelect.textLabel.text = [stArr componentsJoinedByString:@","];
    } else {
        _standardSelect.textLabel.text = @"请选择";
    }
    
    //报价有效期
    if (model.effectiveTime.length < 5) {
        _dateSelectedView.textLabel.text = @"请选择时间";
    } else {
        _dateSelectedView.textLabel.text = model.effectiveTime;
    }
}

- (void)textFieldTextDidChange:(UITextField *)tf {
    if (tf == _orderTF) {
        _model.outputNum = tf.text;
    } else if (tf == _priceTF) {
        _model.price = tf.text;
    }
    
    if (![_standardSelect.textLabel.text isEqualToString:@"请选择"] && ![_dateSelectedView.textLabel.text isEqualToString:@"请选择时间"] && ![_orderTF.text isEqualToString:@""] && ![_priceTF.text isEqualToString:@""]) {
        _checkBox.on = YES;
    } else {
        _checkBox.on = NO;
    }
    _model.isSelect = _checkBox.on;
}

//点击按钮选择标准
- (void)selectStandard {
    if (_model.meetingTypeList.count == 0) {
        return;
    }
    [self endEditing:YES];
    DDWeakSelf;
    SelectStandardView *view = [[SelectStandardView alloc] init];
    //标准数组传过去
    view.productName = _productName.text;
    view.standArr = _model.meetingTypeList;
    view.okBtnClickBlock = ^{
        NSMutableArray *alreadySelArr = [NSMutableArray arrayWithCapacity:0];
        for (MeetingTypeListModel *m in weakself.model.meetingTypeList) {
            //遍历模型，从meetingTypeList拿出已经打钩的标准，准备展示出来
            if (m.isSelectStand == YES) {
                [alreadySelArr addObject:m];
            }
        }
        
        //输入框有文本且选择的标准时,自动打钩
        if (weakself.model.outputNum.length != 0 && alreadySelArr.count != 0 && weakself.model.price.length != 0 && weakself.model.effectiveTime.length != 0) {
            weakself.checkBox.on = YES;
        } else {
            weakself.checkBox.on = NO;
        }
        weakself.model.isSelect = weakself.checkBox.on;
        
        if (alreadySelArr.count != 0) {
            NSMutableArray *stArr = [NSMutableArray arrayWithCapacity:0];
            for (MeetingTypeListModel *m in alreadySelArr) {
                [stArr addObject:m.referenceType];
            }
            weakself.standardSelect.textLabel.text = [stArr componentsJoinedByString:@","];
        } else {
            weakself.standardSelect.textLabel.text = @"请选择";
        }
    };
    [UIApplication.sharedApplication.keyWindow addSubview:view];
}

//复选框代理
- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    //如果输入框或者参考标准，有一个没选就不能钩
    NSMutableArray *alreadySelArr = [NSMutableArray arrayWithCapacity:0];
    for (MeetingTypeListModel *m in _model.meetingTypeList) {
        //遍历模型，从meetingTypeList拿出已经打钩的标准，准备展示出来
        if (m.isSelectStand == YES) {
            [alreadySelArr addObject:m];
        }
    }
    if (_model.outputNum.length == 0 || alreadySelArr.count == 0 || _model.price.length == 0 || _dateSelectedView.textLabel.text.length < 7) {
        _checkBox.on = NO;
    }
    _model.isSelect = _checkBox.on;
}

//结束时间
- (void)showPickView_seleTime {
    [self endEditing:YES];
    DDWeakSelf;
//    //开始日期
//    NSDate *minDate = [TimeAbout getNDay:3];
    NSDate *minDate = [NSDate date];
//    //最大日期
//    NSDate *maxDate = [TimeAbout getNDay:30];
    NSDate *maxDate = [NSDate br_setYear:2030 month:1 day:1];
    [BRDatePickerView showDatePickerWithTitle:@"选择报价有效时间" dateType:BRDatePickerModeYMD defaultSelValue:[TimeAbout stringFromDate:minDate] minDate:minDate maxDate:maxDate isAutoSelect:NO themeColor:MainColor resultBlock:^(NSString *selectValue) {
        weakself.dateSelectedView.textLabel.text = selectValue;
        weakself.model.effectiveTime = selectValue;
        
        if (weakself.model.outputNum.length != 0 && ![weakself.standardSelect.textLabel.text isEqualToString:@"请选择"] && weakself.model.price.length != 0) {
            weakself.checkBox.on = YES;
        } else {
            weakself.checkBox.on = NO;
        }
        weakself.model.isSelect = weakself.checkBox.on;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if (textField == _orderTF) {
                    if ([textField.text pathExtension].length > 2) {
                        return NO;
                    }
                } else {
                    if ([textField.text pathExtension].length > 1) {
                        return NO;
                    }
                }
            }
        }
    }
    
    return YES;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 6;
    [super setFrame:frame];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"SupplyGoodsTBCell";
    SupplyGoodsTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SupplyGoodsTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
