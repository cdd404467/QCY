//
//  WhoCanSeeVC.h
//  QCY
//
//  Created by i7colors on 2019/4/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseSystemPresentVC.h"
@class FriendCricleInfoModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectePermissionBlock)(NSInteger permissionCode, NSMutableArray<FriendCricleInfoModel*> *selectArray);
@interface WhoCanSeeVC : BaseSystemPresentVC
@property (nonatomic, assign)NSInteger permission;
@property (nonatomic, copy)SelectePermissionBlock selectePermissionBlock;
@property (nonatomic, strong)NSMutableArray<FriendCricleInfoModel *> *selectArray;
@property (nonatomic, copy)NSString *userNames;
@end


NS_ASSUME_NONNULL_END
