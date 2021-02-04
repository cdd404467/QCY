//
//  PerfectMyInfoVC.h
//  QCY
//
//  Created by i7colors on 2019/8/15.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CompleteBlock)(void);
@interface PerfectMyInfoVC : BaseViewController
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) CompleteBlock completeBlock;
@end

NS_ASSUME_NONNULL_END
