//
//  FriendCircleDetailVC.h
//  QCY
//
//  Created by i7colors on 2018/12/11.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

//#import "BaseViewControllerNav.h"
#import "BaseViewController.h"
#import "FriendCircleDelegate.h"
@class FriendCricleModel;

NS_ASSUME_NONNULL_BEGIN

@interface FriendCircleDetailVC : BaseViewController<FriendCircleDelegate>
@property (nonatomic,weak) id <FriendCircleDelegate> refreshDelegate;
//传过来的帖子ID
@property (nonatomic, copy)NSString *tieziID;
//未读消息跳转
@property (nonatomic, copy)NSString *messageType;
@property (nonatomic, copy)NSString *messageId;
@property (nonatomic, assign)NSInteger index;
@end


typedef void(^ZiXunClickBlock)(NSString *zixunID);
@interface FCDetailHeaderView : UIView
@property (nonatomic, strong)FriendCricleModel *headerModel;
@property (nonatomic, copy)NSString *tieziStamp;
@property (nonatomic, copy)ZiXunClickBlock ziXunClickBlock;
@property (nonatomic, assign) CGFloat bottom;
@end

NS_ASSUME_NONNULL_END
