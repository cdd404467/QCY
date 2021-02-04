//
//  PostZhuJiDiyVC.m
//  QCY
//
//  Created by i7colors on 2019/8/2.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "PostZhuJiDiyVC.h"
#import "ClassTool.h"
#import "NetWorkingPort.h"
#import <YYText.h>
#import "SelectedView.h"
#import "UIView+Border.h"
#import "UITextView+Placeholder.h"
#import "HelperTool.h"
#import <BRPickerView.h>
#import "TimeAbout.h"
#import "CddHUD.h"
#import "ZhuJiDiyModel.h"


static const CGFloat gap = 20.f;

@interface PostZhuJiDiyVC ()
@property (nonatomic, strong) NSMutableArray *classArray;
@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *companyNameTF;
@property (nonatomic, strong) SelectedView *classView;
@property (nonatomic, strong) UITextField *zhuJiNameTF;
@property (nonatomic, strong) SelectedView *baseMaterialView;
@property (nonatomic, strong) UITextField *useTF;
@property (nonatomic, strong) UITextField *requireTF;
@property (nonatomic, strong) UITextField *phResultTF;
@property (nonatomic, strong) UITextField *dealTechnologyTF;
@property (nonatomic, strong) UITextField *wenDuTF;
@property (nonatomic, strong) UITextField *nowUseTF;
@property (nonatomic, strong) UITextField *productionTF;
@property (nonatomic, strong) UITextField *needNumTF;
@property (nonatomic, strong) UITextField *diynumTF;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) SelectedView *endTimeView;

@property (nonatomic, strong) NSMutableArray *materDataSource;
@property (nonatomic, strong) NSMutableArray *materNameArr;
@end

@implementation PostZhuJiDiyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布助剂定制";
    [self setupUI];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

- (NSMutableArray *)classArray {
    if (!_classArray) {
        _classArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _classArray;
}

- (NSMutableArray *)idArray {
    if (!_idArray) {
        _idArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _idArray;
}

- (NSMutableArray *)nameArr {
    if (!_nameArr) {
        _nameArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _nameArr;
}

- (NSMutableArray *)materDataSource {
    if (!_materDataSource) {
        _materDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _materDataSource;
}

- (NSMutableArray *)materNameArr {
    if (!_materNameArr) {
        _materNameArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _materNameArr;
}

- (void)getZhujiClass {
    if (self.classArray.count > 0) {
        [self selectClass];
        return;
    }
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URLGet_ZhuJiDiy_Classify];
    
    [CddHUD showWithText:@"正在获取分类" view:self.view];
    self.view.userInteractionEnabled = NO;
    
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
            //            NSLog(@"--- %@",json);
            weakself.view.userInteractionEnabled = YES;
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                NSArray *tempArr = [ZhuJiDiyModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [weakself.classArray addObjectsFromArray:tempArr];
                for (ZhuJiDiyModel *model in weakself.classArray) {
                    [weakself.nameArr addObject:model.name];
                    [weakself.idArray addObject:model.zhujiDiyID];
                }
                [weakself selectClass];
            }
        }
        [CddHUD hideHUD:weakself.view];
    } Failure:^(NSError *error) {
        weakself.view.userInteractionEnabled = YES;
        NSLog(@" Error : %@",error);
    }];
}



- (void)postPlan {
    if ([self judgeRight] == NO) {
        return;
    }
    
    NSDictionary *dict = @{@"token":User_Token,
                           @"classId":[self getID],
                           @"zhujiName":_zhuJiNameTF.text,
                           @"endTime":_endTimeView.textLabel.text,
                           @"description":_textView.text,
                           @"material":_baseMaterialView.textLabel.text,
                           @"purpose":_useTF.text,
                           @"requirement":_requireTF.text,
                           @"pH":_phResultTF.text,
                           @"treatmentProcess":_dealTechnologyTF.text,
                           @"temperature":_wenDuTF.text,
                           @"productName":_nowUseTF.text,
                           @"producer":_productionTF.text,
                           @"useNumStr":_needNumTF.text,
                           @"diyNumStr":_diynumTF.text,
                           @"specialId":self.specialID
                           };
    
    
    
    NSMutableDictionary *mDict = [dict mutableCopy];
    if (!isCompanyUser) {
        [mDict setObject:_companyNameTF.text forKey:@"companyName2"];
    }
    
    
//    NSLog(@"--- %@",mDict);
    
    self.view.userInteractionEnabled = NO;
    DDWeakSelf;
    [CddHUD show:self.view];
    [ClassTool postRequest:URLPost_ZhuJiDiy_Post Params:mDict Success:^(id json) {
//        NSLog(@"----- %@",json[@"data"]);
        [CddHUD hideHUD:weakself.view];
        weakself.view.userInteractionEnabled = YES;
        if ([json[@"code"] isEqualToString:@"SUCCESS"]) {
            [CddHUD showTextOnlyDelay:@"发布助剂定制成功" view:weakself.view];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakself.refreshZhuJiDiyListBlock) {
                    weakself.refreshZhuJiDiyListBlock();
                }
                [weakself.navigationController popViewControllerAnimated:YES];
            });
        }
    } Failure:^(NSError *error) {
        weakself.view.userInteractionEnabled = YES;
    }];
}

