//
//  GroupBuyBargainVC.h
//  QCY
//
//  Created by i7colors on 2019/7/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class GroupBuyingModel;
@class GroupBuyBarGainModel;
NS_ASSUME_NONNULL_BEGIN

@interface GroupBuyBargainVC : BaseViewController
@property (nonatomic, strong) GroupBuyingModel *infoDataSource;
@end

@interface BargainCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) GroupBuyBarGainModel *model;
@end

NS_ASSUME_NONNULL_END
