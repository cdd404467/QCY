//
//  Msg_RemindUsersCell.h
//  QCY
//
//  Created by i7colors on 2019/4/22.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FCMsgModel;

NS_ASSUME_NONNULL_BEGIN

@interface Msg_RemindUsersCell : UITableViewCell

@property (nonatomic, strong)FCMsgModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
