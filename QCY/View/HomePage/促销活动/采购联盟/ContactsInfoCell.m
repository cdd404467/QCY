//
//  ContactsInfoCell.m
//  QCY
//
//  Created by i7colors on 2019/2/21.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ContactsInfoCell.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import <BRPickerView.h>
#import "HelperTool.h"
#import "UITextView+Placeholder.h"
#import "UITextField+Limit.h"
#import <UIImageView+WebCache.h>
#import "UIView+Geometry.h"
#import "PrchaseLeagueModel.h"

@interface ContactsInfoCell()<UITextFieldDelegate, UITextViewDelegate>

@end

@implementation ContactsInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = LineColor;
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.8);
    }];
    
    CGFloat topGap = 20;
    NSArray *titleArr = @[@"公司名称:",@"联系人:",@"职务:",@"联系电话:",@"付款方式:",@"账期:",@"区域:",@"详细地址:"];
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArr[i];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = HEXColor(@"#3C3C3C", 1);
        titleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(topGap * (i + 1) + 24 * i);
            make.width.mas_equalTo(KFit_W(80));
            make.height.mas_equalTo(24);
        }];
        if (i != 7) {
            UIImageView *tabIcon = [[UIImageView alloc] init];
            tabIcon.image = [UIImage imageNamed:@"tab_icon"];
            [self.contentView addSubview:tabIcon];
            [tabIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(titleLabel);
                make.right.mas_equalTo(titleLabel.mas_left).offset(-5);
                make.width.height.mas_equalTo(4);
            }];
        }
    }
    
    //公司名称
    UITextField *companyTF = [[UITextField alloc] initWithFrame:CGRectMake(90, topGap, SCREEN_WIDTH - 100,  24)];
    companyTF.font = [UIFont systemFontOfSize:12];
    companyTF.layer.cornerRadius = 3.f;
    companyTF.textColor = HEXColor(@"#1E2226", 1);
    companyTF.leftViewMode = UITextFieldViewModeAlways;
    companyTF.placeholder = @"请输入公司名称";
    companyTF.layer.borderWidth = 1.f;
    companyTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 30)];
    companyTF.delegate = self;
    [companyTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    companyTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [self.contentView addSubview:companyTF];
    _companyTF = companyTF;

    //联系人
    UITextField *contactTF = [[UITextField alloc] initWithFrame:CGRectMake(companyTF.left, companyTF.bottom + topGap, SCREEN_WIDTH - 100,  companyTF.height)];
    contactTF.font = [UIFont systemFontOfSize:12];
    contactTF.layer.cornerRadius = 3.f;
    contactTF.textColor = HEXColor(@"#1E2226", 1);
    contactTF.leftViewMode = UITextFieldViewModeAlways;
    contactTF.placeholder = @"请输入联系人";
    contactTF.layer.borderWidth = 1.f;
    contactTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 30)];
    contactTF.delegate = self;
    [contactTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    contactTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [self.contentView addSubview:contactTF];
    _contactTF = contactTF;
    
    //职务
    UITextField *workTF = [[UITextField alloc] initWithFrame:CGRectMake(companyTF.left, contactTF.bottom + topGap, SCREEN_WIDTH - 100,  companyTF.height)];
    workTF.font = [UIFont systemFontOfSize:12];
    workTF.layer.cornerRadius = 3.f;
    workTF.textColor = HEXColor(@"#1E2226", 1);
    workTF.leftViewMode = UITextFieldViewModeAlways;
    workTF.placeholder = @"请输入职务";
    workTF.layer.borderWidth = 1.f;
    workTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 30)];
    workTF.delegate = self;
    [workTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    workTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [self.contentView addSubview:workTF];
    _workTF = workTF;
    
    //联系电话
    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(companyTF.left, workTF.bottom + topGap, SCREEN_WIDTH - 100,  companyTF.height)];
    phoneTF.font = [UIFont systemFontOfSize:12];
    phoneTF.layer.cornerRadius = 3.f;
    phoneTF.textColor = HEXColor(@"#1E2226", 1);
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.leftViewMode = UITextFieldViewModeAlways;
    phoneTF.placeholder = @"请输入联系电话";
    phoneTF.layer.borderWidth = 1.f;
    phoneTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 30)];
    phoneTF.delegate = self;
    [phoneTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    phoneTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [self.contentView addSubview:phoneTF];
    //限制字数
    [phoneTF lengthLimit:^{
        if (phoneTF.text.length > 11) {
            phoneTF.text = [phoneTF.text substringToIndex:11];
        }
    }];
    _phoneTF = phoneTF;
    
    //付款方式
    SelectedView *paySelect = [[SelectedView alloc] initWithFrame:CGRectMake(companyTF.left, phoneTF.bottom + topGap, SCREEN_WIDTH - 100,  companyTF.height)];
    paySelect.textLabel.text = @"请选择付款方式";
    [HelperTool addTapGesture:paySelect withTarget:self andSEL:@selector(paytypeSelect)];
    paySelect.layer.cornerRadius = 3.f;
    [self.contentView addSubview:paySelect];
    _paySelect = paySelect;
    
    //帐期
    SelectedView *dateSelect = [[SelectedView alloc] initWithFrame:CGRectMake(companyTF.left, paySelect.bottom + topGap, SCREEN_WIDTH - 100,  companyTF.height)];
    dateSelect.textLabel.text = @"选择结账期";
    [HelperTool addTapGesture:dateSelect withTarget:self andSEL:@selector(showPickView)];
    dateSelect.layer.cornerRadius = 3.f;
    [self.contentView addSubview:dateSelect];
    _dateSelect = dateSelect;
    
    //区域
    SelectedView *areaSelect = [[SelectedView alloc] initWithFrame:CGRectMake(companyTF.left, dateSelect.bottom + topGap, SCREEN_WIDTH - 100,  companyTF.height)];
    areaSelect.textLabel.text = @"请选择区域";
    [HelperTool addTapGesture:areaSelect withTarget:self andSEL:@selector(showPickView_area)];
    areaSelect.layer.cornerRadius = 3.f;
    [self.contentView addSubview:areaSelect];
    _areaSelect = areaSelect;
    
    //详细地址
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(companyTF.left, areaSelect.bottom + topGap, SCREEN_WIDTH - 100,  companyTF.height * 2)];
    textView.backgroundColor = HEXColor(@"#E8E8E8", 1);
    textView.placeholder = @"请输入详细地址";
    textView.delegate = self;
    textView.placeholderColor = HEXColor(@"#868686", 1);
    textView.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:textView];
    _textView = textView;
}

