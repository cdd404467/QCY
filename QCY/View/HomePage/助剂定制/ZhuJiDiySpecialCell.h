//
//  ZhuJiDiySpecialCell.h
//  QCY
//
//  Created by i7colors on 2019/10/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZhuJiDiySpecialModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZhuJiDiySpecialCell : UITableViewCell
@property (nonatomic, strong) ZhuJiDiySpecialModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
