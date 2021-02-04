//
//  ZhuJiDiyInfoCell.h
//  QCY
//
//  Created by i7colors on 2019/7/31.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZhuJiDiyDetailInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface ZhuJiDiyInfoCell : UITableViewCell
@property (nonatomic, strong) ZhuJiDiyDetailInfoModel *model;
@property (nonatomic, strong) UIView *bgView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
