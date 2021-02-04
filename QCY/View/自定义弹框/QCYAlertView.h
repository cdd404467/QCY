//
//  QCYAlertView.h
//  QCY
//
//  Created by i7colors on 2019/10/21.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCYAlertView : UIView
+ (QCYAlertView *)showWithTitle:(NSString *)title text:(NSString *)text cancel:(void (^ __nullable)(void))cancel;
+ (QCYAlertView *)showWithTitle:(NSString *)title text:(NSString *)text btnTitle:(NSString * _Nullable )leftBt handler:(void (^ __nullable)(void))handler cancel:(void (^ __nullable)(void))cancel;
+ (QCYAlertView *)showWithTitle:(NSString *)title text:(NSString *)text leftBtnTitle:(NSString * _Nullable)leftBt rightBtnTitle:(NSString * _Nullable)rightBt leftHandler:(void (^ __nullable)(void))leftHandler rightHandler:(void (^ __nullable)(void))rightHandler cancel:(void (^ __nullable)(void))cancel;

@end

NS_ASSUME_NONNULL_END
