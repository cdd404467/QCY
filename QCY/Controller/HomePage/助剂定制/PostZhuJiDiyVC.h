//
//  PostZhuJiDiyVC.h
//  QCY
//
//  Created by i7colors on 2019/8/2.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshZhuJiDiyListBlock)(void);

@interface PostZhuJiDiyVC : BaseViewController

@property (nonatomic, copy) RefreshZhuJiDiyListBlock refreshZhuJiDiyListBlock;
@property (nonatomic, copy) NSString *specialCompanyName;
@property (nonatomic, copy) NSString *specialID;

@end

NS_ASSUME_NONNULL_END
