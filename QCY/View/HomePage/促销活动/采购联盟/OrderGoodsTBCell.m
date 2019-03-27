//
//  OrderGoodsTBCell.m
//  QCY
//
//  Created by i7colors on 2019/3/2.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "OrderGoodsTBCell.h"
#import "BEMCheckBox.h"
#import "MacroHeader.h"
#import "UIView+Geometry.h"
#import <Masonry.h>
#import "PrchaseLeagueModel.h"
#import "SelectedView.h"
#import <BRPickerView.h>
#import "HelperTool.h"
#import "SelectStandardView.h"

@interface OrderGoodsTBCell()<BEMCheckBoxDelegate, UITextFieldDelegate>
@property (nonatomic, strong)BEMCheckBox *checkBox;
@property (nonatomic, strong)UILabel *productName;
@property (nonatomic, strong)UILabel *isCustomLab;
@property (nonatomic, strong)UITextField *reserveTF;
@property (nonatomic, strong)SelectedView *standardSelect;
@property (nonatomic, assign)BOOL isHaveDian;
@property (nonatomic, strong)UILabel *tipLab;

@end


@implementation OrderGoodsTBCell

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
    //    checkBox.enabled = NO;
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
    UILabel *reserveTxt = [[UILabel alloc] initWithFrame:CGRectMake(checkBox.left, checkBox.bottom + 20, 100, 14)];
    reserveTxt.text = @"预定量:";
    reserveTxt.font = [UIFont systemFontOfSize:12];
    reserveTxt.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:reserveTxt];
    [reserveTxt sizeToFit];
    
    //预定量TF
    UITextField *reserveTF = [[UITextField alloc] init];
    reserveTF.delegate = self;
    reserveTF.backgroundColor = HEXColor(@"#F7F7F7", 1);
    reserveTF.layer.borderColor = HEXColor(@"#E5E5E5", 1).CGColor;
    reserveTF.layer.borderWidth = 1.f;
    reserveTF.layer.cornerRadius = 3.f;
    reserveTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    reserveTF.leftViewMode = UITextFieldViewModeAlways;
    [reserveTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    reserveTF.textColor = HEXColor(@"#F10215", 1);
    reserveTF.font = [UIFont systemFontOfSize:16];
    reserveTF.frame = CGRectMake(reserveTxt.right + 20, 0, 100, 24);
    reserveTF.centerY = reserveTxt.centerY;
    reserveTF.keyboardType = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:reserveTF];
    _reserveTF = reserveTF;
    
    //单位 - 吨
    UILabel *numUnit = [[UILabel alloc] initWithFrame:CGRectMake(reserveTF.right + 5, reserveTxt.top, 50, 14)];
    numUnit.centerY = reserveTxt.centerY;
    numUnit.text = @"吨";
    numUnit.font = [UIFont systemFontOfSize:12];
    numUnit.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:numUnit];
    [numUnit sizeToFit];
    
    //参考标准文字
    UILabel *standardTxt = [[UILabel alloc] init];
    standardTxt.centerY = reserveTxt.centerY;
    standardTxt.text = @"参考标准:";
    standardTxt.font = [UIFont systemFontOfSize:12];
    standardTxt.textColor = HEXColor(@"#868686", 1);
    [self.contentView addSubview:standardTxt];
    [standardTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(reserveTxt);
        make.top.mas_equalTo(reserveTxt.mas_bottom).offset(22);
        make.height.mas_equalTo(14);
    }];
    [standardTxt sizeToFit];
    
    //选择参考标准
    SelectedView *standardSelect = [[SelectedView alloc] init];
    standardSelect.textLabel.text = @"请选择";
    [HelperTool addTapGesture:standardSelect withTarget:self andSEL:@selector(selectStandard)];
    standardSelect.layer.cornerRadius = 3.f;
    [self.contentView addSubview:standardSelect];
    [standardSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(reserveTF);
        make.height.mas_equalTo(24);
        make.centerY.mas_equalTo(standardTxt);
        make.right.mas_equalTo(-20);
    }];
    _standardSelect = standardSelect;
    
}

- (void)setModel:(MeetingShopListModel *)model {
    _model = model;
    _productName.text = model.shopName;
    _checkBox.on = model.isSelect;
    _isCustomLab.hidden = !model.isCustom;
    _tipLab.hidden = _isCustomLab.hidden;
    //预定量输入框
    _reserveTF.text = model.reservationNum;
    
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
        if (weakself.model.reservationNum.length != 0 && alreadySelArr.count != 0) {
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

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 6;
    [super setFrame:frame];
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
                if ([textField.text pathExtension].length > 2) {
                    return NO;
                }
            }
        }
        
    }
    
    return YES;
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
    if (_model.reservationNum.length == 0 || alreadySelArr.count == 0) {
        _checkBox.on = NO;
    }
    _model.isSelect = _checkBox.on;
}

- (void)textFieldTextDidChange:(UITextField *)tf {
    _model.reservationNum = tf.text;
    if (![_standardSelect.textLabel.text isEqualToString:@"请选择"] && ![tf.text isEqualToString:@""]) {
        _checkBox.on = YES;
    } else {
        _checkBox.on = NO;
    }
    _model.isSelect = _checkBox.on;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"OrderGoodsTBCell";
    OrderGoodsTBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[OrderGoodsTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

