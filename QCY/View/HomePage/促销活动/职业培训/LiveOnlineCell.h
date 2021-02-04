//
//  LiveOnlineCell.h
//  QCY
//
//  Created by i7colors on 2020/3/27.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveOnlineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveOnlineCell : UITableViewCell
@property (nonatomic, strong) LiveOnlineModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
