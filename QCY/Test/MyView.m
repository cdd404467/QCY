//
//  MyView.m
//  QCY
//
//  Created by i7colors on 2018/11/13.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "MyView.h"

@implementation MyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
//    CGContextRef context =UIGraphicsGetCurrentContext();
//    UIColor *aColor = RGBA(84, 204, 84, 1);
//
//    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
//    CGContextAddEllipseInRect(context,CGRectMake(0,NAV_HEIGHT + 46 - 100,SCREEN_WIDTH,100));//椭圆
//
//    CGContextDrawPath(context,kCGPathFill);
    
    //线条颜色
      UIColor *color = MainColor;
         [color set];
    UIBezierPath *path;
         //创建path
         path = [UIBezierPath bezierPath];
         //设置线宽
         path.lineWidth = 0;
         //线条拐角
         path.lineCapStyle = kCGLineCapRound;
         //终点处理
         path.lineJoinStyle = kCGLineJoinRound;
    [path moveToPoint:(CGPoint){0,0}];
         [path addQuadCurveToPoint:(CGPoint){SCREEN_WIDTH,0} controlPoint:(CGPoint){SCREEN_WIDTH / 2, 52}];
    
//         [path moveToPoint:(CGPoint){0,NAV_HEIGHT}];
//         [path addLineToPoint:(CGPoint){SCREEN_WIDTH / 2,NAV_HEIGHT + 46}];
//         [path addLineToPoint:(CGPoint){SCREEN_WIDTH,NAV_HEIGHT}];
////        [path addLineToPoint:(CGPoint){200,200}];
//         [path addLineToPoint:(CGPoint){100,200}];
//         [path addLineToPoint:(CGPoint){50,150}];
//         [path closePath];
         //根据坐标点连线
    
         [path fill];
   
}


@end
