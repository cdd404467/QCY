//
//  InformationChildVC.h
//  QCY
//
//  Created by i7colors on 2018/11/1.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class InfomationModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectedZXBlock)(InfomationModel *model);
@interface InformationChildVC : BaseViewController
@property (nonatomic, copy)NSString *fromPage;
@property (nonatomic, copy)NSString *typeID;
@property (nonatomic, copy)SelectedZXBlock selectedZXBlock;
@end

NS_ASSUME_NONNULL_END
