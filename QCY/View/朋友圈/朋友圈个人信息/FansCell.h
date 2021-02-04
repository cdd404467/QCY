//
//  FansCell.h
//  QCY
//
//  Created by i7colors on 2018/12/6.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendCricleModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^FocusBlock)(NSString *userID);
typedef void(^CancelFocusBlock)(NSString *userID,NSString *userName);
@interface FansCell : UITableViewCell
@property (nonatomic, copy)FocusBlock focusBlock;
@property (nonatomic, copy)CancelFocusBlock cancelFocusBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)FriendCricleModel *model;
@end

NS_ASSUME_NONNULL_END
