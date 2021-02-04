//
//  MyGroupBuyingTBCell.h
//  QCY
//
//  Created by i7colors on 2019/7/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupBuyingModel;

NS_ASSUME_NONNULL_BEGIN

@interface MyGroupBuyingTBCell : UITableViewCell
@property (nonatomic, strong) GroupBuyingModel *model;
@property (nonatomic, copy) NSString *style;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
