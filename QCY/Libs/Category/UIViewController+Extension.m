//
//  UIViewController+Extension.m
//  QCY
//
//  Created by i7colors on 2019/3/18.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "UIViewController+Extension.h"
//#import "BaseNavigationController.h"

@implementation UIViewController (Extension)

- (BaseNavigationController *)mainNavController {
    
    BaseNavigationController *nav = (BaseNavigationController *)self.navigationController;
    if (nav) {
        return nav;
    }

    return nil;
}

@end
