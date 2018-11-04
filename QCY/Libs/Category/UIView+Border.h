//
//  UIView+Border.h
//  QCY
//
//  Created by i7colors on 2018/9/28.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSInteger, BorderDirection)
{
    BorderDirectionTop      = 1 << 0,
    BorderDirectionLeft     = 1 << 1,
    BorderDirectionBottom   = 1 << 2,
    BorderDirectionRight    = 1 << 3,
    BorderDirectionAll      = BorderDirectionTop | BorderDirectionLeft | BorderDirectionBottom | BorderDirectionRight
};

@interface UIView (Border)
- (void)addBorderLayer:(UIColor * _Nonnull)color width:(CGFloat) borderWidth direction:(BorderDirection)direction;

- (void)addBorderView:(UIColor * _Nonnull)color width:(CGFloat)borderWidth direction:(BorderDirection)direction;
@end

NS_ASSUME_NONNULL_END
