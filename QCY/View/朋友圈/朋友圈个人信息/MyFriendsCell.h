//
//  MyFriendsCell.h
//  QCY
//
//  Created by i7colors on 2019/4/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendCricleModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^CancelFriendsBlock)(NSString *userID, NSString *userName);
@interface MyFriendsCell : UITableViewCell
@property (nonatomic, strong)FriendCricleModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy)CancelFriendsBlock cancelFriendsBlock;
@end

NS_ASSUME_NONNULL_END
