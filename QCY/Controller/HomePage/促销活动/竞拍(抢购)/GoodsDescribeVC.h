//
//  GoodsDescribeVC.h
//  QCY
//
//  Created by i7colors on 2019/3/6.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class AuctionModel;
@class DetailPcPicModel;
@class VideoListModel;
NS_ASSUME_NONNULL_BEGIN

@interface GoodsDescribeVC : BaseViewController
@property (nonatomic, strong)AuctionModel *dataSource;
@property (nonatomic, strong)UITableView *tableView;
@end

@interface JPIMageViewCell : UITableViewCell
@property (nonatomic, strong)DetailPcPicModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView ;
@end

@interface JPVideoCell : UITableViewCell
@property (nonatomic, strong)VideoListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView ;
@end
NS_ASSUME_NONNULL_END
