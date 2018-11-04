//
//  CddHUD.m
//  QCY
//
//  Created by i7colors on 2018/10/21.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "CddHUD.h"
#import "MacroHeader.h"

#define DELAY_TIME 1.5f
@implementation CddHUD

+ (MBProgressHUD *)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view onlyText:(BOOL)isOnly delay:(NSTimeInterval)duration {
    if (view == nil)
        view = [[UIApplication sharedApplication].windows lastObject];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled= NO;
    hud.bezelView.color = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    
    if (icon != nil) {
        UIImage *image = [[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        hud.customView = [[UIImageView alloc] initWithImage:image];
    }
    if (isOnly == YES) {
        hud.mode = MBProgressHUDModeText;
    }
    hud.margin = 18;
    hud.label.text = text;
    //不设置的话hud为半透明
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    //蒙版
//    hud.backgroundView.color = RGBA(0, 0, 0, 0.2);
    hud.removeFromSuperViewOnHide = YES;
    
    if (duration != 0) {
        [hud hideAnimated:YES afterDelay:DELAY_TIME];
    }
    
    return hud;
}

/*** 只显示菊花 ***/
+ (MBProgressHUD *)show {
   return [self show:nil icon:nil view:nil onlyText:NO delay:0];
}

+ (MBProgressHUD *)show:(UIView *)view {
    return [self show:nil icon:nil view:view onlyText:NO delay:0];
}

/*** 只显示菊花,延时关闭 ***/
//+ (void)showDelay {
//    [self show:nil icon:nil view:nil onlyText:NO delay:DELAY_TIME];
//}

/*** 只显示文本 ***/
+ (void)showTextOnly:(NSString *)text {
    [self show:text icon:nil view:nil onlyText:YES delay:0];
}

+ (void)showTextOnly:(NSString *)text view:(UIView *)view {
    [self show:text icon:nil view:view onlyText:YES delay:0];
}


/*** 只显示文本,延时关闭 ***/
+ (void)showTextOnlyDelay:(NSString *)text {
    [self show:text icon:nil view:nil onlyText:YES delay:DELAY_TIME];
}

+ (void)showTextOnlyDelay:(NSString *)text view:(UIView *)view {
    [self show:text icon:nil view:view onlyText:YES delay:DELAY_TIME];
}

/*** 菊花和文本 ***/
+ (MBProgressHUD *)showWithText:(NSString *)text {
    return [self show:text icon:nil view:nil onlyText:NO delay:0];
}

+ (MBProgressHUD *)showWithText:(NSString *)text view:(UIView *)view {
    return [self show:text icon:nil view:view onlyText:NO delay:0];
}

/*** 菊花和文本,延时关闭 ***/
//+ (void)showWithTextDelay:(NSString *)text {
//    [self show:text icon:nil view:nil onlyText:NO delay:DELAY_TIME];
//}


/*** 关闭hud ***/
+ (void)hideHUDForView:(UIView * _Nullable)view {
    if (view == nil)
        view = [[UIApplication sharedApplication].windows lastObject];
    
    [MBProgressHUD hideHUDForView:view animated:YES];
}

/*** 关闭 window hud ***/
+ (void)hideHUD {
    [CddHUD hideHUDForView:nil];
}

+ (void)showSwitchText:(MBProgressHUD *)hud text:(NSString *)text {
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:DELAY_TIME];
}




@end
