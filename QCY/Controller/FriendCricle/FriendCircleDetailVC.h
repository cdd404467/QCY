//
//  FriendCircleDetailVC.h
//  QCY
//
//  Created by i7colors on 2018/12/11.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

//#import "BaseViewControllerNav.h"
#import "BaseViewController.h"
@class FriendCricleModel;

NS_ASSUME_NONNULL_BEGIN

@interface FriendCircleDetailVC : BaseViewController
//传过来的帖子ID
@property (nonatomic, copy)NSString *tieziID;

@end

@interface FCDetailHeaderView : UIView
@property (nonatomic, strong)FriendCricleModel *headerModel;
@property (nonatomic, copy)NSString *tieziStamp;

@property (nonatomic, assign) CGFloat bottom;
@end

NS_ASSUME_NONNULL_END
