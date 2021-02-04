//
//  Msg_CommentsCell.h
//  QCY
//
//  Created by i7colors on 2019/4/19.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FCMsgModel;

NS_ASSUME_NONNULL_BEGIN

@interface Msg_CommentsCell : UITableViewCell

@property (nonatomic, strong)FCMsgModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
