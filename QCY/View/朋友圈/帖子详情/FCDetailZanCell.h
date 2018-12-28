//
//  FCDetailZanCell.h
//  QCY
//
//  Created by i7colors on 2018/12/16.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LikeListModel;

NS_ASSUME_NONNULL_BEGIN

@interface FCDetailZanCell : UITableViewCell

@property (nonatomic, strong)LikeListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
