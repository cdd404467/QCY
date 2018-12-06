//
//  CompanyInfoVC.m
//  QCY
//
//  Created by i7colors on 2018/10/30.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "CompanyInfoVC.h"
#import "MacroHeader.h"
#import <YNPageTableView.h>

@interface CompanyInfoVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation CompanyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[YNPageTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
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
    
    return 1;
}

//cell高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return 44;
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
}

//数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
//    NSString *text = @"       一群人、一条心、一辈子、一件事，忠于自己、服务他人。 山东索玛德染料有限公司办公室地址位于山东重要的石油化工基地淄博，于2017年01月16日在淄博市工商行政管理局高新区分局注册成立，注册资本为300万，在公司发展壮大的2年里，我们始终为客户提供好的产品和技术支持、健全的售后服务，我公司主要经营染料、颜料、印染助剂、化工原料、塑料原料（以上五项不含危险、监控及易制毒化学品）、纺织面料、纸张、包装材料的销售；网上贸易代理；货物及技术进出口。我们有好的产品和专业的销售和技术团队，我公司属于淄博零售业黄页行业，如果您对我公司的产品服务有兴趣，期待您在线留言或者来电咨询。";
    
    NSString *text = [NSString string];
    if isRightData(_companyDesc) {
        text = _companyDesc;
    } else {
        text = @"暂无介绍!";
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = HEXColor(@"#575757", 1);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = cell.textLabel.font.pointSize * 2;
    // 行间距设置为6
    [paragraphStyle  setLineSpacing:6];
//    [paragraphStyle setParagraphSpacing:10];
    NSMutableAttributedString *mText = [[NSMutableAttributedString alloc]initWithString:text];
    [mText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    cell.textLabel.attributedText = mText;
    return cell;
}

@end
