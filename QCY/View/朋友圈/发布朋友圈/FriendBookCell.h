//
//  FriendBookCell.h
//  QCY
//
//  Created by i7colors on 2019/4/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendCricleInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface FriendBookCell : UITableViewCell
@property (nonatomic, strong)FriendCricleInfoModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
