//
//  UIView+Border.m
//  QCY
//
//  Created by i7colors on 2018/9/28.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "UIView+Border.h"

@implementation UIView (Border)
/*** 添加layer ***/
- (void)addBorderLayer:(UIColor * _Nonnull)color width:(CGFloat)borderWidth direction:(BorderDirection)direction {
    if (direction & BorderDirectionTop) {
        [self addTopBorderWithColor:color andWidth:borderWidth];
    }
    if (direction & BorderDirectionLeft) {
        [self addLeftBorderWithColor:color andWidth:borderWidth];
    }
    if (direction & BorderDirectionBottom) {
        [self addBottomBorderWithColor:color andWidth:borderWidth];
    }
    if (direction & BorderDirectionRight) {
        [self addRightBorderWithColor:color andWidth:borderWidth];
    }
}

/*** 上边的border ***/
-(void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
    
}

/***  下边的border ***/
-(void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

/*** 左边的border ***/
-(void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

/*** 右边的border ***/
-(void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}


/*** 添加View ***/
- (void)addBorderView:(UIColor * _Nonnull)color width:(CGFloat)borderWidth direction:(BorderDirection)direction {
    if (direction & BorderDirectionTop) {
        [self addBorderViewTop:color andWidth:borderWidth];
    }
    if (direction & BorderDirectionLeft) {
        [self addBorderViewLeft:color andWidth:borderWidth];
    }
    if (direction & BorderDirectionBottom) {
        [self addBorderViewBottom:color andWidth:borderWidth];
    }
    if (direction & BorderDirectionRight) {
        [self addBorderViewRight:color andWidth:borderWidth];
    }
}

- (void)addBorderViewTop:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [[UIView alloc] init];
    border.backgroundColor = color;
    [self addSubview:border];
    [border mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(borderWidth);
    }];
}

- (void)addBorderViewLeft:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [[UIView alloc] init];
    border.backgroundColor = color;
    [self addSubview:border];
    [border mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(borderWidth);
    }];
}

- (void)addBorderViewBottom:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [[UIView alloc] init];
    border.backgroundColor = color;
    [self addSubview:border];
    [border mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(borderWidth);
    }];
}

- (void)addBorderViewRight:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [[UIView alloc] init];
    border.backgroundColor = color;
    [self addSubview:border];
    [border mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(borderWidth);
    }];
}
@end
