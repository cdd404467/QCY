//
//  GroupBuyRecordVC.h
//  QCY
//
//  Created by i7colors on 2018/11/5.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupBuyRecordVC : BaseViewController

@property (nonatomic, copy)NSString *groupID;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)CGFloat tbHeight;
@end

NS_ASSUME_NONNULL_END
