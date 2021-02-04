//
//  AppDelegate.m
//  QCY
//
//  Created by zz on 2018/8/31.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Helper.h"
//微信
#import "WXAuth.h"
#import "WXApiManager.h"
//极光推送
#import <JPUSHService.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "VCJump.h"
#import "BaseNavigationController.h"
#import "WebViewVC.h"
#import "Alert.h"
#import "MessageVC.h"
#import "MessageModel.h"
#import "BannerModel.h"



@interface AppDelegate ()<JPUSHRegisterDelegate>
@property (nonatomic, strong)UITabBarController *tabbarController;
@end

@implementation AppDelegate

#pragma mark - 生命周期
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化
    [self initAll];
    //注册通知
    [self registerAPNs:launchOptions application:application];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

//已经在后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

//从后台回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    Icon_BadgeValue = 0;
    [JPUSHService setBadge:0];
}

//打开app处理URL
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSString *urlStrID = [url.absoluteString substringToIndex:11];
    if (url && [urlStrID isEqualToString:@"arouter://m"]) {
        BaseNavigationController *nav = self.tabbarController.viewControllers[self.tabbarController.selectedIndex];
        [VCJump openShareURLWithHost:url.host query:url.query nav:nav];
        
        return YES;
    }
   
    return [WXAUTH handleOpenURL:url];
//    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

//程序进入前台，处于活跃期
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationName_ApplicationDidBecomeActive object:nil userInfo:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - APN代理
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

// Required, iOS 7 Support - 处于后台
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateBackground) {
        [self msgCountWithDict:userInfo];
    }
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 Support 点击
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [self dealWithApsWithDict:userInfo];
            [JPUSHService handleRemoteNotification:userInfo];
        }
    }
    completionHandler();  // 系统要求执行这个方法
}





// iOS 10 Support 在前台收到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler API_AVAILABLE(ios(10.0)) {
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self msgCountWithDict:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    //UNNotificationPresentationOptionAlert
    ///UNNotificationPresentationOptionBadge
}

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
//        NSLog(@"---1212");
    }else{
        //从通知设置界面进入应用
//        NSLog(@"---1212 ----- ");
    }
}

#pragma mark - 通知
//从通知栏点击跳转
- (void)dealWithApsWithDict:(NSDictionary *)dict {
    BannerModel *apnModel = [BannerModel mj_objectWithKeyValues:dict];
    NSString *workType = apnModel.workType;
    //系统消息，需要跳转到消息tab
    if ([workType isEqualToString:@"appSystemInform"]) {
        //系统消息 - app内部跳转
        if ([apnModel.type isEqualToString:@"inner"]) {
            [VCJump jumpToWithModel_Apns:apnModel];
        }
        //系统消息 - 跳转到html
        else if ([apnModel.type isEqualToString:@"html"]) {
            self.tabbarController.selectedIndex = 2;
            BaseNavigationController *nav = self.tabbarController.viewControllers[self.tabbarController.selectedIndex];
            MessageVC *navRootVC = (MessageVC *)nav.viewControllers.firstObject;
            navRootVC.index = 2;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"msgtab_item_selected" object:nil];
            NSString *url = [dict valueForKey:@"url"];
            WebViewVC *vc = [[WebViewVC alloc] init];
            vc.needBottom = YES;
            vc.webUrl = url;
            [nav pushViewController:vc animated:YES];
        }
    }
    //直接跳转到html
    else if ([workType isEqualToString:@"html"]) {
        BaseNavigationController *nav = self.tabbarController.viewControllers[self.tabbarController.selectedIndex];
        NSString *url = [dict valueForKey:@"url"];
        WebViewVC *vc = [[WebViewVC alloc] init];
        vc.needBottom = YES;
        vc.webUrl = url;
        [nav pushViewController:vc animated:YES];
    }
    //买家或者卖家消息
    else if ([workType isEqualToString:@"vMallInform"]) {
        MessageModel *model = [[MessageModel alloc] init];
        //买家还是卖家
        model.type = [dict valueForKey:@"type"];
        //消息类型 - 求购或者助剂定制
        model.directType = [dict valueForKey:@"directType"];
        //求购相关
        if ([model.directType isEqualToString:@"enquiry"]) {
            model.directTypeId = [dict valueForKey:@"enquiryId"];
        }
        //助剂定制相关
        else if ([model.directType isEqualToString:@"zhujiDiy"]) {
            //买家
            if ([model.type isEqualToString:@"buyer"]) {
                model.directTypeId = [dict valueForKey:@"zhujiDiyId"];
            }
            //卖家
            else if([model.type isEqualToString:@"seller"]) {
                model.directTypeId = [dict valueForKey:@"zhujiDiySolutionId"];
            }
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [VCJump jumpToVCWithModel:model];
        });
    }
    //课程直播
    else if ([workType isEqualToString:@"schoolLiveClass"]) {
        [VCJump jumpToWithModel_Apns:apnModel];
    }
}

