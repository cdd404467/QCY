//
//  AuctionTBCell.h
//  QCY
//
//  Created by i7colors on 2019/3/4.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AuctionModel;

NS_ASSUME_NONNULL_BEGIN

@interface AuctionTBCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)AuctionModel *model;
@end

NS_ASSUME_NONNULL_END
