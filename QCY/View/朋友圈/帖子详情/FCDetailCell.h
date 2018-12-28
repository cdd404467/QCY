//
//  FCDetailCell.h
//  QCY
//
//  Created by i7colors on 2018/12/16.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentListModel;


typedef void(^ClickPLBlock)(NSString *commentID, NSString *isSelf, NSString *user);
NS_ASSUME_NONNULL_BEGIN

@interface FCDetailCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)CommentListModel *model;
@property (nonatomic, copy)ClickPLBlock clickPLBlock;
@end

NS_ASSUME_NONNULL_END
