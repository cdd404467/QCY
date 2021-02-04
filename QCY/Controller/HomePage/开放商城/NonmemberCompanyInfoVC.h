//
//  NonmemberCompanyInfoVC.h
//  QCY
//
//  Created by i7colors on 2019/7/12.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class FCMapModel;
@class FCMapNavigationModel;
NS_ASSUME_NONNULL_BEGIN

@interface NonmemberCompanyInfoVC : BaseViewController
@property (nonatomic, strong) FCMapModel *model;
@property (nonatomic, strong) FCMapNavigationModel *navModel;
@end

NS_ASSUME_NONNULL_END
