//
//  BigVCertVC.h
//  QCY
//
//  Created by i7colors on 2018/12/9.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewControllerNav.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshMyInfoBlock)(void);
@interface BigVCertVC : BaseViewControllerNav

@property (nonatomic, copy)RefreshMyInfoBlock refreshMyInfoBlock;
@end

NS_ASSUME_NONNULL_END
