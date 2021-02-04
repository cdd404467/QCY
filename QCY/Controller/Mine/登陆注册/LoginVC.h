//
//  LoginVC.h
//  QCY
//
//  Created by i7colors on 2018/9/20.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseSystemPresentVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LoginCompleteBlock)(void);

@interface LoginVC : BaseSystemPresentVC
@property (nonatomic, copy , nullable) LoginCompleteBlock loginCompleteBlock;
@property (nonatomic, assign) BOOL isJump;
@property (nonatomic, assign) NSInteger jumpIndex;
@end

NS_ASSUME_NONNULL_END
