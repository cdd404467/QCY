//
//  TabbarVC.m
//  QCY
//
//  Created by zz on 2018/9/3.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "TabbarVC.h"
#import "HomePageVC.h"
//#import "FriendCircleVC.h"
#import "CircleClassifyVC.h"
#import "MessageVC.h"
#import "MineVC.h"
#import "BaseNavigationController.h"
#import "LoginVC.h"
#import "ViewController.h"

@interface TabbarVC ()<UITabBarDelegate, UITabBarControllerDelegate>
@property (nonatomic,assign) NSInteger  indexFlag;
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
//    ViewController *vc_1 = [[ViewController alloc] init];
    [self addChildViewController:vc_1 tabTitle:@"首页" normalImage:@"tabbar_1" selectedImage:@"tabbar_1_selected"];
    
    CircleClassifyVC *vc_2 = [[CircleClassifyVC alloc] init];
    [self addChildViewController:vc_2 tabTitle:@"印染圈" normalImage:@"tabbar_2" selectedImage:@"tabbar_2_selected"];

    MessageVC *vc_3 = [[MessageVC alloc] init];
    [self addChildViewController:vc_3 tabTitle:@"消息" normalImage:@"tabbar_3" selectedImage:@"tabbar_3_selected"];
    
    MineVC *vc_4 = [[MineVC alloc] init];
    [self addChildViewController:vc_4 tabTitle:@"我的" normalImage:@"tabbar_4" selectedImage:@"tabbar_4_selected"];
}



//添加childViewController
- (void)addChildViewController:(UIViewController *)vc tabTitle:(NSString *)tabTitle normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage {
    
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
//    nav.navigationBar.translucent = NO;
    nav.tabBarItem.title = tabTitle;
    vc.navigationItem.title = tabTitle;
    //调整每个bar title的位置
    [nav.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    //调整bar icon的位置
    nav.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    NSDictionary *titleColor = [NSDictionary dictionaryWithObject:RGBA(0, 0, 0, 0.7) forKey:NSForegroundColorAttributeName];
    NSDictionary *selectedTitleColor = [NSDictionary dictionaryWithObject:MainColor forKey:NSForegroundColorAttributeName];
    [nav.tabBarItem setTitleTextAttributes:titleColor forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:selectedTitleColor forState:UIControlStateSelected];
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


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:@"我的"]) {
        if (!GET_USER_TOKEN) {
            LoginVC *vc = [[LoginVC alloc] init];
            BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
            navVC.modalPresentationStyle = UIModalPresentationFullScreen;
            UITabBarController *tb = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
            vc.isJump = YES;
            vc.jumpIndex = tb.tabBar.items.count - 1;
            
            [self presentViewController:navVC animated:YES completion:nil];
            return NO;
        }else {
            return YES;
        }
    }
//    else if ([viewController.tabBarItem.title isEqualToString:@"消息"]) {
//        if (!GET_USER_TOKEN) {
//            LoginVC *vc = [[LoginVC alloc] init];
//            BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:vc];
//            UITabBarController *tb = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
//            vc.isJump = YES;
//            vc.jumpIndex = tb.tabBar.items.count - 2;
//            [self presentViewController:navVC animated:YES completion:nil];
//            return NO;
//        }else {
//            return YES;
//        }
//    }
    else {
        return YES;
    }
}

////已经选中tabbar的 item
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    NSInteger index = [self.tabBar.items indexOfObject:item];
//    if (index != self.indexFlag) {
//        //执行动画
//        NSMutableArray *array = [NSMutableArray array];
//        for (UIView *btn in self.tabBar.subviews) {
//            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//                UIImageView *btnImageView = [btn valueForKey:@"info"];
//                [array addObject:btnImageView];
//            }
//        }
//        
//        [self tabAnimation:array index:index];
//        self.indexFlag = index;
//    }
//}
//
////tabbar动画
//- (void)tabAnimation:(NSMutableArray *)array index:(NSInteger)index {
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    //速度控制函数，控制动画运行的节奏
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.duration = 0.2;       //执行时间
//    animation.repeatCount = 1;      //执行次数
//    animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
//    animation.fromValue = [NSNumber numberWithFloat:1.0];   //初始伸缩倍数
//    animation.toValue = [NSNumber numberWithFloat:1.2];     //结束伸缩倍数
//    [[array[index] layer] addAnimation:animation forKey:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
