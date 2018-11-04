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
+ (UIFont * _Nonnull)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    if (fontSize >= 12.f && (fontSize * Scale_W) < 12.f) {
        newFont = [UIFont adjustFont:12.f];
        return newFont;
    } else if(fontSize < 12.f && SCREEN_WIDTH > 375.f) {
        newFont = [UIFont adjustFont:fontSize * Scale_W];
        return newFont;
    } else if(fontSize < 12.f && SCREEN_WIDTH <= 375.f) {
        newFont = [UIFont adjustFont:fontSize];
        return newFont;
    } else if (fontSize == 15.1f) {
        newFont = [UIFont adjustFont:fontSize];
        return newFont;
    }else {
        newFont = [UIFont adjustFont:fontSize * Scale_W];
        return newFont;
    }
}

//boldSystemFontOfSize
+ (UIFont * _Nonnull)adjustBoldFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    if (fontSize >= 12.f && (fontSize * Scale_W) < 12.f) {
        newFont = [UIFont adjustBoldFont:12.f];
        return newFont;
    } else if(fontSize < 12.f && SCREEN_WIDTH > 375.f) {
        newFont = [UIFont adjustBoldFont:fontSize * Scale_W];
        return newFont;
    } else if(fontSize < 12.f && SCREEN_WIDTH <= 375.f) {
        newFont = [UIFont adjustBoldFont:fontSize];
        return newFont;
        //导航栏字体
    } else if (fontSize == 17.f) {
        newFont = [UIFont adjustBoldFont:fontSize];
        return newFont;
    } else {
        newFont = [UIFont adjustBoldFont:fontSize * Scale_W];
        return newFont;
    }
}

//adjustFontOfWeight
+ (UIFont * _Nonnull)adjustFontOfWeight:(CGFloat)fontSize weight:(CGFloat)weight
{
    UIFont *newFont = nil;
    if (fontSize >= 12.f && (fontSize * Scale_W) < 12.f) {
        newFont = [UIFont adjustFontOfWeight:12.f weight:weight];
        return newFont;
    } else if(fontSize < 12.f && SCREEN_WIDTH > 375.f) {
        newFont = [UIFont adjustFontOfWeight:fontSize * Scale_W weight:weight];
        return newFont;
    } else if(fontSize < 12.f && SCREEN_WIDTH <= 375.f) {
        newFont = [UIFont adjustFontOfWeight:fontSize weight:weight];
        return newFont;
    } else {
        newFont = [UIFont adjustFontOfWeight:fontSize * Scale_W weight:weight];
        return newFont;
    }
}

//italicSystemFontOfSize - 倾斜字体
+ (UIFont * _Nonnull)adjustItalicFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    if (fontSize >= 12.f && (fontSize * Scale_W) < 12.f) {
        newFont = [UIFont adjustItalicFont:12.f];
        return newFont;
    } else if(fontSize < 12.f && SCREEN_WIDTH > 375.f) {
        newFont = [UIFont adjustItalicFont:fontSize * Scale_W];
        return newFont;
    } else if(fontSize < 12.f && SCREEN_WIDTH <= 375.f) {
        newFont = [UIFont adjustItalicFont:fontSize];
        return newFont;
    } else {
        newFont = [UIFont adjustItalicFont:fontSize * Scale_W];
        return newFont;
    }
}


@end
