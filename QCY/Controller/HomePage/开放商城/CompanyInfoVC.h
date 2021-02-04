//
//  CompanyInfoVC.h
//  QCY
//
//  Created by i7colors on 2018/10/30.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class OpenMallModel;
@class FCMapNavigationModel;
NS_ASSUME_NONNULL_BEGIN

@interface CompanyInfoVC : BaseViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FCMapNavigationModel *navModel;
@property (nonatomic, strong) OpenMallModel *dataSource;
@end


@interface CompInfoCell_0 : UITableViewCell
@property (nonatomic, strong)OpenMallModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end


@interface CompInfoCell_1 : UITableViewCell
@property (nonatomic, strong)OpenMallModel *model;
@property (nonatomic, strong) FCMapNavigationModel *navModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end


typedef void(^CellHeightBlock)(void);
@interface CompInfoCell_2 : UITableViewCell
@property (nonatomic, strong)OpenMallModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy)CellHeightBlock cellHeightBlock;
@end

NS_ASSUME_NONNULL_END
