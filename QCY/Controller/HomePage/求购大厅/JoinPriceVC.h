//
//  JoinPriceVC.h
//  QCY
//
//  Created by i7colors on 2018/10/17.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshDataBlock)(void);
@interface JoinPriceVC : BaseViewController

@property (nonatomic, copy)NSString *productID;
@property (nonatomic, copy)RefreshDataBlock refreshDataBlock;

@end

NS_ASSUME_NONNULL_END
