//
//  GoodsDescribeCell.h
//  QCY
//
//  Created by i7colors on 2019/3/8.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AttributeListModel;
NS_ASSUME_NONNULL_BEGIN

@interface GoodsDescribeCell : UITableViewCell
@property (nonatomic, strong)AttributeListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
