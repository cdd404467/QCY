//
//  CompanytypeSelectView.m
//  QCY
//
//  Created by i7colors on 2019/7/11.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "CompanytypeSelectView.h"

@interface CompanytypeSelectView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSString *> *typeArr;
@property (nonatomic, assign) CGFloat tbHeight;
@end

@implementation CompanytypeSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.typeArr = @[@"全部",@"印染企业",@"染料供应商",@"助剂供应商",@"设备仪器企业",@"化学品企业"];
        self.tbHeight = self.typeArr.count * 50;
        [self setupUI];
    }
    
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -_tbHeight, SCREEN_WIDTH, _tbHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXColor(@"#ededed", 1);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
//        _tableView.scrollIndicatorInsets = _leftTableView.contentInset;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _tableView.separatorColor = Like_Color;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (void)setupUI {
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    [self addSubview:self.tableView];
}

- (void)show {
    DDWeakSelf;
    weakself.hidden = NO;
    [UIView animateWithDuration:.3 animations:^{
        weakself.backgroundColor = RGBA(0, 0, 0, 0.5);
        weakself.tableView.top = 0;
    }];
}

//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.typeArr.count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.typeSelectBlock) {
        NSArray *tempArr = @[@"全部",@"印染",@"染料",@"助剂",@"设备仪器",@"化学品"];
        NSString *type = indexPath.row == 0 ? @"" : tempArr[indexPath.row];
        self.typeSelectBlock(type);
    }
    [self hide];
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompanyTypeCell *cell = [CompanyTypeCell cellWithTableView:tableView];
    cell.typeName = self.typeArr[indexPath.row];
    
    return cell;
}

- (void)hide {
    DDWeakSelf;
    [UIView animateWithDuration:.3 animations:^{
        weakself.backgroundColor = RGBA(0, 0, 0, 0.0);
        weakself.tableView.top = -weakself.tbHeight;
    } completion:^(BOOL finished) {
        weakself.hidden = YES;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

@end


@implementation CompanyTypeCell {
    UILabel *_textLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    _textLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    _textLab.textAlignment = NSTextAlignmentCenter;
    _textLab.font = [UIFont systemFontOfSize:16];
    _textLab.backgroundColor = UIColor.whiteColor;
    _textLab.textColor = HEXColor(@"#333333", 1);
    [self.contentView addSubview:_textLab];
}

- (void)setTypeName:(NSString *)typeName {
    _typeName = typeName;
    _textLab.text = typeName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _textLab.textColor = selected ? MainColor : HEXColor(@"#333333", 1);
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"CompanyTypeCell";
    CompanyTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CompanyTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
