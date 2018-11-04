//
//  CddHUD.h
//  QCY
//
//  Created by i7colors on 2018/10/21.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface CddHUD : NSObject
+ (MBProgressHUD *)show;
+ (MBProgressHUD *)show:(UIView *)view;

+ (void)showTextOnly:(NSString *)text;
+ (void)showTextOnly:(NSString *)text view:(UIView *)view;

+ (void)showTextOnlyDelay:(NSString *)text;
+ (void)showTextOnlyDelay:(NSString *)text view:(UIView *)view;

+ (MBProgressHUD *)showWithText:(NSString *)text;
+ (MBProgressHUD *)showWithText:(NSString *)text view:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView * _Nullable)view;

+ (void)showSwitchText:(MBProgressHUD *)hud text:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
