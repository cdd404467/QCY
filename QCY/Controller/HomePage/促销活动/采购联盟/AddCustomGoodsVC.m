//
//  AddCustomGoodsVC.m
//  QCY
//
//  Created by i7colors on 2019/2/20.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AddCustomGoodsVC.h"
#import "ClassTool.h"
#import "CddHUD.h"
#import "PrchaseLeagueModel.h"
#import "AddStandardCell.h"
#import "SelectedView.h"
#import "HelperTool.h"
#import "BRPickerView.h"
#import "TimeAbout.h"

@interface AddCustomGoodsVC ()<UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITextField *nameTF;
@property (nonatomic, strong)UITextField *numTF;
@property (nonatomic, strong)UITextField *packTF;
@property (nonatomic, strong)UITextField *priceTF;
@property (nonatomic, strong)SelectedView *dateSelectView;
@property (nonatomic, strong)UIButton *addCustomBtn;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *addItemDataSource;
@end

@implementation AddCustomGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加自定义商品";
    [self setupUI];
}


- (NSMutableArray *)addItemDataSource {
    if (!_addItemDataSource) {
        _addItemDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _addItemDataSource;
}


- (void)addGoods {
    [self.view endEditing:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请自定义标准" preferredStyle:UIAlertControllerStyleAlert];
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    //增加确定按钮；
    DDWeakSelf;
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = alertController.textFields.firstObject;
        
        if (tf.text.length == 0) {
            [CddHUD showTextOnlyDelay:@"标准不可为空" view:weakself.scrollView];
            return ;
        }
        
        if (weakself.addItemDataSource.count != 0) {
            for (NSInteger i = 0; i < weakself.addItemDataSource.count; i++) {
                if ([tf.text isEqualToString:weakself.addItemDataSource[i]]) {
                    [CddHUD showTextOnlyDelay:@"不可添加重复标准" view:weakself.scrollView];
                    return ;
                }
            }
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakself.addItemDataSource.count inSection:0];
        [weakself.addItemDataSource addObject:tf.text];
        weakself.tableView.height = 32 + weakself.addItemDataSource.count * 58;
        weakself.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, weakself.tableView.bottom + 34);
        [weakself.tableView beginUpdates];
        [weakself.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [weakself.tableView endUpdates];

    }]];
    
    //设置第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        sv.backgroundColor = [UIColor whiteColor];
        sv.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT);
        //150 + 680 + 6
        sv.showsVerticalScrollIndicator = YES;
        sv.bounces = NO;
        _scrollView = sv;
    }
    
    return _scrollView;
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.bounces = NO;
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 32)];
        UIButton *addCustomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addCustomBtn.frame = CGRectMake(0, 0, 32, 32);
        [addCustomBtn setImage:[UIImage imageNamed:@"cg_jia"] forState:UIControlStateNormal];
        [addCustomBtn addTarget:self action:@selector(addGoods) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:addCustomBtn];
        _tableView.tableFooterView = footer;
        
    }
    return _tableView;
}

//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addItemDataSource.count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

//section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

