//
//  ShopMainPageVC.h
//  QCY
//
//  Created by i7colors on 2018/10/30.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class FCMapNavigationModel;
NS_ASSUME_NONNULL_BEGIN

@interface ShopMainPageVC : BaseViewController
@property (nonatomic, strong) FCMapNavigationModel *navModel;
@property (nonatomic, copy)NSString *storeID;
@end


NS_ASSUME_NONNULL_END
