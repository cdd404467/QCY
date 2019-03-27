//
//  AuctionPriceRecordCell.h
//  QCY
//
//  Created by i7colors on 2019/3/7.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AuctionRecordModel;

NS_ASSUME_NONNULL_BEGIN

@interface AuctionPriceRecordCell : UITableViewCell
@property (nonatomic, strong)AuctionRecordModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, assign)NSInteger index;
@end

NS_ASSUME_NONNULL_END
