//
//  CircleClassifyVC.h
//  QCY
//
//  Created by i7colors on 2019/3/21.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
//#import "FriendCircleDelegate.h"


NS_ASSUME_NONNULL_BEGIN
@protocol FriendCircleDelegate;
@interface CircleClassifyVC : BaseViewController

@property (nonatomic,weak) id <FriendCircleDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
