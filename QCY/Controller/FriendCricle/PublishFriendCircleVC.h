//
//  PublishFriendCircleVC.h
//  QCY
//
//  Created by i7colors on 2018/12/3.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshFCBlock)(void);
@interface PublishFriendCircleVC : BaseViewController

@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UIButton *publishBtn;
@property (nonatomic, copy)RefreshFCBlock refreshFCBlock;
@end

NS_ASSUME_NONNULL_END
