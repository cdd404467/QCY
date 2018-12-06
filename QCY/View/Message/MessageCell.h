//
//  MessageCell.h
//  QCY
//
//  Created by i7colors on 2018/11/14.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageModel;

NS_ASSUME_NONNULL_BEGIN

@interface MessageCell : UITableViewCell

@property (nonatomic, strong)MessageModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
