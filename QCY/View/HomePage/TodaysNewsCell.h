//
//  TodaysNewsCell.h
//  QCY
//
//  Created by i7colors on 2018/9/13.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodaysNewsCell : UITableViewCell
@property (nonatomic, strong)UILabel *countLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
