//
//  SelecteTopicCell.h
//  QCY
//
//  Created by i7colors on 2019/4/15.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendTopicModel;

NS_ASSUME_NONNULL_BEGIN

@interface SelecteTopicCell : UITableViewCell
@property (nonatomic, strong)FriendTopicModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
