//
//  ZhuJiDiyCell.h
//  QCY
//
//  Created by i7colors on 2019/7/31.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZhuJiDiyModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZhuJiDiyCell : UITableViewCell

@property (nonatomic, strong) ZhuJiDiyModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
