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
#import "VHLNavigation.h"

//极光推送
#import <JPUSHService.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "Alert.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [NSThread sleepForTimeInterval:1];
    [self guidePage];
    //初始化
    [self initWindow];
    //初始化第三方
    [self initThirdParty];
    //注册通知
//    [self registerAPNs:launchOptions];
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


//推送通知获取设备
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

//实现注册 APNs 失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"APNs注册失败: %@", error);
}

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
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
    [VHLNavigation vhl_setDefaultNavBackgroundColor:UIColor.whiteColor];
}

- (void)initThirdParty {
    /*** IQKeyBoard ***/
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    // 输入框距离键盘的距离
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f;
    
    /*** 注册微信 - 官方SDK ***/
    [WXApi registerApp:@"wx63410989373f8975" enableMTA:YES];
    
    /*** shareSDK ***/
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //注册微信
        [platformsRegister setupWeChatWithAppId:@"wx63410989373f8975" appSecret:@"8a63da0ba72799ddd58edf7b55357094"];
    }];
    
}

- (void)registerAPNs:(NSDictionary *)launchOptions {
    /*** 注册极光推送 ***/
    //初始化 APNs 代码
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //初始化 JPush 代码
    [JPUSHService setupWithOption:launchOptions appKey:@"72fda44ff48833af8afd0be5" channel:@"App Store" apsForProduction:YES];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode ==0) {
//            NSLog(@"deviceToken ----------------- === %@",registrationID);
//            [Alert alertOne:registrationID okBtn:@"知道了" OKCallBack:^{
//                
//            }];
        }
        
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

