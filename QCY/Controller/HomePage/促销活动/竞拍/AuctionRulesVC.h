//
//  AuctionRulesVC.h
//  QCY
//
//  Created by i7colors on 2019/3/7.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

@class InstructionsListModel;
NS_ASSUME_NONNULL_BEGIN

@interface AuctionRulesVC : BaseViewController
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSArray *dataSource;
@end


@interface AuctionRulesCell : UITableViewCell
@property (nonatomic, strong)InstructionsListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
