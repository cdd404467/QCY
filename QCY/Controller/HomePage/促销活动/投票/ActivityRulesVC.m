//
//  ActivityRulesVC.m
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "ActivityRulesVC.h"
#import <YNPageTableView.h>
#import "MacroHeader.h"
#import <YYText.h>
#import "VoteModel.h"
#import "UIView+Geometry.h"


@interface ActivityRulesVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ActivityRulesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];

}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            //            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height_Dif, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49 + Bottom_Height_Dif)];
    }
    return _tableView;
}

#pragma mark - UITableView代理
//section header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.00001;
}

//section footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.00001;
}

//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _dataSource.ruleList.count;
    } else {
        return 1;
    }
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RuleListModel *model = _dataSource.ruleList[indexPath.row];
        return model.cellHeight;
    } else {
        return _dataSource.cellHeight;
    }
    
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ActivityCellOne *cell = [ActivityCellOne cellWithTableView:tableView];
        cell.index = indexPath.row;
        cell.model = _dataSource.ruleList[indexPath.row];
        return cell;
    } else {
        ActivityCellTwo *cell = [ActivityCellTwo cellWithTableView:tableView];
        cell.index = _dataSource.ruleList.count;
        cell.model = _dataSource;
        return cell;
    }
}

@end

@implementation ActivityCellOne {
    YYLabel *_activityLab;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    YYLabel *activityLab = [[YYLabel alloc] init];
    activityLab.frame = CGRectMake(25, 12, SCREEN_WIDTH - 25 * 2, 14);
//    activityLab.backgroundColor = [UIColor redColor];
    activityLab.numberOfLines = 0;
    [self.contentView addSubview:activityLab];
    _activityLab = activityLab;
}

- (void)setModel:(RuleListModel *)model {
    _model = model;
    NSArray *chineseNumArr = @[@"一、",@"二、",@"三、",@"四、",@"五、",@"六、",@"七、",@"八、",@"九、",@"十、"];
    NSString *title = [NSString stringWithFormat:@"%@%@:",chineseNumArr[_index],model.key];
    NSString *text = [NSString stringWithFormat:@"%@  %@",title,model.value];
    CGFloat fitHeight = [self getMessageHeight:text andLabel:_activityLab titleLen:title.length];
    _activityLab.height = fitHeight;

    model.cellHeight = _activityLab.bottom;
}

//YYLbael计算高度
- (CGFloat)getMessageHeight:(NSString *)mess andLabel:(YYLabel *)label titleLen:(NSInteger)len {
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:mess];
    introText.yy_font = [UIFont systemFontOfSize:12];
    introText.yy_lineSpacing = 9;
    introText.yy_color = HEXColor(@"#333333", 1);
    [introText yy_setFont:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, len)];
    
//    introText.yy_firstLineHeadIndent = 10.f;
//    introText.yy_headIndent = 5.f;
//    introText.yy_tailIndent = -5.f;
//    introText.yy_alignment = NSTextAlignmentCenter;
    CGSize introSize = CGSizeMake(_activityLab.width, CGFLOAT_MAX);
    label.attributedText = introText;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:introText];
    label.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ActivityCellOne";
    ActivityCellOne *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ActivityCellOne alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end

@implementation ActivityCellTwo {
    UILabel *_titleLab;
    YYLabel *_textLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(25, 12, SCREEN_WIDTH - 25 * 2, 15);
    titleLab.font = [UIFont boldSystemFontOfSize:15];
    titleLab.numberOfLines = 0;
    titleLab.textColor = HEXColor(@"#333333", 1);
    [self.contentView addSubview:titleLab];
    _titleLab = titleLab;
    
    YYLabel *textLab = [[YYLabel alloc] init];
    textLab.numberOfLines = 0;
    textLab.frame = CGRectMake(25, titleLab.bottom - 10, SCREEN_WIDTH - 25 * 2, 14);
    [self.contentView addSubview:textLab];
    _textLab = textLab;
}

- (void)setModel:(VoteModel *)model {
    _model = model;
    NSArray *chineseNumArr = @[@"一、",@"二、",@"三、",@"四、",@"五、",@"六、",@"七、",@"八、",@"九、",@"十、"];
    
    NSString *title = [NSString stringWithFormat:@"%@活动介绍:",chineseNumArr[_index]];
    _titleLab.text = title;
    
    NSString *text = [NSString string];
    for (NSInteger i = 0; i < model.detailList.count; i++) {
        text = [NSString stringWithFormat:@"%@\n       %@、%@",text,@(i + 1),model.detailList[i]];
    }
    
    CGFloat fitHeight = [self getMessageHeight:text andLabel:_textLab];
    _textLab.height = fitHeight;
    model.cellHeight = _textLab.bottom;
}

//YYLbael计算高度
- (CGFloat)getMessageHeight:(NSString *)mess andLabel:(YYLabel *)label {
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:mess];
    introText.yy_font = [UIFont systemFontOfSize:12];
    introText.yy_lineSpacing = 12;
    introText.yy_color = HEXColor(@"#333333", 1);
    //    introText.yy_firstLineHeadIndent = 10.f;
    //    introText.yy_headIndent = 5.f;
    //    introText.yy_tailIndent = -5.f;
    //    introText.yy_alignment = NSTextAlignmentCenter;
    CGSize introSize = CGSizeMake(_textLab.width, CGFLOAT_MAX);
    label.attributedText = introText;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:introText];
    label.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"ActivityCellTwo";
    ActivityCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ActivityCellTwo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