//section footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddStandardCell *cell = [AddStandardCell cellWithTableView:tableView];
    cell.itemTitle = self.addItemDataSource[indexPath.row];
    DDWeakSelf;
    cell.jianBtnClick = ^(NSString * _Nonnull title) {
        NSInteger index = [weakself.addItemDataSource indexOfObject:title];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [weakself.addItemDataSource removeObjectAtIndex:index];
        weakself.tableView.height = 32 + weakself.addItemDataSource.count * 58;
        weakself.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, weakself.tableView.bottom + 34);
        [weakself.tableView beginUpdates];
        [weakself.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [weakself.tableView endUpdates];
    };
    return cell;
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    CGFloat topGap = 24;
    //for循环创建
    NSArray *titleArr = [NSArray array];
    
    if ([_type isEqualToString:@"order"]) {
        titleArr = @[@"商品名称:",@"预定量:",@"包装形式:",@"参考标准:\n(可多选)"];
    } else {
        titleArr = @[@"商品名称:",@"价格",@"预供量:",@"包装形式:",@"报价有效期",@"参考标准:\n(可多选)"];
    }
    
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArr[i];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = HEXColor(@"#3C3C3C", 1);
        titleLabel.font = [UIFont systemFontOfSize:12];
        //        titleLabel.frame = CGRectMake(18, 20 * (i + 1) + 32 * i + 9, KFit_W(80), 14);
        [_scrollView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(topGap * (i + 1) + 32 * i);
            make.width.mas_equalTo(KFit_W(80));
            make.height.mas_equalTo(32);
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
    
    //商品名称
    UITextField *nameTF = [[UITextField alloc] initWithFrame:CGRectMake(105, topGap, SCREEN_WIDTH - 115,  32)];
    nameTF.font = [UIFont systemFontOfSize:12];
    nameTF.textColor = HEXColor(@"#1E2226", 1);
    nameTF.leftViewMode = UITextFieldViewModeAlways;
    nameTF.placeholder = @"请输入商品名称";
    nameTF.layer.borderWidth = 1.f;
    nameTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 30)];
    nameTF.delegate = self;
    nameTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [_scrollView addSubview:nameTF];
    _nameTF = nameTF;
    
    if ([_type isEqualToString:@"supply"]) {
        //价格
        UITextField *priceTF = [[UITextField alloc] initWithFrame:CGRectMake(105, nameTF.bottom + topGap, SCREEN_WIDTH - 115,  32)];
        priceTF.font = [UIFont systemFontOfSize:12];
        priceTF.textColor = HEXColor(@"#1E2226", 1);
        priceTF.leftViewMode = UITextFieldViewModeAlways;
        priceTF.placeholder = @"请输入价格";
        priceTF.keyboardType = UIKeyboardTypeDecimalPad;
        priceTF.layer.borderWidth = 1.f;
        priceTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 30)];
        priceTF.delegate = self;
        priceTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
        [_scrollView addSubview:priceTF];
        _priceTF = priceTF;
        
        //单位 - 元/KG
        UILabel *priceUnitLab = [[UILabel alloc] initWithFrame:CGRectMake(priceTF.right + 20, 0, 50, 32)];
        priceUnitLab.text = @"元/KG";
        priceUnitLab.font = [UIFont systemFontOfSize:12];
        priceUnitLab.textColor = HEXColor(@"#3C3C3C", 1);
        priceUnitLab.centerY = priceTF.centerY;
        [_scrollView addSubview:priceUnitLab];
    }
    
    //预定量
    UITextField *numTF = [[UITextField alloc] initWithFrame:CGRectMake(nameTF.left, nameTF.bottom + topGap, 120,  32)];
    if ([_type isEqualToString:@"supply"]) {
        numTF.top = _priceTF.bottom + topGap;
    }
    
    numTF.font = [UIFont systemFontOfSize:12];
    numTF.textColor = HEXColor(@"#1E2226", 1);
    numTF.leftViewMode = UITextFieldViewModeAlways;
    numTF.placeholder = @"请输入预定量";
    numTF.layer.borderWidth = 1.f;
    numTF.keyboardType = UIKeyboardTypeDecimalPad;
    numTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 30)];
    numTF.delegate = self;
    numTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [_scrollView addSubview:numTF];
    _numTF = numTF;
    
    //单位 - 吨
    UILabel *unitLab = [[UILabel alloc] initWithFrame:CGRectMake(numTF.right + 20, 0, 50, 32)];
    unitLab.text = @"吨";
    unitLab.font = [UIFont systemFontOfSize:12];
    unitLab.textColor = HEXColor(@"#3C3C3C", 1);
    unitLab.centerY = numTF.centerY;
    [_scrollView addSubview:unitLab];
    
    //包装形式
    UITextField *packTF = [[UITextField alloc] initWithFrame:CGRectMake(nameTF.left, numTF.bottom + topGap, 120,  32)];
    packTF.font = [UIFont systemFontOfSize:12];
    packTF.textColor = HEXColor(@"#1E2226", 1);
    packTF.leftViewMode = UITextFieldViewModeAlways;
    packTF.placeholder = @"请输入包装形式";
    packTF.layer.borderWidth = 1.f;
    packTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 30)];
    packTF.delegate = self;
    packTF.layer.borderColor = HEXColor(@"#E6E6E6", 1).CGColor;
    [_scrollView addSubview:packTF];
    _packTF = packTF;
    
    //例
    UILabel *txtLab = [[UILabel alloc] initWithFrame:CGRectMake(packTF.right + 20, 0, 100, 32)];
    txtLab.text = @"(例：25KG/箱)";
    txtLab.font = [UIFont systemFontOfSize:12];
    txtLab.textColor = HEXColor(@"#3C3C3C", 1);
    txtLab.centerY = packTF.centerY;
    [_scrollView addSubview:txtLab];
    
    //报价有效期
    if ([_type isEqualToString:@"supply"]) {
        SelectedView *dateSelectView = [[SelectedView alloc] init];
        dateSelectView.frame = CGRectMake(packTF.left, packTF.bottom + topGap, nameTF.width, 32);
        dateSelectView.textLabel.text = @"选择有效期";
        [HelperTool addTapGesture:dateSelectView withTarget:self andSEL:@selector(showPickView_seleTime)];
        [_scrollView addSubview:dateSelectView];
        _dateSelectView = dateSelectView;
    }
    
    [_scrollView addSubview:self.tableView];
    _tableView.frame = CGRectMake(packTF.left, packTF.bottom + topGap, nameTF.width, 90);
    if ([_type isEqualToString:@"supply"]) {
        _tableView.top = _dateSelectView.bottom + topGap;
    }
    
    //确认添加商品按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:@"添加商品" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addCustomGoods) forControlEvents:UIControlEventTouchUpInside];
    [ClassTool addLayer:addBtn];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-Bottom_Height_Dif);
        make.height.mas_equalTo(49);
    }];
}

