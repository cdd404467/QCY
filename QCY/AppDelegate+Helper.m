//
//  AppDelegate+Helper.m
//  QCY
//
//  Created by i7colors on 2019/9/15.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AppDelegate+Helper.h"
#import <IQKeyboardManager.h>
#import "KSGuaidViewManager.h"
#import "WXApi.h"
//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
//友盟
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
//MOB
#import <ShareSDK/ShareSDK.h>
#import "TabbarVC.h"
#import "VHLNavigation.h"


@implementation AppDelegate (Helper)

- (void)initAll {
    [self initWindow];
    [self initThirdParty];
}


//注册、初始化第三方
- (void)initThirdParty {
    //引导页
    [self guidePage];
    
    //导航栏
    [VHLNavigation vhl_setDefaultNavBackgroundColor:Like_Color];
    [VHLNavigation vhl_setDefaultNavBarShadowImageHidden:YES];
    
    /*** IQKeyBoard ***/
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f;    // 输入框距离键盘的距离
    
    /*** 注册微信 - 官方SDK ***/
    [WXApi registerApp:@"wx63410989373f8975" enableMTA:YES];
    
    /*** shareSDK ***/
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //注册微信
        [platformsRegister setupWeChatWithAppId:@"wx63410989373f8975" appSecret:@"8a63da0ba72799ddd58edf7b55357094"];
    }];
    
    /*** 高德地图 ***/
    [AMapServices sharedServices].apiKey = @"68bee531a097b8ab56860010e904de67";
    
    /*** 友盟 ***/ //DEBUG模式下不开启友盟统计
#ifndef DEBUG
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    [UMConfigure initWithAppkey:@"5cd38579570df39ca5000ab2" channel:@"App Store"];
    //    [UMConfigure setLogEnabled:YES];
    //    [UMCommonLogManager setUpUMCommonLogManager];
#endif
}

- (void)initWindow {
    //初始化window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    if(@available(iOS 13.0,*)) {
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    //加载根视图视图
    TabbarVC *rootVC = [[TabbarVC alloc] init];
    rootVC.selectedIndex = 0;
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
}

- (void)guidePage {
    KSGuaidManager.images = @[[UIImage imageNamed:@"guidepage_1"],
                              [UIImage imageNamed:@"guidepage_2"],
                              [UIImage imageNamed:@"guidepage_3"],
                              [UIImage imageNamed:@"guidepage_4"]];
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    KSGuaidManager.dismissButtonCenter = CGPointMake(size.width / 2, size.height - 70);
    KSGuaidManager.pageIndicatorTintColor = RGBA(0, 0, 0, 0.2);
    KSGuaidManager.currentPageIndicatorTintColor = [UIColor whiteColor];
    [KSGuaidManager begin];
}


@end
