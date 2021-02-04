//
//  AreaSelectView.m
//  QCY
//
//  Created by i7colors on 2019/7/5.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AreaSelectView.h"
#import <MJExtension.h>
#import "UIView+Border.h"
#import "HistoryRecordView.h"
#import "OtherModel.h"

@interface AreaSelectView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *midTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *provinceDataSource;
@property (nonatomic, strong) NSMutableArray *cityDataSource;
@property (nonatomic, strong) NSMutableArray *areaDataSource;
@property (nonatomic, strong) HistoryRecordView *historyView;
@property (nonatomic, strong) UIButton *midHeaderBtn;
@end

static const CGFloat aniTime = 0.3;

@implementation AreaSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self parseDataSource];
        [self addCityDataArrWithIndex:0];
        [self addAreaDataArrWithIndex:0];
        [self setupUIWithArray];
    }
    
    return self;
}

- (void)setupUIWithArray {
    self.backgroundColor = RGBA(0, 0, 0, 0.0);
    
    CGFloat height = SCREEN_HEIGHT - NAV_HEIGHT - 40;
    _backgroundView = [[UIView alloc] init];
    _backgroundView.backgroundColor = UIColor.whiteColor;
    _backgroundView.frame = CGRectMake(0, -height, SCREEN_WIDTH, height);
    [self addSubview:_backgroundView];
    
    [_backgroundView addSubview:self.leftTableView];
    [_backgroundView addSubview:self.midTableView];
    [_backgroundView addSubview:self.rightTableView];
    
    _historyView = [[HistoryRecordView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    _historyView.hidden = YES;
    DDWeakSelf;
    _historyView.historyBtnClickBlock = ^(NSString * _Nonnull title, NSInteger type) {
        [weakself hide];
        if (weakself.allAreaClickBlock) {
            weakself.allAreaClickBlock(title, type);
        }
    };
    [_backgroundView addSubview:_historyView];
    
    if ([(NSArray *)FCMap_History_Area count] > 0) {
        _historyView.histroyArr = (NSArray *)FCMap_History_Area;
        _historyView.hidden = NO;
    }
    [self updataFrame];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.leftTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self.midTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self.rightTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}


- (void)updataFrame {
    CGFloat tbHeight = SCREEN_HEIGHT - NAV_HEIGHT - 40;
    self.leftTableView.top = _historyView.bottom;
    self.leftTableView.height = tbHeight - _historyView.bottom;
    self.midTableView.top = self.leftTableView.top;
    self.midTableView.height = self.leftTableView.height;
    self.rightTableView.top = self.leftTableView.top;
    self.rightTableView.height = self.leftTableView.height;
}


- (void)show {
    DDWeakSelf;
    if ([(NSArray *)FCMap_History_Area count] > 0) {
        _historyView.histroyArr = (NSArray *)FCMap_History_Area;
        _historyView.hidden = NO;
    }
    [self updataFrame];
    self.hidden = NO;
    [UIView animateWithDuration:aniTime animations:^{
        weakself.backgroundColor = RGBA(0, 0, 0, 0.5);
        weakself.backgroundView.top = 0;
    }];
}

- (void)hide {
    CGFloat height = SCREEN_HEIGHT - NAV_HEIGHT - 40;
    DDWeakSelf;
    [UIView animateWithDuration:aniTime animations:^{
        weakself.backgroundColor = RGBA(0, 0, 0, 0.0);
        weakself.backgroundView.top = -height;
    } completion:^(BOOL finished) {
        weakself.hidden = YES;
        //        [weakself.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //        [weakself removeFromSuperview];
    }];
}

- (NSMutableArray *)provinceDataSource {
    if (!_provinceDataSource) {
        _provinceDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _provinceDataSource;
}

- (NSMutableArray *)cityDataSource {
    if (!_cityDataSource) {
        _cityDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _cityDataSource;
}

- (NSMutableArray *)areaDataSource {
    if (!_areaDataSource) {
        _areaDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _areaDataSource;
}

//解析整个数据
- (void)parseDataSource {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSArray *tempArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    tempArr = [AreaModel mj_objectArrayWithKeyValuesArray:tempArr];
    for (AreaModel *provinceModel in tempArr) {
        provinceModel.regionList = [AreaModel mj_objectArrayWithKeyValuesArray:provinceModel.regionList];
        for (AreaModel *cityModel in provinceModel.regionList) {
            cityModel.regionList = [AreaModel mj_objectArrayWithKeyValuesArray:cityModel.regionList];
            self.areaDataSource = [cityModel.regionList mutableCopy];
        }
        self.cityDataSource = [provinceModel.regionList mutableCopy];
    }
    [self.provinceDataSource addObjectsFromArray:tempArr];
}

//点击省份时，切换市的数据源
- (void)addCityDataArrWithIndex:(NSInteger)index {
    AreaModel *provinceModel = self.provinceDataSource[index];
    self.cityDataSource = [provinceModel.regionList mutableCopy];
}

//点击市时，切换区的数据源
- (void)addAreaDataArrWithIndex:(NSInteger)index {
    AreaModel *cityModel = self.cityDataSource[index];
    self.areaDataSource = [cityModel.regionList mutableCopy];
}

- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, SCREEN_HEIGHT - NAV_HEIGHT - 40) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.backgroundColor = HEXColor(@"#ededed", 1);
        _leftTableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _leftTableView.scrollIndicatorInsets = _leftTableView.contentInset;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _leftTableView.estimatedRowHeight = 0;
            _leftTableView.estimatedSectionHeaderHeight = 0;
            _leftTableView.estimatedSectionFooterHeight = 0;
            _leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headerBtn.tag = 10000;
        [headerBtn addTarget:self action:@selector(clickHeader:) forControlEvents:UIControlEventTouchUpInside];
        headerBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH / 3, 50);
        [headerBtn setTitleColor:HEXColor(@"#333333", 1) forState:UIControlStateNormal];
        [headerBtn setTitle:@"全国" forState:UIControlStateNormal];
        headerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _leftTableView.tableHeaderView = headerBtn;
        _leftTableView.tableFooterView = [[UIView alloc] init];
    }
    return _leftTableView;
}

- (UITableView *)midTableView {
    if (!_midTableView) {
        _midTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3, 0, SCREEN_WIDTH / 3, SCREEN_HEIGHT - NAV_HEIGHT - 40) style:UITableViewStylePlain];
        _midTableView.delegate = self;
        _midTableView.dataSource = self;
        _midTableView.backgroundColor = HEXColor(@"#ededed", .5);
        _midTableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _midTableView.scrollIndicatorInsets = _leftTableView.contentInset;
        _midTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _midTableView.estimatedRowHeight = 0;
            _midTableView.estimatedSectionHeaderHeight = 0;
            _midTableView.estimatedSectionFooterHeight = 0;
            _midTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _midHeaderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _midHeaderBtn.tag = 10001;
        [_midHeaderBtn addTarget:self action:@selector(clickHeader:) forControlEvents:UIControlEventTouchUpInside];
        _midHeaderBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH / 3, 50);
        [_midHeaderBtn setTitleColor:HEXColor(@"#333333", 1) forState:UIControlStateNormal];
        [_midHeaderBtn setTitle:@"全部" forState:UIControlStateNormal];
        _midHeaderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _midTableView.tableHeaderView = _midHeaderBtn;
        
        if (self.cityDataSource.count > 1) {
            _midHeaderBtn.height = 50;
            _midHeaderBtn.hidden = NO;
        } else {
            _midHeaderBtn.height = 0;
            _midHeaderBtn.hidden = YES;
        }
        _midTableView.tableFooterView = [[UIView alloc] init];
    }
    return _midTableView;
}

- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2, 0, SCREEN_WIDTH / 3, SCREEN_HEIGHT - NAV_HEIGHT - 40) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.backgroundColor = UIColor.whiteColor;
        _rightTableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _rightTableView.scrollIndicatorInsets = _leftTableView.contentInset;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _rightTableView.estimatedRowHeight = 0;
            _rightTableView.estimatedSectionHeaderHeight = 0;
            _rightTableView.estimatedSectionFooterHeight = 0;
            _rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headerBtn.tag = 10002;
        [headerBtn addTarget:self action:@selector(clickHeader:) forControlEvents:UIControlEventTouchUpInside];
        headerBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH / 3, 50);
        [headerBtn setTitleColor:HEXColor(@"#333333", 1) forState:UIControlStateNormal];
        [headerBtn setTitle:@"全部" forState:UIControlStateNormal];
        headerBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rightTableView.tableHeaderView = headerBtn;
        _rightTableView.tableFooterView = [[UIView alloc] init];
    }
    return _rightTableView;
}

- (void)clickHeader:(UIButton *)sender {
    //点击全国
    NSString *clickArea = [NSString string];
    if (sender.tag == 10000) {
        clickArea = @"";
    }
    //点击全省
    else if (sender.tag == 10001) {
        NSIndexPath *indexPath = [self.leftTableView indexPathForSelectedRow];
        AreaModel *model = self.provinceDataSource[indexPath.row];
        clickArea = model.regionName;
    }
    //点击全市
    else if (sender.tag == 10002) {
        NSIndexPath *indexPath = [self.midTableView indexPathForSelectedRow];
        AreaModel *model = self.cityDataSource[indexPath.row];
        clickArea = model.regionName;
    }
    
    if (self.allAreaClickBlock) {
        [self hide];
        self.allAreaClickBlock(clickArea,sender.tag);
    }
}



