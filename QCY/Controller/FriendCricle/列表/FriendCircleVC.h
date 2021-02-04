//
//  FriendCircleVC.h
//  QCY
//
//  Created by i7colors on 2018/11/19.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewControllerNav.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendCircleVC : BaseViewController
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSString *firstTopicID;
@property (nonatomic, copy)NSString *firstType;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *secondTopicID;
@property (nonatomic, copy)NSString *navTitle;
@property (nonatomic, assign)CGRect tbFrame;
@end

NS_ASSUME_NONNULL_END
