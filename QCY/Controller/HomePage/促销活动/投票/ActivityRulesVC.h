//
//  ActivityRulesVC.h
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class RuleListModel;
@class VoteModel;
NS_ASSUME_NONNULL_BEGIN

@interface ActivityRulesVC : BaseViewController
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)VoteModel *dataSource;
@end

@interface ActivityCellOne : UITableViewCell
@property (nonatomic, strong)RuleListModel *model;
@property (nonatomic, assign)NSInteger index;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

@interface ActivityCellTwo : UITableViewCell
@property (nonatomic, strong)VoteModel *model;
@property (nonatomic, copy)NSArray *textArr;
@property (nonatomic, assign)NSInteger index;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