- (void)textFieldTextDidChange:(UITextField *)tf {
    if (tf == _companyTF) {
        _model.companyTF_data = tf.text;
    } else if (tf == _contactTF) {
        _model.contactTF_data = tf.text;
    } else if (tf == _workTF) {
        _model.workTF_data = tf.text;
    } else if (tf == _phoneTF) {
        _model.phoneTF_data = tf.text;
    }
}
//textView输入监听
- (void)textViewDidChange:(UITextView *)textView
{
    _model.detailArea_data = textView.text;
}

- (void)paytypeSelect {
    [self endEditing:YES];
    NSArray *titleArr = @[@"现汇",@"银行承兑"];
    DDWeakSelf;
    [BRStringPickerView showStringPickerWithTitle:@"请选择付款方式" dataSource:titleArr defaultSelValue:nil isAutoSelect:NO themeColor:MainColor resultBlock:^(id selectValue) {
        weakself.paySelect.textLabel.text = selectValue;
        weakself.model.paySelect_data = selectValue;
    }];
    
}
//帐期选择
- (void)showPickView {
    [self endEditing:YES];
    DDWeakSelf;
    [BRStringPickerView showStringPickerWithTitle:@"选择结帐期" dataSource:_model.accountPeriod defaultSelValue:nil isAutoSelect:NO themeColor:MainColor resultBlock:^(id selectValue) {
        weakself.dateSelect.textLabel.text = selectValue;
        weakself.model.dateSelect_data = selectValue;
    }];
}

//地址选择
- (void)showPickView_area {
    [self endEditing:YES];
    DDWeakSelf;
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeCity dataSource:nil defaultSelected:nil isAutoSelect:NO themeColor:MainColor resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        NSString *areaStr = [NSString stringWithFormat:@"%@-%@", province.name, city.name];
        weakself.areaSelect.textLabel.text = areaStr;
        weakself.model.areaSelect_data = areaStr;
    } cancelBlock:^{
        //        NSLog(@"点击了背景视图或取消按钮");
    }];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ContactsInfoCell";
    ContactsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ContactsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
