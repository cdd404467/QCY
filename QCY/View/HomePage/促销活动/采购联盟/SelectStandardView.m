//
//  SelectStandardView.m
//  QCY
//
//  Created by i7colors on 2019/2/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//


#import "SelectStandardView.h"
#import "MacroHeader.h"
#import <Masonry.h>
#import "UIView+Geometry.h"
#import "HelperTool.h"
#import "SelectStandardCell.h"
#import "PrchaseLeagueModel.h"

#define AniTime 0.25
@interface SelectStandardView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *selectView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)NSMutableArray *tempSelectedArr;
@end

@implementation SelectStandardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
        self.frame = SCREEN_BOUNDS;
    }
    
    return self;
}


- (void)setupUI {
    DDWeakSelf;
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    [UIView animateWithDuration:0.3 animations:^{
        weakself.backgroundColor = RGBA(0, 0, 0, 0.3);
    }];
    
    UIButton *selectView = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250 + TABBAR_HEIGHT)];
    selectView.backgroundColor = [UIColor whiteColor];
    [self addSubview:selectView];
    _selectView = selectView;
    
    [UIView animateWithDuration:AniTime animations:^{
        selectView.top = SCREEN_HEIGHT - selectView.height;
    }];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    topView.backgroundColor = HEXColor(@"#f3f3f3", 1);
    [selectView addSubview:topView];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:MainColor forState:UIControlStateNormal];
    cancel.layer.borderColor = MainColor.CGColor;
    cancel.layer.cornerRadius = 5;
    [cancel addTarget:self action:@selector(removeAllSubviews) forControlEvents:UIControlEventTouchUpInside];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    cancel.layer.borderWidth = 1.f;
    [topView addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(28);
        make.centerY.mas_equalTo(topView);
    }];
    
    //确定
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okClick) forControlEvents:UIControlEventTouchUpInside];
    okBtn.backgroundColor = MainColor;
    okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    okBtn.layer.cornerRadius = 5;
    [topView addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.height.centerY.mas_equalTo(cancel);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    titleLabel.textColor = UIColor.blackColor;
//    titleLabel.text = _productName;
    [topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cancel.mas_right).offset(10);
        make.right.mas_equalTo(okBtn.mas_left).offset(-10);
        make.height.mas_equalTo(38);
        make.centerY.mas_equalTo(topView);
    }];
    _titleLabel = titleLabel;
}


- (void)setStandArr:(NSArray *)standArr {
    _standArr = standArr;
    _titleLabel.text = _productName;
    _tempSelectedArr = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < standArr.count; i++) {
        MeetingTypeListModel *model = standArr[i];
        MeetingTypeListModel *tempModel = [[MeetingTypeListModel alloc] init];
        tempModel.referenceType = model.referenceType;
        tempModel.isSelectStand = model.isSelectStand;
        [_tempSelectedArr addObject:tempModel];
    }
    [_selectView addSubview:self.tableView];
}

- (void)removeAllSubviews {
    
    [UIView animateWithDuration:AniTime animations:^{
        self.selectView.top = SCREEN_HEIGHT;
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

//点击确定按钮
- (void)okClick {
    for (NSInteger i = 0; i < _standArr.count; i ++) {
        MeetingTypeListModel *model = _standArr[i];
        MeetingTypeListModel *tempMode = _tempSelectedArr[i];
        model.referenceType = tempMode.referenceType;
        model.isSelectStand = tempMode.isSelectStand;
    }
    
    if (self.okBtnClickBlock) {
        self.okBtnClickBlock();
    }
    [self removeAllSubviews];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeAllSubviews];
}

//懒加载tableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 250) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.separatorColor = RGBA(235, 235, 235, 1);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        _tableView.backgroundColor = [UIColor whiteColor];
        //取消垂直滚动条
        //        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            //            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _standArr.count;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectStandardCell *cell = [SelectStandardCell cellWithTableView:tableView];
    cell.model = _tempSelectedArr[indexPath.row];
    cell.index = indexPath.row;
    return cell;
}

@end
