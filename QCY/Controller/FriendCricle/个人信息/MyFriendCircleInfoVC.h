//
//  MyFriendCircleInfoVC.h
//  QCY
//
//  Created by i7colors on 2018/12/5.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendCircleDelegate.h"
@class FriendCricleInfoModel;
@class YYLabel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickFocusBlock)(NSString *type);
@interface MyFriendCircleInfoVC : BaseViewController<FriendCircleDelegate>
@property (nonatomic,weak) id <FriendCircleDelegate> refreshDelegate;
@property (nonatomic, copy)NSString *ofType;
@property (nonatomic, copy)NSString *userID;
@property (nonatomic, copy)ClickFocusBlock clickFocusBlock;
@property (nonatomic, copy)NSString *messageType;
@property (nonatomic, copy)NSString *messageId;
@property (nonatomic, assign)NSInteger index;
@end



typedef void(^CertClickBlock)(void);
@interface MyFriendCircleInfoView : UIView
@property (nonatomic, strong)UIButton *focusBtn;
@property (nonatomic, strong)UIButton *changeBtn;
@property (nonatomic, copy)NSString *ofType;
@property (nonatomic, strong)YYLabel *isCert;
@property (nonatomic, strong)UIImageView *headerImage;
@property (nonatomic, strong)FriendCricleInfoModel *model;
@property (nonatomic, copy)CertClickBlock certClickBlock;
@end
NS_ASSUME_NONNULL_END
