//
//  AllProductsVC.h
//  QCY
//
//  Created by i7colors on 2018/10/30.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AllProductsVC : BaseViewController

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSString *storeID;
@property (nonatomic, assign)int totalNum;
@end

NS_ASSUME_NONNULL_END
