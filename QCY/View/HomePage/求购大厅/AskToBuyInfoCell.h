//
//  AskToBuyInfoCell.h
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AskDetailInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface AskToBuyInfoCell : UITableViewCell
@property (nonatomic, strong)AskDetailInfoModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
