//
//  ManifestSupplyCell.h
//  QCY
//
//  Created by i7colors on 2019/1/24.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeetingShopListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ManifestSupplyCell : UITableViewCell

@property (nonatomic, strong)MeetingShopListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
