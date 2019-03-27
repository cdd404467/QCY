//
//  BaseNavigationController.m
//  CodeDemo
//
//  Created by wangrui on 2017/4/19.
//  Copyright © 2017年 wangrui. All rights reserved.
//
//  Github地址：https://github.com/wangrui460/WRNavigationBar

#import "BaseNavigationController.h"
#import "UIImage+Color.h"
#import <Masonry.h>


@interface BaseNavigationController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong)UIButton *expBtn;
@property (nonatomic, strong)UIButton *backBtn;
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 重新响应侧滑返回手势
    self.interactivePopGestureRecognizer.delegate = self;
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.interactivePopGestureRecognizer.enabled = YES;
}

//+ (void)initialize
//{
//    UINavigationBar *navigationBar = [UINavigationBar appearance];
//    navigationBar.tintColor = [UIColor blackColor];
//
//}

#pragma mark - 侧滑手势 - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    return YES;
}
// 允许同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
// 禁止响应手势 是否和ViewController中scrollView跟着滚动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer: (UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        //返回按钮自定义
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(0, 0, 38, 38);
        [_backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
//        _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        CGFloat space = 38 * [UIScreen mainScreen].bounds.size.width / 375.0 / 2 - 38 / 2;
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, space, 0, -space)];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
        viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)setBackBtnTintColor:(UIColor *)backBtnTintColor {
    _backBtnTintColor = backBtnTintColor;
    UIImage *image = [UIImage imageNamed:@"back_black"];
    [_backBtn setImage:[image imageWithTintColor:backBtnTintColor] forState:UIControlStateNormal];
    _backBtn.tintColor = backBtnTintColor;
}

- (void)popBack {
    
    [self popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return [self.topViewController prefersStatusBarHidden];
}

- (void)dealloc {
    self.interactivePopGestureRecognizer.delegate = nil;
}
@end

