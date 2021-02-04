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
#import "JudgeTools.h"


#define _PRODUCTION_NETWORK
//#define _ONLINE_TEST_NETWORK
//#define _LOCAL_TEST_NETWORK


#ifdef _PRODUCTION_NETWORK
#define URL_ALL_API @"https://i7app.i7colors.com/app-web/"
#define Photo_URL @"http://static.i7colors.com"
#define ShareString @"mobile"
#else
#ifdef _ONLINE_TEST_NETWORK
#define URL_ALL_API @"https://i7apptest.i7colors.com/app-web/"
#define Photo_URL @"http://static1.i7colors.com"
#define ShareString @"manage"
#else
#define URL_ALL_API @"http://192.168.11.54:9919/app-web/"
#define Photo_URL @"http://192.168.0.76"
#define ShareString @"manage"
#endif
#endif



//公司电话
#define CompanyContact @"02164860217,8021"
//图片地址
#define ImgStr(urlStr) [NSString stringWithFormat:@"%@%@",Photo_URL,urlStr]
#define ImgUrl(urlStr) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Photo_URL,urlStr]]

//占位图片
#define PlaceHolderImg [UIImage imageNamed:@"placeHolder_Img1"]
#define PlaceHolderImgBanner [UIImage imageNamed:@"placeHolder_Img2"]
#define DefaultImage [UIImage imageNamed:@"default_116"]
//logo
#define Logo [UIImage imageNamed:@"appLogo"]

/*** 颜色 ***/
#define LineColor [UIColor colorWithHexString:@"#e9e9e9"]   //全局线条颜色
#define MainColor [UIColor colorWithHexString:@"#ef3673"]   //全局主题色
#define View_Color [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];     //全局view背景色
#define Main_BgColor RGBA(0, 0, 0, 0.08)
#define Cell_BGColor  HEXColor(@"#e1e1e1", 1)
#define Like_Color HEXColor(@"#ededed", 1)

//RGBA
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define RGBA_F(r, g, b, a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]

//Hex
#define HEXColor(string,alpha) [UIColor colorWithHexString:(string) andAlpha:(alpha)]

/*** 手机尺寸 ***/
//屏幕大小
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
//屏幕的宽
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕的高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//系统版本
#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

//app角标
#define Icon_BadgeValue [UIApplication sharedApplication].applicationIconBadgeNumber
//Tabbar 标记
#define Tab_BadgeValue_1(value) [self.navigationController.tabBarController.viewControllers[1].tabBarItem setBadgeValue:value];
#define Tab_BadgeValue_2(value) [self.navigationController.tabBarController.viewControllers[2].tabBarItem setBadgeValue:value];
//极光ID
#define JPushID [UserDefault objectForKey:@"jpushID"]

/*** 手机适配（包括iPhoneX系列） ***/
// 适配宽比例
#define Scale_W [UIScreen mainScreen].bounds.size.width / 375.f
//iPhoneXR 和 iPhoneXS Max
#define XP (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f ? 736.f/667.f : [UIScreen mainScreen].bounds.size.height / 667.f)

//宽适配
#define KFit_W(variate) Scale_W * variate

//判断是否是iPhoneX系列
#define iPhoneX (((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f)) ? YES : NO)

/*** 适配iPhoneX 顶部和底部 ***/
//返回状态栏高度
#define STATEBAR_HEIGHT (iPhoneX ? 44.f : 20.f)
//返回tabbar的高度
#define TABBAR_HEIGHT (iPhoneX ? (49.f + 34.f) : 49.f)
//返回导航栏高度
#define NAV_HEIGHT (iPhoneX ? 88.f : 64.f)
//顶部高度差
#define Top_Height_Dif (((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f)) ? 24.f: 0.f)
//底部高度差
#define Bottom_Height_Dif (((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f)) ? 34.f : 0.f)


/*** 常用代码简化宏 ***/
//weakself 和 strongself
#define DDWeakSelf __weak typeof(self) weakself = self;
#define DDStrongSelf __weak typeof(self) strongself = self;

//判断后台返回数据是合法的
#define isRightData(jsonData) (jsonData && ![jsonData isEqualToString:@""] && ![jsonData isEqualToString:@"null"] && ![jsonData isEqualToString:@"<null>"] && jsonData != NULL && ![jsonData isKindOfClass:[NSNull class]])
//判断后台返回数据是不合法的
#define isNotRightData(jsonData) (!jsonData || [jsonData isEqualToString:@""]  || [jsonData isEqualToString:@"null"] || [jsonData isEqualToString:@"<null>"] || jsonData == NULL || [jsonData isKindOfClass:[NSNull class]])

//转换字符串
#define To_String(code) [NSString stringWithFormat:@"%@", code]

/*********   本地存储   *********/
//NSUserDefaults
#define UserDefault [NSUserDefaults standardUserDefaults]
//用户信息
#define User_Info [UserDefault objectForKey:@"userInfo"]
//获取 userToken
#define GET_USER_TOKEN [User_Info objectForKey:@"token"]
//高级版自动判断获取usertoken
#define User_Token ([User_Info objectForKey:@"token"] ? [User_Info objectForKey:@"token"] : @"")
//获取头像
#define Get_Header [User_Info objectForKey:@"userHeaderImage"]
//公司名称
#define Get_CompanyName [User_Info objectForKey:@"companyName"]
//用户名称
#define Get_UserName [User_Info objectForKey:@"userName"]
//印染地图历史搜索的地区
#define FCMap_History_Area [UserDefault objectForKey:@"fcMapHistoryAreaArray"]


#pragma mark - msg存储
//消息- tabbar badgeValue
#define Tabbar_Msg_Badge_Get [UserDefault integerForKey:@"msgBadge"]
#define Tabbar_Msg_Badge_Set(badge) [UserDefault setInteger:badge forKey:@"msgBadge"]

//用来设置tabbar，数字转nil
#define Count_For_Tabbar(count) (count <= 0 ? nil : @(count).stringValue)

//系统消息
#define Msg_Sys_Count_Get [UserDefault integerForKey:@"msgSysCount"]
#define Msg_Sys_Count_Set(badge) [UserDefault setInteger:badge forKey:@"msgSysCount"]

//买家消息
#define Msg_Buyer_Count_Get [UserDefault integerForKey:@"msgBuyerCount"]
#define Msg_Buyer_Count_Set(badge) [UserDefault setInteger:badge forKey:@"msgBuyerCount"]

//卖家消息
#define Msg_Seller_Count_Get [UserDefault integerForKey:@"msgSellerCount"]
#define Msg_Seller_Count_Set(badge) [UserDefault setInteger:badge forKey:@"msgSellerCount"]

//朋友圈消息
#define Get_Badge_Fc ([User_Info objectForKey:@"fcBadge"] ? [[User_Info valueForKey:@"fcBadge"] integerValue] == 0 ? nil : To_String([User_Info valueForKey:@"fcBadge"]) : nil)



#ifdef DEBUG
#define sLog(format, ...) NSLog((@"[函数名:%s]" "[行号:%d]  " format), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define sLog(...)
#endif



#pragma mark - 快速判断
//判断是不是模拟器
#define isSimuLator [JudgeTools is_SimuLator]
//判断是否是debug模式
#define isDebug [JudgeTools is_Debug]
//是否是企业用户
#define isCompanyUser [JudgeTools is_CompanyUser]
//用户类型
#define User_Type [JudgeTools getUserType]

#endif /* MacroHeader_h */
