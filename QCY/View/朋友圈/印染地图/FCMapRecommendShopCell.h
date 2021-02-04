//
//  FCMapRecommendShopCell.h
//  QCY
//
//  Created by i7colors on 2019/6/30.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FCMapModel;
@class FCMapNavigationModel;
NS_ASSUME_NONNULL_BEGIN
 typedef void(^SearchRouteBlock)(FCMapNavigationModel *model);
@interface FCMapRecommendShopCell : UITableViewCell
@property (nonatomic, copy) SearchRouteBlock searchRouteBlock;
@property (nonatomic, strong)FCMapModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
