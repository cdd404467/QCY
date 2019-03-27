//
//  FriendCircleRecordVC.h
//  QCY
//
//  Created by i7colors on 2018/12/5.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewControllerNav.h"
@class FriendCricleInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface FriendCircleRecordVC : BaseViewController
@property (nonatomic, copy)NSString *userID;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)FriendCricleInfoModel *headerModel;
@end

NS_ASSUME_NONNULL_END
