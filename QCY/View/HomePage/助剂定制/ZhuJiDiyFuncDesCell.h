//
//  ZhuJiDiyFuncDesCell.h
//  QCY
//
//  Created by i7colors on 2019/8/1.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZhuJiDiyDetailInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface ZhuJiDiyFuncDesCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) ZhuJiDiyDetailInfoModel *model;
@end

NS_ASSUME_NONNULL_END