//获取材质分类
- (void)getBaseMaterial {
    if (self.materNameArr.count > 0) {
        [self selectMater];
        return;
    }
    DDWeakSelf;
    NSString *urlString = [NSString stringWithFormat:URLGet_ZhuJiDiy_Material];
    
    [CddHUD showWithText:@"正在获取材质列表" view:self.view];
    self.view.userInteractionEnabled = NO;
    
    [ClassTool getRequest:urlString Params:nil Success:^(id json) {
        [CddHUD hideHUD:weakself.view];
        if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
//                        NSLog(@"--- %@",json);
            weakself.view.userInteractionEnabled = YES;
            if ([To_String(json[@"code"]) isEqualToString:@"SUCCESS"]) {
                NSArray *tempArr = [ZhuJiDiyModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [weakself.materDataSource addObjectsFromArray:tempArr];
                for (ZhuJiDiyModel *model in weakself.materDataSource) {
                    [weakself.materNameArr addObject:model.name];
                }
                [weakself selectMater];
            }
        }
        [CddHUD hideHUD:weakself.view];
    } Failure:^(NSError *error) {
        weakself.view.userInteractionEnabled = YES;
        NSLog(@" Error : %@",error);
    }];
}

//YYLbael计算高度
- (CGFloat)getMessageHeight:(NSString *)mess andLabel:(YYLabel *)label {
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:mess];
    introText.yy_font = [UIFont systemFontOfSize:12];
    introText.yy_lineSpacing = 7;
    introText.yy_color = HEXColor(@"#3C3C3C", 1);
    introText.yy_firstLineHeadIndent = 10.f;
    introText.yy_headIndent = 5.f;
    introText.yy_tailIndent = -5.f;
    [introText yy_setColor:HEXColor(@"#FF771C", 1) range:NSMakeRange(4, _specialCompanyName.length + 2)];
//    introText.yy_alignment = NSTextAlignmentCenter;
    CGSize introSize = CGSizeMake(SCREEN_WIDTH - 8 * 2, CGFLOAT_MAX);
    label.attributedText = introText;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:introText];
    label.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight;
}

