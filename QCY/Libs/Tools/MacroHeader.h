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
#import "UIImage+Color.h"


#define Photo_URL @"http://192.168.0.76"
//线上测试-图片
//#define Photo_URL @"http://static1.i7colors.com"

#define CompanyContact @"4009208599"
//图片地址
#define ImgStr(urlStr) [NSString stringWithFormat:@"%@%@",Photo_URL,urlStr]
#define ImgUrl(urlStr) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Photo_URL,urlStr]]
//占位图片
#define PlaceHolderImg [UIImage imageNamed:@"placeHolder_Img1"]

/*** 颜色 ***/
#define LineColor [UIColor colorWithHexString:@"#e5e5e5"]
#define MainColor [UIColor colorWithHexString:@"#ef3673"]
#define View_Color [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
#define Main_BgColor RGBA(0, 0, 0, 0.08)
//RGBA
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//Hex
#define HEXColor(string,alpha) [UIColor colorWithHexString:(string) andAlpha:(alpha)]

/*** 手机d尺寸 ***/
//屏幕大小
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
//屏幕的宽
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕的高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/*** 手机适配（包括iPhoneX系列） ***/
// 适配宽比例
#define Scale_W [UIScreen mainScreen].bounds.size.width / 375.f
//iPhoneXR 和 iPhoneXS Max
#define XP (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f ? 736.f/667.f : [UIScreen mainScreen].bounds.size.height / 667.f)
#define Scale_H (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f ? 1.0 : XP)
//宽适配
#define KFit_W(variate) Scale_W * variate
//高适配
#define KFit_H(variate) Scale_H * variate
//判断是否是iPhoneX系列
#define iPhoneX (((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f)) ? YES : NO)

/*** 适配iPhoneX 顶部和底部 ***/
//返回状态栏高度
#define STATEBAR_HEIGHT (iPhoneX ? 44.f : 20.f)
//返回tabbar的高度
#define TABBAR_HEIGHT (iPhoneX ? (49.f + 34.f) : 49.f)
//返回导航栏高度
#define NAV_HEIGHT (iPhoneX ? 88.f : 64.f)
//顶部高度h差
#define Top_Height_Dif (((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f)) ? 24.f: 0.f)
//底部高度差
#define Bottom_Height_Dif (((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f)) ? 34.f : 0.f)


/*** 常用代码简化宏 ***/
//NSUserDefaults
#define UserDefault [NSUserDefaults standardUserDefaults]
//weakself 和 strongself
#define DDWeakSelf __weak typeof(self) weakself = self;
#define DDStrongSelf __weak typeof(weakself) strongself = weakself;

//判断后台返回数据是合法的
#define isRightData(jsonData) (jsonData && ![jsonData isEqualToString:@""]  && ![jsonData isEqualToString:@"null"] && ![jsonData isEqualToString:@"<null>"] && jsonData != NULL && ![jsonData isKindOfClass:[NSNull class]])
//判断后台返回数据是不合法的
#define isNotRightData(jsonData) (!jsonData || [jsonData isEqualToString:@""]  || [jsonData isEqualToString:@"null"] || [jsonData isEqualToString:@"<null>"] || jsonData == NULL || [jsonData isKindOfClass:[NSNull class]])

//转换字符串
#define To_String(code) [NSString stringWithFormat:@"%@", code]
//获取 userToken
#define GET_USER_TOKEN [[UserDefault objectForKey:@"userInfo"] objectForKey:@"token"]

//获取头像
#define Get_Header [[UserDefault objectForKey:@"userInfo"] objectForKey:@"userHeaderImage"]
//判断是否是企业用户
#define isCompany [[UserDefault objectForKey:@"userInfo"] objectForKey:@"isCompany"]
//公司名称
#define Get_CompanyName [[UserDefault objectForKey:@"userInfo"] objectForKey:@"companyName"]

#ifdef DEBUG
#define sLog(format, ...) NSLog((@"[函数名:%s]" "[行号:%d]  " format), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define sLog(...)
#endif


#endif /* MacroHeader_h */
