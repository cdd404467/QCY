//
//  BaseParameterTextVC.h
//  QCY
//
//  Created by i7colors on 2019/2/28.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseParameterTextVC : BaseViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy)NSArray *dataSource;
@end

NS_ASSUME_NONNULL_END
