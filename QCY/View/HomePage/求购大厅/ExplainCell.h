//
//  ExplainCell.h
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AskToBuyModel;

NS_ASSUME_NONNULL_BEGIN

@interface ExplainCell : UITableViewCell

@property (nonatomic, strong)AskToBuyModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
