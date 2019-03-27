//
//  VoteCell.h
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VoteModel;

NS_ASSUME_NONNULL_BEGIN

@interface VoteCell : UITableViewCell
@property (nonatomic, strong)VoteModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
