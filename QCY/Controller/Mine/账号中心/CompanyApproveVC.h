//
//  CompanyApproveVC.h
//  QCY
//
//  Created by i7colors on 2018/11/19.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewControllerNav.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshMyInfoBlock)(void);
@interface CompanyApproveVC : BaseViewController
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *infoID;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) RefreshMyInfoBlock refreshMyInfoBlock;
@end

NS_ASSUME_NONNULL_END
