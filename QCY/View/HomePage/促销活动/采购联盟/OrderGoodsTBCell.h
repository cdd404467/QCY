//
//  OrderGoodsTBCell.h
//  QCY
//
//  Created by i7colors on 2019/3/2.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeetingShopListModel;
NS_ASSUME_NONNULL_BEGIN
@interface OrderGoodsTBCell : UITableViewCell
@property (nonatomic, strong)MeetingShopListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
