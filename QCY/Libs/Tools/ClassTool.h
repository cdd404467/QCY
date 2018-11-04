//
//  ClassTool.h
//  QCY
//
//  Created by i7colors on 2018/9/6.
//  Copyright © 2018年 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ClassTool : NSObject
+ (NSString *)getApiToken:(BOOL)isGetFromNet;
+ (UIButton *)customBackBtn;
+ (void)addLayer:(UIView *)view;
+ (void)addLayer:(UIView *)view frame:(CGRect)frame;
+ (void)addLayerVertical:(UIView *)view frame:(CGRect)frame startColor:(UIColor *)sColor endColor:(UIColor *) eColor;

/**
 get请求
 
 @param requestUrl 请求路径
 @param params 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (void)getRequest:(NSString *)requestUrl Params:(NSDictionary *)params  Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;

/**
 post请求
 
 @param requestUrl 请求路径
 @param params 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (void)postRequest:(NSString *)requestUrl Params:(NSMutableDictionary *)params  Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;

//获取图片
+ (void)getRequestWithStream:(NSString *)requestUrl Params:(NSDictionary *)params Success:(void (^)(id json))success Failure:(void (^)(NSError *error))failure;

@end
