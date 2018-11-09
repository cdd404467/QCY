//
//  HelperTool.m
//  QCY
//
//  Created by i7colors on 2018/9/18.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "HelperTool.h"
#import <Masonry.h>

@implementation HelperTool

//  添加点击手势
+ (void)addTapGesture:(UIView *)view withTarget:(id)target andSEL:(SEL)sel {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tap];
}

//找到导航栏的黑线
+ (UIImageView *)findNavLine:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findNavLine:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//圆角
+ (void)setRound:(UIView * _Nonnull)view corner:(UIRectCorner)corner radiu:(CGFloat)radius {
    [view layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}



///*** 添加View ***/
//+ (void)addBorderView:(UIView *_Nonnull)view color:(UIColor * _Nonnull)color width:(CGFloat)borderWidth direction:(BorderDirection)direction {
//    if (direction & BorderDirectionTop) {
//        [self addBorderViewTop:view color:color andWidth:borderWidth];
//    }
//    if (direction & BorderDirectionLeft) {
//        [self addBorderViewLeft:view color:color andWidth:borderWidth];
//    }
//    if (direction & BorderDirectionBottom) {
//        [self addBorderViewBottom:view color:color andWidth:borderWidth];
//    }
//    if (direction & BorderDirectionRight) {
//        [self addBorderViewRight:view color:color andWidth:borderWidth];
//    }
//}
//
//+ (void)addBorderViewTop:(UIView *)view color:(UIColor *)color andWidth:(CGFloat) borderWidth {
//    UIView *border = [[UIView alloc] init];
//    border.backgroundColor = color;
//    [view addSubview:border];
//    [border mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//    }];
//}
//
//+ (void)addBorderViewLeft:(UIView *)view color:(UIColor *)color andWidth:(CGFloat) borderWidth {
//    UIView *border = [[UIView alloc] init];
//    border.backgroundColor = color;
//    [view addSubview:border];
//    [border mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.mas_equalTo(0);
//        make.width.mas_equalTo(1);
//    }];
//}
//
//+ (void)addBorderViewBottom:(UIView *)view color:(UIColor *)color andWidth:(CGFloat) borderWidth {
//    UIView *border = [[UIView alloc] init];
//    border.backgroundColor = color;
//    [view addSubview:border];
//    [border mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//    }];
//}
//
//+ (void)addBorderViewRight:(UIView *)view color:(UIColor *)color andWidth:(CGFloat) borderWidth {
//    UIView *border = [[UIView alloc] init];
//    border.backgroundColor = color;
//    [view addSubview:border];
//    [border mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.mas_equalTo(0);
//        make.width.mas_equalTo(1);
//    }];
//}


@end
