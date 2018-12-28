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

//获取当前显示的控制器
+ (UIViewController *)getCurrentVC;

//视频转换为mp4
+ (NSURL *)convertToMp4:(NSURL *)movUrl;

//压缩视频
+ (NSURL *)yasuoVideoNewUrl: (NSURL *)url;

//版本比较
+ (NSInteger)compareVersionWithOnline:(NSString *)onlineVersion oldVersion:(NSString *)oldVersion;
@end

NS_ASSUME_NONNULL_END
