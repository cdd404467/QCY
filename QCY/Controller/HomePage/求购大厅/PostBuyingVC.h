//
//  PostBuyingVC.h
//  QCY
//
//  Created by i7colors on 2018/10/16.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^RefreshPostBuyBlock)(void);
@interface PostBuyingVC : BaseViewController

@property (nonatomic, copy)RefreshPostBuyBlock refreshPostBuyBlock;
@end

NS_ASSUME_NONNULL_END
