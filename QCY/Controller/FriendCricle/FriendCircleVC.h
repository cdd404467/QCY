//
//  FriendCircleVC.h
//  QCY
//
//  Created by i7colors on 2018/11/19.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewControllerNav.h"
#import "FriendCircleDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendCircleVC : BaseViewController <FriendCircleDelegate>

@property (nonatomic,weak) id <FriendCircleDelegate> friendDelegate;
@end

NS_ASSUME_NONNULL_END
