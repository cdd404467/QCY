//
//  WebViewVC.h
//  QCY
//
//  Created by i7colors on 2019/4/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewVC : BaseViewController
@property (nonatomic, copy)NSString *webUrl;
@property (nonatomic, assign)BOOL needBottom;
@end

NS_ASSUME_NONNULL_END
