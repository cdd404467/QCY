//
//  BasePresentViewController.h
//  QCY
//
//  Created by i7colors on 2019/3/23.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RightBtnClickBlock)(void);
@interface BasePresentViewController : BaseViewController
@property (nonatomic, copy)RightBtnClickBlock rightBtnClickBlock;
@property (nonatomic, strong)CustomNavigationBar *navBar;
@end

NS_ASSUME_NONNULL_END
