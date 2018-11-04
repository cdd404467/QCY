//
//  OpenMallVC_Cell.h
//  QCY
//
//  Created by i7colors on 2018/9/17.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OpenMallModel;

@interface OpenMallVC_Cell : UITableViewCell
@property (nonatomic, strong)OpenMallModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