//添加自定义标准
- (void)addCustomGoods {
    if ([_type isEqualToString:@"supply"]) {
        if (_nameTF.text.length == 0) {
            [CddHUD showTextOnlyDelay:@"请输入商品名称" view:self.view];
            return;
        } else if (_priceTF.text.length == 0) {
            [CddHUD showTextOnlyDelay:@"请输入价格" view:self.view];
            return;
        } else if (_numTF.text.length == 0) {
            [CddHUD showTextOnlyDelay:@"请输入预供量" view:self.view];
            return;
        } else if (_packTF.text.length == 0) {
            [CddHUD showTextOnlyDelay:@"请输入包装形式" view:self.view];
            return;
        } else if (_dateSelectView.textLabel.text.length < 8) {
            [CddHUD showTextOnlyDelay:@"请选择报价有效期" view:self.view];
            return;
        } else if (_addItemDataSource.count == 0) {
            [CddHUD showTextOnlyDelay:@"请至少添加一个标准" view:self.view];
            return;
        }
    } else {
        if (_nameTF.text.length == 0) {
            [CddHUD showTextOnlyDelay:@"请输入商品名称" view:self.view];
            return;
        } else if (_numTF.text.length == 0) {
            [CddHUD showTextOnlyDelay:@"请输入预定量" view:self.view];
            return;
        } else if (_packTF.text.length == 0) {
            [CddHUD showTextOnlyDelay:@"请输入包装形式" view:self.view];
            return;
        } else if (_addItemDataSource.count == 0) {
            [CddHUD showTextOnlyDelay:@"请至少添加一个标准" view:self.view];
            return;
        }
    }
    
    MeetingShopListModel *model = [[MeetingShopListModel alloc] init];
    model.shopName = _nameTF.text;
    if ([_type isEqualToString:@"supply"]) {
        model.outputNum = _numTF.text;
        model.price = _priceTF.text;
        model.effectiveTime = _dateSelectView.textLabel.text;
    } else {
        model.reservationNum = _numTF.text;
    }
    
    model.packing = _packTF.text;
    //添加完这个商品，就是选中状态
    model.isSelect = YES;
    //这是一个自定义标签
    model.isCustom = YES;
    //往数据源中添加数据，选择几条就添加几个
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < _addItemDataSource.count; i++) {
        MeetingTypeListModel *standModel = [[MeetingTypeListModel alloc] init];
        standModel.referenceType = _addItemDataSource[i];
        //添加完成后，这个商品的所有标准都是选中状态
        standModel.isSelectStand = YES;
        [tempArr addObject:standModel];
    }
    //供用户选择的标准数组
    model.meetingTypeList = tempArr;
    
    if (self.addCustomGoodsBlock) {
        self.addCustomGoodsBlock(model);
    }
    [self back];
}

//结束时间
- (void)showPickView_seleTime {
    [self.view endEditing:YES];
    DDWeakSelf;
    //    //开始日期
    //    NSDate *minDate = [TimeAbout getNDay:3];
    NSDate *minDate = [NSDate date];
    //    //最大日期
    //    NSDate *maxDate = [TimeAbout getNDay:30];
    NSDate *maxDate = [NSDate br_setYear:2030 month:1 day:1];
    [BRDatePickerView showDatePickerWithTitle:@"选择报价有效时间" dateType:BRDatePickerModeYMD defaultSelValue:[TimeAbout stringFromDate:minDate] minDate:minDate maxDate:maxDate isAutoSelect:NO themeColor:MainColor resultBlock:^(NSString *selectValue) {
        weakself.dateSelectView.textLabel.text = selectValue;
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
