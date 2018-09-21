//
//  UIFont+Runtime.m
//  QCY
//
//  Created by i7colors on 2018/9/19.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "UIFont+Runtime.h"
#import <objc/runtime.h>
#import "MacroHeader.h"

@implementation UIFont (Runtime)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swappingMethod:@selector(systemFontOfSize:) withSwizzledClassSelector:@selector(adjustFont:)];
        [self swappingMethod:@selector(boldSystemFontOfSize:) withSwizzledClassSelector:@selector(adjustBoldFont:)];
        [self swappingMethod:@selector(systemFontOfSize:weight:) withSwizzledClassSelector:@selector(adjustFontOfWeight:weight:)];
        [self swappingMethod:@selector(italicSystemFontOfSize:) withSwizzledClassSelector:@selector(adjustItalicFont:)];
    });
}

+ (void)swappingMethod:(SEL)originalSelector withSwizzledClassSelector:(SEL)swizzledSelector
{
    Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
    Method originalMethod = class_getClassMethod(self, originalSelector);
    method_exchangeImplementations(swizzledMethod, originalMethod);
}


//systemFontOfSize
+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    //4寸 和 4.7寸
    if (SCREEN_HEIGHT <= 667.f && SCREEN_WIDTH <= 375.f && (fontSize * SCREEN_HEIGHT / 667.f) < 12.f) {
        newFont = [UIFont adjustFont:12.f];
        return newFont;
    } else {
        newFont = [UIFont adjustFont:fontSize * SCREEN_WIDTH / 375];
        return newFont;
    }
}

//boldSystemFontOfSize
+ (UIFont *)adjustBoldFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    if (SCREEN_HEIGHT <= 667.f && SCREEN_WIDTH <= 375.f && (fontSize * SCREEN_HEIGHT / 667.f) < 12.f) {
        newFont = [UIFont adjustBoldFont:12.f];
        return newFont;
    } else {
        newFont = [UIFont adjustBoldFont:fontSize * SCREEN_WIDTH / 375];
        return newFont;
    }
}

//adjustFontOfWeight
+ (UIFont *)adjustFontOfWeight:(CGFloat)fontSize weight:(CGFloat)weight
{
    UIFont *newFont = nil;
    if (SCREEN_HEIGHT <= 667.f && SCREEN_WIDTH <= 375.f && (fontSize * SCREEN_HEIGHT / 667.f) < 12.f) {
        newFont = [UIFont adjustFontOfWeight:12.f weight:weight];
        return newFont;
    } else {
        newFont = [UIFont adjustFontOfWeight:fontSize * SCREEN_WIDTH / 375 weight:weight];
        return newFont;
    }
}

//italicSystemFontOfSize - 倾斜字体
+ (UIFont *)adjustItalicFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    if (SCREEN_HEIGHT <= 667.f && SCREEN_WIDTH <= 375.f && (fontSize * SCREEN_HEIGHT / 667.f) < 12.f) {
        newFont = [UIFont adjustItalicFont:12.f];
        return newFont;
    } else {
        newFont = [UIFont adjustItalicFont:fontSize * SCREEN_WIDTH / 375];
        return newFont;
    }
}


@end
