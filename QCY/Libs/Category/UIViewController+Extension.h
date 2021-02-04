//
//  UIViewController+Extension.h
//  QCY
//
//  Created by i7colors on 2019/3/18.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Extension)
//- (BaseNavigationController *)mainNavController;
@property(nonatomic,strong,readonly) BaseNavigationController *mainNavController;
@end

NS_ASSUME_NONNULL_END
