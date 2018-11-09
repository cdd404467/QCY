//
//  AppDelegate.m
//  QCY
//
//  Created by zz on 2018/8/31.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "TabbarVC.h"
#import <IQKeyboardManager.h>
#import "NSString+Class.h"



@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSThread sleepForTimeInterval:1];
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
    
    if (!url) {
        return NO;
    }
    
    //接收到的字符串
//    NSString *urlString = [url absoluteString];
//    NSLog(@"urlh --   %@ --- %@",url.host,url.query);
//    NSString *classString = [urlString componentsSeparatedByString:@"togo="].lastObject;
//    NSDictionary *dict = @{@"className":classString};
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"urlJump" object:nil userInfo:dict];
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    UIViewController *vc = [classString stringToClass:classString];
//    [appDelegate.rootViewController.navigationController pushViewController:viewController animated:NO];
    
    return YES;
}

//- (void)appJumpToPage:(NSInteger)type andParagam:(id)obj,...{
////    [AppDelegate di];
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////    Class class = [self pageTransferClassDict][@(type)];
////    [appDelegate.rootViewController setSelectedIndex:0];
//    UIViewController *viewController = [[class alloc]init];
//    viewController.params = obj;
//    [appDelegate.rootViewController.navigationController pushViewController:viewController animated:NO];
//}

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
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}



@end

@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
