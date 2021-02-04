//
//  BindPhoneNumberVC.h
//  QCY
//
//  Created by i7colors on 2019/6/11.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^BindCompleteBlock)(void);
@interface BindPhoneNumberVC : BaseViewController
@property (nonatomic, copy)NSString *bindToken;
@property (nonatomic, assign)BOOL isJump;
@property (nonatomic, assign)NSInteger jumpIndex;
@property (nonatomic, copy)BindCompleteBlock bindCompleteBlock;
@end

NS_ASSUME_NONNULL_END
