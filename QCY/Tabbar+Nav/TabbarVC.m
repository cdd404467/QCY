//
//  TabbarVC.m
//  QCY
//
//  Created by zz on 2018/9/3.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "TabbarVC.h"
#import "MacroHeader.h"
#import "HomePageVC.h"
#import "HeadLineVC.h"
#import "MessageVC.h"
#import "MineVC.h"
#import "BaseNavigationController.h"


@interface TabbarVC ()<UITabBarDelegate, UITabBarControllerDelegate>

@end

@implementation TabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    //去掉半透明
    self.tabBar.translucent = NO;
    self.delegate = self;
    //去掉tabbar的黑线
//    [self.tabBar setBackgroundImage:[UIImage new]];
//    [self.tabBar setShadowImage:[UIImage new]];
    [self initTabbar];
}

//初始化tabbar
- (void)initTabbar {
    
    HomePageVC *vc_1 = [[HomePageVC alloc] init];
    [self addChildViewController:vc_1 tabTitle:@"首页" normalImage:@"icon1" selectedImage:@"icon1-1"];
    
    HeadLineVC *vc_2 = [[HeadLineVC alloc] init];
    [self addChildViewController:vc_2 tabTitle:@"头条" normalImage:@"icon2" selectedImage:@"icon2-1"];
    
    MessageVC *vc_3 = [[MessageVC alloc] init];
    [self addChildViewController:vc_3 tabTitle:@"消息" normalImage:@"icon3" selectedImage:@"icon3-1"];
    
    MineVC *vc_4 = [[MineVC alloc] init];
    [self addChildViewController:vc_4 tabTitle:@"我的" normalImage:@"icon3" selectedImage:@"icon3-1"];
}



//添加childViewController
- (void)addChildViewController:(UIViewController *)vc tabTitle:(NSString *)tabTitle normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage {
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
//    nav.navigationBar.translucent = NO;
    nav.tabBarItem.title = tabTitle;
    vc.navigationItem.title = tabTitle;
    //调整每个bar title的位置
    [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -1)];
    //调整bar icon的位置
    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
    NSDictionary *titleColor = [NSDictionary dictionaryWithObject:RGBA(0, 0, 0, 0.7) forKey:NSForegroundColorAttributeName];
    [nav.tabBarItem setTitleTextAttributes:titleColor forState:UIControlStateNormal];
    //未选中图片
    UIImage *normal_image = [UIImage imageNamed:normalImage];
    normal_image = [normal_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.image = normal_image;
    //选中后图片
    UIImage *selected_image = [UIImage imageNamed:selectedImage];
    selected_image = [selected_image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = selected_image;
    
    [self addChildViewController:nav];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
