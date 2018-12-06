//
//  SwitchVC.h
//  QCY
//
//  Created by i7colors on 2018/10/24.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SwitchBlock)(NSInteger tag);
@interface SwitchVC : UIViewController

@property (nonatomic, copy)SwitchBlock switchBlock;
@property (nonatomic, assign)NSInteger sID;
@end

NS_ASSUME_NONNULL_END
