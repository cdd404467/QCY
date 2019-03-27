//
//  BaseParameterCell.h
//  QCY
//
//  Created by i7colors on 2019/2/28.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class listSaleModel;
NS_ASSUME_NONNULL_BEGIN

@interface BaseParameterCell : UITableViewCell
@property (nonatomic, strong)UIView *vLine;
@property (nonatomic, strong)UILabel *noneLabel;
@property (nonatomic, strong)listSaleModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
