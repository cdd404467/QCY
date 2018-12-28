//
//  BaseNavigationController.m
//  CodeDemo
//
//  Created by wangrui on 2017/4/19.
//  Copyright © 2017年 wangrui. All rights reserved.
//
//  Github地址：https://github.com/wangrui460/WRNavigationBar

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

+ (void)initialize
{
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.tintColor=[UIColor blackColor];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