#pragma mark 创建UI
- (void)setupUI {
    [self.view addSubview:self.scrollView];
    
    NSString *text = [NSString stringWithFormat:@"您正在向“%@”发起一对一助剂专场定制，但是也能收到其它供应商助剂定制方案!",self.specialCompanyName];

    YYLabel *tipLab = [[YYLabel alloc] init];
    tipLab.layer.borderColor = HEXColor(@"#FFCCAA", 1).CGColor;
    tipLab.layer.borderWidth = 0.5f;
    tipLab.backgroundColor = HEXColor(@"#FFFAE7", 1);
    [self.scrollView addSubview:tipLab];
    CGFloat height = [self getMessageHeight:text andLabel:tipLab];
//    NSMutableAttributedString *mtext = [[NSMutableAttributedString alloc] initWithString:text];
//    mtext.yy_font = [UIFont systemFontOfSize:12];
//    mtext.yy_color = HEXColor(@"#3C3C3C", 1);
//    [mtext yy_setColor:HEXColor(@"#FF771C", 1) range:NSMakeRange(4, _specialCompanyName.length + 2)];
//    tipLab.attributedText = mtext;
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(self.view.mas_right).offset(-8);
        make.height.mas_equalTo(height + 10);
    }];
    
    //不是企业公司，要填写公司名字
    if (!isCompanyUser) {
        UILabel *companyLab = [[UILabel alloc] init];
        companyLab.text = @"公司名称";
        companyLab.numberOfLines = 2;
        companyLab.textColor = HEXColor(@"#3C3C3C", 1);
        companyLab.font = [UIFont systemFontOfSize:13];
        [_scrollView addSubview:companyLab];
        [companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(tipLab.mas_bottom).offset(gap);
            make.width.mas_equalTo(KFit_W(95));
            make.height.mas_equalTo(32);
        }];
        
        [self addIcon:companyLab];
        
        UITextField *companyNameTF = [[UITextField alloc] init];
        companyNameTF.placeholder = @"请输入公司名称";
        [self setTFProperty:companyNameTF];
        [_scrollView addSubview:companyNameTF];
        _companyNameTF = companyNameTF;
        [companyNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).offset(KFit_W(120));
            make.centerY.height.mas_equalTo(companyLab);
            make.right.mas_equalTo(self.view.mas_right).offset(-8);
        }];
    }
    
    //助剂定制分类
    UILabel *classLabel = [[UILabel alloc] init];
    classLabel.text = @"印染助剂定制分类:";
    classLabel.numberOfLines = 2;
    classLabel.textColor = HEXColor(@"#3C3C3C", 1);
    classLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:classLabel];
    [classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        if (isCompanyUser) {
            make.top.mas_equalTo(tipLab.mas_bottom).offset(gap);
        } else {
            make.top.mas_equalTo(self.companyNameTF.mas_bottom).offset(gap);
        }
        make.width.mas_equalTo(KFit_W(95));
        make.height.mas_equalTo(32);
    }];
    
    [self addIcon:classLabel];
    
    SelectedView *classView = [[SelectedView alloc] init];
    classView.textLabel.text = @"请选择分类";
    classView.textLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:classView];
    [classView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(KFit_W(120));
        make.centerY.height.mas_equalTo(classLabel);
        make.right.mas_equalTo(self.view.mas_right).offset(-8);
    }];
    _classView = classView;
    [HelperTool addTapGesture:classView withTarget:self andSEL:@selector(getZhujiClass)];
    
    //定制助剂名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"定制助剂名称:";
    nameLabel.numberOfLines = classLabel.numberOfLines;
    nameLabel.textColor = classLabel.textColor;
    nameLabel.font = classLabel.font;
    [_scrollView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(classLabel);
        make.top.mas_equalTo(classLabel.mas_bottom).offset(gap);
    }];
    
    [self addIcon:nameLabel];
    
    UITextField *zhuJiNameTF = [[UITextField alloc] init];
    zhuJiNameTF.placeholder = @"例如:仿蜡印增调剂";
    [self setTFProperty:zhuJiNameTF];
    [_scrollView addSubview:zhuJiNameTF];
    _zhuJiNameTF = zhuJiNameTF;
    [zhuJiNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(classView);
        make.top.mas_equalTo(classView.mas_bottom).offset(gap);
    }];
    
    /*** 纺织品属性 ***/
    UILabel *titleLab1 = [[UILabel alloc] init];
    titleLab1.text = @"纺织品属性";
    titleLab1.textColor = HEXColor(@"#708090", 1);
    titleLab1.font = [UIFont boldSystemFontOfSize:15];
    [_scrollView addSubview:titleLab1];
    [titleLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.mas_equalTo(classLabel);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(gap);
        make.right.mas_equalTo(zhuJiNameTF);
    }];
    [titleLab1 layoutIfNeeded];
    [titleLab1 addBorderView:HEXColor(@"#708090", 1) width:.6f direction:BorderDirectionBottom];
    
    NSArray *titleArr1 = @[@"材质(基材):",@"成品用途:",@"环保要求:"];
    [self addLab_iconWithArr:titleArr1 baseLab:titleLab1 isNeedIcon:YES];
    
    //基材
    SelectedView *baseMaterialView = [[SelectedView alloc] init];
    baseMaterialView.textLabel.text = @"请选择材质";
    baseMaterialView.textLabel.font = [UIFont systemFontOfSize:13];
    [_scrollView addSubview:baseMaterialView];
    [baseMaterialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(classView);
        make.top.mas_equalTo(titleLab1.mas_bottom).offset(gap);
    }];
    _baseMaterialView = baseMaterialView;
    [HelperTool addTapGesture:baseMaterialView withTarget:self andSEL:@selector(getBaseMaterial)];
    
    //用途
    UITextField *useTF = [[UITextField alloc] init];
    useTF.placeholder = @"例如:用于工厂工人装面料";
    [self setTFProperty:useTF];
    [_scrollView addSubview:useTF];
    _useTF = useTF;
    [useTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(classView);
        make.top.mas_equalTo(baseMaterialView.mas_bottom).offset(gap);
    }];
    
    //要求
    UITextField *requireTF = [[UITextField alloc] init];
    [self setTFProperty:requireTF];
    [_scrollView addSubview:requireTF];
    _requireTF = requireTF;
    [requireTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(classView);
        make.top.mas_equalTo(useTF.mas_bottom).offset(gap);
    }];
    
    /*** 纺织品属性 ***/
    UILabel *titleLab2 = [[UILabel alloc] init];
    titleLab2.text = @"染整工艺要求";
    titleLab2.textColor = titleLab1.textColor;
    titleLab2.font = titleLab1.font;
    [_scrollView addSubview:titleLab2];
    [titleLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(titleLab1);
        make.top.mas_equalTo(requireTF.mas_bottom).offset(gap);
        
    }];
    [titleLab2 layoutIfNeeded];
    [titleLab2 addBorderView:HEXColor(@"#708090", 1) width:.6f direction:BorderDirectionBottom];
    
    NSArray *titleArr2 = @[@"工作浴PH值:",@"处理工艺:",@"染色温度:"];
    [self addLab_iconWithArr:titleArr2 baseLab:titleLab2 isNeedIcon:NO];
    
    //设备
    UITextField *phResultTF = [[UITextField alloc] init];
    [self setTFProperty:phResultTF];
    [_scrollView addSubview:phResultTF];
    _phResultTF = phResultTF;
    [phResultTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(classView);
        make.top.mas_equalTo(titleLab2.mas_bottom).offset(gap);
    }];
    
    //染料
    UITextField *dealTechnologyTF = [[UITextField alloc] init];
    [self setTFProperty:dealTechnologyTF];
    [_scrollView addSubview:dealTechnologyTF];
    _dealTechnologyTF = dealTechnologyTF;
    [dealTechnologyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(classView);
        make.top.mas_equalTo(phResultTF.mas_bottom).offset(gap);
    }];
    
    //温度
    UITextField *wenDuTF = [[UITextField alloc] init];
    [self setTFProperty:wenDuTF];
    [_scrollView addSubview:wenDuTF];
    _wenDuTF = wenDuTF;
    [wenDuTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(classView);
        make.top.mas_equalTo(dealTechnologyTF.mas_bottom).offset(gap);
    }];
    
    /*** 现用产品说明 ***/
    UILabel *titleLab3 = [[UILabel alloc] init];
    titleLab3.text = @"现用产品说明";
    titleLab3.textColor = titleLab1.textColor;
    titleLab3.font = titleLab1.font;
    [_scrollView addSubview:titleLab3];
    [titleLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.mas_equalTo(titleLab1);
        make.top.mas_equalTo(wenDuTF.mas_bottom).offset(gap);
        
    }];
    [titleLab3 layoutIfNeeded];
    [titleLab3 addBorderView:HEXColor(@"#708090", 1) width:.6f direction:BorderDirectionBottom];
    
    NSArray *titleArr3 = @[@"现用产品名称:",@"生产厂家:",@"每月用量:",@"定制需求量:"];
    for (NSInteger i = 0; i < titleArr3.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArr3[i];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = HEXColor(@"#3C3C3C", 1);
        titleLabel.font = [UIFont systemFontOfSize:13];
        [_scrollView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(titleLab3.mas_bottom).offset((i + 1) * gap + i * 32);
            make.width.mas_equalTo(KFit_W(95));
            make.height.mas_equalTo(32);
        }];
        
        if (i == 3) {
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
//    [self addLab_iconWithArr:titleArr3 baseLab:titleLab3 isNeedIcon:NO];
    
    //现用产品说明
    UITextField *nowUseTF = [[UITextField alloc] init];
    [self setTFProperty:nowUseTF];
    [_scrollView addSubview:nowUseTF];
    _nowUseTF = nowUseTF;
    [nowUseTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(classView);
        make.top.mas_equalTo(titleLab3.mas_bottom).offset(gap);
    }];
    
    //生产厂家
    UITextField *productionTF = [[UITextField alloc] init];
    [self setTFProperty:productionTF];
    [_scrollView addSubview:productionTF];
    _productionTF = productionTF;
    [productionTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(classView);
        make.top.mas_equalTo(nowUseTF.mas_bottom).offset(gap);
    }];
    
    //每月用量
    UITextField *needNumTF = [[UITextField alloc] init];
    needNumTF.placeholder = @"例如: 1吨";
    [self setTFProperty:needNumTF];
    [_scrollView addSubview:needNumTF];
    _needNumTF = needNumTF;
    [needNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(classView);
        make.top.mas_equalTo(productionTF.mas_bottom).offset(gap);
    }];
    
    //定制需求量
    UITextField *diynumTF = [[UITextField alloc] init];
    diynumTF.placeholder = @"例如: 1吨";
    [self setTFProperty:diynumTF];
    [_scrollView addSubview:diynumTF];
    _diynumTF = diynumTF;
    [diynumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(classView);
        make.top.mas_equalTo(needNumTF.mas_bottom).offset(gap);
    }];
    
    //助剂性能描述
    UILabel *xnDesLabel = [[UILabel alloc] init];
    xnDesLabel.text = @"助剂性能描述:";
    xnDesLabel.numberOfLines = classLabel.numberOfLines;
    xnDesLabel.textColor = classLabel.textColor;
    xnDesLabel.font = classLabel.font;
    [_scrollView addSubview:xnDesLabel];
    [xnDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(classLabel);
        make.top.mas_equalTo(diynumTF.mas_bottom).offset(gap);
    }];

    [self addIcon:xnDesLabel];

    UITextView *textView = [[UITextView alloc] init];
    textView.placeholder = @"50字以内...";
    textView.placeholderColor = HEXColor(@"#868686", 1);
    textView.font = needNumTF.font;
    textView.textColor = needNumTF.textColor;
    textView.backgroundColor = needNumTF.backgroundColor;
    [_scrollView addSubview:textView];
    _textView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(needNumTF);
        make.height.mas_equalTo(125);
        make.top.mas_equalTo(diynumTF.mas_bottom).with.offset(gap);
    }];

    //结束时间
    UILabel *endLabel = [[UILabel alloc] init];
    endLabel.text = @"结束时间:";
    endLabel.numberOfLines = classLabel.numberOfLines;
    endLabel.textColor = classLabel.textColor;
    endLabel.font = classLabel.font;
    [_scrollView addSubview:endLabel];
    [endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(classLabel);
        make.top.mas_equalTo(textView.mas_bottom).offset(gap);
    }];
    [self addIcon:endLabel];

    SelectedView *endTimeView = [[SelectedView alloc] init];
    endTimeView.textLabel.text = @"选择结束时间";
    [_scrollView addSubview:endTimeView];
    _endTimeView = endTimeView;
    [endTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(needNumTF);
        make.top.mas_equalTo(textView.mas_bottom).offset(gap);
    }];
    [HelperTool addTapGesture:endTimeView withTarget:self andSEL:@selector(showPickView_endTime)];

    UILabel *desLabel_1 = [[UILabel alloc] init];
    desLabel_1.text = @"(结束时间不能小于3天，不能大于30天)";
    desLabel_1.font = [UIFont systemFontOfSize:12];
    desLabel_1.textColor = MainColor;
    [_scrollView addSubview:desLabel_1];
    [desLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(endTimeView);
        make.height.mas_equalTo(15);
        make.top.mas_equalTo(endTimeView.mas_bottom).offset(5);
        make.right.mas_equalTo(-8);
    }];

    [desLabel_1.superview layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, desLabel_1.bottom + 50);
    
    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"发布助剂定制" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(postPlan) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ClassTool addLayer:submitBtn];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
}

