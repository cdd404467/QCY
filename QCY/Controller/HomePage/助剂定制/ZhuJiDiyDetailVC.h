//
//  ZhuJiDiyDetailVC.h
//  QCY
//
//  Created by i7colors on 2019/7/31.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZhuJiDiyDetailVC : BaseViewController
@property (nonatomic, copy) NSString *zhuJiDiyID;
//判断是从我的页面进入还是首页进入(home || myZhuJiDiy || myZhuJiSolution)
@property (nonatomic, copy) NSString *jumpFrom;

@end

NS_ASSUME_NONNULL_END
