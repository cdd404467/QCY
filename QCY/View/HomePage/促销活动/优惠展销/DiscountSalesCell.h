//
//  DiscountSalesCell.h
//  QCY
//
//  Created by i7colors on 2019/1/14.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiscountSalesModel;

NS_ASSUME_NONNULL_BEGIN

@interface DiscountSalesCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)DiscountSalesModel *model;
@end

NS_ASSUME_NONNULL_END
