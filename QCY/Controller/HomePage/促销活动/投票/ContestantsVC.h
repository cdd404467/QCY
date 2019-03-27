//
//  ContestantsVC.h
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContestantsVC : BaseViewController
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSString *voteID;
@property (nonatomic, copy)NSString *voteName;
@end

NS_ASSUME_NONNULL_END
