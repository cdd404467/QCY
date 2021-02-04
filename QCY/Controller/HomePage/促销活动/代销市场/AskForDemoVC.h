//
//  AskForDemoVC.h
//  QCY
//
//  Created by i7colors on 2020/3/24.
//  Copyright © 2020 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class ProxySaleModel;

NS_ASSUME_NONNULL_BEGIN

@interface AskForDemoVC : BaseViewController
@property (nonatomic, copy) NSString *pageType;
@property (nonatomic, strong)ProxySaleModel *dataSource;
@end

NS_ASSUME_NONNULL_END
