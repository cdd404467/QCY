//
//  MacroHeader.h
//  QCY
//
//  Created by zz on 2018/9/3.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#ifndef MacroHeader_h
#define MacroHeader_h

#import "UIColor+Hex.h"

//RGBA
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//Hex
#define HEXColor(string,alpha) [UIColor colorWithHexString:(string) andAlpha:(alpha)]

//屏幕大小
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
//屏幕的宽
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕的高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
// 适配宽比例
#define Scale_W [UIScreen mainScreen].bounds.size.width / 375
// 适配高比例
#define Scale_H (CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) ? 1.0 : [UIScreen mainScreen].bounds.size.height / 667)
//宽适配
#define KFit_W(variate) Scale_W * variate
//高适配
#define KFit_H(variate) Scale_H * variate
//判断是否是iPhoneX
//#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断是否是iPhoneX系列
#define iPhoneX (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f ? YES : NO)
//返回状态栏高度
#define STATEBAR_HEIGHT (iPhoneX ? 44.f : 20.f)
//返回tabbar的高度
#define TABBAR_HEIGHT (iPhoneX ? (49.f + 34.f) : 49.f)
//返回导航栏高度
#define NAV_HEIGHT (iPhoneX ? 88.f : 64.f)

//NSUserDefaults
#define UserDefault [NSUserDefaults standardUserDefaults]
//weakself 和 strongself
#define DDWeakSelf __weak typeof(self) weakself = self;
#define DDStrongSelf __weak typeof(weakself) strongself = weakself;

#endif /* MacroHeader_h */
