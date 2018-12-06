//
//  AppDelegate.m
//  QCY
//
//  Created by zz on 2018/8/31.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "MacroHeader.h"
#import "TabbarVC.h"
#import <IQKeyboardManager.h>
#import "KSGuaidViewManager.h"
#import "NSString+Class.h"
//MOB
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "WXAuth.h"



@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [NSThread sleepForTimeInterval:1];
    [self guidePage];
    //初始化
    [self initWindow];
    [self initThirdParty];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}

//已经在后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


//从后台回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    

    return [WXAUTH handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}

#pragma mark - 初始化
- (void)initWindow {
    //初始化window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //加载根视图视图
    
    TabbarVC *rootVC = [[TabbarVC alloc] init];
    rootVC.selectedIndex = 0;
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)initThirdParty {
    //IQKeyBoard
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
    
    //注册微信
    [WXApi registerApp:@"wx63410989373f8975" enableMTA:YES];
    //shareSDK
    
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //注册微信
        [platformsRegister setupWeChatWithAppId:@"wx63410989373f8975" appSecret:@"8a63da0ba72799ddd58edf7b55357094"];
    }];
    
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

