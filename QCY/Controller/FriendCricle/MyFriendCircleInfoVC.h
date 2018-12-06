//
//  MyFriendCircleInfoVC.h
//  QCY
//
//  Created by i7colors on 2018/12/5.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class FriendCricleInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface MyFriendCircleInfoVC : BaseViewController

@property (nonatomic, copy)NSString *userID;
@end

@interface MyFriendCircleInfoView : UIView
@property (nonatomic, strong)UIButton *focusBtn;
@property (nonatomic, strong)FriendCricleInfoModel *model;
@end
NS_ASSUME_NONNULL_END
