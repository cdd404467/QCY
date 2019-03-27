//
//  AskToBuyCell.h
//  QCY
//
//  Created by i7colors on 2018/9/7.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AskToBuyModel;

@interface AskToBuyCell : UITableViewCell

@property (nonatomic, strong) AskToBuyModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
