//
//  GroupBuyAlreadyCell.h
//  QCY
//
//  Created by i7colors on 2018/11/7.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupBuyFinishModel;

NS_ASSUME_NONNULL_BEGIN

@interface GroupBuyAlreadyCell : UITableViewCell

@property (nonatomic, strong)GroupBuyFinishModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
