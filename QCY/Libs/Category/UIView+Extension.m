//
//  UIView+Extension.m
//  QCY
//
//  Created by i7colors on 2019/6/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>
typedef void(^TapEventsBlock)(void);

@interface UIView()
/** 事件回调的block */
@property (nonatomic, copy) TapEventsBlock tapEventsBlock;
@end

@implementation UIView (Extension)
- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)aPoint
{
    CGRect newframe = self.frame;
    newframe.origin = aPoint;
    self.frame = newframe;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

- (CGPoint)bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint)topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newheight
{
    CGRect newframe = self.frame;
    newframe.size.height = newheight;
    self.frame = newframe;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newwidth
{
    CGRect newframe = self.frame;
    newframe.size.width = newwidth;
    self.frame = newframe;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newbottom
{
    CGFloat rightY = [self superview].frame.size.height - newbottom;
    CGFloat deltY = rightY - (self.frame.origin.y + self.frame.size.height);
    CGRect newframe = self.frame;
    newframe.origin.y += deltY;
    self.frame = newframe;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newright
{
    CGFloat rightX = [self superview].frame.size.width - newright;
    CGFloat deltX = rightX - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += deltX ;
    self.frame = newframe;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centetX
{
    CGPoint center = self.center;
    center.x = centetX - [self superview].frame.origin.x;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centetY
{
    CGPoint center = self.center;
    center.y = centetY - [self superview].frame.origin.y;
    self.center = center;
}

- (void)setMaxX:(CGFloat)maxX
{
    CGRect frame = self.frame;
    frame.origin.x = maxX - frame.size.width;
    self.frame = frame;
    
}
- (void)setMaxY:(CGFloat)maxY
{
    CGRect frame = self.frame;
    frame.origin.y = maxY - frame.size.height;
    self.frame = frame;
    
}
- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

#pragma mark - button的block
//------- 添加属性 -------//

static void *my_tapEventsBlockKey = &my_tapEventsBlockKey;

- (TapEventsBlock)tapEventsBlock {
    return objc_getAssociatedObject(self, &my_tapEventsBlockKey);
}

- (void)setTapEventsBlock:(TapEventsBlock)tapEventsBlock {
    objc_setAssociatedObject(self, &my_tapEventsBlockKey, tapEventsBlock, OBJC_ASSOCIATION_COPY);
}

- (void)addEventHandler:(void (^)(void))block {
    self.tapEventsBlock = block;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addEventHandler)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

// 按钮点击
- (void)addEventHandler {
    !self.tapEventsBlock ?: self.tapEventsBlock();
}

@end
