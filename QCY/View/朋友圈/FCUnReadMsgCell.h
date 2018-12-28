//
//  FCUnReadMsgCell.h
//  QCY
//
//  Created by i7colors on 2018/12/17.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentListModel;

NS_ASSUME_NONNULL_BEGIN

@interface FCUnReadMsgCell : UITableViewCell

@property (nonatomic, strong)CommentListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
