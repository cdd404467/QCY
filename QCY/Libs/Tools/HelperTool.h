//
//  HelperTool.h
//  QCY
//
//  Created by i7colors on 2018/9/18.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HelperTool : NSObject

// 添加点击手势
+ (void)addTapGesture:(UIView *)view withTarget:(id)target andSEL:(SEL)sel;

//找到导航栏黑线
+ (UIImageView *)findNavLine:(UIView *)view;

//添加圆角
+ (void)setRound:(UIView * _Nonnull)view corner:(UIRectCorner)corner radiu:(CGFloat)radius;
@end

NS_ASSUME_NONNULL_END