//每组的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _leftTableView) {
        return self.provinceDataSource.count;
    }
    else if (tableView == _midTableView) {
        return self.cityDataSource.count;
    }
    else {
        return self.areaDataSource.count;
    }
    
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        [self.leftTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self addCityDataArrWithIndex:indexPath.row];
        [self addAreaDataArrWithIndex:0];
        if (self.cityDataSource.count > 1) {
            _midHeaderBtn.height = 50;
            _midHeaderBtn.hidden = NO;
        } else {
            _midHeaderBtn.height = 0;
            _midHeaderBtn.hidden = YES;
        }
        
        [self.midTableView reloadData];
        [self.rightTableView reloadData];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.midTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self.rightTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    else if (tableView == _midTableView) {
        [self.midTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self addAreaDataArrWithIndex:indexPath.row];
        [self.rightTableView reloadData];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.rightTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    else {
        if (self.allAreaClickBlock) {
            [self hide];
            AreaModel *model = self.areaDataSource[indexPath.row];
            self.allAreaClickBlock(model.regionName,10003);
        }
    }
    
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _leftTableView) {
        AreaSelectTBLeftCell *cell = [AreaSelectTBLeftCell cellWithTableView:tableView];
        cell.model = self.provinceDataSource[indexPath.row];
        return cell;
    }
    else if (tableView == _midTableView) {
        AreaSelectTBMidCell *cell = [AreaSelectTBMidCell cellWithTableView:tableView];
        cell.model = self.cityDataSource[indexPath.row];
        return cell;
    }
    else {
        AreaSelectTBRightCell *cell = [AreaSelectTBRightCell cellWithTableView:tableView];
        cell.model = self.areaDataSource[indexPath.row];
        return cell;
    }
}


@end



// ***   ***//

@implementation AreaSelectTBLeftCell {
    UIView *_leftView;
    UILabel *_provinceLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    //左边标记的View
    _leftView = [[UIView alloc]init];
    _leftView.backgroundColor = MainColor;
    [self.contentView addSubview:_leftView];
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(3);
    }];
    
    _provinceLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, SCREEN_WIDTH / 3 - 14, 50)];
    _provinceLab.textAlignment = NSTextAlignmentCenter;
    _provinceLab.font = [UIFont systemFontOfSize:14];
    _provinceLab.numberOfLines = 2;
    [self.contentView addSubview:_provinceLab];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _provinceLab.textColor = selected ? MainColor : HEXColor(@"#333333", 1);
    _leftView.hidden = !selected;
    self.contentView.backgroundColor = selected ? HEXColor(@"#ededed", .5) : HEXColor(@"#ededed", 1);
}

- (void)setModel:(AreaModel *)model {
    _model = model;
    _provinceLab.text = model.regionName;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AreaSelectTBLeftCell";
    AreaSelectTBLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AreaSelectTBLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end

@implementation AreaSelectTBMidCell {
    UILabel *_cityLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _cityLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, SCREEN_WIDTH / 3 - 14, 50)];
    _cityLab.textAlignment = NSTextAlignmentCenter;
    _cityLab.font = [UIFont systemFontOfSize:14];
    _cityLab.numberOfLines = 2;
    [self.contentView addSubview:_cityLab];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _cityLab.textColor = selected ? MainColor : HEXColor(@"#333333", 1);
    self.contentView.backgroundColor = selected ? UIColor.whiteColor : HEXColor(@"#ededed", .5);
}

- (void)setModel:(AreaModel *)model {
    _model = model;
    _cityLab.text = model.regionName;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AreaSelectTBMidCell";
    AreaSelectTBMidCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AreaSelectTBMidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

@implementation AreaSelectTBRightCell {
    UILabel *_areaLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _areaLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, SCREEN_WIDTH / 3 - 14, 50)];
    _areaLab.textAlignment = NSTextAlignmentCenter;
    _areaLab.font = [UIFont systemFontOfSize:14];
    _areaLab.numberOfLines = 2;
    [self.contentView addSubview:_areaLab];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _areaLab.textColor = selected ? MainColor : HEXColor(@"#333333", 1);
}

- (void)setModel:(AreaModel *)model {
    _model = model;
    _areaLab.text = model.regionName;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"AreaSelectTBRightCell";
    AreaSelectTBRightCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AreaSelectTBRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

