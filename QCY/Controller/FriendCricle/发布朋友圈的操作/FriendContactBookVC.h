//
//  FriendContactBookVC.h
//  QCY
//
//  Created by i7colors on 2019/4/17.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseSystemPresentVC.h"
@class FriendCricleInfoModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectedCompleteBlock)(NSMutableArray<FriendCricleInfoModel*> *selectArray);
@interface FriendContactBookVC : BaseSystemPresentVC
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)SelectedCompleteBlock selectedCompleteBlock;
@property (nonatomic, strong)NSMutableArray<FriendCricleInfoModel *> *selectArray;
@end


NS_ASSUME_NONNULL_END