#pragma mark - 自定义消息回调(印染圈)
- (void)customJpushHandle:(NSNotification *)notification {
    NSMutableDictionary *userDict = [User_Info mutableCopy];
    NSInteger count = 0;
    if (Get_Badge_Fc) {
        count = [Get_Badge_Fc integerValue] + 1;
    } else {
        count = 1;
    }
    [userDict setObject:@(count).stringValue forKey:@"fcBadge"];
    [UserDefault setObject:userDict forKey:@"userInfo"];
    [self.tabbarController.viewControllers[1].tabBarItem setBadgeValue:Get_Badge_Fc];
    NSString *FCMsg = @"FC_UnRead_Msg_message";
    [[NSNotificationCenter defaultCenter]postNotificationName:FCMsg object:nil userInfo:nil];
}



- (void)registerAPNs:(NSDictionary *)launchOptions application:(UIApplication *)application {
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
    [JPUSHService setLogOFF];
    //初始化 JPush 代码
    [JPUSHService setupWithOption:launchOptions appKey:@"72fda44ff48833af8afd0be5" channel:@"App Store" apsForProduction:YES];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode ==0) {
            NSLog(@"registrationID--- %@",registrationID);
            [UserDefault setObject:registrationID forKey:@"jpushID"];
        }
    }];
    
    // app未启动的状态下，在这里处理远程通知
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        
    }
    
    //注册监听推送
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(customJpushHandle:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}


- (void)msgCountWithDict:(NSDictionary *)userInfo {
    Tabbar_Msg_Badge_Set(Tabbar_Msg_Badge_Get + 1);
    DDWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.tabbarController.viewControllers[2].tabBarItem setBadgeValue:@(Tabbar_Msg_Badge_Get).stringValue];
    });
    
    NSString *workType = [userInfo valueForKey:@"workType"];
    //系统消息
    if ([workType isEqualToString:@"appSystemInform"] || [workType isEqualToString:@"html"]) {
        Msg_Sys_Count_Set(Msg_Sys_Count_Get + 1);
        
    }
    //买家或卖家
    else if ([workType isEqualToString:@"vMallInform"]) {
        NSString *userType = [userInfo valueForKey:@"type"];
        //买家
        if ([userType isEqualToString:@"buyer"]) {
            Msg_Buyer_Count_Set(Msg_Buyer_Count_Get + 1);
        }
        //卖家
        else if ([userType isEqualToString:@"seller"]) {
            Msg_Seller_Count_Set(Msg_Seller_Count_Get + 1);
        }
    } else {
        //这句是用来调试的，只在debug模式下有效
        if (isDebug)
            Msg_Sys_Count_Set(Msg_Sys_Count_Get + 1);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:App_Notification_Change_MsgCount object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"app_msg_nfc_refresh" object:nil];
}


- (UITabBarController *)tabbarController {
    _tabbarController = (UITabBarController *)_window.rootViewController;
    return _tabbarController;
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