- (BOOL)judgeRight {
    if (!isCompanyUser && _companyNameTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请填写公司名称" view:self.view];
        return NO;
    } else if ([_classView.textLabel.text isEqualToString:@"请选择分类"]) {
        [CddHUD showTextOnlyDelay:@"请选择分类" view:self.view];
        return NO;
    } else if (_zhuJiNameTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请填写助剂名称" view:self.view];
        return NO;
    } else if (_baseMaterialView.textLabel.text.length >= 3 && [[_baseMaterialView.textLabel.text substringToIndex:3] isEqualToString:@"请选择"]) {
        [CddHUD showTextOnlyDelay:@"请填写材质（基材）" view:self.view];
        return NO;
    } else if (_useTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请填写成品用途" view:self.view];
        return NO;
    } else if (_requireTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请填写环保要求" view:self.view];
        return NO;
    } else if (_diynumTF.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请填写需求定制量" view:self.view];
        return NO;
    } else if (_textView.text.length == 0) {
        [CddHUD showTextOnlyDelay:@"请填写助剂性能描述" view:self.view];
        return NO;
    } else if ([_endTimeView.textLabel.text isEqualToString:@"选择结束时间"] || _endTimeView.textLabel.text.length < 7) {
        [CddHUD showTextOnlyDelay:@"请选择结束时间" view:self.view];
        return NO;
    }

    return YES;
}

