//
//  MyZhuJiDiyChildVC.h
//  QCY
//
//  Created by i7colors on 2019/8/7.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyZhuJiDiyChildVC : BaseViewController
@property (nonatomic, copy) NSString *status;
//判断是助剂定制还是助剂定制方案 （0 - 助剂定制 ; 1 - 助剂定制方案）
@property (nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
