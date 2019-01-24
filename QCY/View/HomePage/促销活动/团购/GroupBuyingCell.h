//
//  GroupBuyingCell.h
//  QCY
//
//  Created by i7colors on 2018/11/1.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupBuyingModel;

NS_ASSUME_NONNULL_BEGIN

@interface GroupBuyingCell : UITableViewCell

@property (nonatomic, strong)GroupBuyingModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