//选择助剂分类
- (void)selectClass {
    [self.view endEditing:YES];
    
    
    DDWeakSelf;
    [BRStringPickerView showStringPickerWithTitle:@"请选择分类" dataSource:self.nameArr defaultSelValue:nil isAutoSelect:NO themeColor:MainColor resultBlock:^(id selectValue) {
        weakself.classView.textLabel.text = selectValue;
    }];
}

//选择材质
- (void)selectMater {
    [self.view endEditing:YES];
    
    DDWeakSelf;
    [BRStringPickerView showStringPickerWithTitle:@"请选择材质" dataSource:self.materNameArr defaultSelValue:nil isAutoSelect:NO themeColor:MainColor resultBlock:^(id selectValue) {
        weakself.baseMaterialView.textLabel.text = selectValue;
    }];
}

- (NSString *)getID {
    NSString *title = self.classView.textLabel.text;
    if ([self.nameArr containsObject:title]) {
        NSInteger index = [self.nameArr indexOfObject:title];
        return self.idArray[index];
    }
    return @"0";
}

//结束时间
- (void)showPickView_endTime {
    [self.view endEditing:YES];
    DDWeakSelf;
    //开始日期
    NSDate *minDate = [TimeAbout getNDay:3];
    //最大日期
    NSDate *maxDate = [TimeAbout getNDay:30];
    //    NSDate *maxDate = [NSDate br_setYear:2030 month:1 day:1];
    [BRDatePickerView showDatePickerWithTitle:@"选择结束时间" dateType:BRDatePickerModeYMD defaultSelValue:[TimeAbout stringFromDate:minDate] minDate:minDate maxDate:maxDate isAutoSelect:NO themeColor:MainColor resultBlock:^(NSString *selectValue) {
        weakself.endTimeView.textLabel.text = selectValue;
    }];
}

- (void)addLab_iconWithArr:(NSArray *)titleArr baseLab:(UIView *)view isNeedIcon:(BOOL)isNeed {
    //for循环创建
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArr[i];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = HEXColor(@"#3C3C3C", 1);
        titleLabel.font = [UIFont systemFontOfSize:13];
        [_scrollView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(view.mas_bottom).offset((i + 1) * gap + i * 32);
            make.width.mas_equalTo(KFit_W(95));
            make.height.mas_equalTo(32);
        }];
        
        if (isNeed) {
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
}

//设置输入框
- (void)setTFProperty:(UITextField *)tf {
    tf.font = [UIFont systemFontOfSize:13];
    tf.backgroundColor = RGBA(248, 248, 248, 1);
    tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.textColor = HEXColor(@"#1E2226", 1);
    tf.layer.borderWidth = 0.7f;
    tf.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
}

//添加红色星标
- (void)addIcon:(UIView *)view {
    UIImageView *tabIcon = [[UIImageView alloc] init];
    tabIcon.image = [UIImage imageNamed:@"tab_icon"];
    [_scrollView addSubview:tabIcon];
    [tabIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.right.mas_equalTo(view.mas_left).offset(-5);
        make.width.height.mas_equalTo(4);
    }];
}


@end
