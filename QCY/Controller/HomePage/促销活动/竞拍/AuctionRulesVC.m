//
//  AuctionRulesVC.m
//  QCY
//
//  Created by i7colors on 2019/3/7.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AuctionRulesVC.h"
#import <YNPageTableView.h>
#import "MacroHeader.h"
#import <YYText.h>
#import "UIView+Geometry.h"
#import "AuctionModel.h"
#import <Masonry.h>


@interface AuctionRulesVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation AuctionRulesVC

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
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
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
    
    return 1;
}

//cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    InstructionsListModel *model = _dataSource[indexPath.row];
    return model.cellHeight;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AuctionRulesCell *cell = [[AuctionRulesCell alloc] init];
    
    cell.model = _dataSource[indexPath.row];
    return cell;
}

@end


@implementation AuctionRulesCell {
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

- (void)setModel:(InstructionsListModel *)model {
    _model = model;
//    NSArray *chineseNumArr = @[@"一、",@"二、",@"三、",@"四、",@"五、",@"六、",@"七、",@"八、",@"九、",@"十、"];
//    NSString *title = [NSString stringWithFormat:@"%@%@:",chineseNumArr[0],model.shuXing];
//    NSString *text = [NSString stringWithFormat:@"%@  %@",model.shuXing,model.zhi];
    CGFloat fitHeight = [self getMessageHeight:model.relatedInstructions andLabel:_activityLab];
    _activityLab.height = fitHeight;

    model.cellHeight = _activityLab.bottom;
}


//YYLbael计算高度
- (CGFloat)getMessageHeight:(NSString *)mess andLabel:(YYLabel *)label {
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:mess];
    introText.yy_font = [UIFont systemFontOfSize:12];
    introText.yy_lineSpacing = 9;
    introText.yy_color = HEXColor(@"#333333", 1);
//    [introText yy_setFont:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(0, len)];
    
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
    static NSString *identifier = @"AuctionRulesCell";
    AuctionRulesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AuctionRulesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
